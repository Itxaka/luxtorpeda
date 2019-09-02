#!/bin/env bash

# Setup working copies for projects mirrored by Luxtorpeda project.
# Perform one way sync (origin → gitlab) of master branches.

lowercase () {
	echo "$@" | tr '[:upper:]' '[:lower:]'
}

repo_name () {
	url=$1
	lowercase "$(basename "${url%.git}")"
}

all_projects () {
	echo git@github.com:adventuregamestudio/ags.git
	echo git@github.com:arx/ArxLibertatis.git
	echo git@github.com:coelckers/gzdoom.git
	echo git@github.com:dhewm/dhewm3.git
	echo git@github.com:eternalcodes/EternalJK.git
	echo git@github.com:ioquake/ioq3.git
	echo git@github.com:iortcw/iortcw.git
	echo git@github.com:JACoders/OpenJK.git
	echo git@github.com:Novum/vkQuake.git
	echo git@github.com:OpenRCT2/OpenRCT2.git
	echo git@github.com:OpenXcom/OpenXcom.git
	echo git@github.com:REGoth-project/REGoth-bs.git
	echo git@gitlab.com:OpenMW/openmw.git
}

# set -x

cd "$(git rev-parse --show-toplevel)" || exit
if [ ! -d ../mirrors ] ; then
	mkdir -p ../mirrors
fi
cd ../mirrors || exit
echo "Using dir: $(pwd)"

# initializing:

for project_url in $(all_projects) ; do
	repo_name="$(repo_name "$project_url")"
	mirror_url=git@gitlab.com:luxtorpeda/mirrors/${repo_name}.git
	if [ -d "$repo_name" ] ; then
		continue
	fi
	echo "Cloning $project_url"
	git clone "$project_url" "$repo_name"
	git -C "$repo_name" remote add gitlab "$mirror_url"
	git -C "$repo_name" checkout master
 	git -C "$repo_name" push gitlab master
	echo
done

# syncing

for project_url in $(all_projects) ; do
	repo_name="$(repo_name "$project_url")"
	echo "Syncing $repo_name"
	git -C "$repo_name" fetch --all
	git -C "$repo_name" push --force gitlab origin/master:master
 	git -C "$repo_name" push --tags gitlab
	echo
done
