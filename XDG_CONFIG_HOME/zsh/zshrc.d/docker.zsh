# shellcheck shell=bash
# vi: ft=sh

sudo chown root:docker /var/run/docker.sock
sudo chmod g+w /var/run/docker.sock
