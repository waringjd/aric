---
title: "README"
author: "Anish Shah"
date: "`r format(Sys.time(), '%B %d, %Y')`"
output: md_document
---

# Project overview

This is a evaluation of the ARIC study, with a focus on HRV and psychosocial stressors. We are theorizing that autonomic dysfunction is associated with psychosocial stressors, and that the will be reflected by attenuated HRV.

# Variable explanations

## Dictionary for comorbidities

### Visit 1

From the **DERIVE10** data set, also called **DERIVE13**.

Variable | Description
--- | ---
BM101 | BMI
PRVCHD05 | prevalent CHD
PREVM105 | prevalent MI from ECG
MDDXMI102 | MD dx MI
HXOFMI02 | h/o MI
DIABTS03 | bg > 126 DM
HYPERT05 | SBP > 140, DBP > 90
HYPTMD01 | took BP meds in 2w
CHOLMD01 | cholesterol meds
V1AGE01 | age at visit 1
V1DATE01 | date of visit 1
BIRTHDAT | birthday
GENDER | F or M
RACEGRP | A = asian, B= black, I = NA, W = white
PLAQUE01 | plaques anywhere in carotids
CIGT01 | 1 current, 2 former, 3, never, 4 unknown
CIGTYR01 | #cig/d x yrs

### Visit 2

From the **DERIVE28** data set, also called **DERIVE2_10**.

Variable | Description
--- | ---
DRNKR21 | 1 current, 2 former, 3 never, 4 unknown
BM101 | BMI
DIABTS23 | BG > 126
PRVCHD21 | CHD @ V1 + CHD events
MDDXMI21 | MD dx MI, 1 yes, 0 no
HXOFMI21 | h/o MI, 1 yes, 0 no
ECGMI24 | MI/Q waves on ECG, 1 yes, 0 no
PRVSTR21 | stroke prevalence at V2
HYPERT25 | SBP > 140, DBP > 90
CHOLMDCODE21 | cholesterol meds
HYPTMD21 | took BP meds in 2w
PLAQUE21 | plaque anywhere in carotids
CIGT21 | 1 current, 2 former, 3 never, 4 unknown
V2DATE21 | date of visit 2
V2AGE22 | age at visit 2

Extended ECG findings at *ECGMB22 data set*.


### Visit 4

From the **DERVIE46** data set, also called **DERIVE46**.

Variable | Description
--- | ---
DRNKR21 | 1 current, 2 former, 3 never, 4 unknown
BMI41 | BMI
DIABTS42 | BG > 136
PRVCHD43 | CHD by visit 4 prevalence
MDDXMI41 | MD dx MI, 1 yes 0 no
HXOFMI41 | ho MI, 1 yes, 0 no
ECGMI41 | MI/Qwaves on ECG, 1 yes, 0 no
PRVSTR41 | stroke prevalence at V4
HYPERT45 | SBP > 140, DBP > 90
CHOLMDCODE41 | cholesterol meds
HYPTMD41 | HTN meds in past 2 weeks
PLAQUE42 | plaque in carotids anywhere
CIGT41 | 1 current, 2 former, 3 never, 4 unknown
V4DATE4 | date of visit 4
V4AGE41 | age at visit 4

### Outcomes since 2015

From the **inc_by15.dat** file, containing events updated to 2015.

Variable | Description
--- | ---
ID | ARIC id number
C7_DATEMI | date recorded for MI
C7_DATEPROC | date of reconciliation
UCOD | ICD9 versus ICD10 code
DATED15 | date of known death
DEAD15 | binary death by 2015

The diagnosis codes are through the ICD

## Dictionary for HRV variables

Described in the file **aric-hrv-dictionary.xlsx** file in the dictionary folder.

### Visit 1

Using the **f_hrv11b.dat*** file.

*Not using the HRV12B data set because that is done while standing, part of an orthostatic measure.*


Variable | Description
--- | ---
ID | ARIC identification number
POSTV11 | 1 = supine (standard), 2 = standing
QCFLGV11 | quality of data, 1 = standard (good data)
M_HRV11 | beat/minute
HFV11 | high frequency
LFV11 | low frequency power
VLFV11 | very low frequency
TPV11 | total power
PNN50V11 | successive difference > 50 ms
MSSDV11 | mean squared successive difference
SDNNV11 | standard deviation of normal RR

### Visit 4

Using the **hrv_re4f.dat** file. 

Variable | Description
--- | ---
ID | ARIC identification number
postV4r | 1 = supine (standard), 2 = standing
qcflgv4r | 0 = no flag, 1 = ineligible, 2 = technical, 3 = RR < 150, 4 = noise
m_hrv4r | mean beats per minute
HFv4r | high frequency
LFv4r | low frequency
VLFv4r | very low frequency
tpV4r | total power
mssdV4r | mean squared successive differences
pnn50V4r | % successive differences > 50 ms
sdnnV4r | standard deviation of RR

## PSYCHOSOCIAL METRICS

### HPAA

#### Interpersonal Support Evaluation List (ISEL)

ISEL-SF is 16 items, each scored on a 4-point rating scale (from 0 to 3). The total summed score is an aggregate index of social support, higher scores indicating greater levels of perceived interpersonal support. The overall total score ranges from 0-48 points. 

Four subscales used are Appraisal Support (AP), Tangible Assets (TA), Belonging (BE), and Self Esteeem (SE). 

ARIC uses questions 3:18 as ISEL.

Variable | Questions
--- | ---
AP | 7, 10, 14, 17, 
TA | 8, 9, 13, 16,
BE | 4, 5, 6, 11, 18
SE | 3, 12, 15,

#### Lubben Social Network Scale

LSNS is an 11 item component of structure social support. The total score ranges from 0-50, and contains five subscales.

ARIC uses questions 19:29 as LSNS.

### HPBA

#### Maastricht Vital Exhaustion Scale

Vital exhaustion was defined by excessive fatigue, feelings of demoralization, and increased irritability. Thought to be a form of adaption to prolonged distress. 

The Maastricht Questionnaire is 21 items. The responses are ordinal as *Yes = 2*, *Don't know = 1*, and *No = 0*.

Summation of the questionnaire ranges from 0 to 42, with higher scores representing exhaustion (Cronbach's alpha for internal consistency reported as 0.89). 

### HPCA

#### Spielberger Anger Trait Scale

There are 10 items with four answers, given points of 1-4. 

The overall anger score (a numeric score of 10 to 40) was coded as
a 3-level categoric variable in which scores of 22 to 40 defined high
trait anger, 15 to 21 moderate anger, and 10 to 14 low anger.


