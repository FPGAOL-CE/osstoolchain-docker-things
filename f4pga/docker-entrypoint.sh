#!/bin/bash

source "/opt/conda/etc/profile.d/conda.sh"
conda activate xc7

exec "$@"
