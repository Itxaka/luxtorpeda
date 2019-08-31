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

readonly ags_url=git@github.com:adventuregamestudio/ags.git
readonly dhewm3_url=git@github.com:dhewm/dhewm3.git
readonly eternaljk_url=git@github.com:eternalcodes/EternalJK.git
readonly gzdoom_url=git@github.com:coelckers/gzdoom.git
readonly ioq3_url=git@github.com:ioquake/ioq3.git
readonly iortcw_url=git@github.com:iortcw/iortcw.git
readonly openjk_url=git@github.com:JACoders/OpenJK.git
readonly openmw_url=git@gitlab.com:OpenMW/openmw.git
readonly openrct2_url=git@github.com:OpenRCT2/OpenRCT2.git
readonly openxcom_url=git@github.com:OpenXcom/OpenXcom.git
readonly regoth_url=git@github.com:REGoth-project/REGoth-bs.git
readonly vkquake_url=git@github.com:Novum/vkQuake.git

readonly all_projects="$ags_url $dhewm3_url $eternaljk_url $gzdoom_url $ioq3_url $iortcw_url $openjk_url $openmw_url $openrct2_url $openxcom_url $regoth_url $vkquake_url"

# set -x

cd "$(git rev-parse --show-toplevel)" || exit
if [ ! -d ../mirrors ] ; then
	mkdir -p ../mirrors
fi
cd ../mirrors || exit
echo "Using dir: $(pwd)"

# initializing:

for project_url in $all_projects ; do
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

for project_url in $all_projects ; do
	repo_name="$(repo_name "$project_url")"
	echo "Syncing $repo_name"
	git -C "$repo_name" fetch --all
	git -C "$repo_name" push --force gitlab origin/master:master
 	git -C "$repo_name" push --tags gitlab
	echo
done
