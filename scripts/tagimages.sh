#!/bin/bash

docker tag nwn_debian-nwn:latest ghcr.io/kucik/nwn-runtime:2026-04-09
docker tag nwn_debian-nwn:latest ghcr.io/kucik/nwn-runtime:latest


docker tag nwn_debian-nwnx-build:latest ghcr.io/kucik/nwn-builder:2026-04-09
docker tag nwn_debian-nwnx-build:latest ghcr.io/kucik/nwn-builder:latest

