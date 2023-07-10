********************************************************************************
********************************REGRESSIONS*************************************
*********************************Analysis***************************************

clear
clear matrix
clear mata
set maxvar 20000

*Reading in Final Data Set - Post grid level collapse (Panel Datset at Grid level panel, created in QGIS)
use "$results/FinalDataSet", clear

******************************************************************
// Maximum Temperature Variables of Interest
******************************************************************

//Should we do these by years etc especially quartiles

* MAX TEMP DUMMY POSITIVE

drop dummy_tmax*

gen dummy_tmax12_pos =  temp_rollMean_p12 > 0 
gen dummy_tmax9_pos  =  temp_rollMean_p9  > 0
gen dummy_tmax6_pos  =  temp_rollMean_p6  > 0 
gen dummy_tmax3_pos  =  temp_rollMean_p3  > 0 


* MAX TEMP CONTINUOUS POSITIVE
gen anom_tmax3_POS = temp_rollMean_p3 if temp_rollMean_p3 >0 
replace anom_tmax3_POS =0 if temp_rollMean_p3<=0 
gen anom_tmax6_POS = temp_rollMean_p6 if temp_rollMean_p6 >0 
replace anom_tmax6_POS =0 if temp_rollMean_p6<=0 
gen anom_tmax9_POS = temp_rollMean_p9 if temp_rollMean_p9 >0 
replace anom_tmax9_POS =0 if temp_rollMean_p9<=0 
gen anom_tmax12_POS = temp_rollMean_p12 if temp_rollMean_p12 >0 
replace anom_tmax12_POS =0 if temp_rollMean_p12<=0

* TEMP EXTREME 12 CONTINUOUS
xtile temp_quartile_1 = temp_rollMean_p12 if temp_rollMean_p12 > 0, n(4)
gen temp_Q1_12=0
gen temp_Q2_12=0
gen temp_Q3_12=0
gen temp_Q4_12=0
replace temp_Q1_12=temp_rollMean_p12 if temp_quartile_1==1
replace temp_Q2_12=temp_rollMean_p12 if temp_quartile_1==2
replace temp_Q3_12=temp_rollMean_p12 if temp_quartile_1==3
replace temp_Q4_12=temp_rollMean_p12 if temp_quartile_1==4
replace temp_Q1_12=. if temp_rollMean_p12==. 
replace temp_Q2_12=. if temp_rollMean_p12==. 
replace temp_Q3_12=. if temp_rollMean_p12==. 
replace temp_Q4_12=. if temp_rollMean_p12==. 

* TEMP EXTREME 12 DUMMY
gen dummy_temp_Q4_12 = temp_Q4_12 > 0

* TEMP EXTREME 9 CONTINUOUS
xtile temp_quartile_2=temp_rollMean_p9 if temp_rollMean_p9>0,n(4)
gen temp_Q1_9=0
gen temp_Q2_9=0
gen temp_Q3_9=0
gen temp_Q4_9=0
replace temp_Q1_9=temp_rollMean_p9 if temp_quartile_2==1
replace temp_Q2_9=temp_rollMean_p9 if temp_quartile_2==2
replace temp_Q3_9=temp_rollMean_p9 if temp_quartile_2==3
replace temp_Q4_9=temp_rollMean_p9 if temp_quartile_2==4
replace temp_Q1_9=. if temp_rollMean_p9==. 
replace temp_Q2_9=. if temp_rollMean_p9==. 
replace temp_Q3_9=. if temp_rollMean_p9==. 
replace temp_Q4_9=. if temp_rollMean_p9==. 

* TEMP EXTREME 9 DUMMY
gen dummy_temp_Q4_9 = temp_Q4_9 > 0


* TEMP EXTREME 6 CONTINUOUS
xtile temp_quartile_3=temp_rollMean_p6 if temp_rollMean_p6>0,n(4)
gen temp_Q1_6=0
gen temp_Q2_6=0
gen temp_Q3_6=0
gen temp_Q4_6=0
replace temp_Q1_6=temp_rollMean_p6 if temp_quartile_3==1
replace temp_Q2_6=temp_rollMean_p6 if temp_quartile_3==2
replace temp_Q3_6=temp_rollMean_p6 if temp_quartile_3==3
replace temp_Q4_6=temp_rollMean_p6 if temp_quartile_3==4
replace temp_Q1_6=. if temp_rollMean_p6==. 
replace temp_Q2_6=. if temp_rollMean_p6==. 
replace temp_Q3_6=. if temp_rollMean_p6==. 
replace temp_Q4_6=. if temp_rollMean_p6==. 

* TEMP EXTREME 6 DUMMY
gen dummy_temp_Q4_6 = temp_Q4_6 > 0

* TEMP EXTREME 3 CONTINUOUS
xtile temp_quartile_4=temp_rollMean_p3 if temp_rollMean_p3>0,n(4)
gen temp_Q1_3=0
gen temp_Q2_3=0
gen temp_Q3_3=0
gen temp_Q4_3=0
replace temp_Q1_3=temp_rollMean_p3 if temp_quartile_4==1
replace temp_Q2_3=temp_rollMean_p3 if temp_quartile_4==2
replace temp_Q3_3=temp_rollMean_p3 if temp_quartile_4==3
replace temp_Q4_3=temp_rollMean_p3 if temp_quartile_4==4
replace temp_Q1_3=. if temp_rollMean_p3==. 
replace temp_Q2_3=. if temp_rollMean_p3==. 
replace temp_Q3_3=. if temp_rollMean_p3==. 
replace temp_Q4_3=. if temp_rollMean_p3==. 

* TEMP EXTREME 3 DUMMY
gen dummy_temp_Q4_3 = temp_Q4_3 > 0


******************************************************************
// RAIN
******************************************************************
* RAIN DUMMY - NEG and POS

drop dummy_rain*

gen  dummy_rain12_pos =  prec_rollMean_p12 >  0 
gen  dummy_rain9_pos  =  prec_rollMean_p9  >  0 
gen  dummy_rain6_pos =  prec_rollMean_p6   >  0 
gen  dummy_rain3_pos =  prec_rollMean_p3   >  0 

gen  dummy_rain12_neg =  prec_rollMean_p12  < 0
gen  dummy_rain9_neg  =  prec_rollMean_p9   < 0 
gen  dummy_rain6_neg  =  prec_rollMean_p6   < 0 
gen  dummy_rain3_neg  =  prec_rollMean_p3   < 0 


* RAIN CONTINUOUS - NEG and POS
gen anom_rain12_POS = prec_rollMean_p12 if prec_rollMean_p12 >0 
replace anom_rain12_POS =0 if prec_rollMean_p12<= 0 

gen anom_rain12_NEG = prec_rollMean_p12 if prec_rollMean_p12 <0 
replace anom_rain12_NEG =0 if prec_rollMean_p12>=0 

gen anom_rain9_POS = prec_rollMean_p9 if prec_rollMean_p9 >0 
replace anom_rain9_POS =0 if prec_rollMean_p9<=0 

gen anom_rain9_NEG = prec_rollMean_p9 if prec_rollMean_p9 <0 
replace prec_rollMean_p9 =0 if prec_rollMean_p9>=0 

gen anom_rain6_POS = prec_rollMean_p6 if prec_rollMean_p6 >0 
replace anom_rain6_POS =0 if prec_rollMean_p6 <=0 

gen anom_rain6_NEG = prec_rollMean_p6 if prec_rollMean_p6 <0 
replace anom_rain6_NEG =0 if prec_rollMean_p6>=0

gen anom_rain3_POS = prec_rollMean_p3 if prec_rollMean_p3 >0 
replace anom_rain3_POS =0 if prec_rollMean_p3<=0 

gen anom_rain3_NEG = prec_rollMean_p3 if prec_rollMean_p3 <0 
replace anom_rain3_NEG =0 if prec_rollMean_p3 >=0 

* RAIN EXTREME 9 NEGATIVE CONTINUOUS
xtile rain_quartile_1 = prec_rollMean_p9 if prec_rollMean_p9 < 0, n(4)
gen rain_Q1_9_neg=0 // most negative one
gen rain_Q2_9_neg=0
gen rain_Q3_9_neg=0
gen rain_Q4_9_neg=0
replace rain_Q1_9_neg=prec_rollMean_p9 if rain_quartile_1==1
replace rain_Q2_9_neg=prec_rollMean_p9 if rain_quartile_1==2
replace rain_Q3_9_neg=prec_rollMean_p9 if rain_quartile_1==3
replace rain_Q4_9_neg=prec_rollMean_p9 if rain_quartile_1==4
replace rain_Q1_9_neg=. if prec_rollMean_p9==. 
replace rain_Q2_9_neg=. if prec_rollMean_p9==. 
replace rain_Q3_9_neg=. if prec_rollMean_p9==. 
replace rain_Q4_9_neg=. if prec_rollMean_p9==. 

* RAIN EXTREME 9 NEGATIVE DUMMY
gen dummy_rain_Q1_9_neg = rain_Q1_9_neg < 0

/* Error: NO obs >0 so can't make quartiles
* RAIN EXTREME 9 POS CONTINUOUS
xtile rain_quartile_2 = prec_rollMean_p9 if prec_rollMean_p9 > 0, n(4)
gen rain_Q1_9_pos=0 
gen rain_Q2_9_pos=0
gen rain_Q3_9_pos=0
gen rain_Q4_9_pos=0 // most positive one
replace rain_Q1_9_pos=prec_rollMean_p9 if rain_quartile_2==1
replace rain_Q2_9_pos=prec_rollMean_p9 if rain_quartile_2==2
replace rain_Q3_9_pos=prec_rollMean_p9 if rain_quartile_2==3
replace rain_Q4_9_pos=prec_rollMean_p9 if rain_quartile_2==4
replace rain_Q1_9_pos=. if prec_rollMean_p9==. 
replace rain_Q2_9_pos=. if prec_rollMean_p9==. 
replace rain_Q3_9_pos=. if prec_rollMean_p9==. 
replace rain_Q4_9_pos=. if prec_rollMean_p9==. 

* RAIN EXTREME 9 POSITIVE DUMMY
gen dummy_rain_Q4_9_pos = rain_Q4_9_pos > 0
*/

* RAIN EXTREME 6 NEGATIVE CONTINUOUS
xtile rain_quartile_3=prec_rollMean_p6 if prec_rollMean_p6<0,n(4)
gen rain_Q1_6_neg=0 // most negative one
gen rain_Q2_6_neg=0
gen rain_Q3_6_neg=0
gen rain_Q4_6_neg=0
replace rain_Q1_6_neg=prec_rollMean_p6 if rain_quartile_3==1
replace rain_Q2_6_neg=prec_rollMean_p6 if rain_quartile_3==2
replace rain_Q3_6_neg=prec_rollMean_p6 if rain_quartile_3==3
replace rain_Q4_6_neg=prec_rollMean_p6 if rain_quartile_3==4
replace rain_Q1_6_neg=. if prec_rollMean_p6==. 
replace rain_Q2_6_neg=. if prec_rollMean_p6==. 
replace rain_Q3_6_neg=. if prec_rollMean_p6==. 
replace rain_Q4_6_neg=. if prec_rollMean_p6==. 

* RAIN EXTREME 6 NEGATIVE DUMMY
gen dummy_rain_Q1_6_neg = rain_Q1_6_neg < 0

* RAIN EXTREME 6 POS CONTINUOUS
xtile rain_quartile_4=prec_rollMean_p6 if prec_rollMean_p6>0,n(4)
gen rain_Q1_6_pos=0 
gen rain_Q2_6_pos=0
gen rain_Q3_6_pos=0
gen rain_Q4_6_pos=0 // most positive one
replace rain_Q1_6_pos=prec_rollMean_p6 if rain_quartile_4==1
replace rain_Q2_6_pos=prec_rollMean_p6 if rain_quartile_4==2
replace rain_Q3_6_pos=prec_rollMean_p6 if rain_quartile_4==3
replace rain_Q4_6_pos=prec_rollMean_p6 if rain_quartile_4==4
replace rain_Q1_6_pos=. if prec_rollMean_p6==. 
replace rain_Q2_6_pos=. if prec_rollMean_p6==. 
replace rain_Q3_6_pos=. if prec_rollMean_p6==. 
replace rain_Q4_6_pos=. if prec_rollMean_p6==. 

* RAIN EXTREME 6 POSITIVE DUMMY
gen dummy_rain_Q4_6_pos = rain_Q4_6_pos > 0

******************************************************************
// CONFLICTS
******************************************************************
*-------------------------------------------------------------------------------
* LOG (battles related conflicts)
gen log_battles_pres = log(battles_present_number_of_confli + 1)
gen log_battles_fut=   log(battles_future_number_of_conflic +1)

* LOG (Violence Against civilians related conflicts)
gen log_vac_pres = log(vac_present_number_of_conflicts + 1)
gen log_vac_fut=   log(vac_future_number_of_conflicts +1)

* LOG (Riots related conflicts)
gen log_riots_pres = log(riots_present_number_of_conflict + 1)
gen log_riots_fut=   log(riots_future_number_of_conflicts +1)

* LOG (Protests related conflicts)
gen log_protests_pres = log(protests_present_number_of_confl + 1)
gen log_protests_fut=   log(protests_future_number_of_confli +1)
*-------------------------------------------------------------------------------
* INVERSE HYPERBOLIC sine transf (for right skewed vars with zeros and neg values) 
*Battles
gen ihs_battles_fut = log(battles_future_number_of_conflic + sqrt(battles_future_number_of_conflic^2 + 1))
gen ihs_battles_pres= log(battles_present_number_of_confli + sqrt(battles_present_number_of_confli^2 + 1))
*VAC
gen ihs_vac_fut = log(vac_future_number_of_conflicts + sqrt(vac_future_number_of_conflicts^2 + 1))
gen ihs_vac_pres= log(vac_present_number_of_conflicts + sqrt(vac_present_number_of_conflicts^2 + 1))
*Riots
gen ihs_riots_fut = log(riots_future_number_of_conflicts + sqrt(riots_future_number_of_conflicts^2 + 1))
gen ihs_riots_pres= log(riots_future_number_of_conflicts + sqrt(riots_future_number_of_conflicts^2 + 1))
*Protests
gen ihs_protests_fut = log(protests_future_number_of_confli + sqrt(protests_future_number_of_confli^2 + 1))
gen ihs_protests_pres= log(protests_present_number_of_confl + sqrt(protests_present_number_of_confl^2 + 1))
*-------------------------------------------------------------------------------
* TOTAL CONFLICT 
egen tot_conf_future = rowtotal (battles_future_number_of_conflic vac_future_number_of_conflicts riots_future_number_of_conflicts protests_future_number_of_confli)
egen tot_conf_present = rowtotal (battles_present_number_of_confli vac_present_number_of_conflicts riots_present_number_of_conflict protests_present_number_of_confl)

gen log_tot_fut = log(tot_conf_future +1)
gen log_tot_pres = log(tot_conf_present +1)
gen ihs_tot_fut = log(tot_conf_future + sqrt(tot_conf_future^2 + 1))
gen ihs_tot_pres= log(tot_conf_present + sqrt(tot_conf_present^2 + 1))
*-------------------------------------------------------------------------------

******************************************************************
// OTHER VARIABLES (May be later suh as prices)
******************************************************************
*Notes:
* 1. Rainfall results are relatively better 
* 1.1 12 month positive rainfall anolmalies worl best (significant direct and total, insignificnat indirect)
* 2. Positive rainfall anomalies work better than -ve rainfall anomalies
* 3. Battles, Riots, VAC ==> Same results

* 4. Positive temp significant for 3-month and protests (direct + total)
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Model 1 (Rainfall)

*Mediation	- by Stunting and Rainfall anamoly   (12, 9: Okay with insignificnat indirect effect, 3,6 not working here)
global control1  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_rain12_POS" 	
global conflict "log_battles_fut"   

gsem (stunted_ch <- $prec_anamoly  $control1 i.quarter#i.dhsyear i.region M1[grid_id]) ///
    ($conflict <- stunted_ch $prec_anamoly $control2 i.quarter#i.dhsyear i.region M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_stunt12.xls", replace keep(stunted_ch $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$prec_anamoly]


*-------------------------------------------------------------------------------
*Mediation	- by Stunting and Rainfall anamoly   (Only 12 works)
global control1  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_rain12_POS" 	
global conflict "log_riots_fut"   

gsem (stunted_ch <- $prec_anamoly  $control1 i.quarter#i.dhsyear i.region M1[grid_id]) ///
    ($conflict <- stunted_ch $prec_anamoly $control2 i.quarter#i.dhsyear i.region M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_riotsstunt12.xls", replace keep(stunted_ch $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$prec_anamoly]
*-------------------------------------------------------------------------------
*Mediation	- by Stunting and Rainfall anamoly   (Only 12, 9 works)
global control1  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_rain12_POS" 	
global conflict "log_vac_fut"   

gsem (stunted_ch <- $prec_anamoly  $control1 i.quarter#i.dhsyear i.region M1[grid_id]) ///
    ($conflict <- stunted_ch $prec_anamoly $control2 i.quarter#i.dhsyear i.region M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_vac_stunt12.xls", replace keep(stunted_ch $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$prec_anamoly]
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Mediation	- by Stunting and Rainfall anamoly   (Only 12, 9 works)
global control1  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_protests_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_protests_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_rain12_POS" 	
global conflict "log_protests_fut"   

gsem (stunted_ch <- $prec_anamoly  $control1 i.quarter#i.dhsyear i.region M1[grid_id]) ///
    ($conflict <- stunted_ch $prec_anamoly $control2 i.quarter#i.dhsyear i.region M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_prot_stunt12.xls", replace keep(stunted_ch $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$prec_anamoly]
*-------------------------------------------------------------------------------
*Models 2 (Rainfall Dummy)  (work for battles + protests + VAC) (not for riots)

*Mediation	- by stunting and  Rainfall Dummies   
global control1  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "dummy_rain12_neg" 	
global conflict "log_vac_fut"  

gsem (stunted_ch <- $prec_anamoly  $control1 i.quarter#i.dhsyear i.region M1[grid_id]) ///
    ($conflict <- stunted_ch $prec_anamoly  $control2 i.quarter#i.dhsyear i.region M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_dummy_rain_stunt12.xls", replace keep(stunted_ch $prec_anamoly  $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$prec_anamoly]


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Models 3 (Positive Temperature anomalies)  pos temp not significant in general  (Significant for 3 month protests)

*Mediation	- by Stunitng and  temp anamoly
global control1  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_protests_pres      underwht_ch No_min_diet_diversity_hh //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_protests_pres      underwht_ch No_min_diet_diversity_hh //nt_ch_sev_anem RI_Low_w anom_tmax12_POS

global temp_anamoly "anom_tmax3_POS" 	
global conflict "log_protests_fut"   

gsem (stunted_ch <- $temp_anamoly $control1 i.quarter#i.dhsyear i.region M1[grid_id]) ///
    ($conflict <- stunted_ch $temp_anamoly $control2 i.quarter#i.dhsyear i.region M1[grid_id]), latent(M1) nocapslatent difficult
	
	outreg2 using "$results/tables/table_temp3_vac.xls", replace keep(stunted_ch $temp_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$temp_anamoly]

* Indirect
nlcom _b[stunted_ch:$temp_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$temp_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$temp_anamoly]

*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Models 4

*Mediation	- by Stunting and  Temperature Dummies   
global control1  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   dummy_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global temp_anamoly "dummy_tmax12_pos" 	
global conflict "log_battles_fut"  

gsem (stunted_ch <- $temp_anamoly  $control1 i.quarter#i.dhsyear i.region M1[grid_id]) ///
    ($conflict <- stunted_ch $temp_anamoly  $control2 i.quarter#i.dhsyear i.region M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_dummy_temp_stunt12.xls", replace keep(stunted_ch $temp_anamoly  $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$temp_anamoly]

* Indirect
nlcom _b[stunted_ch:$temp_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$temp_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$temp_anamoly]


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
