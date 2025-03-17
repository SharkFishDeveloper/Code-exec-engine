#!/bin/bash

# Path to the code file to compile
# /usr/src/app/cpp-engine/app/main
if [ -z "$1" ]; then
    echo "No language specified! Use 'c' or 'cpp'."
    exit 1
fi

FILE_EXTENSION="$1"
CODE_FILE="/usr/src/app/cpp-engine/app/main.${FILE_EXTENSION}"


if [ "$FILE_EXTENSION" == "c" ]; then
    clang -o output_program "$CODE_FILE" 2> compile_error.txt
elif [ "$FILE_EXTENSION" == "cpp" ]; then
    clang++ -o output_program "$CODE_FILE" 2> compile_error.txt
else
    echo "Invalid language specified. Use 'c' or 'cpp'."
    exit 1
fi

# Check if there were any compilation errors
if [ $? -ne 0 ]; then
    echo -e "Compilation failed!\n"
    cat compile_error.txt
    exit 1
fi

# Check if input file exists
INPUT_FILE="/usr/src/app/cpp-engine/app/input.txt"
if [ -f "$INPUT_FILE" ]; then
    # Run the compiled program with input redirection
    ./output_program < "$INPUT_FILE" > output.txt 2> runtime_error.txt
else
    # Run the compiled program without input redirection
    ./output_program > output.txt 2> runtime_error.txt
fi

# Check if there were any runtime errors
if [ $? -ne 0 ]; then
    echo -e "Runtime error!\n"
    cat runtime_error.txt
    exit 1
fi

cat output.txt