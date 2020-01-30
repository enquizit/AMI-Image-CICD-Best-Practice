#!/bin/bash

# always get ``dir_here`` first then get ``dir_project_root`` right after it
# then derive other path from ``dir_project_root``. NEVER use ``dir_here``
# to derive other path in your script to avoid problems caused by  ``dir_here``
# variable been overwritten by ``source {other-shell-script.sh}`` command
dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname ${dir_here} )"

dir_bin="${dir_project_root}/bin"
dir_ami_root="$dir_project_root/ami"

ami_name=$1

dir_project_root_on_ec2="/tmp/repo"
dir_here_on_ec2="$(python -c "print('${dir_here}'.replace('${dir_project_root}', '${dir_project_root_on_ec2}', 1))")"
echo $dir_here_on_ec2
ami_name="$(cat "${dir_here}/ami-name")"
version="$(cat "${dir_here}/version")"
path_packer_json="${dir_here}/packer.json"
path_final_packer_json="${dir_here}/packer-final.json"
path_remove_json_comment_script="${dir_project_root}/bin/rm_json_comment.py"

echo $ami_name
echo $dir_project_root