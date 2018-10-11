#!/bin/bash

cd /home/pulpito/pulpito || exit
# shellcheck disable=SC1091
source ./virtualenv/bin/activate
python run.py
