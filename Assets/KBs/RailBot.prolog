:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

% get box from platform to sorting zone
add collectBox(Box) && (belief busy) =>
[
    cr goto(Box),
    act (pickUp(Box)),

    add_desire(checkShipmentInfo(Box)),

    add_desire(nextStep(Box)),

    del_belief(busy),
    add_desire(idle),

    stop
].

add checkShipmentInfo(Box) && true =>
[
    check_artifact_belief(Box, start(Start)),
    check_artifact_belief(Box, destination(Destination)),

    check_agent_belief(Start, area(StartArea)),
    check_agent_belief(Destination, area(DestinationArea)),

    StartArea = DestinationArea,

    add_belief(sameShippingArea),

    stop
].

add checkShipmentInfo(Box) && true =>
[
    check_artifact_belief(Box, start(Start)),
    check_artifact_belief(Box, destination(Destination)),

    check_agent_belief(Start, area(StartArea)),
    check_agent_belief(Destination, area(DestinationArea)),

    StartArea \= DestinationArea,

    add_belief(differentShippingArea),

    stop
].

add nextStep(Box) && (belief sameShippingArea) =>
[
    check_artifact_belief(Box, start(Destination)),
    check_agent_belief(Destination, area(DestinationArea)),
    act (getArea(DestinationArea), Area),

    act (dropDown(Area)),

    add_desire(callDrone(Box)),
    add_belief(requestingDrone),

    del_belief(sameShippingArea),

    stop
].

add nextStep(Box) && (belief differentShippingArea) =>
[
    act (getExchangeArea, ExchangeArea),
    cr goto(ExchangeArea),
    act (dropDown(ExchangeArea)),

    act (getSortingBot, SortingBot),
    add_agent_belief(SortingBot, busy),
    add_agent_desire(SortingBot, sort(Box)),

    del_belief(differentShippingArea),

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
    add_desire(idle),

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

add idle && (\+ busy) =>
[
    act (getChargingStation(), ChargingStation),
    cr goto(ChargingStation),

    stop
].

add idle && (busy) =>
[
    add_desire(idle),

    stop
].