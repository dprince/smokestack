#!/bin/bash

NOVA_URL=$1
NOVA_BRANCH=$2
NOVA_MERGE_TRUNK=$3
NOVA_REVISION=$4
NOVA_DEB_PACKAGER_URL=$5
NOVA_RPM_PACKAGER_URL=$6

KEYSTONE_URL=$7
KEYSTONE_BRANCH=$8
KEYSTONE_MERGE_TRUNK=$9
KEYSTONE_REVISION=${10}
KEYSTONE_DEB_PACKAGER_URL=${11}
KEYSTONE_RPM_PACKAGER_URL=${12}

GLANCE_URL=${13}
GLANCE_BRANCH=${14}
GLANCE_MERGE_TRUNK=${15}
GLANCE_REVISION=${16}
GLANCE_DEB_PACKAGER_URL=${17}
GLANCE_RPM_PACKAGER_URL=${18}

CHEF_INSTALLER_CONF=${19}
NODES_JSON_CONF=${20}
SERVER_GROUP_JSON_CONF=${21}

# Log to the job log and stdout
function fail {
	local MSG=$1
	echo "FAILURE_MSG=$MSG"
	exit 1
}

function git_clone {
        local URL=${1:?"Please specify a URL."}
        local DIR=${2:?"Please specify a DIR."}
        local COUNT=1
        until GIT_ASKPASS=echo git clone "$URL" "$DIR"; do
                [ "$COUNT" -eq "4" ] && fail "Failed to clone: $URL"
                sleep $(( $COUNT * 5 ))
                COUNT=$(( $COUNT + 1 ))
        done
}

function get_nova_source_bzr {

	bzr branch "$NOVA_URL" nova_source || \
		fail "Failed to checkout bzr branch."
	if [ -n "$NOVA_REVISION" ]; then
		pushd nova_source
		bzr revert --revision="$NOVA_REVISION" || \
			fail "Failed to revert to revision $NOVA_REVISION."
		bzr commit -m "Revert to revision $NOVA_REVISION." || \
			fail "Failed to commit revert to revision $NOVA_REVISION."
		popd
	else
	    NOVA_REVISION=$(bzr version-info nova_source | grep revno | sed -e "s|revno: ||")
		[ -z "$NOVA_REVISION" ] && fail "Failed to obtain nova revision from bzr."
	fi
	echo "NOVA_REVISION=$NOVA_REVISION"

	if [[ "$NOVA_MERGE_TRUNK" == "true" ]]; then
		pushd nova_source || fail "Failed to cd into nova_source directory."
		bzr merge lp:nova || fail "Failed to merge lp:nova."
		popd
	fi

}

function get_nova_source_git {

	git_clone "$NOVA_GIT_MASTER" "nova_source"
	pushd nova_source
	git fetch $NOVA_URL $NOVA_BRANCH || \
		fail "Failed to git fetch branch $NOVA_BRANCH."
	git checkout -q FETCH_HEAD || fail "Failed to git checkout FETCH_HEAD."

	if [ -n "$NOVA_REVISION" ]; then
		git checkout $NOVA_REVISION || \
			fail "Failed to revert to revision $NOVA_REVISION."
	else
		NOVA_REVISION=$(git rev-parse --short HEAD)
		[ -z "$NOVA_REVISION" ] && \
			fail "Failed to obtain nova revision from git."
	fi
	echo "NOVA_REVISION=$NOVA_REVISION"

	if [[ "$NOVA_MERGE_TRUNK" == "true" ]]; then
		git rebase master || fail "Failed to rebase master."
	fi

	popd
}

function get_keystone_source_bzr {
   #NOTE: Does anyone uses bzr for Keystone development?
	bzr branch "$KEYSTONE_URL" keystone_source || \
		fail "Failed to checkout bzr branch."
	if [ -n "$KEYSTONE_REVISION" ]; then
		pushd keystone_source
		bzr revert --revision="$KEYSTONE_REVISION" || \
			fail "Failed to revert to revision $KEYSTONE_REVISION."
		bzr commit -m "Revert to revision $KEYSTONE_REVISION." || \
			fail "Failed to commit revert to revision $KEYSTONE_REVISION."
		popd
	else
		KEYSTONE_REVISION=$(bzr version-info keystone_source | grep revno | sed -e "s|revno: ||")
		[ -z "$KEYSTONE_REVISION" ] && fail "Failed to obtain keystone revision from bzr."
	fi
	echo "KEYSTONE_REVISION=$KEYSTONE_REVISION"

	if [[ "$KEYSTONE_MERGE_TRUNK" == "true" ]]; then
		pushd keystone_source || fail "Failed to cd into keystone_source directory."
        #NOTE: this may fail (I'm not sure there is an lp:keystone)
		bzr merge lp:keystone || fail "Failed to merge lp:keystone."
		popd
	fi

}

function get_keystone_source_git {

	git_clone "$KEYSTONE_GIT_MASTER" "keystone_source"
	pushd keystone_source
	git fetch $KEYSTONE_URL $KEYSTONE_BRANCH || \
		fail "Failed to git fetch branch $KEYSTONE_BRANCH."
	git checkout -q FETCH_HEAD || fail "Failed to git checkout FETCH_HEAD."

	if [ -n "$KEYSTONE_REVISION" ]; then
		git checkout $KEYSTONE_REVISION || \
			fail "Failed to revert to revision $KEYSTONE_REVISION."
	else
		KEYSTONE_REVISION=$(git rev-parse --short HEAD)
		[ -z "$KEYSTONE_REVISION" ] && \
			fail "Failed to obtain keystone revision from git."
	fi
	echo "KEYSTONE_REVISION=$KEYSTONE_REVISION"

	if [[ "$KEYSTONE_MERGE_TRUNK" == "true" ]]; then
		git rebase master || fail "Failed to rebase master."
	fi

	popd
}

function get_glance_source_bzr {

	bzr branch "$GLANCE_URL" glance_source || \
		fail "Failed to checkout bzr branch."
	if [ -n "$GLANCE_REVISION" ]; then
		pushd glance_source
		bzr revert --revision="$GLANCE_REVISION" || \
			fail "Failed to revert to revision $GLANCE_REVISION."
		bzr commit -m "Revert to revision $GLANCE_REVISION." || \
			fail "Failed to commit revert to revision $GLANCE_REVISION."
		popd
	else
		GLANCE_REVISION=$(bzr version-info glance_source | grep revno | sed -e "s|revno: ||")
		[ -z "$GLANCE_REVISION" ] && fail "Failed to obtain glance revision from bzr."
	fi
	echo "GLANCE_REVISION=$GLANCE_REVISION"

	if [[ "$GLANCE_MERGE_TRUNK" == "true" ]]; then
		pushd glance_source || fail "Failed to cd into glance_source directory."
		bzr merge lp:glance || fail "Failed to merge lp:glance."
		popd
	fi

}

function get_glance_source_git {

	git_clone "$GLANCE_GIT_MASTER" "glance_source"
	pushd glance_source
	git fetch $GLANCE_URL $GLANCE_BRANCH || \
		fail "Failed to git fetch branch $GLANCE_BRANCH."
	git checkout -q FETCH_HEAD || fail "Failed to git checkout FETCH_HEAD."

	if [ -n "$GLANCE_REVISION" ]; then
		git checkout $GLANCE_REVISION || \
			fail "Failed to revert to revision $GLANCE_REVISION."
	else
		GLANCE_REVISION=$(git rev-parse --short HEAD)
		[ -z "$GLANCE_REVISION" ] && \
			fail "Failed to obtain glance revision from git."
	fi
	echo "GLANCE_REVISION=$GLANCE_REVISION"

	if [[ "$GLANCE_MERGE_TRUNK" == "true" ]]; then
		git rebase master || fail "Failed to rebase master."
	fi

    popd

}
