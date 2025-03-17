#!/bin/bash

# Path to the Python file to run
CODE_FILE="/usr/src/app/js-engine/app/index.js"
INPUT_REQUIRED=false

# Check for the flag (modify if using a different flag name)
if [[ "$1" == "inputtrue" ]]; then
  INPUT_REQUIRED=true
  shift  # Remove the flag from the argument list
fi

# Execute the nodejs command
if [[ $INPUT_REQUIRED == true ]]; then
  if nodejs $CODE_FILE < /usr/src/app/js-engine/app/input.txt > output.txt 2> runtime_error.txt; then
    # Check if output.txt exists and is not empty before printing.
    if [ -s output.txt ]; then
      cat output.txt
    else
      echo "Output file is empty."
    fi
  else
    echo "Runtime error!"
    if [ -s runtime_error.txt ]; then
      cat runtime_error.txt
    else
      echo "No runtime error message available."
    fi
    exit 1
  fi
else
  if nodejs $CODE_FILE > output.txt 2> runtime_error.txt; then
    # Check if output.txt exists and is not empty before printing.
    if [ -s output.txt ]; then
      cat output.txt
    else
      echo "Output file is empty."
    fi
  else
    echo "Runtime error!"
    if [ -s runtime_error.txt ]; then
      cat runtime_error.txt
    else
      echo "No runtime error message available."
    fi
    exit 1
  fi
fi