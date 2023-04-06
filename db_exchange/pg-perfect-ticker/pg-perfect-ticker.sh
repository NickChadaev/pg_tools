#!/bin/bash

# . /opt/rh/rh-python36/enable

exec -- /usr/bin/python3 -u -- /opt/pg-perfect-ticker/pg-perfect-ticker "$@"
