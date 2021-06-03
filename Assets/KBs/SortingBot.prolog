:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

add sort(Box) && (belief busy) =>
[
    % move bot to box and pickup the box
    cr goto(Box),
    act (pickUp(Box)),

    % get the destination
    check_artifact_belief(Box, destination(Destination)),
    check_agent_belief(Destination, area(DestinationArea)),
    act (getExchangeArea(DestinationArea), ExchangeArea),

    % move bot to destination
    cr goto(ExchangeArea),
    act (dropDown(ExchangeArea)),

    % call RailBot
    act (getRailBot(DestinationArea), RailBot),
    add_agent_desire(RailBot, deliverBox(Box)),
    add_agent_belief(RailBot, busy),

    del_belief(busy),
    add_desire(recharge),

    stop
].

add recharge && (\+ busy) =>
[
    act (getChargingStation(), ChargingStation),
    cr goto(ChargingStation),

    stop
].

add recharge && (busy) =>
[
    add_desire(recharge),

    stop
].