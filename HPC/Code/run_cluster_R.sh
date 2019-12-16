#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb

# cp main function file to tmpdir to be used
cp $HOME/cluster_R/Code/db319_HPC_2019_main.R $TMPDIR

module load anaconda3/personal 
echo "R is about to run"
R --vanilla < $HOME/cluster_R/Code/db319_HPC_2019_cluster.R
mv Cluster_Run_output* $HOME/cluster_R/Results
echo "R has finished running"

# END OF FILE #
