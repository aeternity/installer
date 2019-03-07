#!/usr/bin/env bats

@test "fail on no version" {
    run ./install.sh
    [[ ${lines[0]} =~ "ERROR: No release version given" ]]
}

@test "fail on wrong version" {
    run echo "y" | ./install.sh 1.2
    [[ ${lines[0]} =~ "ERROR: wrong version format" ]]
}

@test "fail on not existing version" {
    run echo "y" | ./install.sh 0.0.0
    [[ ${lines[0]} =~ "ERROR: wrong version format" ]]
}
