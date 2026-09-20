#!/usr/bin/env bash
set -euo pipefail

[[ ! -d .git ]] || {
    echo "ERROR: .git already exists."
    exit 1
}

cat > .gitignore <<'EOF'
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
__pycache__/
*.pyc
*.tmp
*.bak
.DS_Store
algebra-init.sh
EOF

git init -b main

commit_one() {
    file="$1"
    message="$2"
    category="$3"

    printf '\nAdding: %s\n' "$file"

    git add -- "$file"

    count="$(git diff --cached --name-only | wc -l)"
    [[ "$count" -eq 1 ]] || {
        echo "ERROR: expected exactly one staged file."
        exit 1
    }

    git commit \
        -m "$message" \
        -m "Category: $category" \
        -m "Introduces $file as an independent artifact in the initial monotonic history of Algebra."
}

commit_one ".gitignore" \
    "Establish repository exclusions" \
    "repository"

commit_one "README.md" \
    "Introduce Algebra" \
    "repository"

commit_one "the-admissible-subspace.tex" \
    "Add The Admissible Subspace" \
    "theory"

commit_one "the-waste-is-in-the-boundary.tex" \
    "Add The Waste Is in the Boundary" \
    "theory"

commit_one "the-unequal-error.tex" \
    "Add The Unequal Error" \
    "theory"

commit_one "when-failure-becomes-a-signal.tex" \
    "Add When Failure Becomes a Signal" \
    "theory"

commit_one "Constraint_Topologies.pdf" \
    "Add Constraint Topologies" \
    "theory"

commit_one "01-residual.png" \
    "Add first residual study" \
    "visual"

commit_one "02-residual.png" \
    "Add second residual study" \
    "visual"

commit_one "next-move.png" \
    "Add next-move study" \
    "visual"

commit_one "How_Boundaries_Create_Truth_and_Waste.txt" \
    "Add Boundaries Create Truth and Waste transcript" \
    "transcript"

commit_one "How_Boundaries_Create_Truth_and_Waste.srt" \
    "Add subtitle transcript" \
    "transcript"

commit_one "How_Boundaries_Create_Truth_and_Waste.vtt" \
    "Add WebVTT transcript" \
    "transcript"

commit_one "How_Boundaries_Create_Truth_and_Waste.tsv" \
    "Add transcript timing data" \
    "transcript"

commit_one "How_Boundaries_Create_Truth_and_Waste.json" \
    "Add audio metadata" \
    "metadata"

commit_one "How_Boundaries_Create_Truth_and_Waste.mp3" \
    "Add Boundaries Create Truth and Waste audio" \
    "audio"

commit_one "process_audio.sh" \
    "Add audio processing pipeline" \
    "tooling"

echo
echo "Verifying monotonic history..."

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

    if [[ "$count" -ne 1 || "$status" != A$'\t'* ]]; then
        printf 'FAIL: %s -> %s\n' "$commit" "$status"
        bad=$((bad + 1))
    fi
done < <(git rev-list --reverse HEAD)

[[ "$bad" -eq 0 ]] || exit 1

echo "PASS: every commit adds exactly one file."
echo
git --no-pager log --reverse --format='%h  %s'
echo
git status --short
