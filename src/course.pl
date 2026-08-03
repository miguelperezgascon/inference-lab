%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% course.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- module(course, [
    course/3,
    explanation_course/3,
    best_explanation/4
]).

:- use_module(library(lists)).
:- use_module(engine).
:- use_module(reinforcement).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% course(+Theory, +Fact, -Course)
%%
%% Greatest course among all explanations of Fact.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

course(T, Fact, Course) :-
    findall(
        Value,
        (
            explain(T, Fact, Explanation),
            explanation_course(T, Explanation, Value)
        ),
        Values
    ),
    Values \= [],
    max_list(Values, Course).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% explanation_course(+Theory, +Explanation, -Course)
%%
%% Course of one specific explanation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

explanation_course(T, explanation(Rules, _), Value) :-
    rules_product(T, Rules, Value).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% best_explanation(+Theory, +Fact, -Explanation, -Course)
%%
%% Returns the explanation with the greatest course.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

best_explanation(T, Fact, BestExplanation, BestCourse) :-
    findall(
        Course-Explanation,
        (
            explain(T, Fact, Explanation),
            explanation_course(T, Explanation, Course)
        ),
        Pairs
    ),
    Pairs \= [],
    keysort(Pairs, Sorted),
    reverse(Sorted, [BestCourse-BestExplanation|_]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% rules_product(+Theory, +Rules, -Product)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rules_product(_, [], 1).

rules_product(T, [Rule|Rules], Product) :-
    reinforcement(T, Rule, Rho),
    rules_product(T, Rules, Rest),
    Product is Rho * Rest.