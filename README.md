# Inference Lab

Experimental implementations of inference algorithms in Prolog based in paper proposals or theories with the objective of achieving a better understanding of said papers.

The long-term goal is to build a small research framework
for experimenting with:

- deductive inference
- explanatory and descriptional induction
- abduction
- theory revision
- analogical reasoning
- measures of consilience and explanatory coherence

The implementation is intentionally modular so that alternative algorithms and
representations can be compared.

## Current modules (work in progress)wi

- `theory_db.pl` — representation of theories, rules, facts and observations
- `engine.pl` — proof search and explanation extraction
- `reinforcement.pl` — reinforcement map computation
- `course.pl` — course computation for facts
- `consilience.pl` — evaluation of theories
- `revision.pl` — (work in progress)

## Requirements

- SWI-Prolog 9.x (recommended)

## Running

Clone the repository and start SWI-Prolog:

```bash
swipl
```

Load the project:

```prolog
?- [engine].
```

## Tests

### 1. Theory

```prolog
?- theory(base).

?- rule(base, ID, Head, Body).

?- fact(base, Fact).

?- observation(base, Obs).
```

---

### 2. Explanation engine

Facts:

```prolog
?- explain(base, type(obj2,endtable), E).

?- explain(base, volume(obj1,2), E).
```

Derived facts:

```prolog
?- explain(base, weight(obj2,5), E).

?- explain(base, weight(obj1,W), E).

?- explain(base, lighter(obj1,obj2), E).
```

Top-level goal:

```prolog
?- explain(base, safetostack(obj1,obj2), E).
```

Enumerate every explanation:

```prolog
?- explain(base, safetostack(obj1,obj2), E), fail.
```

Built-ins:

```prolog
?- explain(base, times(2,3,X), E).

?- explain(base, lessthan(2,5), E).
```

Negation:

```prolog
?- explain(base, not(fragile(obj2)), E).
```

Impossible goals:

```prolog
?- explain(base, fragile(obj2), E).

?- explain(base, weight(obj2,7), E).
```

---

### 3. Reinforcement

Single rule:

```prolog
?- raw_reinforcement(base, r1, N).

?- reinforcement(base, r1, R).

?- raw_reinforcement(base, r5, N).

?- reinforcement(base, r5, R).
```

Whole map:

```prolog
?- reinforcement_map(base, Map).
```

Expected:

```prolog
[r1-0.5,r2-0.5,r3-0.5,r4-0.5,r5-0.5,r6-0]
```

---

### 4. Course

Simple facts:

```prolog
?- course(base, weight(obj2,5), C).

?- course(base, weight(obj1,0.6), C).
```

Top-level goal:

```prolog
?- course(base, safetostack(obj1,obj2), C).
```

Best explanation:

```prolog
?- best_explanation(base, safetostack(obj1,obj2), E, C).
```

---

### 5. Consilience

```prolog
?- Data = [
       weight(obj2,5),
       safetostack(obj1,obj2)
   ],
```

And then:

Arithmetic mean:

```prolog
?- mean_course(base, Data, Mean).
```

Geometric mean:

```prolog
?- geometric_mean_course(base, Data, GMean).
```

Detect anomalies:

```prolog
?- anomaly(base, Data, 2, Fact).
```

Theory evaluation:

```prolog
?- theory_consilience(base, Data, 2, Score).
```

---

### 6. Revision (work in progress)

Current interface:

```prolog
?- revise(base, Data, 2, RevisedTheory).

?- abduct(base, Goal, CandidateTheory, Hypothesis).
```

## Bibliography

Hernández-Orallo, J. (1997). *Computational "Consilience" as a Basis for Theory Formation.*

Hernández-Orallo, J., & García-Varea, I. (2000). *Distinguishing Abduction and Induction under Intensional Complexity.*

Hernández-Orallo, J. *Extracción Automática de Conocimiento en Bases de Datos e Ingeniería del Software*. Tema 1: Introducción.
