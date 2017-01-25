#!/bin/bash

# Examples using SHUnit2
#====================================================

testEquality() {
	assertEquals 1 1
}

testPartyLikeItIs1999() {
	year=$(date '+%Y')
	assertEquals "It's not 1999 :-(" '1999' "${year}"
}

# load shunit2
. shunit2
