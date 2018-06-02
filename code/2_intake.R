#!/usr/bin/env Rscript


## Visit 1 {{{

# Read in table
v1d <- read_csv("../data/v1/DERIVE13.dat", col_names = TRUE)

# Select only important columns
svar <- c(
  "ID",
  "DRNKR01",
  "BMI01",
  "PRVCHD05",
  "MDDXMI02",
  "PREVMI05",
  "HXOFMI02",
  "DIABTS03",
  "HYPERT05",
  "HYPTMD01",
  "CHOLMDCODE01",
  "V1AGE01",
  "V1DATE01",
  "BIRTHDAT",
  "GENDER",
  "RACEGRP",
  "PLAQUE01",
  "CIGT01",
  "CIGTYR01"
)
v1d <- v1d[c(svar)]

# Format data
v1d$V1DATE01 <- dmy(v1d$V1DATE01)
v1d$BIRTHDAT <- dmy(v1d$BIRTHDAT)
# }}}

## Visit 2 {{{


# Selected variables
svar <- c(
  "ID",
  "DRNKR21",
  "BMI21",
  "PRVCHD21",
  "MDDXMI21",
  "HXOFMI21",
  "DIABTS23",
  "ECGMI24",
  "PRVSTR21",
  "HYPERT25",
  "HYPTMD21",
  "CHOLMDCODE21",
  "V2AGE22",
  "V2DATE21",
  "PLAQUE21",
  "CIGT21"
)

# Intake and format variables
v2d <- read_csv("../data/v2/DERIVE2_10.dat", col_names = TRUE)
v2d <- v2d[c(svar)]
v2d$V2DATE21 <- dmy(v2d$V2DATE21)

## Intake of V2 psychosocial metrics (Health and Life Profile).

# Social support
hpa2 <- read_csv("../data/v2/HPAA.dat", col_names = TRUE)
hpa2$HPAA30 <- dmy(hpa2$HPAA30)

# Vital exhaustion
hpb2 <- read_csv("../data/v2/HPBA.dat", col_names = TRUE)
hpb2$HPBA22 <- dmy(hpb2$HPBA22)

# Spielberger anger trait
hpc2 <- read_csv("../data/v2/HPCA.dat", col_names = TRUE)
hpc2$HPCA11 <- dmy(hpc2$HPCA11)
# }}}

## Visit 4 {{{

# Selected variables.
svar <- c(
  "ID",
  "DRNKR41",
  "BMI41",
  "PRVCHD43",
  "MDDXMI41",
  "HXOFMI41",
  "DIABTS42",
  "ECGMI41",
  "PRVSTR41",
  "HYPERT45",
  "HYPTMD41",
  "CHOLMDCODE41",
  "V4AGE41",
  "V4DATE41",
  "PLAQUE42",
  "CIGT41"
)

v4d <- read_csv("../data/v4/DERIVE46.dat", col_names = TRUE)
v4d <- v4d[c(svar)]
v4d$V4DATE41 <- dmy(v4d$V4DATE41)

## Psychosocial metric

# Spielberger anger trait at visit 4.
hpc4 <- read_csv("../data/v4/HPCB04.dat", col_names = TRUE)
hpc4$HPCB11 <- dmy(hpc4$HPCB11)
# }}}

## HRV data {{{

# HRV data was shared by Eric Whitsel from the ARIC group, containing HRV measures from visit 1 and visit 4. This includes both frequency-domain and time-domain methods that were derived by the ARIC group. No raw data was available.

# Data from HRV from visit 1, supine data.

hrv1 <- read_csv("../data/hrv/f_hrv11b.dat", col_names = TRUE)

# Variables
svar <- c(
  "ID",
  "POSTV11",
  "QCFLGV11",
  "M_HRV11",
  "HFV11",
  "LFV11",
  "VLFV11",
  "TPV11",
  "PNN50V11",
  "MSSDV11",
  "SDNNV11"
)
hrv1 <- hrv1[c(svar)]

## HRV data from visit 4.
hrv4 <- read_csv("../data/hrv/hrv_re4f.dat", col_names = TRUE)

# Selected variables
svar <- c(
  "ID",
  "postV4r",
  "qcflgv4R",
  "m_hrv4r",
  "HFv4r",
  "LFv4r",
  "VLFv4r",
  "tpV4r",
  "mssdV4r",
  "pnn50V4r",
  "sdnnV4r"
)
hrv4 <- hrv4[c(svar)]
# }}}

## Outcomes {{{

# Patient mortality and morbidity and time of death was available up to the year 2015. The outcomes were given alongside ICD codes.

# Read in table
outcomes <- read_csv("../data/outcomes/inc_by15.dat", col_names = TRUE)

# Select and trim data frame
svar <- c(
  "ID",
  "C7_DATEMI",
  "C7_DATEPROC",
  "UCOD",
  "DATED15",
  "DEAD15"
)
outcomes <- outcomes[c(svar)]

# Date of MI (12/31/2015 is just the censoring date)
outcomes$C7_DATEMI <- mdy(outcomes$C7_DATEMI)

# Date of catherization (12/31/2015 is a censoring date)
outcomes$C7_DATEPROC <- mdy(outcomes$C7_DATEPROC)

# Date of death
outcomes$DATED15 <- dmy(outcomes$DATED15)

# Clean up outcomes
outcomes <- outcomes[c("ID", "C7_DATEMI", "UCOD", "DATED15", "DEAD15")]
names(outcomes) <- c("ID", "DATE_MI", "UCOD", "DATE_DEAD", "DEAD")
# }}}

