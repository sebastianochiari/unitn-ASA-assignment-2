:- consult("UnityLogic/KBs/UnityLogicAgentAPI.prolog").

add call_drone(SpawnedBox) && true =>
[
    add_desire(send(SpawnedBox))

    % in case not working remove this line
    stop
].

add send(SpawnedBox) && true =>
[
    % get a random Drone
    act (getDrone, Drone),
    % check if the chosen drone is not busy
    (
        not(check_agent_belief(Drone, busy)),
        add_agent_belief(Drone, busy)
    ),
    
    % add to the Drone the desire to pickup the box
    add_agent_desire(Drone, shipBox(SpawnedBox)),
    
    stop
].

add receive(Box) && true =>
[
    act (destroy(Box)),

    stop   
].