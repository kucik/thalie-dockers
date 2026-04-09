#!/bin/sh

set -eu

repo_dir=/home/nwn/src/nwnx2-linux
repo_url=https://github.com/kucik/nwnx2-linux.git
repo_url_lc=https://github.com/kucik/login-checker.git
repo_dir_lc=/home/nwn/src/login-checker
output_dir=/home/nwn/compiled

rm -rf "$repo_dir"
git clone "$repo_url" "$repo_dir"

cd "$repo_dir"
printf '\n' | ./compile.sh
cp compiled/*.so "$output_dir"/

# Build login checker
echo "Building login checker"
cd ~/src
git clone "$repo_url_lc" "$repo_dir_lc"
cd "$repo_dir_lc"
make
cp -v login_checker recvover.so "$output_dir"/
