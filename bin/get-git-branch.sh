#!/bin/bash

# always get ``dir_here`` first then get ``dir_project_root`` right after it
# then derive other path from ``dir_project_root``. NEVER use ``dir_here``
# to derive other path in your script to avoid problems caused by  ``dir_here``
# variable been overwritten by ``source {other-shell-script.sh}`` command
dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname ${dir_here} )"

branch_name="branch-name-not-available-yet"

# if in AWS Code Build environment
# for more built-in environment variable for Code Build runtime, read this:
# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-env-vars.html
if [ -n "${CODEBUILD_RESOLVED_SOURCE_VERSION}" ]; then
    echo "detected code build runtime"
    git_branch_name="$(git branch -a --contains "${CODEBUILD_RESOLVED_SOURCE_VERSION}" | sed -n 2p )"
    branch_name="$(python -c "print('$branch_name'.strip())")"
    var_file_arg=""
# if in CircleCI environment
# for more built-in environment variable for CircleCI runtime, read this:
# https://circleci.com/docs/2.0/env-vars/#built-in-environment-variables
elif [ -n "${CIRCLECI}" ]; then
    echo "detected circleci runtime"
    git_branch_name="${CIRCLE_BRANCH}"
    git_last_commit_sha="${CIRCLE_SHA1}"
# if in local laptop
else
    echo "detected local laptop runtime"
    git_branch_name="$(git rev-parse --abbrev-ref HEAD)"
    git_last_commit_sha="$(git rev-parse HEAD)"
fi