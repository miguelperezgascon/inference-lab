:- module(theory_db, [
    theory/1,
    rule/4,
    fact/2,
    observation/2
]).

theory(base).

rule(base, r1, safetostack(X,Y), [not(fragile(Y))]).
rule(base, r2, safetostack(X,Y), [lighter(X,Y)]).
rule(base, r3, lighter(X,Y), [weight(X,WX), weight(Y,WY), lessthan(WX,WY)]).
rule(base, r4, weight(X,W), [volume(X,V), density(X,D), times(V,D,W)]).
rule(base, r5, weight(X,5), [type(X,endtable)]).
rule(base, r6, fragile(X), [material(X,glass)]).

fact(base, type(obj1,box)).
fact(base, type(obj2,endtable)).
fact(base, volume(obj1,2)).
fact(base, density(obj1,0.3)).
fact(base, material(obj1,cardboard)).
fact(base, material(obj2,wood)).

observation(base, safetostack(obj1,obj2)).