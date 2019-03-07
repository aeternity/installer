#!/usr/bin/env bats

@test "fail on no version" {
    run ./install.sh
    [ "${lines[0]}" = "ERROR: No release version given" ]
    [ "$status" -eq 1 ]
}

@test "fail on wrong version" {
    run ./install.sh -v 1.2
    [ "${lines[0]}" = "ERROR: wrong version format" ]
    [ "$status" -eq 1 ]
}

@test "fail on not existing version" {
    run ./install.sh -v 0.0.0 --do-not-prompt
    [[ ${output} =~ "ERROR: release do not exist" ]]
}

@test "install version" {
    run ./install.sh -v 2.0.0 --do-not-prompt
    [[ ${output} =~ "Instalation completed." ]]
}
