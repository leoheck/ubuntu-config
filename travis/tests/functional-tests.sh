#!/bin/bash

# set -e -x
# echo "TODO: Implement shunit2/bats tests"

bats trevis/tests/bats-tests.bats
./trevis/tests/shunit2-tests.sh