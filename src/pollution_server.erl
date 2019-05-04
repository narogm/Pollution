%%%-------------------------------------------------------------------
%%% @author Mateusz
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. maj 2019 11:05
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("Mateusz").

%% API
-export([start/0,stop/0,addStation/2,addValue/4,removeValue/3,getOneValue/3,getStationMean/2, getDailyMean/2, getAreaMean/3]).

start() ->
  Pid = spawn(fun() -> init() end),
  register(monitor,Pid),
  Pid.

stop() ->
  monitor ! stop.

init() ->
  loop(pollution:createMonitor()).

loop(Monitor) ->
  receive
    {request, Pid, {addStation,Name, Coords}} ->
      Pid ! {replay, ok},
      loop(pollution:addStation(Name, Coords, Monitor));

    {request, Pid, {addValue,Attr, Date, Type, Value}} ->
      Pid ! {replay, ok},
      loop(pollution:addValue(Attr, Date, Type, Value, Monitor));

    {request, Pid, {removeValue,Attr, Date, Type}} ->
      Pid ! {replay, ok},
      loop(pollution:removeValue(Attr, Date, Type, Monitor));

    {request, Pid, {getOneValue,Attr, Date, Type}} ->
      Pid ! {replay, ok},
      loop(pollution:getOneValue(Attr, Date, Type, Monitor));

    {request, Pid, {getStationMean,Attr, Type}} ->
      Pid ! {replay, ok},
      loop(pollution:getStationMean(Attr, Type, Monitor));

    {request, Pid, {getDailyMean,Date, Type}} ->
      Pid ! {replay, ok},
      loop(pollution:getDailyMean(Date, Type, Monitor));

    {request, Pid, {getAreaMean,Attr, Type, Radius}} ->
      Pid ! {replay, ok},
      loop(pollution:getAreaMean(Attr, Type, Radius, Monitor))
  end.

call(Message) ->
  monitor ! {request, self(), Message},
  receive
    {reply,Reply} -> Reply
  end.

addStation(Name, Coords) ->
  call({addStation,Name,Coords}).

addValue(Attr, Date, Type, Value) ->
  call({addValue,Attr, Date, Type, Value}).

removeValue(Attr, Date, Type) ->
  call({removeValue,Attr, Date, Type}).

getOneValue(Attr, Date, Type) ->
  call({getOneValue,Attr, Date, Type}).

getStationMean(Attr, Type) ->
  call({getStationMean,Attr, Type}).

getDailyMean(Date, Type) ->
  call({getDailyMean, Date, Type}).

getAreaMean(Attr, Type, Radius) ->
  call({addValue,Attr, Type, Radius}).