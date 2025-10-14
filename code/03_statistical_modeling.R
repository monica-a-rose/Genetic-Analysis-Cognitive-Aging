# This script is a representative example of the secondary statistical analyses
# performed for the dissertation, specifically modeling the relationship between
# post-mortem neuropathology markers and cognitive trajectories.

library(tidyverse)
library(broom) # For tidying model outputs

# ===================================================================
# STEP 1: LOAD AND PREPARE DATA
# ===================================================================

# Load the clean datasets for neuropathology and cognitive scores
neuropath_data <- read_csv("analysis_data/neuropathology_basic_final.csv")
cognitive_data <- read_tsv("analysis_data/cognitive_clean.tsv")

# Join the two datasets
analysis_df <- inner_join(neuropath_data, cognitive_data, by = "IID")

print(paste("Joined dataset created with", nrow(analysis_df), "participants."))


# ===================================================================
# STEP 2: DEFINE AND RUN STATISTICAL MODELS
# ===================================================================

# Example Analysis: Test if Braak stage (neuropathology) predicts
# the rate of processing speed decline (cognitive trajectory).

# Define the linear model. Covariates are based on the dissertation methods
# for the post-mortem subset (basic model).
braak_model <- lm(gsstd_lin ~ braak_stage + sex + site + age_at_death + pmi_hrs + apoe_e4 +
                  smoke_curr + alcohol_freq_wk + mvpa_min_wk + sleep_hrs_raw +
                  sleep_eff_raw + srh_raw,
                  data = analysis_df)

# View a tidy summary of the model results
model_summary <- tidy(braak_model)

print("Results for the association between Braak stage and processing speed decline:")
print(model_summary)


# ===================================================================
# STEP 3: EXTRACT AND INTERPRET KEY RESULTS
# ===================================================================

# Filter for the specific result of interest
braak_result <- model_summary %>%
  filter(term == "braak_stage")

print("--- Key Finding ---")
# From the dissertation, this association was not statistically significant.
# The strongest signal in the neuropathology subset was between a COMT variant
# and Braak stage (p = 0.0005), but this did not survive multiple testing correction.
print(braak_result)