# U-BLOX GPS Package Development Guide

## Overview

This document describes the code quality improvements and development standards implemented for the u-blox GPS ROS package.

## Code Formatting & Style

### Clang-Format Configuration
- **Tool**: clang-format-12
- **Configuration**: `.clang-format` file in project root
- **Style**: Based on Google style with custom brace wrapping
- **Line limit**: 120 characters
- **Indentation**: 2 spaces
- **Brace style**: Custom - braces on new lines for classes, functions, namespaces

### Key Style Rules
- **Classes**: PascalCase (e.g., `GpsReceiver`)
- **Functions**: camelCase (e.g., `parseMessage`)
- **Variables**: camelCase (e.g., `baudRate`)
- **Constants**: ALL_CAPS (e.g., `MAX_BUFFER_SIZE`)
- **Files**: snake_case (e.g., `gps_receiver.cpp`)
- **Namespaces**: snake_case (e.g., `ublox_gps`)

### Formatting Scripts
- `./format_code.sh` - Format all C++ files
- `./build_with_checks.sh` - Build with formatting verification
- `./analyze_code.sh` - Comprehensive code quality analysis
- `./pre-commit-hook.sh` - Git pre-commit hook for formatting

## Code Quality Standards

### Function Design
- Maximum 20 lines per function (excluding comments)
- Single responsibility principle
- Early returns to avoid deep nesting
- Use descriptive names starting with verbs
- Boolean functions: use `is`, `has`, `can` prefixes

### Class Design
- Follow SOLID principles
- Maximum 200 lines per class
- Maximum 10 public methods per class
- Use Rule of Five or Rule of Zero
- Make member variables private
- Use const-correctness

### Memory Management
- Prefer smart pointers over raw pointers
- Use RAII principles
- Use standard containers over C-style arrays
- Avoid memory leaks with proper resource management

### Error Handling
- Use exceptions for unexpected errors only
- Use `std::optional` or error codes for expected failures
- Catch exceptions to add context or fix problems
- Use global exception handlers where appropriate

### Documentation
- Use Doxygen-style comments for public APIs
- Document all public classes and methods
- Include parameter descriptions and return values
- Add brief descriptions for complex algorithms

## Build System Integration

### CMake Configuration
- C++11 standard (current)
- Thread support enabled
- Proper dependency management
- Boost integration

### Quality Checks
1. **Pre-build**: Formatting verification
2. **Build**: Compiler warnings as errors (recommended)
3. **Post-build**: Static analysis (future enhancement)

## Development Workflow

### Before Committing
1. Run `./format_code.sh` to ensure consistent formatting
2. Run `./analyze_code.sh` to check for quality issues
3. Run `./build_with_checks.sh` to verify build success
4. Consider installing the pre-commit hook: `cp pre-commit-hook.sh .git/hooks/pre-commit`

### Code Review Checklist
- [ ] All functions under 20 lines
- [ ] No magic numbers (use named constants)
- [ ] Proper const-correctness
- [ ] RAII for resource management
- [ ] Doxygen comments for public APIs
- [ ] No deep nesting (max 3 levels)
- [ ] Descriptive variable and function names

## Current Status

### Completed Improvements
✅ **Code Formatting**: All files formatted with clang-format-12  
✅ **Build Scripts**: Automated formatting verification  
✅ **Analysis Tools**: Comprehensive code quality analysis  
✅ **Documentation**: Development guide and standards  
✅ **Git Integration**: Pre-commit hook for formatting  

### Recommended Future Enhancements
- [ ] Upgrade to C++17 or C++20 for modern features
- [ ] Replace magic numbers with named constants
- [ ] Add unit tests for core functionality
- [ ] Implement static analysis with cppcheck
- [ ] Add automated CI/CD pipeline
- [ ] Migrate from Boost to std library where possible

## Usage Examples

### Running Formatting Check
```bash
# Check all files
find . -name "*.cpp" -o -name "*.h" | xargs clang-format-12 --dry-run --Werror

# Format all files
./format_code.sh
```

### Building with Quality Checks
```bash
# Standard build with checks
./build_with_checks.sh

# Clean build with checks
./build_with_checks.sh clean
```

### Code Analysis
```bash
# Run comprehensive analysis
./analyze_code.sh
```

## Integration with IDEs

### VS Code
1. Install C/C++ extension
2. Install Clang-Format extension
3. Configure format on save
4. Use provided `.clang-format` configuration

### CLion/Other IDEs
1. Configure clang-format as external tool
2. Set up format on save
3. Import code style from `.clang-format`

## Maintenance

### Updating Standards
- Review and update `.clang-format` configuration as needed
- Update this guide when standards change
- Ensure all team members follow the same standards
- Regular code quality reviews

### Performance Monitoring
- Monitor build times after changes
- Profile code changes for performance impact
- Regular dependency updates

---
**Last Updated**: September 25, 2025  
**Version**: 1.0  
**Maintainer**: Senior Developer Team