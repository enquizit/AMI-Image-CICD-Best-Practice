# -*- coding: utf-8 -*-

"""
vim and writing code on remote server is painful!

This is a development playground scripts allow you to develop shell scripts or
commands to run on remote server. It gives you ability to use user friendly tools
to develop complicate shell scripts for remote server.

Example:

1. you want to develop a shell scripts on EC2, you are running command line by line,
    and eventually you want to run it all together. You can type command on remote
    line by line, or use the "Example: run command remotely" that run from local.
    then put everything into ``dev.sh`` and use the "Example: run shell script remotely"
    to run the shell script on remote.
"""

from fabric2 import Connection
from invoke import Result
from paramiko import SFTPClient
from patchwork.transfers import rsync
from pathlib_mate import PathCls as Path

# --- Config ---
HOST = "ec2-111-222-333-444.compute-1.amazonaws.com"
OS_USERNAME = "ec2-user"  # for Amazon Linux and Redhat, its ec2-user, for Ubuntu, its ubuntu, for other system, read this: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connection-prereqs.html#connection-prereqs-get-info-about-instance

# all path are absolute
HOME = Path.home()  # $HOME directory
HERE = Path(__file__).parent  # where this dev.py scripts locate
REPO_ROOT = HERE.parent  # the path of this repository on local laptop
REPO_ROOT_REMOTE = "/tmp/{}".format(REPO_ROOT.basename)  # the path of this repository on remote server, if using rsync.

PEM_PATH = Path(HOME, "path-to-my-pem-file.pem").abspath

_ = Result
_ = SFTPClient
_ = rsync

# config connection
with Connection(
        host=HOST,
        user=OS_USERNAME,
        connect_kwargs=dict(
            key_filename=[
                PEM_PATH,
            ]
        )
) as conn:
    # --- Example: sync folder from local to remote, usually for uploading bin tools ---
    # rsync(conn, source=REPO_ROOT, target="/tmp")

    # --- Example: run shell script remotely ---
    # conn.put(Path(HERE, "dev.sh"), "/tmp/dev.sh") # copy to remote first
    # result = conn.run('bash /tmp/dev.sh', warn=True)  # type: Result

    # --- Example: run command remotely ---
    # result = conn.run('which jq', warn=True)  # type: Result
    # print(result.stdout)
    # print(result.stderr)
    # print(result.encoding)
    # print(result.command)
    # print(result.shell)
    # print(result.env)
    # print(result.exited)

    # --- Example: get file from remote ---
    # conn.run('echo "{\\"name\\": \\"Bob\\"}" > /tmp/data.json') # create a temp file on remote
    # conn.get("/tmp/data.json", Path(HERE, "data.json")) # get it from here

    pass
