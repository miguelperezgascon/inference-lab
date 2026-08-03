:- module(engine, [
    explain/3,
    prove/6
]).

:- use_module(library(ordsets)).
:- use_module(theory_db).

explain(T, Goal, explanation(Rules, Facts)) :-
    prove(T, Goal, [], Rules, [], Facts).

prove(T, Goal, Rules, Rules, FactsIn, FactsOut) :-
    fact(T, Goal),
    ord_add_element(FactsIn, Goal, FactsOut).

prove(T, Goal, RulesIn, RulesOut, FactsIn, FactsOut) :-
    rule(T, ID, Goal, Body),
    ord_add_element(RulesIn, ID, RulesNext),
    prove_all(T, Body, RulesNext, RulesOut, FactsIn, FactsOut).

prove(T, Goal, Rules, Rules, Facts, Facts) :-
    execute(T, Goal).

prove_all(_, [], Rules, Rules, Facts, Facts).
prove_all(T, [G|Gs], RulesIn, RulesOut, FactsIn, FactsOut) :-
    prove(T, G, RulesIn, RulesNext, FactsIn, FactsNext),
    prove_all(T, Gs, RulesNext, RulesOut, FactsNext, FactsOut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% execute
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

execute(_, times(A,B,C)) :-
    number(A),
    number(B),
    C is A*B.

execute(_, lessthan(A,B)) :-
    number(A),
    number(B),
    A < B.

execute(T, not(Goal)) :-
    \+ prove(T, Goal, [], _, [], _).

execute(_, _) :-
    fail.