%%%-------------------------------------------------------------------
%%% @author Mateusz
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. maj 2019 14:14
%%%-------------------------------------------------------------------
-module(pollution_server_test).
-author("Mateusz").

-include_lib("eunit/include/eunit.hrl").

pollution_server_test() ->
  pollution_server:start(),
  pollution_server:addStation("Krakow", {50,20}),
  pollution_server:addStation("Warszawa", {52,21}),
  pollution_server:addValue("Krakow", {{2019,5,3},{14,0,0}}, "pm10", 10),
  pollution_server:addValue({50,20}, {{2019,5,3},{13,0,0}}, "pm10", 20),
  pollution_server:addValue("Krakow", {{2019,5,3},{14,0,0}}, "pm2.5", 5),
  pollution_server:addValue({50,20}, {{2019,5,3},{13,0,0}}, "pm2.5", 15),
  pollution_server:addValue("Warszawa", {{2019,5,3},{14,0,0}}, "pm10", 20),
  pollution_server:addValue({52,21}, {{2019,5,3},{13,0,0}}, "pm10", 30),
  pollution_server:removeValue("Krakow", {{2019,5,3},{13,0,0}}, "pm2.5"),
  ?assert(pollution_server:getOneValue("Krakow", {{2019,5,3},{14,0,0}}, "pm2.5") == 5),
  ?assert(pollution_server:getStationMean({50,20}, "pm2.5") == 5),
  ?assert(pollution_server:getDailyMean({2019,5,3}, "pm10") == 20),
  ?assert(pollution_server:getAreaMean("Krakow", "pm2.5", 2) == 5).