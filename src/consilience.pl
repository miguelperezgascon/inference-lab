%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% consilience.pl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- module(consilience, [
    mean_course/3,
    geometric_mean_course/3,
    anomaly/4,
    theory_consilience/4
]).

:- use_module(library(lists)).
:- use_module(course).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% mean_course(+Theory, +Data, -Mean)
%%
%% Mean of the course values of the data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mean_course(T, Data, Mean) :-
    must_be(list, Data),
    Data \= [],
    findall(
        C,
        ( member(F, Data),
          course(T, F, C)
        ),
        Cs
    ),
    Cs \= [],
    sum_list(Cs, Sum),
    length(Cs, N),
    Mean is Sum / N.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% geometric_mean_course(+Theory, +Data, -GMean)
%%
%% Geometric mean of the course values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

geometric_mean_course(T, Data, GMean) :-
    must_be(list, Data),
    Data \= [],
    findall(
        C,
        ( member(F, Data),
          course(T, F, C)
        ),
        Cs
    ),
    Cs \= [],
    product(Cs, Prod),
    length(Cs, N),
    GMean is Prod ** (1 / N).

product([], 1).
product([X|Xs], P) :-
    product(Xs, Rest),
    P is X * Rest.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% anomaly(+Theory, +Data, +Strictness, -Fact)
%%
%% A fact is anomalous if its course is below Mean / Strictness.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


anomaly(T, Data, Strictness, Fact) :-
    must_be(list, Data),
    must_be(number, Strictness),
    Strictness > 0,
    member(Fact, Data),
    mean_course(T, Data, Mean),
    course(T, Fact, C),
    C < Mean / Strictness.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% theory_consilience(+Theory, +Data, +Strictness, -Score)
%%
%% Score = mean course, provided there are no anomalies.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

theory_consilience(T, Data, Strictness, Score) :-
    mean_course(T, Data, Score),
    \+ ( member(F, Data),
         anomaly(T, Data, Strictness, F)
       ).