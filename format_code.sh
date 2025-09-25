#!/bin/bash

# Format all C++ files in the ublox package using clang-format-12
find . -name "*.cpp" -o -name "*.h" -o -name "*.hpp" | grep -v "/build/" | while read file; do
    echo "Formatting: $file"
    clang-format-12 -i "$file"
done

echo "All files have been formatted according to clang-format-12 standards."