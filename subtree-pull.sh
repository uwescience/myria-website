#!/bin/bash
# This is a subtree updater for myria-website.
# We chose this solution because Github pages does not allw symlinks, making submodules infeasible.
# Inspired by #3 of an answer at
# https://stackoverflow.com/questions/23937436/add-subdirectory-of-remote-repo-with-git-subtree

set -e #command fail -> script fail
set -u #unset variable reference causes script fail

# format: thisSubdir^gitUrl^gitBranch^gitSubdir
rstrs="docs/myria/^git@github.com:uwescience/myria.git^add_myriax_doc^docs/ "

for rstr in $rstrs
do
    if [[ "${rstr}" != *"^"* ]]; then echo "bad rstr: $rstr"; return; fi
    thisSubfolder="${rstr%%^*}" # strip longest match of ^* from end
    rstr="${rstr#*^}"           # strip shortest match of *^ from beginning
    if [[ "${rstr}" != *"^"* ]]; then echo "bad rstr: $rstr"; return; fi
    gitUrl="${rstr%%^*}"
    gitName="${gitUrl%\.git}"
    gitName="${gitName##*/}"
    if [[ "${gitName}" == "" ]]; then echo "bad gitUrl: $gitUrl"; return; fi
    rstr="${rstr#*^}"
    if [[ "${rstr}" != *"^"* ]]; then echo "bad rstr: $rstr"; return; fi
    gitBranch="${rstr%%^*}"
    rstr="${rstr#*^}"
    if [[ "${rstr}" == *"^"* ]]; then echo "bad rstr: $rstr"; return; fi # no ^
    gitSubdir="${rstr}"
    rstr=""

    origBranch="$(git branch --no-column | grep \*)"
    origBranch="${origBranch:2}"
    if [[ "${origBranch}" == *" "* ]]; then echo "You appear to be in a detached branch: $origBranch"; return; fi
    tempBranch="subtree-${gitName}-${gitBranch}-temp"

    echo "thisSubfolder: ${thisSubfolder}"
    echo "gitUrl       : ${gitUrl}"
    echo "gitName      : ${gitName}"
    echo "gitBranch    : ${gitBranch}"
    echo "gitSubdir    : ${gitSubdir}"
    echo "origBranch   : ${origBranch}"
    echo "tempBranch   : ${tempBranch}"

    # Motivation: Use subtree split to put the docs/ directory of myria repo into a temp branch.
    # Then subtree merge that temp branch into a different directory. Profit.

    if git remote | grep -q "^${gitName}\$"; then 
	:
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
    git branch -D "${tempBranch}"
    git remote remove "${gitName}"
done

