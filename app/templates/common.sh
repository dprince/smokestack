#!/bin/bash


CUSTOM_ENV_FILE=${1}
source $CUSTOM_ENV_FILE

NOVA_URL=${2}
NOVA_BRANCH=${3}
NOVA_MERGE_TRUNK=${4}
NOVA_REVISION=${5}
NOVA_DEB_PACKAGER_URL=${6:-$NOVA_DEB_PACKAGER_URL}
NOVA_RPM_PACKAGER_URL=${7:-$NOVA_RPM_PACKAGER_URL}

KEYSTONE_URL=${8}
KEYSTONE_BRANCH=${9}
KEYSTONE_MERGE_TRUNK=${10}
KEYSTONE_REVISION=${11}
KEYSTONE_DEB_PACKAGER_URL=${12:-$KEYSTONE_DEB_PACKAGER_URL}
KEYSTONE_RPM_PACKAGER_URL=${13:-$KEYSTONE_RPM_PACKAGER_URL}

GLANCE_URL=${14}
GLANCE_BRANCH=${15}
GLANCE_MERGE_TRUNK=${16}
GLANCE_REVISION=${17}
GLANCE_DEB_PACKAGER_URL=${18:-$GLANCE_DEB_PACKAGER_URL}
GLANCE_RPM_PACKAGER_URL=${19:-$GLANCE_RPM_PACKAGER_URL}

CHEF_INSTALLER_CONF=${20}
NODES_JSON_CONF=${21}
SERVER_GROUP_JSON_CONF=${22}

# Setup default branches to merge if MERGE_TRUNK is checked
# These may be overridden by some environements
NOVA_GIT_MASTER_BRANCH=${NOVA_GIT_MASTER_BRANCH:-"master"}
GLANCE_GIT_MASTER_BRANCH=${GLANCE_GIT_MASTER_BRANCH:-"master"}
KEYSTONE_GIT_MASTER_BRANCH=${KEYSTONE_GIT_MASTER_BRANCH:-"master"}

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
		git merge $NOVA_GIT_MASTER_BRANCH || fail "Failed to merge $NOVA_GIT_MASTER_BRANCH."
	fi

	popd
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
		git merge $KEYSTONE_GIT_MASTER_BRANCH || fail "Failed to merge $KEYSTONE_GIT_MASTER_BRANCH."
	fi

	popd
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
		git merge $GLANCE_GIT_MASTER_BRANCH || fail "Failed to merge $GLANCE_GIT_MASTER_BRANCH."
	fi

	popd

}
