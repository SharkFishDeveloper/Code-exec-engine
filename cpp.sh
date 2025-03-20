#!/bin/bash

# Path to the code file to compile
# /usr/src/app/cpp-engine/app/main

set -e

if [ -z "$1" ]; then
    echo "No language specified! Use 'c' or 'cpp'."
    exit 1
fi

FILE_EXTENSION="$1"
CODE_FILE="/usr/src/app/cpp-engine/app/main.${FILE_EXTENSION}"

# Validate file extension
if [[ "$FILE_EXTENSION" != "c" && "$FILE_EXTENSION" != "cpp" ]]; then
    echo "Invalid file extension.  Must be 'c' or 'cpp'."
    exit 1
fi

# Check if the code file exists
if [ ! -f "$CODE_FILE" ]; then
    echo "Error: Code file '$CODE_FILE' not found."
    exit 1
fi

if [ "$FILE_EXTENSION" == "c" ]; then
    clang -o output_program "$CODE_FILE" 2> compile_error.txt
elif [ "$FILE_EXTENSION" == "cpp" ]; then
    clang++ -o output_program "$CODE_FILE" 2> compile_error.txt
fi

# Check if there were any compilation errors
if [ $? -ne 0 ]; then
    echo -e "Compilation failed!\n"
    cat compile_error.txt
    exit 1
fi

# Determine input redirection and run the program only once
if [ -f "/usr/src/app/cpp-engine/app/input.txt" ]; then
    ./output_program < /usr/src/app/cpp-engine/app/input.txt > output.txt 2> runtime_error.txt
else
    ./output_program > output.txt 2> runtime_error.txt
fi

# Check if there were any runtime errors
if [ $? -ne 0 ]; then
    echo -e "Runtime error!\n"
    cat runtime_error.txt
    exit 1
fi

cat output.txt