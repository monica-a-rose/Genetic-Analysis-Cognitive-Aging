#!/bin/bash
# This script documents the full command-line workflow for the dissertation project.
# It covers per-gene QC, merging, phenotype attachment, and the final association analysis.
set -euo pipefail


# ===================================================================
# PHASE 1: PER-GENE QUALITY CONTROL (QC)
# The following steps were performed for all 9 candidate genes.
# COMT is shown as a representative example.
# ===================================================================

echo "--- Running QC for COMT gene (Example) ---"

# Step 1: Missing Data Assessment
plink --bfile comt --missing --out qc_outputs/comt_missing

# Step 2: Hardy-Weinberg Equilibrium Testing
plink --bfile comt --hardy --out qc_outputs/comt_hwe

# Step 3: Allele Frequency Calculation
plink --bfile comt --freq --out qc_outputs/comt_freq

# Step 4: Comprehensive QC Filtering
# This step applies all thresholds simultaneously to create a clean dataset.
plink --bfile comt \
    --mind 0.02 \
    --geno 0.02 \
    --maf 0.05 \
    --hwe 1e-4 \
    --make-bed \
    --out clean_data/comt_clean

echo "--- QC complete for COMT. This process was repeated for all 9 genes. ---"


# ===================================================================
# PHASE 2: MERGING & PHENOTYPE ATTACHMENT
# ===================================================================

echo "--- Merging all 9 clean gene datasets ---"

# Step 1: Create a list of all clean datasets to be merged
# (This file was created manually, listing the paths to each *_clean.bed/bim/fam trio)
# Example content of merge_list.txt:
# clean_data/comt_clean
# clean_data/drd2_clean
# ...etc

# Step 2: Run the merge command
plink --bfile clean_data/comt_clean \
    --merge-list clean_data/merge_list.txt \
    --make-bed \
    --out dopamine_clean

echo "--- Attaching cognitive phenotype data ---"

# Step 3: Attach the phenotype (processing speed slope) to the merged genotype file
plink --bfile dopamine_clean \
    --pheno cognitive_slopes_main.tsv \
    --pheno-name gsstd_lin \
    --make-bed \
    --out dopamine_ps_main


# ===================================================================
# PHASE 3: PRIMARY ASSOCIATION ANALYSIS (Processing Speed Decline)
# ===================================================================

echo "--- Running final candidate gene association analysis with PC1-20 ---"

plink --bfile dopamine_ps_main \
    --covar phenotypes_clean_main.tsv \
    --covar-name sex,htn_status,bmi_raw,m1score_raw,smoke_curr,alcohol_freq_wk,mvpa_min_wk,sleep_hrs_raw,sleep_eff_raw,srh_raw,MAP,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 \
    --linear hide-covar \
    --out association_results/speed_decline_PC20

echo "--- Workflow Complete. See association_results/ for output. ---"