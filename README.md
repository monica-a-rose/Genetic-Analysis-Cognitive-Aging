# Genetic Analysis of Cognitive Aging (MSc Dissertation)

> **MSc Dissertation Project - Distinction**

This repository contains the full dissertation, a draft manuscript for publication, and all associated analysis code for my master's thesis.

---

### ➡️ [**View the Full Dissertation (PDF)**](Dissertation_Monica_Rose.pdf)

---

## Project Overview

This project is a longitudinal candidate-gene study that investigates the genetic underpinnings of cognitive decline in aging, focusing on the dopamine system. It addresses the gap between established neurobiological evidence of dopamine's role and the unresolved genetic basis.

The analysis involved a multi-tiered approach—including single-variant, gene-based (MAGMA), and polygenic risk score analyses—on 957 variants across nine key dopamine genes in a cohort of 434 participants over 12 years.

## Research Question

Do dopaminergic genes modulate processing speed during cognitive aging?

## Key Findings

-   Despite robust methodology and adequate statistical power to detect moderate-to-large effects, the study found **no significant associations** between common dopaminergic variants and the rate of processing speed decline after multiple testing correction.
-   These null findings persisted across secondary cognitive domains and exploratory post-mortem analyses.
-   The results support a model of extreme polygenicity in cognitive aging, suggesting that individual common variants in this pathway have effects too small to be detected in candidate-gene studies of this size. The dissertation discusses the value of these null findings in refining biological models and guiding future research.

## Technical Workflow & Technologies

The project involved a complete bioinformatics and statistical workflow, with all scripts available in the `/code` folder.

1.  **Covariate Data Preprocessing (`00_covariate_preprocessing.R`):** Raw clinical, demographic, and lifestyle data were cleaned, merged, recoded, and handled for missingness using MICE imputation in R.
2.  **Genomic Quality Control & Merging (`01_plink_commands.sh`):** A full command-line pipeline in PLINK was used to perform QC on a per-gene basis before merging all nine candidate genes into a final, analysis-ready dataset.
3.  **Gene-Based Association Analysis (`02_magma_analysis.R`):** PLINK association results were formatted and analyzed using MAGMA to test for cumulative gene-level effects.
4.  **Post-Hoc Statistical Modeling (`03_statistical_modeling.R`):** Secondary analyses, such as modeling the effects of neuropathology markers, were performed in R.

**Key Technologies:** `PLINK`, `MAGMA`, `R (tidyverse, mice)`, `Shell Scripting`, `Statistical Genetics`, `Longitudinal Data Analysis`

## Data Availability

The genetic and clinical data used in this study were obtained from the University of Manchester Longitudinal Study of Cognition in Normal Healthy Old Age. Due to participant confidentiality and the data sharing agreement, the raw data cannot be made publicly available in this repository.

## Repository Structure

-   **/code/**: Contains all R and Shell scripts used for data processing and analysis, numbered in chronological order.
-   **/report/**: Contains the full dissertation PDF and the draft manuscript for journal submission.
