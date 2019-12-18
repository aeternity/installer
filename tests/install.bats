#!/usr/bin/env bats

load test_helper

@test "--help print usage information" {
    run ./install.sh --help
    [ "${lines[0]}" = "Usage:" ]
    [[ $status -eq 1 ]]
}

@test "fail if release does not exits" {
    run ./install.sh 1.1.1
    [[ ${output} =~ "ERROR: Release package not found" ]]
    [[ $status -eq 1 ]]
}

@test "install specific version (openssl@1.0)" {
    run ./install.sh --no-prompt 2.0.0
    [[ ${output} =~ "Installation completed" ]]
    [[ $status -eq 0 ]]

    [[ -f $NODE_DIR/bin/aeternity ]]
    $NODE_DIR/bin/aeternity start && sleep 10
    $NODE_DIR/bin/aeternity ping
    $NODE_DIR/bin/aeternity stop
}

@test "install specific version and update to latest version" {
    run ./install.sh --no-prompt 4.0.0
    [[ ${output} =~ "Installation completed" ]]
    [[ $status -eq 0 ]]

    [[ -f $NODE_DIR/bin/aeternity ]]
    $NODE_DIR/bin/aeternity start && sleep 10
    $NODE_DIR/bin/aeternity ping
    $NODE_DIR/bin/aeternity stop

    run ./install.sh --no-prompt
    [[ ${output} =~ "Installation completed" ]]
    [[ $status -eq 0 ]]

    [[ -f $NODE_DIR/bin/aeternity ]]
    $NODE_DIR/bin/aeternity start && sleep 10
    $NODE_DIR/bin/aeternity ping
    $NODE_DIR/bin/aeternity stop
}

@test "install specific version (openssl@1.1)" {
    run ./install.sh --no-prompt 5.0.0
    [[ ${output} =~ "Installation completed" ]]
    [[ $status -eq 0 ]]

    [[ -f $NODE_DIR/bin/aeternity ]]
    $NODE_DIR/bin/aeternity start && sleep 10
    $NODE_DIR/bin/aeternity ping
    $NODE_DIR/bin/aeternity stop
}

@test "install latest version" {
    run ./install.sh --no-prompt
    [[ ${output} =~ "Installation completed." ]]
    [[ $status -eq 0 ]]

    [[ -f $NODE_DIR/bin/aeternity ]]
    $NODE_DIR/bin/aeternity start && sleep 10
    $NODE_DIR/bin/aeternity ping
    $NODE_DIR/bin/aeternity stop
}
