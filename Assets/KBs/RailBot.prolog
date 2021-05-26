:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

% get box from platform to sorting zone
add collectBox(Box) && (belief busy) =>
[
    cr goto(Box),
    act (pickUp(Box)),
    act (getExchangeArea, ExchangeArea),
    cr goto(ExchangeArea),
    act (dropDown(ExchangeArea)),

    act (getSortingBot, SortingBot),
    add_agent_desire(SortingBot, sort(Box)),

    del_belief(busy),

    stop
].

% get box from sorting zone to platform
add deliverBox(Box) && (belief busy) =>
[
    cr goto(Box),
    act (pickUp(Box)),
    
    check_artifact_belief(Box, start(Start)),
    check_agent_belief(Start, area(StartArea)),
    act (getArea(StartArea), Area),

    cr goto(Area),
    act (dropDown(Area)),

    add_desire(callDrone(Box)),
    add_belief(requestingDrone),

    del_belief(busy),

    stop
].

add callDrone(Box) && (belief requestingDrone) =>
[
    % call drone for delivery
    act (getDrone, Drone),
    % check if the chosen drone is not busy
    (
        not(check_agent_belief(Drone, busy)),
        add_agent_belief(Drone, busy)
    ),
    add_agent_desire(Drone, deliverBox(Box)),
    del_belief(requestingDrone),

    stop
].