setup_gpg() {
	[[ -f "/usr/bin/gpg2" ]] && alias gpg="/usr/bin/gpg2"
	export GNUPGHOME=$(mktemp -d)
	gpg-agent \
		--daemon \
		--allow-preset-passphrase 3>&- &
	export GPG_AGENT_PID="$!"

	echo "GNUPGHOME=$GNUPGHOME"
	echo "GPG_AGENT_PID=$GPG_AGENT_PID"
}

teardown_gpg() {
	rm -rf "$GNUPGHOME"
	kill -9 "$GPG_AGENT_PID" || true
}

setup(){
	# git sets this for commands it execs from git-rebase
	# thus breaking tests running from git-rebase
	unset GIT_DIR

	setup_gpg

	export FILES=$(pwd)/files

	gpg --import "$FILES"/example.com/*.key &>/dev/null
	gpg --import-ownertrust "$FILES"/example.com/trust &>/dev/null
	gpg -k

	export PATH=$(pwd)/../bin:$PATH

	export REPO_REMOTE=$(mktemp -d)
	export REPO_LOCAL=$(mktemp -d)
	git init --bare "$REPO_REMOTE"
	git clone "$REPO_REMOTE" "$REPO_LOCAL"

	cd "$REPO_LOCAL"

	git config user.name "Author 1"
	git config user.email "author1@example.com"
	git config user.signingkey "author1@example.com"

	touch testfile
	git add .
	git commit -m "initial commit"

	echo "changes" > testfile
	git add .
	git commit -m "second commit"
}

teardown(){
	teardown_gpg
	rm -rf "$REPO_REMOTE" "$REPO_LOCAL"
}
