#!/bin/bash
####################################################
# Author: Omar Ocegueda (omar@cimat.mx)
#PBS -l pmem=4gb
#PBS -l nodes=1:ppn=1
#PBS -l walltime=01:45:00
#PBS -N FullRegistration
#PBS -M jomaroceguedag@gmail.com
export PATH="/opt/python/anaconda/bin:$PATH"
export PYTHONPATH="/opt/python/anaconda/lib/python2.7/site-packages:$HOME/local/lib/python2.7/site-packages:$PYTHONPATH:$HOME/code/registration"
###################################
date
reference=$(ls reference)
target=$(ls target)
extension="${target##*.}"
targetbase="${target%.*}"
targetbase="${targetbase%.*}"
referencebase="${reference%.*}"
referencebase="${referencebase%.*}"
#Affine registration using Mutual information with ANTS
affine="${targetbase}_${referencebase}Affine.txt"
affinePrecomputed="../affine/${affine}"
if [ -r $affinePrecomputed ]; then
    cp $affinePrecomputed .
fi
if ! [ -r $affine ]; then
    ANTS 3 -m MI[reference/$reference, target/$target, 1, 32] -i 0 -o ${targetbase}_${referencebase}
else
    echo "Affine mapping found ($affine). Skipping affine registration."
fi
#Diffeomorphic registration
python registrationDiffeomorphic.py target/$target reference/$reference $affine warp 100.0
date
