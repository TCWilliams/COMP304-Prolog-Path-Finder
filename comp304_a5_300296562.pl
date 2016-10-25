
% Knowledge base captures road segments, start town, end town, distance between

segment(wellington, palmerston_north, 143).
segment(palmerston_north, wanganui, 74).
segment(palmerston_north, napier, 178).
segment(palmerston_north, taupo, 259).
segment(wanganui, taupo, 231).
segment(wanganui, new_plymouth, 163).
segment(wanganui, napier, 252).
segment(napier, taupo, 147).
segment(napier, gisborne, 215).
segment(new_plymouth, hamilton, 242).
segment(new_plymouth, taupo, 289).
segment(taupo, hamilton, 153).
segment(taupo, rotorua, 82).
segment(taupo, gisborne, 334).
segment(gisborne, rotorua, 291).
segment(rotorua, hamilton, 109).
segment(hamilton, auckland, 126).

% road/3 makes the road map bi-directional
% by reversing each segment
road(Start, To, Distance) :-
    segment(Start, To, Distance);
    segment(To, Start, Distance).

route(Start, Finish, Visits, Distance) :-
    % find all routes from start to finish
    find_routes(Start, Finish, Visited, Dist),
    % check that visits is a subset of visited
    check_visited(Visits, Visited),
    % check Distance is correct
    Distance == Dist,
    !. % stop if a suitable route was found

% check_visited/2 checks two lists to see if all towns in visits were visited
%check head of visits is a member of visited, if it is recurse on tail if visits
%else false, not all towns in visits were visited
check_visited([],_). % empty list is a subset of any list
check_visited([H|Visits], Visited) :-
    member(H, Visited),
    check_visited(Visits, Visited).


%choice/3 gets all routes from start to finish and outputs the route and distance 
choice(Start, Finish, RoutesAndDistances) :-
    % calls helper predicate find_routes to find all the routes and distances, collect together
    % using findall/3
    findall((Visited,Distance), find_routes(Start, Finish, Visited, Distance), RoutesAndDistances).
  

% find_routes/3 is the where most of the work is done for all tasks.
% it finds all routes from Start to Finish and provides a list of visited towns
% and the distance of the route.
% It uses move/5 to traverse segments of the road map

find_routes(Start, Finish, Visited, Distance) :-
    move(Start, Finish, [Start], X, Distance),
    reverse(X, Visited).

% move/5 first clause is true if Start and Finish are connected
move(Start, Finish, Visited, [Finish|Visited], Distance) :-
     road(Start, Finish, Distance).

% move/5 this clause is true if there is a path from Start to Finish if Start is connected
% to town X and X is not Finish and X is not already visited (not a member of visited list)
% Also adds distances of segments.
% recurses with town X as start, addign X to visited
move(Start, Finish, Visited, Visits, Distance) :-
    road(Start, X, Dist1),
    X \= Finish,
    \+member(X, Visited),
    move(X, Finish, [X|Visited], Visits, Dist2),
    Distance is Dist1 + Dist2.

% via/4 uses find_routes to get routes from Start to FInish. 
% Then calls check_visited/2 to get the routes that visit all
% towns in Via list. This is done withing findall/3 predicate to gather
% the results in a list
 
via(Start, Finish, Via, RoutesAndDistances) :-
    findall((Visited,Distance), (find_routes(Start, Finish, Visited, Distance),check_visited(Via, Visited)), RoutesAndDistances).

% avoiding/4 uses find_routes to get routes from Start to Finish.
% calls avoid/2 to find all the routes that do not contain all towns
% in Avoiding. This is done withing findall/3 predicate to gather
% the results in a list

avoiding(Start, Finish, Avoiding, RoutesAndDistances) :-
     findall((Visited,Distance), (find_routes(Start, Finish, Visited, Distance),avoid(Avoiding, Visited)), RoutesAndDistances).
    
% avoid/2, similar to check_visited but does the opposite
% is true if the head of Avoids is not in Visited list

avoid([],_).
avoid([H|Avoid], Visited) :-
    \+member(H, Visited),
    avoid(Avoid, Visited).

% TESTS
%-------------------------------------------

% route/4 tests

% route(wellington, taupo, [wanganui], 669). 
% TRUE

% route(wellington, taupo, [wanganui], 668).
% FALSE

% route(wellington, taupo, [wanganui], 448).
% TRUE

% route(wellington, taupo, [wanganui], 449). 
% FALSE

% route(wellington, taupo, [wanganui], 402). 
% FALSE not via wanganui

% route(wellington,auckland,[taupo, hamilton],1847). 
% TRUE because of this route  ([wellington, palmerston_north, taupo, new_plymouth, wanganui, napier, gisborne, rotorua, hamilton, auckland],1847)]

% route(wellington,auckland,[taupo, hamilton],1846).
% False, distance is 1km off

%-------------------------------------------
% choice tests

% choice(wellington,palmerston_north,X).
% X = [([wellington, palmerston_north],143)]

% most of these queries return large lists as there are many ways to get around the map
% choice(taupo,auckland, X).
% X = [([taupo, hamilton, auckland],279), ([taupo, rotorua, hamilton, auckland],317), ([taupo, rotorua, gisborne, napier, palmerston_north, wanganui, new_plymouth, hamilton, auckland],1371), 
% ([taupo, rotorua, gisborne, napier, wanganui, new_plymouth, hamilton, auckland],1371), ([taupo, gisborne, rotorua, hamilton, auckland],860), 
% ([taupo, gisborne, napier, palmerston_north, wanganui, new_plymouth, hamilton, auckland],1332), ([taupo, gisborne, napier, wanganui, new_plymouth, hamilton, auckland],1332), 
% ([taupo, palmerston_north, wanganui, new_plymouth, hamilton, auckland],864), ([taupo, palmerston_north, wanganui, napier, gisborne, rotorua, hamilton, auckland],1326), 
% ([taupo, palmerston_north, napier, gisborne, rotorua, hamilton, auckland],1178), ([taupo, palmerston_north, napier, wanganui, new_plymouth, hamilton, auckland],1220), 
% ([taupo, wanganui, new_plymouth, hamilton, auckland],762), ([taupo, wanganui, napier, gisborne, rotorua, hamilton, auckland],1224), ([taupo, wanganui, palmerston_north, napier, gisborne, rotorua, hamilton, auckland],1224), 
% ([taupo, napier, gisborne, rotorua, hamilton, auckland],888), ([taupo, napier, palmerston_north, wanganui, new_plymouth, hamilton, auckland],930), ([taupo, napier, wanganui, new_plymouth, hamilton, auckland],930), 
% ([taupo, new_plymouth, hamilton, auckland],657), ([taupo, new_plymouth, wanganui, napier, gisborne, rotorua, hamilton, auckland],1445), ([taupo, new_plymouth, wanganui, palmerston_north, napier, gisborne, rotorua, hamilton, auckland],1445)]
%-------------------------------------------

% via tests

% via(wellington,palmerston_north,[hamilton],X).
% X = [] - no way to do this without visiting a town more than once

% most queries for via give big results, such as this
% via(wellington,taupo,[wanganui],X).
% X = [([wellington, palmerston_north, wanganui, taupo],448), ([wellington, palmerston_north, wanganui, new_plymouth, taupo],669), 
% ([wellington, palmerston_north, wanganui, new_plymouth, hamilton, taupo],775), ([wellington, palmerston_north, wanganui, new_plymouth, hamilton, rotorua, taupo],813), 
% ([wellington, palmerston_north, wanganui, new_plymouth, hamilton, rotorua, gisborne, taupo],1356), ([wellington, palmerston_north, wanganui, new_plymouth, hamilton, rotorua, gisborne, napier, taupo],1384), 
% ([wellington, palmerston_north, wanganui, napier, taupo],616), ([wellington, palmerston_north, wanganui, napier, gisborne, taupo],1018), ([wellington, palmerston_north, wanganui, napier, gisborne, rotorua, taupo],1057), 
% ([wellington, palmerston_north, wanganui, napier, gisborne, rotorua, hamilton, taupo],1237), ([wellington, palmerston_north, wanganui, napier, gisborne, rotorua, hamilton, new_plymouth, taupo],1615), 
% ([wellington, palmerston_north, napier, gisborne, rotorua, hamilton, new_plymouth, wanganui, taupo],1572), ([wellington, palmerston_north, napier, wanganui, taupo],804), 
%([wellington, palmerston_north, napier, wanganui, new_plymouth, taupo],1025), ([wellington, palmerston_north, napier, wanganui, new_plymouth, hamilton, taupo],1131), 
% ([wellington, palmerston_north, napier, wanganui, new_plymouth, hamilton, rotorua, taupo],1169), ([wellington, palmerston_north, napier, wanganui, new_plymouth, hamilton, rotorua, gisborne, taupo],1712)]

% here is a ridiculous way to get to Taupo
% via(wellington,taupo,[wanganui,napier,rotorua,gisborne,hamilton,new_plymouth],X).
% X = [([wellington, palmerston_north, wanganui, new_plymouth, hamilton, rotorua, gisborne, napier, taupo],1384), ([wellington, palmerston_north, wanganui, napier, gisborne, rotorua, hamilton, new_plymouth, taupo],1615), 
% ([wellington, palmerston_north, napier, gisborne, rotorua, hamilton, new_plymouth, wanganui, taupo],1572), ([wellington, palmerston_north, napier, wanganui, new_plymouth, hamilton, rotorua, gisborne, taupo],1712)]

%-------------------------------------------

% avoiding tests

% avoiding(wellington,napier,[palmerston_north],X).
% produces an empty list, no palmerston_north can't be avoided unfortunately

% avoiding(wellington,napier,[wanganui,taupo],X).
% produces just one result - X = [([wellington, palmerston_north, napier],321)]

% avoiding(wellington,auckland,[hamilton],X).
% X = [] - no way to Auckland without visiting Hamilton

% avoiding(wellington,auckland,[taupo,gisborne],X).
% X = [([wellington, palmerston_north, wanganui, new_plymouth, hamilton, auckland],748), ([wellington, palmerston_north, napier, wanganui, new_plymouth, hamilton, auckland],1104)]
