#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

RELEASE_VERSION="latest"
TEMP_RELEASE_FILE=${TEMP_RELEASE_FILE:=/tmp/aeternity.tgz}
TARGET_DIR=${TARGET_DIR:=$HOME/aeternity/node}
SNAPSHOT_DIR=${SNAPSHOT_DIR:=$TARGET_DIR/data}
SNAPSHOT_URL="https://aeternity-database-backups.s3.eu-central-1.amazonaws.com"
SNAPSHOT_FILE="mnesia_main_v-1_latest.tgz"
SHOW_PROMPT=true
DELETE_TARGET_DIR=false
SNAPSHOT_RESTORE=false

usage () {
    echo -e "Usage:\n"
    echo -e "  $0 [options] release_version\n"
    echo "Options:"
    echo -e "  --no-prompt Disable confirmation prompts.\n"
    echo -e "  --snapshot-restore Restore the database from a snapshot.\n"
    echo "Release version format is X.Y.Z where X, Y, and Z are non-negative integers"
    echo "You can find a list of aeternity releases at https://github.com/aeternity/aeternity/releases"
    exit 1
}

for arg in "$@"; do
    case $arg in
        --no-prompt)
            SHOW_PROMPT=false
            shift
        ;;
        --delete)
            DELETE_TARGET_DIR=true
            shift
        ;;
        --snapshot-restore)
            SNAPSHOT_RESTORE=true
            shift
        ;;
        --help)
            usage
        ;;
        --*)
            echo -e "ERROR: Unknown option '$arg'\n"
            usage
        ;;
        *)
        # do nothing, it's interpreted as version below
        ;;
    esac
done

# latest argument is interpreted as version
if [ $# -gt 0 ]; then
    RELEASE_VERSION=${@:$#}
fi

in_array() {
    local haystack=${1}[@]
    local needle=${2}
    for i in ${!haystack}; do
        if [[ ${i} == ${needle} ]]; then
            return 0
        fi
    done
    return 1
}

install_prompt () {
    if [ "$DELETE_TARGET_DIR" = true ]; then
        echo -e "\nATTENTION: This script will delete the directory ${TARGET_DIR} if it exists. You should back up any contents before continuing.\n"
    else
        echo -e "\nATTENTION: This script will update the directory ${TARGET_DIR} if it exists. You should back up any contents before continuing.\n"
    fi
    read -p "Continue (y/n)?" inputprerunchoice
    case "$inputprerunchoice" in
        y|Y )
            echo "Continuing..."
            ;;
        n|N )
            echo "Exiting..."
            exit 0
            ;;
        * )
            echo "Invalid input..."
            install_prompt
            ;;
    esac
}

install_deps_ubuntu() {
    OS_RELEASE=$(lsb_release -r -s)
    echo -e "\nPrepare host system and install dependencies ...\n"
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y curl libssl1.0.0

    if [[ "$OS_RELEASE" = "16.04" ]]; then
        sudo apt-get install -y build-essential
        LIB_VERSION=1.0.17
        wget https://download.libsodium.org/libsodium/releases/libsodium-${LIB_VERSION}.tar.gz
        tar -xf libsodium-${LIB_VERSION}.tar.gz && cd libsodium-${LIB_VERSION} &&
        ./configure && make && sudo make install && sudo ldconfig
        cd .. && rm -rf libsodium-${LIB_VERSION} && rm libsodium-${LIB_VERSION}.tar.gz
    elif [[ "$OS_RELEASE" = "18.04" ]]; then
        sudo apt-get install -y curl libsodium23
    else
        echo -e "Unsupported Ubuntu version! Please refer to the documentation for supported versions."
        exit 1
    fi
}

install_deps_osx() {
    VER=$(sw_vers -productVersion)

    if ! [[ $VER = "11."* || $VER = "12."* || $VER = "13."* ]]; then
        echo -e "Unsupported OSX version! Please refer to the documentation for supported versions."
        exit 1
    fi

    echo -e "\nInstalling dependencies ...\n"
    brew update

    if [[ ! $(brew ls --versions openssl) || $RELEASE_VERSION = "latest" || ! $RELEASE_VERSION < "5.0.0" ]]; then
        brew install openssl@1.1
    fi

    if ! [[ $(brew ls --versions libsodium) ]]; then
        brew install libsodium
    fi

    if [[ $RELEASE_VERSION > "5.2.0" ]]; then
        brew install gmp
    fi
}

install_node() {
    RELEASE_FILE=$1
    echo -e "\nInstalling release ${RELEASE_VERSION} ...\n"

    if curl -Lf -o "${TEMP_RELEASE_FILE}" "${RELEASE_FILE}"; then
        if [ "$SHOW_PROMPT" = true ]; then
            install_prompt
        fi

        if [ "$DELETE_TARGET_DIR" = true ]; then
            rm -rf "${TARGET_DIR}"
        fi

        mkdir -p "${TARGET_DIR}"
        tar -C "${TARGET_DIR}" -xzf "${TEMP_RELEASE_FILE}"

        echo -e "\nCleanup...\n"
        rm "${TEMP_RELEASE_FILE}"
    else
        echo -e "ERROR: Release package not found.\n"
        exit 1
    fi
}

snapshot_restore() {
    if [ $SHOW_PROMPT = true ]; then
        echo -e "\nATTENTION: This script will delete the directory ${SNAPSHOT_DIR}/mnesia if it exists and will restore the node database from a snapshot. You should back up any contents before continuing.\n"

        read -p "Restore (y/n)?" inputprerunchoice
        case "$inputprerunchoice" in
            y|Y )
                SNAPSHOT_RESTORE=true
                ;;
            n|N )
                SNAPSHOT_RESTORE=false
                ;;
            * )
                echo "Invalid input..."
                snapshot_restore
                ;;
        esac
    fi

    if [ $SNAPSHOT_RESTORE = true ]; then
        rm -rf "$SNAPSHOT_DIR/mnesia"

        if curl -Lf -o "${SNAPSHOT_DIR}/${SNAPSHOT_FILE}" "${SNAPSHOT_URL}/${SNAPSHOT_FILE}"; then
            CHECKSUM=$(curl ${SNAPSHOT_URL}/${SNAPSHOT_FILE}.md5)

            diff -qs <(echo $CHECKSUM) <(openssl md5 -r ${SNAPSHOT_DIR}/${SNAPSHOT_FILE} | awk '{ print $1; }')
            test $? -eq 0 && tar -xzf ${SNAPSHOT_DIR}/${SNAPSHOT_FILE} -C ${SNAPSHOT_DIR}
            mv ${SNAPSHOT_DIR}/db1/mnesia ${SNAPSHOT_DIR}

            echo -e "\nCleanup...\n"
            rm -rf "${SNAPSHOT_DIR}/${SNAPSHOT_FILE}" "${SNAPSHOT_DIR}/db1"
        fi
    fi
}

if [ "$RELEASE_VERSION" = "latest" ];
    VERSION_STRING="latest"
else
    VERSION_STRING="v${RELEASE_VERSION}"
fi

if [[ "$OSTYPE" = "linux-gnu" && $(lsb_release -i -s) = "Ubuntu" ]]; then
    install_deps_ubuntu
    install_node "https://releases.aeternity.io/aeternity-${VERSION_STRING}-ubuntu-x86_64.tar.gz"
    snapshot_restore
elif [[ "$OSTYPE" = "darwin"* ]]; then
    install_deps_osx
    install_node "https://releases.aeternity.io/aeternity-${VERSION_STRING}-macos-x86_64.tar.gz"
    snapshot_restore
else
    echo -e "Unsupported platform (OS)! Please refer to the documentation for supported platforms."
    exit 1
fi

echo -e "Installation completed."
echo -e "Run '${TARGET_DIR}/bin/aeternity start' to start the node in the background or"
echo -e "Run '${TARGET_DIR}/bin/aeternity console' to start the node with console output"
