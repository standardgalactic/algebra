# Algebra

[The Admissible Subspace](https://standardgalactic.github.io/algebra/the-admissible-subspace.pdf)

[The Unequal Error](https://standardgalactic.github.io/algebra/the-unequal-error.pdf)

[The Waste is in the Boundary](https://standardgalactic.github.io/algebra/the-waste-is-in-the-boundary.pdf)

[When Failure Becomes a Signal](https://standardgalactic.github.io/algebra/when-failure-becomes-a-signal.pdf)

**Algebra** is a research collection about boundaries, admissibility,
residuals, asymmetric error, and the informational structure of failure.

The central proposition running through the project is that what a system
rejects, loses, misclassifies, or leaves behind is not necessarily incidental
to the system. Residuals can reveal the geometry of the transformation that
produced them. Boundaries can manufacture categories of truth and waste.
Errors can be distributed unequally across a state space. Failed transitions
can disclose constraints that successful transitions conceal.

Taken together, the works in this repository develop an algebra of the
residual: a way of reasoning about systems through the structure of what does
not pass cleanly through them.

## Core works

### Constraint Topologies

`Constraint_Topologies.pdf`

A treatment of constraints not merely as scalar limitations but as structures
with topology. What a system can reach depends on the shape, connectivity,
holes, barriers, and admissible paths of its state space.

### The Admissible Subspace

`the-admissible-subspace.tex`

Develops admissibility as a geometric and operational concept. A system does
not act over an undifferentiated universe of possibilities. Operations induce
a subspace of states, transitions, or representations that can actually be
accepted, preserved, or transformed.

The excluded region is therefore not simply "everything else." Its structure
depends upon the operation defining admissibility.

### The Waste Is in the Boundary

`the-waste-is-in-the-boundary.tex`

Examines waste as a consequence of partition and transformation rather than
as an intrinsic property of discarded material.

A boundary decides what counts as product, remainder, signal, contamination,
success, or loss. Changing the boundary can therefore change the measured
quantity of waste without changing the underlying world.

### The Unequal Error

`the-unequal-error.tex`

Investigates error that is distributed nonuniformly across a system's state
space.

A single aggregate error rate can conceal the geometry of failure. Two systems
with identical average performance may fail on radically different regions,
populations, transitions, or boundary cases.

The distribution of error is consequently part of the model rather than an
incidental statistic about it.

### When Failure Becomes a Signal

`when-failure-becomes-a-signal.tex`

Develops the idea that failure can become informative when unsuccessful
operations reveal otherwise hidden constraints.

Success establishes that at least one admissible path exists. Failure can
sometimes reveal substantially more: the location of a boundary, the
direction of a constraint, the exhaustion of a resource, or the inadequacy
of the representation through which the operation was attempted.

## The residual

A conventional engineering description often treats the residual as the
portion left after the important transformation has already occurred:

    input -> transformation -> output + residual

Algebra asks what changes when the residual is retained as evidence about
the transformation itself.

Schematically:

    transformation
         |
         +---- accepted state
         |
         +---- residual
                  |
                  +---- evidence of boundary
                  +---- evidence of constraint
                  +---- evidence of model mismatch
                  +---- evidence of asymmetric loss

Under this interpretation, the residual is not automatically noise.

It may be a measurement of the system's own selectivity.

## Shared structure

The projects can be read as variations on a common formal pattern.

Let a system act on a state space X through an operation T. Not every element
of X necessarily survives T in the same way. For a given operation, define an
admissible region A_T contained in X.

The complement

    R_T = X \ A_T

is then a residual region relative to that operation.

The important point is that R_T is operation-relative. An object rejected by
one transformation may be admissible under another. Waste, error, exclusion,
and failure therefore cannot always be treated as intrinsic labels attached
to objects independently of the systems acting upon them.

This creates a family of related questions:

What boundary produced the residual?

What operation made the distinction relevant?

Is error uniform over the state space?

Does failure identify a constraint?

Would another representation alter the admissible region?

What information disappears if only successful outputs are retained?

These questions connect the individual works in the repository.

## Media

The repository includes visual summaries associated with the project:

`01-residual.png`

`02-residual.png`

`next-move.png`

These images provide alternative visual presentations of the theoretical
material.

## Audio

`How_Boundaries_Create_Truth_and_Waste.mp3`

is accompanied by transcript and timing artifacts:

`How_Boundaries_Create_Truth_and_Waste.txt`

`How_Boundaries_Create_Truth_and_Waste.srt`

`How_Boundaries_Create_Truth_and_Waste.vtt`

`How_Boundaries_Create_Truth_and_Waste.tsv`

`How_Boundaries_Create_Truth_and_Waste.json`

The different representations permit the same material to function as audio,
plain text, subtitles, timed text, tabular timing data, and structured
metadata.

`process_audio.sh` contains supporting audio-processing automation.

## Repository history

The initial history is intentionally monotonic.

Each initial commit introduces one file. Existing files are not imported as
a single snapshot, and no initial commit modifies or removes an artifact
introduced by an earlier commit.

The resulting history therefore represents repository construction as a
sequence of additions:

    S_0 subset S_1 subset S_2 subset ... subset S_n

where S_i denotes the set of tracked artifacts after commit i.

This ordering records repository assembly rather than the historical order
in which the works were authored.

## Building

The LaTeX sources can typically be compiled with:

    latexmk -xelatex filename.tex

Individual documents may have additional dependencies.

## Project status

Algebra is an active research collection. The repository may contain finished
essays, working formulations, visual explanations, audio representations, and
intermediate artifacts.

The project forms part of the broader Flyxion / Galactromeda research corpus.

![](next-move.png)
