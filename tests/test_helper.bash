cleanup() {
    if [[ -d "${NODE_DIR:-}" ]]; then
        rm -rf "$NODE_DIR"
    fi
}

setup() {
    export NODE_DIR=$HOME/aeternity/node

    cleanup
}

teardown() {
    cleanup
}
