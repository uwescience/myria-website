#!/bin/bash
# PARAMETERS:
# (optional) A name of a single child repository to update.
#   Updates all child repositories if not provided.

# This is a subtree updater for myria-website.
# We chose this solution because Github pages does not allow symlinks, making submodules infeasible.
# Inspired by #3 of an answer at
# https://stackoverflow.com/questions/23937436/add-subdirectory-of-remote-repo-with-git-subtree

# safety settings that stop execution if something goes wrong
set -e #command fail -> script fail
set -u #unset variable reference causes script fail

while read thisSubfolder gitUrl gitBranch gitSubdir
do
    gitName="${gitUrl%\.git}"
    gitName="${gitName##*/}"

    # command line parameter filters if provided
    if [ "$#" -ge "1" ] && [ -n "$1" ]; then
	if [ "$1" != "$gitName" ]; then
	    continue
	fi
    fi

    origBranch="$(git branch --no-column | grep \*)"
    origBranch="${origBranch:2}"
    if [[ "${origBranch}" == *" "* ]]; then echo "You appear to be in a detached branch: $origBranch"; return; fi
    tempBranch="subtree-${gitName}-${gitBranch}-temp"

    # Ensure subfolders do NOT have a trailing slash
    # git subtree is sensitive to this
    if [ "${thisSubfolder:$((${#thisSubfolder}-1)):1}" == '/' ]; then
	thisSubfolder="${thisSubfolder:0:$((${#thisSubfolder}-1))}"
    fi
    if [ "${gitSubdir:$((${#gitSubdir}-1)):1}" == '/' ]; then
	gitSubdir="${gitSubdir:0:$((${#gitSubdir}-1))}"
    fi
    
    echo "thisSubfolder: ${thisSubfolder}"
    echo "gitUrl       : ${gitUrl}"
    echo "gitName      : ${gitName}"
    echo "gitBranch    : ${gitBranch}"
    echo "gitSubdir    : ${gitSubdir}"
    echo "origBranch   : ${origBranch}"
    echo "tempBranch   : ${tempBranch}"

    # Motivation: Use subtree split to put the docs/ directory of myria repo into a temp branch.
    # Then subtree merge that temp branch into a different directory. Profit.

    # if a remote called gitName exists...
    if git remote | grep -q "^${gitName}\$"; then
	# careful if remote branch changes. also if remote url changes
	tmp1=$(git config --get "remote.${gitName}.fetch")
	tmp2=$(git config --get "remote.${gitName}.url")
	if [ "${tmp1: -${#gitBranch}}" != "${gitBranch}" -o "${tmp2}" != "${gitUrl}" ]; then
	    git remote remove "${gitName}"
	    git remote add -f -t "${gitBranch}" --no-tags "${gitName}" "${gitUrl}"
	else
	    git fetch "${gitName}"
	fi
    else
	git remote add -f -t "${gitBranch}" --no-tags "${gitName}" "${gitUrl}"
    fi
    git checkout "${gitName}/${gitBranch}"
    # --rejoin does not appear to speed up the subtree split.
    # See https://stackoverflow.com/questions/14865305/extract-a-subtree-using-branch-incrementally
    git subtree split --rejoin -P "${gitSubdir}" -b "${tempBranch}"
    git checkout "${origBranch}"
    if [ ! -d "${thisSubfolder}" ]; then
	git subtree add -P "${thisSubfolder}" "${tempBranch}"
    else
	git subtree merge -P "${thisSubfolder}" "${tempBranch}"
    fi
    # cleanup
    # Delete temp branch because the --rejoin optimization does not appear to be working
    git branch -D "${tempBranch}"
    # Better to keep the remote to prevent needless re-downloading
    #git remote remove "${gitName}"

    echo "Successfully updated ${thisSubfolder} from ${gitUrl}@${gitBranch}@${gitSubdir}"

done < <(grep -v "^\W*#" subtree.config)


