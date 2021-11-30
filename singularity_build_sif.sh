#!/bin/bash

sudo SINGULARITY_TMPDIR=$HOME/agora/ShakeExperiment singularity build singularity_experiment.sif singularity_experiment.def
