%%%-------------------------------------------------------------------
%%% @author Mateusz
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. maj 2019 14:08
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("Mateusz").

-include_lib("eunit/include/eunit.hrl").

-record(monitor, { stationAttributes = #{}, pollutionParameters = #{}}).

createMonitor_test() ->
  ?assert(pollution:createMonitor() == #monitor{stationAttributes = #{}, pollutionParameters = #{}}).

addStation_test() ->
  ?assert(pollution:addStation("Warszawa",{52,21},pollution:createMonitor()) ==
  #monitor{stationAttributes = #{"Warszawa" => {52,21}},
    pollutionParameters = #{{52,21} => #{}}}).

%%addValue_test() ->
%%  ?assert(
%%    pollution:addValue("Warszawa", {{2019,5,3},{14,0,0}}, "pm10", 10,
%%      #monitor{stationAttributes = #{"Warszawa" => {51,21}}, pollutionParameters = #{{52,21} => #{}}}) ==
%%      #monitor{stationAttributes = #{"Warszawa" => {52,21}},
%%        pollutionParameters = #{{52,21} => #{{"pm10",{{2019,5,3},{14,0,0}}} => 10}}}
%%  ).

%%removeValue_test() ->
%%  ?assert(
%%    pollution:removeValue("Warszawa", {{2019,5,3},{14,0,0}}, "pm10",
%%      #monitor{stationAttributes = #{"Warszawa" => {51,21}}, pollutionParameters = #{{52,21} => #{{"pm10",{{2019,5,3},{14,0,0}}} => 10}}}) ==
%%      #monitor{stationAttributes = #{"Warszawa" => {52,21}},
%%        pollutionParameters = #{{52,21} => #{}}}
%%  ).

getMonitor() -> {monitor,
  #{"Krakow" => {50,20},
    "Warszawa" => {52,21}
  },
  #{
    {50,20} => #{
      {"pm10",{{2019,5,3},{14,0,0}}} => 10,
      {"pm10",{{2019,5,3},{13,0,0}}} => 20,
      {"pm2.5",{{2019,5,3},{14,0,0}}} => 5,
      {"pm2.5",{{2019,5,3},{13,0,0}}} => 15
    },
    {52,21} => #{
      {"pm10",{{2019,5,3},{14,0,0}}} => 20,
      {"pm10",{{2019,5,3},{13,0,0}}} => 30,
      {"pm2.5",{{2019,5,3},{14,0,0}}} => 10,
      {"pm2.5",{{2019,5,3},{13,0,0}}} => 25
    }
  }
}.

getOneValue_test() ->
  ?assert(pollution:getOneValue("Krakow", {{2019,5,3},{14,0,0}}, "pm10", getMonitor()) == 10),
  ?assert(pollution:getOneValue({50,20}, {{2019,5,3},{14,0,0}}, "pm10", getMonitor()) == 10).

getStationMean_test() ->
  ?assert(pollution:getStationMean("Krakow", "pm10", getMonitor()) == 15),
  ?assert(pollution:getStationMean("Krakow", "pm2.5", getMonitor()) == 10).

getDailyMean_test() ->
  ?assert(pollution:getDailyMean({2019,5,3},"pm10",getMonitor()) == 20).

getAreaMean_test() ->
  ?assert(pollution:getAreaMean("Krakow", "pm10", 2, getMonitor()) == 15),
  ?assert(pollution:getAreaMean("Krakow", "pm10", 10, getMonitor()) == 20).