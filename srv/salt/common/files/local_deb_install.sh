#!/usr/bin/env bash


localdeb=$1

dpkg -i $localdeb
apt-get install -f -y
dpkg -i $localdeb