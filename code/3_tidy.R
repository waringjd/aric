#!/usr/bin/env Rscript


## Demographics {{{

## Visit 1 prevalence {{{
cs1 <- v1d

# BMI
cs1$BMI_1 <- round(cs1$BMI01, digits = 1)

# Diagnosis of hypertension, including treatment.
cs1$HTN_1 <- 0
cs1$HTN_1[v1d$HYPERT05 == 1 | v1d$HYPTMD01 == 1] <- 1

# Prior coronary artery disease by any known disease, MD decision, or ECG findings of Q waves.
cs1$CHD_1 <- 0
cs1$CHD_1[(v1d$PRVCHD05 | v1d$MDDXMI02 | v1d$HXOFMI02) == 1] <- 1

# Select variables
svar <- c("ID", "BIRTHDAT", "V1DATE01", "GENDER", "RACEGRP", "DRNKR01", "CIGT01", "BMI_1", "HTN_1", "CHD_1", "DIABTS03")
cs1 <- cs1[c(svar)]
names(cs1) <- c("ID", "DATE_BIRTH", "DATE_V1", "GENDER", "RACE", "DRINKER", "SMOKER", "BMI", "HTN", "CHD", "DIABETES")

cs1$AGE_V1 <- interval(cs1$DATE_V1, cs1$DATE_BIRTH) / years(1)

# Convert to factors
cs1 <- within(cs1, {
  ID <- factor(ID)


  GENDER <- factor(GENDER)
  levels(GENDER) <- c("Female", "Male")

  RACE <- factor(RACE)
  levels(RACE) <- c("Asian", "Black", "Unknown", "White")

  DRINKER <- factor(DRINKER)
  levels(DRINKER) <- c("Current", "Former", "Never", "Unknown")

  SMOKER <- factor(SMOKER)
  levels(SMOKER) <- c("Current", "Former", "Never", "Unknown")

  CHD <- factor(CHD)
  levels(CHD) <- c("Absent", "Present")

  DIABETES <- factor(DIABETES)
  levels(DIABETES) <- c("Absent", "Present")

  HTN <- factor(HTN)
  levels(HTN) <- c("Absent", "Present")
})

# Clean
cs1 <- as_tibble(cs1)
# }}}

## Visit 2 cross-sectional data {{{

# Will need to include BMI, drinking status, coronary disease, diabetes, CVA, hypertension, smoking status
cs2 <- v2d

# BMI
cs2$BMI_2 <- round(cs2$BMI21, digits = 1)
cs2$BMI_2cat <- cut(cs2$BMI21,
  breaks = c(-Inf, 18.5, 25, 30, 35, 40, Inf),
  labels = c("underweight", "normal", "overweight", "obese_mild", "obese_moderate", "obese_severe")
)

# Diagnosis of hypertension, including treatment.
cs2$HTN_2 <- 0
cs2$HTN_2[v2d$HYPERT25 == 1 | v2d$HYPTMD21 == 1] <- 1

# Prior coronary artery disease by any known disease, MD decision, or ECG findings of Q waves.
cs2$CHD_2 <- 0
cs2$CHD_2[(v2d$PRVCHD21 | v2d$MDDXMI21 | v2d$ECGMI24) == 1] <- 1

svar <- c("ID", "V2DATE21", "V2AGE22", "DRNKR21", "CIGT21", "BMI_2", "BMI_2cat", "HTN_2", "CHD_2", "DIABTS23", "PRVSTR21")
cs2 <- as_tibble(cs2[c(svar)])
names(cs2) <- c("ID", "DATE_V2", "AGE_V2", "DRINKER", "SMOKER", "BMI", "BMI_cat", "HTN", "CHD", "DIABETES", "STROKE")

# Convert to factors
cs2 <- within(cs2, {
  ID <- factor(ID)

  DRINKER <- factor(DRINKER)
  levels(DRINKER) <- c("Current", "Former", "Never", "Unknown")

  SMOKER <- factor(SMOKER)
  levels(SMOKER) <- c("Current", "Former", "Never", "Unknown")

  CHD <- factor(CHD)
  levels(CHD) <- c("Absent", "Present")

  DIABETES <- factor(DIABETES)
  levels(DIABETES) <- c("Absent", "Present")

  HTN <- factor(HTN)
  levels(HTN) <- c("Absent", "Present")

  STROKE <- factor(STROKE)
  levels(STROKE) <- c("Absent", "Present")
})

# Clean up
cs2 <- as_tibble(cs2)
# }}}

## Visit 4 cross-sectional data {{{

# Make cross sectional data table
cs4 <- v4d

# Fix BMI
cs4$BMI_4 <- round(cs4$BMI41, digits = 1)
cs4$BMI_4cat <- cut(cs4$BMI41,
  breaks = c(-Inf, 18.5, 25, 30, 35, 40, Inf),
  labels = c("underweight", "normal", "overweight", "obese_mild", "obese_moderate", "obese_severe")
)

# Fix hypertension
cs4$HTN_4 <- 0
cs4$HTN_4[v4d$HYPERT45 == 1 | v4d$HYPTMD41 == 1] <- 1

# Prior coronary artery disease by any known disease, MD decision, or ECG findings of Q waves.
cs4$CHD_4 <- 0
cs4$CHD_4[(v4d$PRVCHD43 | v4d$MDDXMI41 | v4d$ECGMI41) == 1] <- 1

# Select variables
svar <- c("ID", "V4AGE41", "V4DATE41", "DRNKR41", "CIGT41", "CHD_4", "HTN_4", "BMI_4", "BMI_4cat", "DIABTS42", "PRVSTR41")
cs4 <- cs4[c(svar)]
names(cs4) <- c("ID", "AGE_V4", "DATE_V4", "DRINKER", "SMOKER", "CHD", "HTN", "BMI", "BMI_cat", "DIABETES", "STROKE")

# Convert to factors
cs4 <- within(cs4, {
  ID <- factor(ID)

  DRINKER <- factor(DRINKER)
  levels(DRINKER) <- c("Current", "Former", "Never", "Unknown")

  SMOKER <- factor(SMOKER)
  levels(SMOKER) <- c("Current", "Former", "Never", "Unknown")

  CHD <- factor(CHD)
  levels(CHD) <- c("Absent", "Present")

  DIABETES <- factor(DIABETES)
  levels(DIABETES) <- c("Absent", "Present")

  HTN <- factor(HTN)
  levels(HTN) <- c("Absent", "Present")

  STROKE <- factor(STROKE)
  levels(STROKE) <- c("Absent", "Present")
})

# Clean up
cs4 <- as_tibble(cs4)
# }}}
# }}}

## Longitudinal follow up {{{

# df need to have diagnoses organized, they are a mix of ICD-9 and ICD-10 codes. If preceded with a letter, is an ICD-10 code, and if starts with a number, is an ICD-9 code (mainly). Using "ICD" package for help.
df <- outcomes[c("ID", "UCOD")]
icd9 <- icd9cm_hierarchy
icd10 <- icd10cm2016

# Process as character strings
icd9[6:8] <- mapply(as.character, icd9[6:8])
icd10[6:8] <- mapply(as.character, icd10[6:8])

# icd-9 set up
codes9 <- df
codes9$icd9 <- NA
codes9$icd9[as.icd9(codes9$UCOD) %>% icd_is_valid()] <-
  codes9$UCOD[as.icd9(codes9$UCOD) %>% icd_is_valid()]
codes9$icd9 <- decimal_to_parts(codes9$icd9)$mjr

# Merge in codes
icd9$icd9 <- icd9$three_digit
codes9 <- unique(merge(codes9, icd9[c("icd9", "major", "sub_chapter", "chapter")], by = "icd9", all.x = TRUE))

# icd-10 set up
codes10 <- df
codes10$icd10 <- NA
codes10$icd10[as.icd10(codes10$UCOD) %>% icd_is_valid()] <-
  codes10$UCOD[as.icd10(codes10$UCOD) %>% icd_is_valid()]
codes10$icd10 <- decimal_to_parts(codes10$icd10)$mjr

# Merge in codes
icd10$icd10 <- icd10$three_digit
codes10 <- unique(merge(codes10, icd10[c("icd10", "major", "sub_chapter", "chapter")], by = "icd10", all.x = TRUE))

# Merge all the codes together
codes <- merge(codes9, codes10, by = "ID", all = TRUE)
codes$dx[!is.na(codes$icd9)] <- codes$major.x[!is.na(codes$icd9)]
codes$dx[!is.na(codes$icd10)] <- codes$major.y[!is.na(codes$icd10)]
codes$subchapter[!is.na(codes$icd9)] <- codes$sub_chapter.x[!is.na(codes$icd9)]
codes$subchapter[!is.na(codes$icd10)] <- codes$sub_chapter.y[!is.na(codes$icd10)]
codes$chapter[!is.na(codes$icd9)] <- codes$chapter.x[!is.na(codes$icd9)]
codes$chapter[!is.na(codes$icd10)] <- codes$chapter.y[!is.na(codes$icd10)]
codes <- codes %>% group_by(ID) %>% filter(row_number() == 1)
codes <- codes[c("ID", "icd9", "icd10", "dx", "subchapter", "chapter")]

# Add teh outcomes back in
df <- merge(outcomes, codes, by = "ID")

# Add age as well
df <- merge(df, cs1[c("ID", "DATE_BIRTH")], by = "ID")

# Add ages
df$AGE_DEATH <- interval(df$DATE_BIRTH, df$DATE_DEAD) / years(1)

# Final data
outcomes <- df[c("ID", "DATE_BIRTH", "DATE_MI", "DATE_DEAD", "DEAD", "AGE_DEATH", "UCOD", "icd9", "icd10", "dx", "subchapter", "chapter")] %>% as_tibble()
# }}}

## Psychosocial measures {{{

## HPAA {{{
# The HPAA file includes the Interpersonal Support and Evaluation List (ISEL) and the Lubben Social Network Scale (LSNS)

# Select social support data
df <- hpa2

# ISEL is 3:18
# LSNS is 19:29

# ISEL variables
isel <- c("HPAA03", "HPAA04", "HPAA05", "HPAA06", "HPAA07", "HPAA08", "HPAA09", "HPAA10", "HPAA11", "HPAA12", "HPAA13", "HPAA14", "HPAA15", "HPAA16", "HPAA17", "HPAA18")

# LSNS variables
lsns <- c("HPAA19", "HPAA20", "HPAA21", "HPAA22", "HPAA23", "HPAA24", "HPAA25", "HPAA26", "HPAA27", "HPAA28", "HPAA29")

# Class of variables

# Trimmed HPAA data
df$placeholder <- NA
df <- df[c("ID", "placeholder", isel, lsns)]

# Create factors for ISEL
# Positive factors (higher score is better)
df[c(3, 6, 7, 8, 11, 12, 13, 14, 16, 18)] <-
  df[c(3, 6, 7, 8, 11, 12, 13, 14, 16, 18)] %>%
  mutate_all(funs(recode(., "A" = 0, "B" = 1, "C" = 2, "D" = 3)))

# Negative or reversed choices
df[c(4, 5, 9, 10, 15, 17)] <-
  df[c(4, 5, 9, 10, 15, 17)] %>%
  mutate_all(funs(recode(., "A" = 3, "B" = 2, "C" = 1, "D" = 0)))

# Create factors and scores for LSNS
df[c(19, 20, 21, 22, 23, 24)] <-
  df[c(19, 20, 21, 22, 23, 24)] %>%
  mutate_all(funs(recode(., "A" = 0, "B" = 1, "C" = 2, "D" = 3, "E" = 4, "F" = 5)))

df[c(25, 26)] <-
  df[c(25, 26)] %>%
  mutate_all(funs(recode(., "A" = 5, "B" = 4, "C" = 3, "D" = 2, "E" = 1, "F" = 0)))

df <- within(df, {
  HPAA27 <- recode(HPAA27, "A" = 1, "B" = 0)
  HPAA28 <- recode(HPAA28, "B" = 5, "C" = 4, "D" = 3, "E" = 2, "F" = 1)
  HPAA29 <- recode(HPAA29, "A" = 4, "B" = 3, "C" = 2, "D" = 1)
})

# Summarize data based on scale
df$ISEL <- rowSums(df[c(3:18)], na.rm = TRUE)
df$LSNS <- rowSums(df[c(19:29)], na.rm = TRUE)

# Summarize data with ISEL subscales
df$AP <- rowSums(df[c(7, 10, 14, 17)], na.rm = TRUE)
df$TA <- rowSums(df[c(8, 9, 13, 16)], na.rm = TRUE)
df$BE <- rowSums(df[c(4, 5, 6, 11, 18)], na.rm = TRUE)
df$SE <- rowSums(df[c(3, 12, 15)], na.rm = TRUE)

# Place data back
score_hpa2 <- df[c("ID", "ISEL", "LSNS", "AP", "TA", "BE", "SE")]

# Normalize the data
score_hpa2[-1] <-
  as_tibble(scale(score_hpa2[-1], center = TRUE), scale = TRUE)
# }}}

## HPBA {{{

# The HPBA file includes the Maastricht Vital Exhaustion Questionnaire.

# Maastrich data
# Don't know is considered NA
df <- hpb2

# HPBA variable set up (questions number align)
questions <- c("HPBA01", "HPBA02", "HPBA03", "HPBA04", "HPBA05", "HPBA06", "HPBA07", "HPBA08", "HPBA09", "HPBA10", "HPBA11", "HPBA12", "HPBA13", "HPBA14", "HPBA15", "HPBA16", "HPBA17", "HPBA18", "HPBA19", "HPBA20", "HPBA21")
df <- df[c(questions, "ID")]

# Mutate to scores
df[c(1:8, 10:13, 15:21)] <-
  df[c(1:8, 10:13, 15:21)] %>%
  mutate_all(funs(recode(., "Y" = 1, "N" = 0)))

# Reversed scores
df[c(9, 14)] <-
  df[c(9, 14)] %>%
  mutate_all(funs(recode(., "Y" = 0, "N" = 1)))

df$MAASTRICH <- rowSums(df[c(1:21)], na.rm = TRUE)

# Place data back
score_hpb2 <- df[c("ID", "MAASTRICH")]
score_hpb2[-1] <-
  as_tibble(scale(score_hpb2[-1], center = TRUE, scale = TRUE))
# }}}

## HPCB {{{

# This is the HPCB file from both visit 2 and visit 4. This includes the Spielberger anger trait scale, which ranged in scores from 10 to 40.


# Visit 2 HPCB file {{{
df <- hpc2

# Create data frame from Spielberger, trimmed down
questions <- c("HPCA01", "HPCA02", "HPCA03", "HPCA04", "HPCA05", "HPCA06", "HPCA07", "HPCA08", "HPCA09", "HPCA10")
df <- df[c(questions, "ID")]

# Mutate scores, with low = 1, high = 4
df[c(1:10)] <-
  df[c(1:10)] %>%
  mutate_all(funs(recode(., "A" = 1, "B" = 2, "C" = 3, "D" = 4)))

# Create total score
df$SPIELBERGER <- rowSums(df[c(1:10)], na.rm = TRUE)

# Create strata defined as high = [22, 40], mid = [15, 21], low = [10,14]
# Variable "anger_level" shows the three strata (low = 1, mid = 2, high = 3)

df$anger_level <- 1
df$anger_level[df$SPIELBERGER >= 15] <- 2
df$anger_level[df$SPIELBERGER >= 22] <- 3

# Confirm data frame, scaling for normality
score_hpc2 <- df[c("ID", "SPIELBERGER", "anger_level")]
score_hpc2[-c(1, 3)] <-
  as_tibble(scale(score_hpc2[-c(1, 3)], center = TRUE, scale = TRUE))
# }}}

# Visit 4 HPCB file {{{
df <- hpc4

# Create data frame from Maastrich, trimmed down
questions <- c("HPCB1", "HPCB2", "HPCB3", "HPCB4", "HPCB5", "HPCB6", "HPCB7", "HPCB8", "HPCB9", "HPCB10")
df <- df[c(questions, "ID")]

# Mutate scores, with low = 1, high = 4
df[c(1:10)] <-
  df[c(1:10)] %>%
  mutate_all(funs(recode(., "A" = 1, "B" = 2, "C" = 3, "D" = 4)))

# Create total score
df$SPIELBERGER <- rowSums(df[c(1:10)], na.rm = TRUE)

# Create strata defined as high = [22, 40], mid = [15, 21], low = [10,14]
# Variable "anger_level" shows the three strata (low = 1, mid = 2, high = 3)

df$anger_level <- 1
df$anger_level[df$SPIELBERGER >= 15] <- 2
df$anger_level[df$SPIELBERGER >= 22] <- 3

# Confirm data frame
score_hpc4 <- df[c("ID", "SPIELBERGER", "anger_level")]
score_hpc4[-c(1, 3)] <-
  as_tibble(scale(score_hpc4[-c(1, 3)], center = TRUE, scale = TRUE))
# }}}
# }}}
# }}}

## Heart rate variability {{{

# During visit 1, HRV was taken in both supine and standing. The standard is to use the supine data. This was collected over 2 minutes only. The data here is normalized using a cube root method to avoid "infinite" values during scaling (which would occur using log-transformation). They were then scaled using the traditional z-transformation centered around 0.

## Visit 1 HRV data {{{
df <- hrv1

# Variables and data trim
svar <- c(
  "ID",
  "M_HRV11",
  "HFV11",
  "LFV11",
  "VLFV11",
  "TPV11",
  "PNN50V11",
  "MSSDV11",
  "SDNNV11"
)
df <- df[c("QCFLGV11", svar)]

# Only "quality" data
df <- df[df$QCFLGV11 != 1, svar]

# Rename the columns for ease of use
names(df) <- c("ID", "BPM", "HF", "LF", "VLF", "TP", "PNN50", "RMSSD", "SDNN")

# Only quality HRV data
hrv1 <- df

# Will need to transform the data prior to utilization
# Cube root to avoid the zero issues and negatives for scaling
z_hrv1 <-
  hrv1 %>%
  mutate_at(
    function(x) {
      sign(x) * abs(x)^(1 / 3)
      (x - mean(x)) / sd(x)
    },
    .vars = vars(-ID)
  )
# }}}

## Visit 4 HRV data {{{

# At visit 4, HRV was collected again while supine. The recordings are 6 minutes in length. The values were transformed by the cube root before scaling using z-transformation centered around 0.

# Select data frame
df <- hrv4

# Variable selection
svar <- c(
  "ID",
  "m_hrv4r",
  "HFv4r",
  "LFv4r",
  "VLFv4r",
  "tpV4r",
  "pnn50V4r",
  "mssdV4r",
  "sdnnV4r"
)
df <- df[c("qcflgv4R", svar)]

# Only quality data
df <- df[df$qcflgv4R != 1, svar]

# Rename variables
names(df) <- c("ID", "BPM", "HF", "LF", "VLF", "TP", "PNN50", "RMSSD", "SDNN")

# Final data frame
hrv4 <- df

# Will need to transform the data prior to utilization

# Cube root to avoid the zero issues and negatives for scaling
z_hrv4 <-
  hrv4 %>%
  na.omit() %>%
  mutate_at(
    function(x) {
      sign(x) * abs(x)^(1 / 3)
      (x - mean(x)) / sd(x)
    },
    .vars = vars(-ID)
  )
# }}}
# }}}

## Clean up {{{

# Clean up of memory-clogging junk
rm(df, questions, svar, v1d, v2d, v4d)
# }}}

