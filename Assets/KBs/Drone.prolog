:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

belief ready.

add deliverBox(Box) && (belief ready) =>
[    
    cr takeOff(),
    cr goto(Box),
    cr land(),
    act (pickUp(Box)),

    check_artifact_belief(Box, destination(Destination)),

    cr takeOff(),
    cr goTo(Destination),
    cr land(),
    act dropDown(),

    add_agent_desire(Destination, receive(Box)),

    % need to refuel
    del_belief(ready),
    add_desire(refuel),

    stop
].

% drone 
add getTo(Object) && (belief loadedBox(Box)) =>
[
    cr takeOff(),
    cr goTo(Object),
    cr land(),
    act dropDown(),

    del_belief(loadedBox(Box)),

    % call RailBot
    check_artifact_belief(Box, start(Start)),
    check_agent_belief(Start, area(StartArea)),
    act (getRailBot(StartArea), RailBot),
    add_agent_desire(RailBot, collectBox(Box)),
    
    % need to refuel
    del_belief(ready),
    add_desire(refuel),

    stop
].

add getTo(Object) && (belief ready) =>
[
    cr takeOff(),
    cr goto(Object),
    cr land(),
    act (pickUp(Object)),

    add_belief(loadedBox(Object)),

    check_artifact_belief(Object, start(Start)),
    check_artifact_belief(Object, destination(Destination)),

    check_agent_belief(Start, area(StartArea)),
    check_agent_belief(Destination, area(DestinationArea)),

    act (getLandingZone(StartArea, DestinationArea), Delivery),

    del_desire(getTo(Object)),
    add_desire(getTo(Delivery)),

    stop
].

% refuel option
add refuel && true =>
[
    cr takeOff(),
    act (getChargingStation(), ChargingStation),
    cr goto(ChargingStation),
    cr land(),
    act printLog("Refueling"),
    % cr waitForSeconds(5),
    del_desire(refuel),
    del_belief(busy),
    act printLog("Ready"),

    stop   
].