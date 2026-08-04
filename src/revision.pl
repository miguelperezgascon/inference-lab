%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% revision.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- module(revision, [
    prediction_hit/2,
    novelty/2,
    anomaly_obs/2,
    abduct/4,
    revise/4
]).

:- use_module(theory_db).
:- use_module(engine).
:- use_module(course).
:- use_module(consilience).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% prediction_hit(+Theory, +Fact)
%%
%% The fact is already covered by the theory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prediction_hit(T, Fact) :-
    course(T, Fact, C),
    C > 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% novelty(+Theory, +Fact)
%%
%% The fact is not covered, but is consistent with the theory.
%% For now, we only sketch the interface; consistency can be
%% refined later with an explicit consistency predicate.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

novelty(T, Fact) :-
    \+ prediction_hit(T, Fact),
    consistent_with_theory(T, Fact).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% anomaly_obs(+Theory, +Fact)
%%
%% The fact is not covered and is inconsistent with the theory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

anomaly_obs(T, Fact) :-
    \+ prediction_hit(T, Fact),
    \+ consistent_with_theory(T, Fact).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% consistent_with_theory(+Theory, +Fact)
%%
%% Placeholder for the consistency requirement.
%% If the fact can be explained, it is consistent enough.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

consistent_with_theory(T, Fact) :-
    explain(T, Fact, _).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% abduct(+Theory, +Fact, -Hypothesis, -Explanation)
%%
%% Sketch of abduction:
%%  - Fact must be explainable under T plus H
%%  - H must not be an anomaly/fantasy
%%  - For now this is a placeholder interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abduct(_T, _Fact, _Hypothesis, _Explanation) :-
    fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% revise(+Theory, +NewFacts, +Strictness, -RevisedTheory)
%%
%% Sketch of revision:
%%  - prediction hits reinforce
%%  - novelties may extend
%%  - anomalies trigger revision
%%  - final choice should respect consilience
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

revise(T, NewFacts, Strictness, T) :-
    must_be(list, NewFacts),
    mean_course(T, NewFacts, Mean),
    \+ ( member(F, NewFacts),
         course(T, F, C),
         C < Mean / Strictness
       ).