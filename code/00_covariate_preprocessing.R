# This script details the full data preparation and covariate cleaning workflow for the dissertation.
# It covers reading raw data, merging multiple data tiers, recoding variables, handling
# missing data via Multiple Imputation by Chained Equations (MICE), and exporting the
# final analysis-ready covariate file for use with PLINK.

# ===================================================================
# STEP 0: LOAD LIBRARIES
# ===================================================================
library(tidyverse)
library(mice)      # For multiple imputation
library(naniar)    # For missing data visualization (used in exploration)

# ===================================================================
# STEP 1: READ RAW DATA
# Assumes all raw CSVs and the ancestry file are in the root project directory.
# ===================================================================

pers <- read_csv("PersonalDetailsQuestionnaire_04-2021.csv", show_col_types = FALSE)
depress <- read_csv("DepressionData_04-2021 (1).csv", show_col_types = FALSE)
clinical <- read_csv("ClinicalData_04-2021 (1).csv", show_col_types = FALSE)
sleep <- read_csv("PersonalDetailsQuestionnaire_Sleep_04-2021 (1).csv", show_col_types = FALSE)
pcs_full <- read_table("ancestry_pcs.eigenvec", col_names = c("FID", "IID", paste0("PC", 1:20)))

# ===================================================================
# STEP 2: BUILD ANALYSIS COHORT (Clinic Attendees)
# Restrict sample to participants with key clinical data (BP or BMI).
# ===================================================================

clinic_ids <- clinical %>%
  filter(!is.na(bp1s) | !is.na(bmi)) %>%
  pull(ID)

pers_filtered <- pers %>% filter(ID %in% clinic_ids)
depress_filtered <- depress %>% filter(ID %in% clinic_ids)
clinical_filtered <- clinical %>% filter(ID %in% clinic_ids)
sleep_filtered <- sleep %>% filter(ID %in% clinic_ids)


# ===================================================================
# STEP 3: MERGE AND RECODE DATA TIERS
# ===================================================================

# --- Build Core Tier (Demographics + Ancestry PCs) ---
core_tier <- pers_filtered %>%
  transmute(
    IID = ID,
    sex_raw = sex,
    site_raw = city
  ) %>%
  left_join(pcs_full %>% select(-FID), by = "IID") # Join all 20 PCs

# --- Build Clinical Tier ---
clinical_tier <- clinical_filtered %>%
  transmute(
    IID = ID,
    sbp_raw = rowMeans(across(bp1s:bp3s), na.rm = TRUE),
    dbp_raw = rowMeans(across(bp1d:bp3d), na.rm = TRUE),
    bmi_raw = bmi,
    knownhp = knownhp
  ) %>%
  left_join(depress_filtered %>% transmute(IID = ID, m1score_raw = m1score), by = "IID")

# --- Merge All Tiers ---
covs_raw <- core_tier %>%
  left_join(clinical_tier, by = "IID") %>%
  left_join(pers_filtered %>% select(IID = ID, p1smoke, p1yrdrnk, p1activm, p1activn, p1cuhlth), by = "IID") %>%
  left_join(sleep_filtered %>% select(IID = ID, p1hrslp, p1sleff), by = "IID")

# --- Final Recoding and Variable Derivation ---
covs_clean <- covs_raw %>%
  mutate(
    sex = case_when(
      sex_raw %in% c("Female", "F", "2") ~ 0,
      sex_raw %in% c("Male", "M", "1") ~ 1
    ),
    site = case_when(
      str_detect(site_raw, regex("Manchester", ignore_case = TRUE)) ~ 0,
      str_detect(site_raw, regex("Newcastle", ignore_case = TRUE)) ~ 1
    ),
    htn_dx = case_when(
      str_to_lower(knownhp) == "yes" ~ 1,
      str_to_lower(knownhp) == "no" ~ 0,
      (sbp_raw >= 140 | dbp_raw >= 90) ~ 1,
      (sbp_raw < 140 & dbp_raw < 90) ~ 0
    ),
    smoke_curr = recode(p1smoke, "Yes" = 1, "No" = 0),
    alcohol_freq_wk = p1yrdrnk / 52,
    mvpa_min_wk = (p1activm + p1activn) * 60 / 4.348,
    sleep_hrs_raw = as.numeric(p1hrslp),
    sleep_eff_raw = as.numeric(p1sleff),
    srh_raw = recode(p1cuhlth, "Very bad" = 1, "Bad" = 2, "Fair" = 3, "Good" = 4, "Very good" = 5)
  ) %>%
  select(
    FID = IID, IID, sex, site, starts_with("PC"),
    sbp_raw, dbp_raw, bmi_raw, m1score_raw, htn_dx,
    smoke_curr, alcohol_freq_wk, mvpa_min_wk,
    sleep_hrs_raw, sleep_eff_raw, srh_raw
  )

# ===================================================================
# STEP 4: MISSING DATA IMPUTATION
# As per the dissertation, MICE was used for key variables with 5-20% missingness.
# This section documents that process.
# ===================================================================

# Set seed for reproducibility
set.seed(12345)

# Perform imputation (example with 20 imputations)
# Note: In the actual project, Little's MCAR test was performed to justify this.
imputed_data <- mice(covs_clean, m = 20, maxit = 20, method = 'pmm', printFlag = FALSE)

# Get the first completed dataset from the imputation
covs_imputed <- complete(imputed_data, 1)

print("Missing data handled via MICE imputation.")


# ===================================================================
# STEP 5: EXPORT FINAL COVARIATE FILE FOR PLINK
# ===================================================================

# The final file used in the GWAS was 'phenotypes_clean_main.tsv'
# PLINK requires FID and IID, and no missing values for covariates.
# Missing values were handled by imputation, and for PLINK are coded as -9.
final_covariate_file <- covs_imputed %>%
  mutate(across(-c(FID, IID), ~replace_na(., -9)))

write_tsv(final_covariate_file, "phenotypes_clean_main.tsv")

print("Final covariate file 'phenotypes_clean_main.tsv' has been created and saved.")