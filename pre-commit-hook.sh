#!/bin/bash

# Pre-commit hook to ensure code formatting compliance
# This script should be placed in .git/hooks/pre-commit and made executable

echo "Running clang-format checks..."

# Get list of C++ files that are being committed
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(cpp|hpp|h)$')

if [ -z "$FILES" ]; then
    echo "No C++ files found in commit."
    exit 0
fi

# Check formatting for each file
NEEDS_FORMATTING=""
for FILE in $FILES; do
    if ! clang-format-12 --dry-run --Werror "$FILE" > /dev/null 2>&1; then
        NEEDS_FORMATTING="$NEEDS_FORMATTING $FILE"
    fi
done

if [ -n "$NEEDS_FORMATTING" ]; then
    echo "The following files need formatting:"
    for FILE in $NEEDS_FORMATTING; do
        echo "  $FILE"
    done
    echo ""
    echo "Please run 'clang-format-12 -i <file>' or './format_code.sh' to format the files."
    echo "Then stage and commit again."
    exit 1
fi

echo "All files are properly formatted."
exit 0