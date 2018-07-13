#!/bin/bash

cd /home/paddles/paddles
source ./virtualenv/bin/activate
pecan serve config.py
