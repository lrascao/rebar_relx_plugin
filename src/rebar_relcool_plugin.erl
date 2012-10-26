%%% -*- mode: Erlang; fill-column: 80; comment-column: 75; -*-
%%% Copyright 2012 Erlware, LLC. All Rights Reserved.
%%%
%%% This file is provided to you under the Apache License,
%%% Version 2.0 (the "License"); you may not use this file
%%% except in compliance with the License.  You may obtain
%%% a copy of the License at
%%%
%%%   http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing,
%%% software distributed under the License is distributed on an
%%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%%% KIND, either express or implied.  See the License for the
%%% specific language governing permissions and limitations
%%% under the License.
%%%---------------------------------------------------------------------------
%%% @author Eric Merrit <ericbmerritt@gmail.com>
%%% @copyright (C) 2012, Eric Merrit
%%% @doc
%%%  This provides a trivial way to integrate the relcool release builder into
%%%  rebar.
-module(rebar_relcool_plugin).

-export([release/2]).

%%============================================================================
%% API
%%============================================================================
release(Config, _AppFile) ->
    CurDir = filename:absname(rebar_utils:get_cwd()),
    RelCoolFile = filename:join(CurDir, "relcool.config"),
    case filelib:is_regular(RelCoolFile) of
        true ->
            do_release_build(Config, RelCoolFile);
        false ->
            ok
    end.


%%============================================================================
%% Internal Functions
%%============================================================================
do_release_build(Config, RelCoolFile) ->
    LibDirs = rebar_config:get_list(Config, relcool_libdirs, []),
    LogLevel = get_log_level(Config),
    OutputDir = rebar_config:get(Config, relcool_output, "rel"),
    {ok, _} = relcool:do(undefined, undefined, [], LibDirs, LogLevel,
                         OutputDir, RelCoolFile),
    ok.


get_log_level(Config) ->
    Verbosity = rebar_config:get_global(Config, verbose, rebar_log:default_level()),
    case Verbosity of
        error -> 0;
        warn -> 1;
        info -> 2;
        debug -> 3;
        I when erlang:is_integer(I) ->
            I
    end.