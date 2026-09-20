#!/usr/bin/env bash
set -euo pipefail

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

category() {
    case "$1" in
        .gitignore|README.md) echo "repository" ;;
        *.tex)                echo "source" ;;
        *.py)                 echo "model" ;;
        *.sh)                 echo "tooling" ;;
        *.png|*.jpg|*.jpeg)   echo "artwork" ;;
        *.pdf)                echo "document" ;;
        *.mp3|*.wav|*.flac)   echo "audio" ;;
        *.txt|*.srt|*.vtt|*.tsv) echo "transcript" ;;
        *.json|*.yaml|*.yml)  echo "metadata" ;;
        *)                    echo "artifact" ;;
    esac
}

pretty_name() {
    local f="$1"
    local name="${f##*/}"

    name="${name%.*}"
    name="${name//_/ }"
    name="${name//-/ }"

    printf '%s\n' "$name"
}

commit_one() {
    local f="$1"
    local cat
    local desc
    local n

    cat="$(category "$f")"
    desc="$(pretty_name "$f")"

    printf '\n%s\n' '------------------------------------------------------------'
    printf 'File:     %s\n' "$f"
    printf 'Category: %s\n' "$cat"
    printf 'Commit:   Add %s\n' "$desc"
    printf '%s\n' '------------------------------------------------------------'

    git add -- "$f"

    n="$(git diff --cached --name-only | wc -l)"

    [[ "$n" -eq 1 ]] ||
        die "expected one staged file, found $n"

    git commit \
        -m "Add $desc" \
        -m "Category: $cat" \
        -m "Adds $f to the research corpus."
}

printf '\n%s\n' '============================================================'
printf '%s\n' ' Monotonic repository builder'
printf ' Directory: %s\n' "$PWD"
printf '%s\n\n' '============================================================'

[[ ! -e .git ]] ||
    die ".git already exists; remove it first if this is a fresh import"

# ----------------------------------------------------------------------
# Ignore generated material
# ----------------------------------------------------------------------

cat > .gitignore <<'EOF'
# LaTeX build artifacts
*.aux
*.bbl
*.bcf
*.blg
*.fdb_latexmk
*.fls
*.log
*.out
*.run.xml
*.synctex.gz
*.toc
*.xdv

# Python
__pycache__/
*.pyc
*.pyo
.venv/
.pytest_cache/

# Editors / OS
*~
*.swp
.DS_Store
Thumbs.db
.vscode/
.idea/

# Temporary files
*.tmp
*.bak
*.backup
.cache/

# Repository construction script
monotonic-commit.sh
EOF

# ----------------------------------------------------------------------
# README
# ----------------------------------------------------------------------

cat > README.md <<'EOF'
# Stylometrics

This repository is a research corpus containing essays, mathematical
models, source documents, illustrations, audio renderings, transcripts,
and computational experiments concerned with stylometry, inference,
epistemic proxies, representation, mathematical modeling, and related
formal frameworks.

A recurring concern across the collection is the relationship between an
observable feature and the hidden process inferred from it. Stylometric
markers, mathematical quantities, probability estimates, interface states,
and textual forms can all become proxies for processes that are not
themselves directly observed.

## Principal works

**Architectures of Permeability** examines representational forms and media
as active cognitive structures, particularly the distinction between useful
enclosure and systems that cease to admit effective external correction.

**Arranged Conditions** examines how explanatory conclusions depend upon
the conditions, reference classes, and causal arrangements supplied around
an observation.

**P(doom)** is a mathematical and satirical investigation of technological
catastrophe estimates, reference classes, priors, anthropic observation,
causal assumptions, and the sensitivity of apparently quantitative
probabilities to modeling choices.

**Roots of Optimism** develops a formal treatment of optimism through
repair, recoverability, continuation, and accessible future states rather
than treating optimism simply as an expectation of favorable outcomes.

**Stylometric Proxies** examines textual surface features used as proxies
for authorship, particularly attempts to identify machine-generated writing
from stylistic markers. It considers proxy formation, Goodhart effects,
adaptation, false positives, and the eventual decoupling of a public test
from the latent property it was intended to measure.

**SpherePOP Desktop** contains work relating the SpherePOP framework to
interface-level and desktop representations.

**Typing Tutors** contains historical and theoretical work on typing
instruction, paper-mediated tutoring systems, software tutors, and changes
in the pedagogical unit of action.

## Computational and visual material

The repository contains Python models, LaTeX tables and figures, cover
artwork, illustrations, and processing utilities associated with the
written research.

Visual artifacts are retained alongside their corresponding theoretical
work because presentation and representation form part of the research
process rather than a wholly separate publication layer.

## Audio corpus

Some works have spoken versions accompanied by transcripts and timing
information. These may appear as families of MP3, TXT, SRT, VTT, TSV, and
JSON files.

Current audio-related material includes the
`Optimism_is_the_math_of_repair` and
`Why_mathematical_models_hide_the_truth` artifact families.

## File types

LaTeX source is stored as `.tex`, compiled documents as `.pdf`,
computational material as `.py`, utilities as `.sh`, artwork as `.png`,
audio as `.mp3`, transcripts as `.txt`, `.srt`, and `.vtt`, timing data as
`.tsv`, and structured metadata as `.json`.

Generated LaTeX working files are intentionally excluded from version
control.

## Monotonic history

The initial Git history is deliberately constructed one file at a time.

Every initial commit introduces exactly one previously untracked path.
Consequently, the repository grows monotonically during its initial import:
no initial commit modifies or removes an artifact introduced by an earlier
commit.

Files are grouped loosely by function so that source material,
computational work, tooling, artwork, compiled documents, audio,
transcripts, and metadata occupy recognizable regions of the initial
history.

This ordering describes repository assembly rather than the historical
order in which the underlying works were authored.

## Building

A typical LaTeX document can be compiled with:

    latexmk -xelatex document.tex

Individual documents may have additional dependencies.

## Status

This is an active research corpus rather than a versioned software release.
Artifacts may represent finished essays, active drafts, computational
experiments, source material, generated representations, or intermediate
theoretical formulations.

The collection forms part of the broader Flyxion / Galactromeda research
corpus.
EOF

# ----------------------------------------------------------------------
# Initialize
# ----------------------------------------------------------------------

git init -b main

# Infrastructure gets its own commits.

commit_one ".gitignore"
commit_one "README.md"

# ----------------------------------------------------------------------
# Snapshot the candidate filenames BEFORE committing the corpus.
#
# Git performs discovery and honors .gitignore.
# NUL delimiters make spaces in filenames safe.
# ----------------------------------------------------------------------

mapfile -d '' files < <(
    git ls-files --others --exclude-standard -z |
    sort -z
)

# ----------------------------------------------------------------------
# Import by category.
# ----------------------------------------------------------------------

categories=(
    source
    model
    tooling
    artwork
    document
    audio
    transcript
    metadata
    artifact
)

for wanted in "${categories[@]}"; do
    printf '\n=== %s ===\n' "$wanted"

    for f in "${files[@]}"; do
        [[ "$(category "$f")" == "$wanted" ]] || continue
        commit_one "$f"
    done
done

# ----------------------------------------------------------------------
# Verify history.
# ----------------------------------------------------------------------

printf '\n%s\n' '============================================================'
printf '%s\n' ' Verifying history'
printf '%s\n' '============================================================'

bad=0

while read -r commit; do

    status="$(
        git diff-tree \
            --root \
            --no-commit-id \
            --name-status \
            -r "$commit"
    )"

    count="$(printf '%s\n' "$status" | sed '/^$/d' | wc -l)"

    if [[ "$count" -ne 1 ]]; then
        printf 'FAIL %s: %s paths changed\n' "$commit" "$count"
        bad=$((bad + 1))
        continue
    fi

    if [[ "$status" != A$'\t'* ]]; then
        printf 'FAIL %s: not a pure addition: %s\n' "$commit" "$status"
        bad=$((bad + 1))
    fi

done < <(git rev-list --reverse HEAD)

printf '\n'

if [[ "$bad" -eq 0 ]]; then
    printf '%s\n' 'PASS: every commit adds exactly one file.'
else
    printf 'FAIL: %d commits violate the monotonic invariant.\n' "$bad"
    exit 1
fi

printf '\nCommits:       '
git rev-list --count HEAD

printf 'Tracked files: '
git ls-files | wc -l

printf '\n%s\n' 'History:'
git --no-pager log --reverse --format='%h  %s'

printf '\n%s\n' 'Working tree:'
git status --short

printf '\n%s\n' 'Repository complete. Nothing has been pushed.'
printf '%s\n' 'To add a remote later:'
printf '%s\n' '  git remote add origin <REMOTE-URL>'
printf '%s\n' '  git push -u origin main'
