#!/bin/bash

rsync -avz ./ asshah4@hpc5.sph.emory.edu:aric/ --delete-after
