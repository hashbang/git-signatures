setup(){
	[[ -f "/usr/bin/gpg2" ]] && alias gpg="/usr/bin/gpg2"
	PATH="$PATH:bin"
	REPO_REMOTE="$(mktemp -d)"; export REPO_REMOTE
	REPO_LOCAL="$(mktemp -d)"; export REPO_LOCAL
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME
	gpg-agent \
		--daemon \
		--allow-preset-passphrase 2>&1 &
	export GPG_AGENT_PID="$!"
	echo "GPG_AGENT_PID=$GPG_AGENT_PID"
	gpg --import test/files/keys/*.key
	gpg --import-ownertrust test/files/keys/keys.trust

	git init --bare "$REPO_REMOTE"
	git clone "$REPO_REMOTE" "$REPO_LOCAL"

	export GIT_WORK_TREE=$REPO_LOCAL
	export GIT_DIR=$REPO_LOCAL/.git

	touch "$REPO_LOCAL/testfile"

	git add .
	git config user.name "Author 1"
	git config user.email "author1@company.com"
	git config user.signingkey "author1@company.com"
	git commit -m "initial commit"

}

teardown(){
	rm -rf "$REPO_REMOTE" "$REPO_LOCAL" "$GNUPGHOME"
	kill -9 "$GPG_AGENT_PID" || true
}
