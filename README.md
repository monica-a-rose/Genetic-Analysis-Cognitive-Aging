# Genetic Analysis of Cognitive Aging (MSc Dissertation Project)

> **MSc Dissertation | Awarded Distinction**

This repository contains all associated analysis code for my master's thesis, a longitudinal candidate-gene study investigating the genetic underpinnings of cognitive decline in aging.

---

### **Publication Status**

> A manuscript based on the findings from this dissertation is currently in preparation for submission to a peer-reviewed academic journal.

---

## Project Overview

This project addresses the gap between the well-established role of the dopamine system in neurobiology and the unresolved genetic basis for its influence on cognitive aging.

The analysis involved a multi-tiered approach—including single-variant, gene-based (MAGMA), and polygenic risk score analyses—on 957 variants across nine key dopamine genes. The study utilized a cohort of 434 participants from the University of Manchester Longitudinal Study of Cognition, with cognitive data spanning 12 years.

## Research Question

Do common dopaminergic gene variants modulate processing speed decline during cognitive aging?

## Key Findings

-   Despite robust methodology and adequate statistical power to detect moderate-to-large effects, the study found **no significant associations** between common dopaminergic variants and the rate of processing speed decline after rigorous multiple testing correction.
-   This null finding was consistent across secondary cognitive domains (fluid reasoning, memory) and exploratory post-mortem analyses, suggesting it is a robust feature of the data.
-   The results strongly support a model of **extreme polygenicity** in cognitive aging, where individual common variants have effects too small to be detected in candidate-gene studies of this size. The dissertation discusses the scientific value of well-powered null findings in refining biological models and guiding future research.

## Technical Workflow & Technologies

The project involved a complete bioinformatics and statistical genetics workflow. All scripts are available in the `/code` folder and can be viewed by clicking the links below.

1.  **Covariate Data Preprocessing ([`00_covariate_preprocessing.R`](code/00_covariate_preprocessing.R)):** Cleaned, merged, and imputed clinical, demographic, and lifestyle data using MICE in R.
2.  **Genomic Quality Control ([`01_plink_commands.sh`](code/01_plink_commands.sh)):** A command-line pipeline in **PLINK** was used to perform QC, filter variants, and merge gene data.
3.  **Gene-Based Association ([`02_magma_analysis.R`](code/02_magma_analysis.R)):** Aggregated SNP-level statistics to test for cumulative gene-level effects using **MAGMA**.
4.  **Statistical Modeling & Power Analysis ([`03_statistical_modeling.R`](code/03_statistical_modeling.R)):** Conducted post-hoc analyses, sensitivity tests, and statistical power calculations in R.

**Key Technologies:** `PLINK`, `MAGMA`, `R (tidyverse, mice)`, `Shell Scripting`, `Statistical Genetics`, `Longitudinal Data Analysis`

## Data Availability

The genetic and clinical data used in this study were obtained from a longitudinal research cohort at the University of Manchester.
