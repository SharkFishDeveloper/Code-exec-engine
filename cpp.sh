#!/bin/bash

# Path to the code file to compile
# /usr/src/app/cpp-engine/app/main
if [ -z "$1" ]; then
    echo "No language specified! Use 'c' or 'cpp'."
    exit 1
fi

FILE_EXTENSION="$1"

# Validate the file extension early
if ! [[ "$FILE_EXTENSION" =~ ^(c|cpp)$ ]]; then
    echo "Invalid language specified. Use 'c' or 'cpp'."
    exit 1
fi

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
fi

# Check if there were any compilation errors
if [ $? -ne 0 ]; then
    echo -e "Compilation failed!\n"
    cat compile_error.txt
    exit 1
fi

# Remove the initial execution and runtime error checks. The redirection part handles execution.

# start
INPUT_FILE="/usr/src/app/cpp-engine/app/input.txt"
if [ -f "$INPUT_FILE" ]; then
    # Run the compiled program with input redirection
    ./output_program < "$INPUT_FILE" > output.txt 2> runtime_error.txt
    RUNTIME_STATUS=$?
else
    # Run the compiled program without input redirection
    ./output_program > output.txt 2> runtime_error.txt
    RUNTIME_STATUS=$?
fi
# end

# Check for runtime errors *after* the execution
if [ $RUNTIME_STATUS -ne 0 ]; then
    echo -e "Runtime error!\n"
    cat runtime_error.txt
    exit 1
fi

# Check if output.txt exists before attempting to cat it
if [ ! -f "output.txt" ]; then
    echo "Error: output.txt not found after execution."
    exit 1
fi

cat output.txt