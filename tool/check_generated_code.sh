#!/usr/bin/env bash

# This script checks that the generated code is up to date.

set -e

# Require that the repo is clean.
if [[ -n $(git status --porcelain) ]]; then
    echo "ERROR: Repo is not clean. Please commit or stash changes."
    exit 1
fi

# Run the code generation.
dart run build_runner build --delete-conflicting-outputs

# Check that the repo is still clean.
if [[ -n $(git status --porcelain) ]]; then
    echo "ERROR: Generated code is out of date. Please run 'dart run build_runner build --delete-conflicting-outputs' and commit the changes."
    exit 1
fi
