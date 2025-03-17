#!/bin/bash

# Path to the code file to compile
# /usr/src/app/cpp-engine/app/main
if [ -z "$1" ]; then
    echo "No language specified! Use 'c' or 'cpp'."
    exit 1
fi

FILE_EXTENSION="$1"
CODE_FILE="/usr/src/app/cpp-engine/app/main.${FILE_EXTENSION}"

# Check if the code file exists
if [ ! -f "$CODE_FILE" ]; then
    echo "Error: Code file not found: $CODE_FILE"
    exit 1
fi


if [ "$FILE_EXTENSION" == "c" ]; then
    clang -o output_program "$CODE_FILE" 2> compile_error.txt
elif [ "$FILE_EXTENSION" == "cpp" ]; then
    clang++ -o output_program "$CODE_FILE" 2> compile_error.txt
else
    echo "Error: Invalid language specified. Use 'c' or 'cpp'."
    exit 1
fi

# Check if there were any compilation errors
if [ $? -ne 0 ]; then
    echo -e "Compilation failed!\n"
    if [ -s "compile_error.txt" ]; then
        cat compile_error.txt
    else
        echo "No compilation error message found."
    fi
    exit 1
fi

# start
INPUT_FILE="/usr/src/app/cpp-engine/app/input.txt"
if [ -f "$INPUT_FILE" ]; then
    # Run the compiled program with input redirection
    ./output_program < "$INPUT_FILE" > output.txt 2> runtime_error.txt
else
    # Run the compiled program without input redirection
    ./output_program > output.txt 2> runtime_error.txt
fi
# end

# Check if there were any runtime errors
if [ $? -ne 0 ]; then
    echo -e "Runtime error!\n"
    if [ -s "runtime_error.txt" ]; then
        cat runtime_error.txt
    else
        echo "No runtime error message found."
    fi
    exit 1
fi

# Check if output.txt exists before attempting to cat it
if [ -f "output.txt" ]; then
    cat output.txt
else
    echo "Output file not found."
    exit 1
fi

# Note: This script assumes sufficient permissions to execute the compiled program
# and create/write to files in the current directory.  File permission issues
# are outside the scope of this script and must be handled separately.