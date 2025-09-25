#!/bin/bash

# Code Quality Analysis Script for u-blox GPS Package
# This script analyzes the codebase for compliance with coding standards

echo "=== U-BLOX GPS PACKAGE CODE QUALITY ANALYSIS ==="
echo "Date: $(date)"
echo "Branch: $(git branch --show-current)"
echo ""

echo "1. FORMATTING COMPLIANCE CHECK"
echo "==============================="
FORMAT_ISSUES=0
find . -name "*.cpp" -o -name "*.h" -o -name "*.hpp" | grep -v "/build/" | while read file; do
    if ! clang-format-12 --dry-run --Werror "$file" > /dev/null 2>&1; then
        echo "❌ Format issue: $file"
        FORMAT_ISSUES=$((FORMAT_ISSUES + 1))
    fi
done

if [ $FORMAT_ISSUES -eq 0 ]; then
    echo "✅ All files are properly formatted with clang-format-12"
else
    echo "❌ $FORMAT_ISSUES files need formatting"
fi
echo ""

echo "2. NAMING CONVENTION ANALYSIS"
echo "============================="
echo "Checking for naming convention compliance..."

# Check for non-camelCase function names (basic check)
echo "Functions with potentially incorrect naming:"
grep -rn --include="*.cpp" --include="*.h" "^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(" . | grep -v "^[[:space:]]*[a-z][a-zA-Z0-9_]*(" | head -5

# Check for magic numbers
echo ""
echo "Potential magic numbers (excluding common values):"
grep -rn --include="*.cpp" --include="*.h" "[^a-zA-Z_][0-9][0-9][0-9][0-9]*[^a-zA-Z_0-9]" . | grep -v "copyright\|2012\|1000\|timeout" | head -3

echo ""
echo "3. FUNCTION LENGTH ANALYSIS"
echo "=========================="
echo "Functions longer than 20 lines (excluding comments and blank lines):"

find . -name "*.cpp" | while read file; do
    awk '
    BEGIN { in_function = 0; func_name = ""; line_count = 0; brace_count = 0 }
    /^[^\/]*{/ && in_function { 
        brace_count += gsub(/{/, "")
        brace_count -= gsub(/}/, "")
        if (brace_count == 0) {
            if (line_count > 20) {
                print FILENAME ":" func_start_line ": " func_name " (" line_count " lines)"
            }
            in_function = 0; line_count = 0; func_name = ""
        }
    }
    /^[a-zA-Z_].*::.*\(/ || /^[a-zA-Z_].*[a-zA-Z_][a-zA-Z0-9_]*\s*\(/ {
        if (!in_function && !/^\s*\/\// && !/^\s*\*/ && !/^\s*#/) {
            func_name = $0; gsub(/\s*{.*$/, "", func_name)
            in_function = 1; line_count = 0; func_start_line = NR; brace_count = 0
        }
    }
    in_function && !/^\s*$/ && !/^\s*\/\// && !/^\s*\*/ { line_count++ }
    ' "$file"
done | head -5

echo ""
echo "4. CONST-CORRECTNESS CHECK"
echo "========================="
echo "Member functions that could be const:"
grep -rn --include="*.h" "^\s*[a-zA-Z_].*)\s*{" . | grep -v "const\s*{" | head -3

echo ""
echo "5. MEMORY MANAGEMENT ANALYSIS"
echo "==========================="
echo "Raw pointer usage (potential issues):"
grep -rn --include="*.cpp" --include="*.h" "\*[^/]" . | grep -v "boost::" | grep -v "/\*" | head -3

echo ""
echo "6. EXCEPTION HANDLING"
echo "===================="
echo "Exception usage patterns:"
grep -rn --include="*.cpp" --include="*.h" "throw\|try\|catch" . | wc -l | xargs echo "Total exception-related statements:"

echo ""
echo "7. INCLUDE ORGANIZATION"
echo "======================"
echo "Files with potentially unorganized includes:"
find . -name "*.h" -o -name "*.cpp" | while read file; do
    # Check if includes are properly organized
    include_count=$(grep -c "^#include" "$file" 2>/dev/null || echo 0)
    if [ "$include_count" -gt 10 ]; then
        echo "$file ($include_count includes)"
    fi
done | head -3

echo ""
echo "=== ANALYSIS COMPLETE ==="
echo "Recommendations:"
echo "1. Run './format_code.sh' to apply consistent formatting"
echo "2. Review functions longer than 20 lines for refactoring opportunities"
echo "3. Consider const-correctness improvements"
echo "4. Review raw pointer usage for smart pointer opportunities"
echo "5. Ensure proper error handling patterns"