%%%-------------------------------------------------------------------
%%% @author Mateusz
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. kwi 2019 22:49
%%%-------------------------------------------------------------------
-module(pollution).
-author("Mateusz").

%% API
-export([createMonitor/0,addStation/3,addValue/5,removeValue/4,getOneValue/4,getStationMean/3,getDailyMean/3, getAreaMean/4]).

-record(monitor, { stationAttributes = #{}, pollutionParameters = #{}}).

createMonitor() ->
  #monitor{}.

addStation(Name, {X,Y}, Monitor) ->
  case maps:get(Name, Monitor#monitor.stationAttributes, "default") of
    "default" -> #monitor{ stationAttributes =  (Monitor#monitor.stationAttributes)#{Name => {X,Y}}, pollutionParameters = (Monitor#monitor.pollutionParameters)#{{X,Y} => #{}} };
    _ -> error("This station has been already added")
  end.

stationExistence(Name, Monitor) ->
  case maps:get(Name, Monitor#monitor.stationAttributes, "default") of
    "default" -> error("This station is not existing");
    _ -> ok
  end.

getKey({X,Y},_) when is_integer(X) and is_integer(Y) ->
  {X,Y};
getKey(Name,Monitor) when is_record(Monitor,monitor) ->
  stationExistence(Name,Monitor),
  maps:get(Name,Monitor#monitor.stationAttributes,"default").

getReadings(Key,M) ->
  V = maps:get(Key,M,"default"),
  case V of
    "default" -> error("Wrong key");
    _ -> V
  end.

addValue(Attribute, Date, Type, Value, Monitor) ->
  Key = getKey(Attribute,Monitor),
  Readings = getReadings(Key,Monitor#monitor.pollutionParameters),
  V = maps:get({Type,Date},Readings,"default"),
  case V of
    "default" -> ok;
    _ -> error("This reading already exist")
  end,
  Monitor#monitor{pollutionParameters = (Monitor#monitor.pollutionParameters)#{Key => Readings#{ {Type,Date} => Value}}}.

removeValue(Attribute, Date, Type, Monitor) ->
  Key = getKey(Attribute,Monitor),
  Readings = getReadings(Key,Monitor#monitor.pollutionParameters),
  Monitor#monitor{pollutionParameters = (Monitor#monitor.pollutionParameters)#{Key => maps:remove({Type,Date},Readings)}}.

getOneValue(Attribute, Date, Type, Monitor) ->
  Key = getKey(Attribute,Monitor),
  Readings = getReadings(Key,Monitor#monitor.pollutionParameters),
  V = maps:get({Type,Date}, Readings, "default"),
  case V of
    "default" -> error("No such reading");
    _ -> V
  end.

getStationMean(Attribute, Type, Monitor) ->
  Key = getKey(Attribute,Monitor),
  Readings = getReadings(Key,Monitor#monitor.pollutionParameters),
  {Sum, Amount} = maps:fold(
  fun(_,V,{S,A}) -> {S+V,A+1} end,
  {0,0},
  maps:filter(fun({T,_},_) -> T =:= Type end,Readings)
  ),
  Sum/Amount.

getDailyMean(Date, Type, Monitor) ->
  Measurements = maps:values(Monitor#monitor.pollutionParameters),
  FilteredMeasurements = lists:map(fun(Measurement) ->
    maps:filter(fun({T, {D,_}},_) -> (D =:= Date) and (T =:= Type) end, Measurement)
                             end, Measurements),
  Values = lists:flatten(lists:map(fun(Measurement) -> maps:values(Measurement) end, FilteredMeasurements)),
  {Sum, Amount} = lists:foldl(
    fun(Value, {S,A}) -> {S+Value,A+1} end,
    {0,0},
    Values
  ),
  Sum/Amount.

getAreaMean(Attribute, Type, Radius, Monitor) ->
  {X,Y} = getKey(Attribute, Monitor),
  MeasurementsFromFilteredStations = maps:values(maps:filter(fun({Xi,Yi},_) -> math:sqrt(math:pow(X-Xi,2) + math:pow(Y-Yi,2)) < Radius end, Monitor#monitor.pollutionParameters)),
  FilteredMeasurements = lists:map(fun(Measurement) ->
    maps:filter(fun({T,_},_) -> T =:= Type end, Measurement)
                                   end, MeasurementsFromFilteredStations),
  Values = lists:flatten(lists:map(fun(Measurement) -> maps:values(Measurement) end, FilteredMeasurements)),
  {Sum, Amount} = lists:foldl(
    fun(Value, {S,A}) -> {S+Value,A+1} end,
    {0,0},
    Values
  ),
  Sum/Amount.