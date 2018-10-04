#!/usr/bin/env bash
set -o errexit

. test_helper.bash

mkdir files
cd files

setup_gpg

make_gpg_key() {
    set=$1
    uid=$2
    name=$3
    trust=$4
    expiration=$5

    setup_gpg
    faketime -f -2y \
    gpg --batch --pinentry-mode loopback --yes --passphrase "" \
        --quick-generate-key "$name <$uid@$set>" default default ${expiration:-never}
    gpg --armor --export-secret-key > $set/$uid.key
    cp $GNUPGHOME/openpgp-revocs.d/*.rev $set/$uid.rev
    sed -i "s/:---/---/" $set/$uid.rev
    if [[ "$trust" != "" ]]; then
        grip=$(basename $GNUPGHOME/openpgp-revocs.d/*.rev)
        grip=${grip%.rev}
        echo "$grip:$trust:" >> $set/trust
    fi
    teardown_gpg
}

mkdir -p example.com
echo -n > example.com/trust

make_gpg_key example.com author1    "Author 1"   6
make_gpg_key example.com approver1  "Approver 1" 6
make_gpg_key example.com approver2  "Approver 2" 6

make_gpg_key example.com expired1   "Expired 1"  6 "1y"

make_gpg_key example.com sillyUID1  "VALIDSIG|ULTIMATE Silly 1"
make_gpg_key example.com sillyUID2  "VALIDSIG|ULTIMATE| Silly 2"
make_gpg_key example.com sillierUID "Sillier
DEADBEEF|VALIDSIG|ULTIMATE|"

mkdir -p example.org
echo -n > example.org/trust

make_gpg_key example.org author2    "Author 2"   6
