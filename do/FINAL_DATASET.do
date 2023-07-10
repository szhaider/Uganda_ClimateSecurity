
*Final Dataset (DHS + Clmate anomalies + Conflicts + Prices)

*DHS + Geo + Climate Dataset - All Years
*merged DHS household and climate dataset at household level
use "results/Final_Uganda_DHS_GEO_CLimate.dta", clear

order dhsclust longnum latnum dhsyear quarter 
*-------------------------------------------------------------------------------

gen HH_head_female = hv219  == 2    // Proportion of female headed households

gen rural_prop = type_place == 2   // Proportion of rural households


gen HH_with_rud_floor_material = inrange(hv213, 10, 22)    //Proportion of households with rudimentary floor material									
/*
definition
          10   natural
          11   earth/sand
          12   dung
          20   rudimentary
          21   wood planks
          22   palm/bamboo   
          30   finished
          31   parquet or polished wood
          32   concrete
          33   ceramic tiles
          34   cement screed
          35   carpet
          36   stones
          37   bricks
          96   other
		  */

gen HH_with_improved_tiolet = inrange(hv205, 10, 13)  						// type of toilet facility 		  
		  
		  /*
		   definition
          10   flush toilet
          11   flush to piped sewer system
          12   flush to septic tank
          13   flush to pit latrine
          14   flush to somewhere else
          15   flush, don't know where
          20   pit toilet latrine
          21   ventilated improved pit latrine (vip)
          22   pit latrine with slab
          23   pit latrine without slab/open pit
          30   no facility
          31   no facility/bush/field
          41   composting toilet/ecosan
          42   bucket toilet
          43   hanging toilet/latrine
          96   other

   variables:  hv205

		  */
		  
/*
Region Label (F.Es)
 definition  2016   , only 10 in 2011, 9 in 2006, 4 in 2001  !!!(Districts are available for 2016 (112), 2006 (56) & 2001 (34), but missing in 2011)!!!
           0   kampala
           1   south buganda
           2   north buganda
           3   busoga
           4   bukedi
           5   bugisu
           6   teso
           7   karamoja
           8   lango
           9   acholi
          10   west nile
          11   bunyoro
          12   tooro
          13   ankole
          14   kigezi


   Variables: hv024 == region

*/

/* Districts sh002 shdist, County sh003

*/

rename  type_place rural_urban
*-------------------------------------------------------------------------------

collapse (mean) prec prec_rollMean_* temp temp_rollMean_* ///
access_electricity=hv206 own_radio=hv207 own_tv=hv208 own_refrigerator=hv209 own_bicycle=hv210 own_scooter=hv211 own_car=hv212 own_telephone= hv221  ///
HH_head_female	HH_head_age= hv220 hhsize = hv009 ///						
head_* ///  //Household Head characteristics (Ocuupation (women + men), Education (women + men), )
hh_head_* /// Household head education (no, prim, sec, higher)
RI_Low_w nt_wm_modsevthin nt_wm_sev_anem nt_wm_micro_iron* /// women BMI, Rohrer's index (low/very low), Severe/Moderate Anemia-women, 
stunted_ch wasted_ch underwht_ch 	nt_ch_sev_anem		///   Stunt, Wast, Underw, Moderate/severe Anemia
HH_with_rud_floor_material HH_with_improved_tiolet rural_prop  ///
No_min_diet_diversity_hh  inf_min_breast not_inf_min_breast min_diet_diversity   /// children diet and food nutrition No_min_meal_freq_hh Meal_freq_hh
new_No_min_diet_diversity_hh nt_mdd min_meal_freq_bf_inf min_meal_freq_bf_child /// children diet and food nutrition
(sum) tot_* No_of_stunt=stunting_c_hh No_of_wast=wasted_c_hh No_of_undw=underwht_ch_hh No_of_anemic=anemia_ch_hh ///
No_of_lowrohrer_w=tot_RI_Low_w No_of_lowBMI_w=DHS_tot_BMI_low_w No_of_anem_w=sev_mod_anemia_hh /// number of stunted, wasted, underweight , low rohrer women, 	low BMI women										
(median) median_wealth_index_quintile=wealth_index median_wealth_index_score=wealth_index_score  ///
[pw=wgt], by (dhsyear quarter region dhsclust latnum longnum rural_urban)  // no. of regions goes down back in early years 

sort dhsyear dhsclust
*-------------------------------------------------------------------------------
*Final Conflicts Data - all years
merge 1:1 dhsyear dhsclust quarter using "$results/final_conflicts_DHS_Uganda.dta", nogen  // All matched

/*
*Final Prices Data - All years
merge m:1 dhsclust  dhsyear quarter     using "$output/prices.dta"   // Allmatched   
keep if _m == 3
drop _m
*/
*-------------------------------------------------------------------------------
*Merging Grid level Data

*Importing grid ids after creation in qgis 
/* 
*GRID csv converted to dta after QGIS algorithms   - PANEL Structure Given
	*import delimited "$qgis/Final_Grid.csv", clear
	*sort id dhsyear
	*save "$results/Final_Grid.dta", replace
*/

merge 1:1 dhsclust dhsyear quarter  using "$results/Final_Grid.dta" , nogen   //All matched

rename id grid_id
order grid_id
sort grid_id dhsyear dhsclust quarter

drop if grid_id == .			  //The grid_ids where no dhscluster got overlayed  = 1obs
unique grid_id  				 //380 unique ids

***************************Grid level collapse**********************************

*** collapsing at GRID and quarter-year 

collapse (mean) prec prec_rollMean_* temp temp_rollMean_* ///
access_electricity own_radio own_tv own_refrigerator own_bicycle own_scooter own_car own_telephone  ///
HH_head_female	HH_head_age hhsize  ///						
head_* ///  
hh_head_* /// 
RI_Low_w nt_wm_modsevthin nt_wm_sev_anem nt_wm_micro_iron* ///  
stunted_ch wasted_ch underwht_ch 	nt_ch_sev_anem		///  
HH_with_rud_floor_material HH_with_improved_tiolet rural_prop  ///
No_min_diet_diversity_hh  inf_min_breast not_inf_min_breast min_diet_diversity   /// 
new_No_min_diet_diversity_hh nt_mdd min_meal_freq_bf_inf min_meal_freq_bf_child ///
(sum) tot_* No_of_stunt No_of_wast No_of_undw No_of_anemic ///
No_of_lowrohrer_w No_of_lowBMI_w No_of_anem_w *_present_* *_future_* /// 	 									
(median) median_wealth_index_quintile median_wealth_index_score,  ///
by(grid_id dhsyear quarter region rural_urban)         


*duplicates report grid_id dhsyear quarter region    //no repetitions  
*------------------------------------------------------------------------
*------------------------------------------------------------------------
*Descriptive stats table of final variables of interest

*Dummy for employed weomen head
gen dummy_wmhead_unempl = head_un_wm != 0
replace dummy_wmhead_unempl = . if head_un_wm == .
label var dummy_wmhead_unempl  "Dummy for unemployed women head"

* MAX TEMP DUMMY POSITIVE
gen dummy_tmax12_pos =  temp_rollMean_p12 > 0 
gen dummy_tmax9_pos  =  temp_rollMean_p9  > 0
gen dummy_tmax6_pos  =  temp_rollMean_p6  > 0 
gen dummy_tmax3_pos  =  temp_rollMean_p3  > 0 

gen  dummy_rain12_neg =  prec_rollMean_p12  < 0
gen  dummy_rain9_neg  =  prec_rollMean_p9   < 0 
gen  dummy_rain6_neg  =  prec_rollMean_p6   < 0 
gen  dummy_rain3_neg  =  prec_rollMean_p3   < 0 

* For descriptives Table
*Main Vars of interest

glo vars "stunted_ch wasted_ch underwht_ch 	nt_ch_sev_anem	RI_Low_w nt_wm_modsevthin nt_wm_sev_anem nt_wm_micro_iron* No_min_diet_diversity_hh  inf_min_breast not_inf_min_breast min_diet_diversity new_No_min_diet_diversity_hh nt_mdd min_meal_freq_bf_inf min_meal_freq_bf_child rural_prop dummy_wmhead_unempl temp_rollMean* prec_rollMean* dummy_tmax*_pos dummy_rain*_neg"

tabstat $vars, stat(count mean sd max min) columns(statistics) format(%9.2f) 

mat d = J(39, 5, .)

local j = 0
foreach var of varlist $vars{
    
	local ++j
	
	sum `var'
	
	mat d[`j', 1] = r(N)
	mat d[`j', 2] = r(mean)
	mat d[`j', 3] = r(sd)
	mat d[`j', 4] = r(min)
	mat d[`j', 5] = r(max)
}

mat colnames d = "Obs" "Mean" "SD" "Min" "Max" 
*mat rownames d =  "Retail Maize prices (pesos/kg)"  "Violent Conflicts" "Future Violent Conflicts" "Cluster Gini Coeff." "Households Rural Share" "Women head Employed (dummy)" "12-Month Temp anomalies (dummy)" "9-Month Temp anomalies (dummy)" "6-Month Temp anomalies (dummy)" "3-Month Temp anomalies (dummy)" "12-Month Prec anomalies (dummy)" "9-Month Prec anomalies (dummy)" "6-Month Prec anomalies (dummy)" "3-Month Prec anomalies (dummy)"

mat list d

esttab matrix(d, fmt(2 2 2 2 2 ))  ///
using "$results/Descriptive_Table.rtf", replace   ///
addnotes("Source: Author's Calculations") ///
title("TABLE 1. DESCRIPTIVE STATISTICS: MAIN VARIABLES OF INTEREST")

*------------------------------------------------------------------------

*Further dummies (Construct here!)
gen new_dietary_diversity_sum = 0
replace new_dietary_diversity_sum=1 if new_No_min_diet_diversity_hh >= 0.5
replace new_dietary_diversity_sum = . if new_No_min_diet_diversity_hh == .

gen new_dietary_diversity_sum_30 = 0
replace new_dietary_diversity_sum_30=1 if new_No_min_diet_diversity_hh >= 0.3
replace new_dietary_diversity_sum_30 = . if new_No_min_diet_diversity_hh == .


gen new_dietary_diversity_sum_80 = 0
replace new_dietary_diversity_sum_80=1 if new_No_min_diet_diversity_hh >= 0.8
replace new_dietary_diversity_sum_80 = . if new_No_min_diet_diversity_hh == .

*------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Conflict dummies

gen dummy_battles_p = battles_present_number_of_confli >= 1
label var dummy_battles_p "Present battles - dummy"

gen dummy_battles_f = battles_future_number_of_conflic >=1
label var dummy_battles_f "Future battles - dummy"

gen dummy_vac_p = vac_present_number_of_conflicts >= 1
label var dummy_vac_p "Present vac - dummy"

gen dummy_vac_f = vac_future_number_of_conflicts >=1
label var dummy_vac_f "Future vac - dummy"

gen dummy_riots_p = riots_present_number_of_conflict >= 1
label var dummy_riots_p "Present riots - dummy"

gen dummy_riots_f = riots_future_number_of_conflicts >=1
label var dummy_riots_f "Future riots - dummy"


gen dummy_protests_p = protests_present_number_of_confl >= 1
label var dummy_protests_p "Present protests - dummy"

gen dummy_protests_f = protests_future_number_of_confli >=1
label var dummy_protests_f "Future protests - dummy"

*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
compress

*Assiging var labels
*labels_dhs_indicators
*-------------------------------------------------------------------------------

*Final Dataset- Household level
save "$results/FinalDataSet.dta", replace
