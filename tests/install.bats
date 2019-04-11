#!/usr/bin/env bats

load test_helper

@test "fail if not release version is provided" {
    run ./install.sh
    [[ ${lines[0]} = "ERROR: No release version given" ]]
    [[ $status -eq 1 ]]
}

@test "fail if release does not exits" {
    run ./install.sh 1.1.1
    [[ ${output} =~ "ERROR: Release package not found" ]]
    [[ $status -eq 1 ]]
}

@test "install specific version" {
    run ./install.sh 2.0.0 auto
    [[ ${output} =~ "Installation completed" ]]
    [[ $status -eq 0 ]]

    [[ -f $NODE_DIR/bin/aeternity ]]
    $NODE_DIR/bin/aeternity start && sleep 5
    $NODE_DIR/bin/aeternity ping
    $NODE_DIR/bin/aeternity stop
}

@test "install latest version" {
    skip "Not implemented yet."
    run ./install.sh auto
    [[ ${output} =~ "Installation completed." ]]
    [[ $status -eq 0 ]]

    [[ -f $NODE_DIR/bin/aeternity ]]
    $NODE_DIR/bin/aeternity start && sleep 5
    $NODE_DIR/bin/aeternity ping
    $NODE_DIR/bin/aeternity stop
}
