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

*drop dummy_tmax*

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

*drop dummy_rain*

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
*Prices: Wholesale Maize prices / KG

*maize_uga  (Maize Prices - UGA)
*maize_usd  (Maize Prices - USD)

gen log_wholesale_maize_uga = log(maize_uga)
gen log_wholesale_maize_usd = log(maize_usd)


******************************************************************
*Notes:
* 1. Rainfall results are relatively better 
* 1.1 12 month positive rainfall anolmalies works best (significant direct and total, insignificnat indirect)
* 2. Positive rainfall anomalies work better than -ve rainfall anomalies
* 3. Battles, Riots, VAC ==> Same results

* 4. Positive temp significant for 3-month and protests (direct + total)
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Model 1 (Neg Rainfall-Stunting)

*Mediation	- by Stunting and Rainfall anamoly   (12, 9: Okay with insignificnat indirect effect, 3,6 not working here) (Not working without 2000) (12 , 9 , 6 Works with price control)
*We have partial negative effect from climate to stunting  << OK

global control1  rural_prop  agri_land_hhds HH_with_improved_tiolet  log_battles_pres underwht_ch   No_min_diet_diversity_hh log_wholesale_maize_uga gini pov_hd_bot_20 //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS      head_ag_m   head_ag_wm share_wmhead_unempl
global control2  rural_prop    agri_land_hhds HH_with_improved_tiolet  log_battles_pres   underwht_ch  No_min_diet_diversity_hh log_wholesale_maize_uga gini pov_hd_bot_20 //nt_ch_sev_anem RI_Low_w anom_tmax12_POS   share_wmhead_unempl
global prec_anamoly "anom_rain9_NEG" 	
global conflict "log_battles_fut"   

gsem (stunted_ch <- $prec_anamoly  $control1 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]) ///
    ($conflict <- stunted_ch $prec_anamoly $control2 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]), latent(M1) nocapslatent difficult  //i.region#i.dhsyear since regions vary within dhsyears

	outreg2 using "$results/tables/table_pos_rain_stunt12.xls", replace keep(stunted_ch $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$prec_anamoly]

*Pos Temp and Stunting

global control1  rural_prop  agri_land_hhds HH_with_improved_tiolet  log_battles_pres underwht_ch   No_min_diet_diversity_hh log_wholesale_maize_uga gini pov_hd_bot_20 //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS      head_ag_m   head_ag_wm share_wmhead_unempl
global control2  rural_prop    agri_land_hhds HH_with_improved_tiolet  log_battles_pres   underwht_ch  No_min_diet_diversity_hh log_wholesale_maize_uga gini pov_hd_bot_20 //nt_ch_sev_anem RI_Low_w anom_tmax12_POS   share_wmhead_unempl
global prec_anamoly "anom_tmax3_POS" 	
global conflict "log_battles_fut"   

gsem (stunted_ch <- $prec_anamoly  $control1 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]) ///
    ($conflict <- stunted_ch $prec_anamoly $control2 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]), latent(M1) nocapslatent difficult  //i.region#i.dhsyear since regions vary within dhsyears

	outreg2 using "$results/tables/table_pos_temp_stunt12.xls", replace keep(stunted_ch $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch]

* Total 
nlcom _b[stunted_ch:$prec_anamoly] * _b[$conflict:stunted_ch] + _b[$conflict:$prec_anamoly]
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
*Mediation	- by Stunting - Pos Rainfall anamoly   (Only 12 works)  (Not without 2000)
global control1  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres underwht_ch   No_min_diet_diversity_hh  log_wholesale_maize_uga  //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres   underwht_ch  No_min_diet_diversity_hh  log_wholesale_maize_uga //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_rain12_NEG" 	
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



*****Neg Temp & Riots
global control1  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres underwht_ch   No_min_diet_diversity_hh  log_wholesale_maize_uga  //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres   underwht_ch  No_min_diet_diversity_hh  log_wholesale_maize_uga //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_tmax12_POS" 	
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
*Mediation	- by Stunting - Rainfall anamoly   (Only 12, 9 works) (Also works without 2000)
global control1  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_rain3_NEG" 	
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

*** Pos temp and vac
global control1  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_tmax12_POS" 	
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
*Mediation	- by Stunting - Rainfall anamoly   (Only 12, 9 works)
global control1  rural_prop  share_wmhead_unempl   HH_with_improved_tiolet  log_protests_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop  share_wmhead_unempl   HH_with_improved_tiolet  log_protests_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_rain12_NEG" 	
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

*Pos temp & protests
global control1  rural_prop  share_wmhead_unempl   HH_with_improved_tiolet  log_protests_pres underwht_ch   No_min_diet_diversity_hh    //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop  share_wmhead_unempl   HH_with_improved_tiolet  log_protests_pres   underwht_ch  No_min_diet_diversity_hh   //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global prec_anamoly "anom_tmax12_POS" 	
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

*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
*PRICES REGRESSIONS & Rainfall

*Good results so far

*Best = anom_rain3_NEG & anom_rain12_NEG, Only indirect effect for battles, with partial effect  | anom_rain6_NEG anom_rain9_NEG works for partial

*Mediation	- by Maize Prices - Rainfall anamoly  (Initially Okay with 12, 9, 6, 3) No indirect

*Battles & negative rainfalls (Works)                *********************************************

global control1  rural_prop     agri_land_hhds    hh_head_primary  share_wmhead_unempl stunted_ch log_battles_pres        //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop      agri_land_hhds    hh_head_primary share_wmhead_unempl stunted_ch log_battles_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_rain12_NEG" 	  //anom_rain9_POS
global conflict "log_battles_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]

****Battles and positive temp

global control1  rural_prop     agri_land_hhds    hh_head_primary  share_wmhead_unempl stunted_ch log_battles_pres        //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop      agri_land_hhds    hh_head_primary share_wmhead_unempl stunted_ch log_battles_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_tmax12_POS" 	  //anom_rain9_POS
global conflict "log_battles_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_temp_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]

*********************VAC (doesn't work')

global control1  rural_prop head_ag_m  agri_land_hhds hh_head_primary  share_wmhead_unempl stunted_ch log_vac_pres       //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop   head_ag_m agri_land_hhds hh_head_primary share_wmhead_unempl stunted_ch log_vac_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_rain12_NEG" 	
global conflict "log_vac_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]

*VAC & POs Temp

global control1  rural_prop head_ag_m  agri_land_hhds hh_head_primary  share_wmhead_unempl stunted_ch log_vac_pres       //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop   head_ag_m agri_land_hhds hh_head_primary share_wmhead_unempl stunted_ch log_vac_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_tmax3_POS" 	
global conflict "log_vac_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]

*********************Riots (works as battles 9, 6)

global control1  rural_prop  head_ag_m  agri_land_hhds   hh_head_primary  share_wmhead_unempl stunted_ch log_riots_pres       //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop   head_ag_m  agri_land_hhds   hh_head_primary share_wmhead_unempl stunted_ch log_riots_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_rain12_NEG" 	
global conflict "log_riots_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]


* Pos Temp and riots


global control1  rural_prop  head_ag_m  agri_land_hhds   hh_head_primary  share_wmhead_unempl stunted_ch log_riots_pres       //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop   head_ag_m  agri_land_hhds   hh_head_primary share_wmhead_unempl stunted_ch log_riots_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_tmax3_POS" 	
global conflict "log_riots_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]

*********************Protests (Pos 3 works)  Partial effect from climate to mediator  ********************************************

global control1  rural_prop  head_ag_m  agri_land_hhds   hh_head_primary  share_wmhead_unempl stunted_ch log_protests_pres       //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop  head_ag_m  agri_land_hhds    hh_head_primary share_wmhead_unempl stunted_ch log_protests_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_rain12_NEG" 	//anom_rain3_POS   (Neg 3,6, 9, 12 works with Negative rainfall for partial effects from climate to mediator)
global conflict "log_protests_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]


*Protests and Pos temp

global control1  rural_prop  head_ag_m  agri_land_hhds   hh_head_primary  share_wmhead_unempl stunted_ch log_protests_pres       //HH_with_improved_tiolet   underwht_ch  share_wmhead_unempl No_min_diet_diversity_hh
global control2  rural_prop  head_ag_m  agri_land_hhds    hh_head_primary share_wmhead_unempl stunted_ch log_protests_pres     //HH_with_improved_tiolet    underwht_ch   share_wmhead_unempl No_min_diet_diversity_hh
global prec_anamoly "anom_tmax3_POS" 	//anom_rain3_POS   (Neg 3,6, 9, 12 works with Negative rainfall for partial effects from climate to mediator)
global conflict "log_protests_fut"   

gsem (log_wholesale_maize_uga <- $prec_anamoly  $control1 i.quarter#i.dhsyear  M1[grid_id]) ///
    ($conflict <- log_wholesale_maize_uga $prec_anamoly $control2 i.quarter#i.dhsyear  M1[grid_id]), latent(M1) nocapslatent difficult

	outreg2 using "$results/tables/table_pos_rain_maize_9.xls", replace keep(log_wholesale_maize_uga $prec_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$prec_anamoly]

* Indirect
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga]

* Total 
nlcom _b[log_wholesale_maize_uga:$prec_anamoly] * _b[$conflict:log_wholesale_maize_uga] + _b[$conflict:$prec_anamoly]
*-------------------------------------------------------------------------------



*-------------------------------------------------------------------------------

*Model 4 (Temp-Poverty worls better) works with i.region#i.dhsyear

*Mediation	- by Poverty (3 works)
*Battles
global control1  rural_prop agri_land_hhds share_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres        //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop agri_land_hhds  share_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres         //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global temp_anamoly "anom_tmax3_POS" 	
global conflict "log_battles_fut"   

gsem (pov_hd_bot_20 <- $temp_anamoly  $control1 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]) ///
    ($conflict <- pov_hd_bot_20 $temp_anamoly $control2 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]), latent(M1) nocapslatent difficult  //i.region#i.dhsyear since regions vary within dhsyears

	outreg2 using "$results/tables/table_pos_rain_pov12.xls", replace keep(pov_hd_bot_20 $temp_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$temp_anamoly]

* Indirect
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20]

* Total 
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20] + _b[$conflict:$temp_anamoly]



*Protests (Doesn't work)

global control1  rural_prop share_wmhead_unempl  HH_with_improved_tiolet  log_protests_pres        //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_protests_pres         //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global temp_anamoly "anom_tmax12_POS" 	
global conflict "log_protests_fut"   

gsem (pov_hd_bot_20 <- $temp_anamoly  $control1 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]) ///
    ($conflict <- pov_hd_bot_20 $temp_anamoly $control2 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]), latent(M1) nocapslatent difficult  //i.region#i.dhsyear since regions vary within dhsyears

	outreg2 using "$results/tables/table_pos_temp_pov12.xls", replace keep(pov_hd_bot_20 $temp_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$temp_anamoly]

* Indirect
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20]

* Total 
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20] + _b[$conflict:$temp_anamoly]


*VAc (12 work)

global control1  rural_prop share_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres        //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_vac_pres         //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global temp_anamoly "anom_tmax9_POS" 	
global conflict "log_vac_fut"   

gsem (pov_hd_bot_20 <- $temp_anamoly  $control1 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]) ///
    ($conflict <- pov_hd_bot_20 $temp_anamoly $control2 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]), latent(M1) nocapslatent difficult  //i.region#i.dhsyear since regions vary within dhsyears

	outreg2 using "$results/tables/table_pos_temp_pov12.xls", replace keep(pov_hd_bot_20 $temp_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$temp_anamoly]

* Indirect
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20]

* Total 
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20] + _b[$conflict:$temp_anamoly]


*Riots (doesnt work)

global control1  rural_prop share_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres       //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_riots_pres         //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global temp_anamoly "anom_tmax6_POS" 	
global conflict "log_riots_fut"   

gsem (pov_hd_bot_20 <- $temp_anamoly  $control1 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]) ///
    ($conflict <- pov_hd_bot_20 $temp_anamoly $control2 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]), latent(M1) nocapslatent difficult  //i.region#i.dhsyear since regions vary within dhsyears

	outreg2 using "$results/tables/table_pos_temp_pov12.xls", replace keep(pov_hd_bot_20 $temp_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$temp_anamoly]

* Indirect
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20]

* Total 
nlcom _b[pov_hd_bot_20:$temp_anamoly] * _b[$conflict:pov_hd_bot_20] + _b[$conflict:$temp_anamoly]


*-------------------------------------------------------------------------------

*Experimentation

*anom_rain12_NEG works with gini and riots

global control1  rural_prop share_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres       //nt_ch_sev_anem   RI_Low_w anom_tmax12_POS
global control2  rural_prop   share_wmhead_unempl  HH_with_improved_tiolet  log_battles_pres         //nt_ch_sev_anem RI_Low_w anom_tmax12_POS
global temp_anamoly "anom_rain12_NEG" 	
global conflict "log_battles_fut"   

gsem (gini <- $temp_anamoly  $control1 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]) ///
    ($conflict <- gini $temp_anamoly $control2 i.quarter#i.dhsyear i.region#i.dhsyear M1[grid_id]), latent(M1) nocapslatent difficult  //i.region#i.dhsyear since regions vary within dhsyears

	outreg2 using "$results/tables/table_pos_temp_pov12.xls", replace keep(gini $temp_anamoly $control1 $control2) dec(3) nocons 

* Direct
nlcom  _b[$conflict:$temp_anamoly]

* Indirect
nlcom _b[gini:$temp_anamoly] * _b[$conflict:gini]

* Total 
nlcom _b[gini:$temp_anamoly] * _b[$conflict:gini] + _b[$conflict:$temp_anamoly]