%%%-------------------------------------------------------------------
%%% @author Mateusz
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. maj 2019 13:26
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("Mateusz").

%% API
-export([start_link/0]).

start_link() ->
  spawn(fun init/0).

init() ->
  process_flag(trap_exit, true),
  register(monitor, spawn_link(pollution_server, init, [])),
  loop().

loop() ->
  receive
    {'EXIT',_,_} -> start_link(),
    loop()
  end.