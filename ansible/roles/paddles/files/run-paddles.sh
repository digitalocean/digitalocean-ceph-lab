#!/bin/bash

cd /home/paddles/paddles || exit
# shellcheck disable=SC1091
source ./virtualenv/bin/activate
pecan serve config.py
