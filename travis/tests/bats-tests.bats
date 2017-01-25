#!/usr/bin/env bats

# Examples using BATS (Bash Automated Testing System)
#====================================================

@test "addition using bc" {
	result="$(echo 2+2 | bc)"
	[ "$result" -eq 4 ]
}

# @test "addition using dc" {
# 	result="$(echo 2 2+p | dc)"
# 	[ "$result" -eq 4 ]
# }

# @test "invoking foo with a nonexistent file prints an error" {
#   run foo nonexistent_filename
#   [ "$status" -eq 1 ]
#   [ "$output" = "foo: no such file 'nonexistent_filename'" ]
# }

# @test "invoking foo without arguments prints usage" {
#   run foo
#   [ "$status" -eq 1 ]
#   [ "${lines[0]}" = "usage: foo <filename>" ]
# }

@test "A test I don't want to execute for now" {
  skip
  run foo
  [ "$status" -eq 0 ]
}

@test "A test I don't want to execute for now" {
  skip "This command will return zero soon, but not now"
  run foo
  [ "$status" -eq 0 ]
}

@test "A test which should run" {
  if [ foo != bar ]; then
    skip "foo isn't bar"
  fi

  run foo
  [ "$status" -eq 0 ]
}