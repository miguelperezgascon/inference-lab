:- module(reinforcement, [
    raw_reinforcement/3,
    reinforcement/3,
    reinforcement_map/2
]).

:- use_module(library(ordsets)).
:- use_module(library(lists)).
:- use_module(engine).
:- use_module(theory_db).

raw_reinforcement(T, Rule, Count) :-
    findall(
        1,
        (
            observation(T, Goal),
            explain(T, Goal, explanation(Rules, _)),
            ord_memberchk(Rule, Rules)
        ),
        L
    ),
    length(L, Count).

reinforcement(T, Rule, Rho) :-
    raw_reinforcement(T, Rule, N),
    Rho is 1 - 2 ** (-N).

reinforcement_map(T, Map) :-
    findall(ID, rule(T, ID, _, _), IDs),
    sort(IDs, SortedIDs),
    maplist(reinforcement_pair(T), SortedIDs, Map).

reinforcement_pair(T, ID, ID-Rho) :-
    reinforcement(T, ID, Rho).