#!/bin/bash
#SBATCH --job-name=PF_EAF_Calc    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=leslie.smith1@ufl.edu     # Where to send mail	
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=200gb                     # Job memory request
#SBATCH --time=120:05:00               # Time limit hrs:min:sec
#SBATCH --output=PF_EAF_Calc%j.log   # Standard output and error log
#SBATCH --error=error_gnomadChromDownload%j.log #error log
#SBATCH --array=1-8 #Array range 

ml R

PER_TASK=3
# Calculate the starting and ending values for this task based
# on the SLURM task and the number of runs per task.
START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))
END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))
#files=gnomad.genomes.v4.0.sites.chr13.parsedV2.vcf
#files=`ls /home/leslie.smith1/blue_kgraim/leslie.smith1/Repositories/PhyloFrameGNN/processed-data/gnomADv4 | grep gnomad.genomes.v4.0.sites.*parsedV2.vcf`
files=($( ls /home/leslie.smith1/blue_kgraim/leslie.smith1/Repositories/PhyloFrameGNN/processed-data/gnomADv4/parsed | grep gnomad.genomes.v4.0.sites.*parsedV2.vcf ))
#for file in ${files[@]}; do

echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM
for (( run=$START_NUM; run<=END_NUM; run++ )); do
  echo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run
#Rscript /blue/kgraim/leslie.smith1/Repositories/PhyloFrameGNN/code/1000_genomes_EAF_Calculation.R -c ${files}
#	Rscript /blue/kgraim/leslie.smith1/Repositories/PhyloFrameGNN/code/gnomadV4_EAF_Calculation.R -c ${file}
  Rscript /blue/kgraim/leslie.smith1/Repositories/PhyloFrameGNN/code/gnomadV4_EAF_Calculation.R -c ${files[$run]}
  echo "Processed ${files[$run]}"

done


