:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

% from railbot to destination area
add deliverBox(Box) && (belief busy) =>
[    
    cr takeOff(),
    cr goto(Box),
    cr land(),
    act (pickUp(Box)),

    check_artifact_belief(Box, destination(Destination)),

    cr takeOff(),
    cr goto(Destination),
    cr land(),
    act dropDown(),

    add_agent_desire(Destination, receive(Box)),

    % need to refuel
    del_belief(busy),
    add_desire(refuel),

    stop
].

% from the PickUpArea to the intermediate destination area
add shipBox(Box) && (belief busy) =>
[
    cr takeOff(),
    cr goto(Box),
    cr land(),
    act (pickUp(Box)),

    check_artifact_belief(Box, start(Start)),
    check_artifact_belief(Box, destination(Destination)),

    check_agent_belief(Start, area(StartArea)),
    check_agent_belief(Destination, area(DestinationArea)),

    act (getLandingZone(StartArea, DestinationArea), Delivery),

    cr takeOff(),
    cr goto(Delivery),
    cr land(),
    act dropDown(),

    add_desire(callRailBot(Box)),

    stop
].

add callRailBot(Box) && true =>
[
    % call RailBot
    check_artifact_belief(Box, start(Start)),
    check_agent_belief(Start, area(StartArea)),
    act (getRailBot(StartArea), RailBot),
    add_agent_belief(RailBot, busy),
    add_agent_desire(RailBot, collectBox(Box)),

    % need to refuel
    del_belief(busy),
    add_desire(refuel),

    stop
].

% refuel option
add refuel && true =>
[
    cr takeOff(),
    act (getChargingStation(), ChargingStation),
    cr goto(ChargingStation),
    cr land(),
    % act printLog("Refueling"),
    cr waitForSeconds(3),
    % act printLog("Ready"),

    stop   
].