#!/usr/bin/env bash
set -o errexit

. test_helper.bash

setup_gpg
mkdir -p files/keys
echo -n > files/keys/keys.trust

make_gpg_key() {
    setup_gpg
    gpg --batch --pinentry-mode loopback --yes --passphrase "" \
        --quick-generate-key "$2" default default never
    gpg --armor --export-secret-key > files/keys/$1.key
    cp $GNUPGHOME/openpgp-revocs.d/*.rev files/keys/$1.rev
    sed -i "s/:---/---/" files/keys/$1.rev
    if [[ "$3" != "" ]]; then
        grip=$(basename $GNUPGHOME/openpgp-revocs.d/*.rev)
        grip=${grip%.rev}
        echo "$grip:$3:" >> files/keys/keys.trust
    fi
    teardown_gpg
}

make_gpg_key author1   "Author 1 <author1@example.com>"     6
make_gpg_key approver1 "Approver 1 <approver1@example.com>" 6
make_gpg_key approver2 "Approver 2 <approver2@example.com>" 6
