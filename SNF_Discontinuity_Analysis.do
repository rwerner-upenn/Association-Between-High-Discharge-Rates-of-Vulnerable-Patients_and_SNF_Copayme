/**************************************************************************************************************************
 * Goal: Defining study cohort and creating descriptive statistics 
**************************************************************************************************************************/

clear all
capture log close
set more off
set matsize 10000, perm
set scrollbufsize 300000
log using /PATH/SNF_Descriptive_03132019.log, replace

use "/PATH/SNF_Bene_Period_1216.dta", replace 

***Generate sample for summary of SNF stays (full sample: both first and not first SNF)
gen sample=(ltc_prior100!=1 & other_cvrg!=1 & snf_hospice!="1" & life_prgns_6month!="1" & dual_stus!=1)
keep if sample==1 & benefitday_snfdc>=16 & benefitday_snfdc<=24

*Check the number of discharges by SNF benefit day on discharge (day 16-24)
tab benefitday_snfdc

*Add value labels to sex and race indicators
label define sexla 1 "Male" 2 "Female" 3 "Unknown"
label values sex_num sexla
label define racela 1 "White" 2 "Black" 3 "Other" 4 "Asian" 5 "Hispanic" 6 "North American Native" 7 "Unknown"
label values race_num racela
label define mar 1 "Married" 0 "Not Married"
label values married_im mar

*Generate dummy variables for day 19 (vs day 20) and day 21 (vs day 20)
gen day19=1 if benefitday_snfdc==19
replace day19=0 if benefitday_snfdc==20

gen day21=1 if benefitday_snfdc==21
replace day21=0 if benefitday_snfdc==20

***Summarize patient covariates by SNF benefit day count at discharge 
*Age 
format age %12.0g
table benefitday_snfdc, c(mean age median age sd age)
reg age day19
reg age day21


*Male
gen male=1 if sex_num==1
replace male=0 if sex_num!=1

tab male benefitday_snfdc, col
reg male day19
reg male day21


*Race
gen race_2="White" if race_num==1
replace race_2="Black/Hispanic" if inlist(race_num, 2, 5)
replace race_2="Other" if inlist(race_num, 3, 4, 6, 7)
label variable race_2 "Race"

gen white=1 if race_num==1
replace white=0 if white==.
gen black_hispanic=1 if inlist(race_num, 2, 5)
replace black_hispanic=0 if black_hispanic==.
gen other=1 if inlist(race_num, 3, 4, 6, 7)
replace other=0 if other==.

tab race_2 benefitday_snfdc, col 

reg white day19
reg white day21

reg black_hispanic day19
reg black_hispanic day21

reg other day19
reg other day21


*Marital status
gen not_married=1 if married_im==0
replace not_married=0 if not_married==.

tab not_married benefitday_snfdc, col 
reg not_married day19
reg not_married day21


*Median Household Income of the Zip Code Area
table benefitday_snfdc, c(mean med_hoshd_inc median med_hoshd_inc sd med_hoshd_inc)
reg med_hoshd_inc day19
reg med_hoshd_inc day21


*Poverty Rate of the Zip Code Area
table benefitday_snfdc, c(mean povty_rate median povty_rate sd povty_rate)
reg povty_rate day19
reg povty_rate day21


*Unemployment Rate of the Zip Code Area
table benefitday_snfdc, c(mean unemplmt_rate median unemplmt_rate sd unemplmt_rate)
reg unemplmt_rate day19
reg unemplmt_rate day21


*Number of comorbidities 
gen combdty_sum_2="0" if combdty_sum==0 
replace combdty_sum_2="1" if combdty_sum==1  
replace combdty_sum_2="2" if combdty_sum==2  
replace combdty_sum_2="3" if combdty_sum==3  
replace combdty_sum_2="4" if combdty_sum==4
replace combdty_sum_2="5+" if combdty_sum>=5
label variable combdty_sum_2 "Count of Comorbidities"

gen combdty_sum0=1 if combdty_sum==0
replace combdty_sum0=0 if combdty_sum!=0
gen combdty_sum1=1 if combdty_sum==1
replace combdty_sum1=0 if combdty_sum!=1
gen combdty_sum2=1 if combdty_sum==2
replace combdty_sum2=0 if combdty_sum!=2
gen combdty_sum3=1 if combdty_sum==3
replace combdty_sum3=0 if combdty_sum!=3
gen combdty_sum4=1 if combdty_sum==4
replace combdty_sum4=0 if combdty_sum!=4
gen combdty_sum5=1 if combdty_sum>=5
replace combdty_sum5=0 if combdty_sum<5


tab combdty_sum_2 benefitday_snfdc, col

reg combdty_sum0 day19
reg combdty_sum0 day21

reg combdty_sum1 day19
reg combdty_sum1 day21

reg combdty_sum2 day19
reg combdty_sum2 day21

reg combdty_sum3 day19
reg combdty_sum3 day21

reg combdty_sum4 day19
reg combdty_sum4 day21

reg combdty_sum5 day19
reg combdty_sum5 day21


capture log close







