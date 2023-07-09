
*Final Dataset (DHS + Clmate anomalies + Conflicts + Prices)

*DHS + Geo + Climate Dataset - All Years
*merged DHS household and climate dataset at household level
use "results/Final_Uganda_DHS_GEO_CLimate.dta", clear

order dhsclust longnum latnum dhsyear quarter 
*-------------------------------------------------------------------------------
*gen urban_rural = type_place == 1
gen HH_head_female = hv219  == 2

gen rural_prop = type_place == 2   //1 if rural


gen HH_with_rud_floor_material = inrange(hv213, 11, 22) 

/*
Region Label (F.Es)
Definition
           1   national capital region
           2   cordillera admin region
           3   i - ilocos
           4   ii - cagayan valley
           5   iii - central luzon
           6   iva - calabarzon
           7   ivb - mimaropa
           8   v - bicol
           9   vi - western visayas
          10   vii - central visayas
          11   viii - eastern visayas
          12   ix - zamboanga peninsula
          13   x - northern mindanao
          14   xi - davao
          15   xii - soccsksargen
          16   xiii - caraga
          17   armm

   Variables:  region

*/

rename  type_place rural_urban
*-------------------------------------------------------------------------------

collapse (mean) prec prec_rollMean_* temp temp_rollMean_* ///
access_electricity=hv206 own_radio=hv207 own_tv=hv208 own_refrigerator=hv209 own_bicycle=hv210 own_scooter=hv211 own_car=hv212 own_telephone= hv221 ///
HH_head_female	HH_head_age= hv220 hhsize = hv009 ///									//1 female 0 male	
head_* ///  //Household Head characteristics
hh_head_* ///
relg_* ///   //Religion of Head 
child_size_small_at_birth ///
No_min_diet_diversity_hh No_min_meal_freq_hh  only_breast_feeding_hh ///
new_No_min_diet_diversity_hh new_No_min_meal_freq_hh new_No_min_acc_diet_hh min_meal_freq_bf_inf min_meal_freq_bf_child ///	
HH_with_rud_floor_material rural_prop  ///
gini ///
infant_mortality ///
(sum) tot_*  ///													
(median) median_wealth_index_quintile=wealth_index median_wealth_index_score=wealth_index_score  ///
[pw=wgt], by (dhsyear quarter  dhsclust latnum longnum region )    //rural_urban

*rural_urban=type_place 	///													//1 Urban, 2 Rural

sort dhsyear dhsclust
*-------------------------------------------------------------------------------
*Final COnflicts Data - all years
merge 1:1 dhsclust dhsyear quarter using "$output/final_conflicts.dta"  // All matched 
keep if _m == 3
drop _m

*Final Prices Data - All years
merge m:1 dhsclust  dhsyear quarter     using "$output/prices.dta"   // Allmatched   
keep if _m == 3
drop _m
*-------------------------------------------------------------------------------
*Merging Grid level Data

*Importing grid ids after creation in qgis 
/* 
import delimited "$xlsx/gis_grid/Final_Grid.csv", clear
save "$output/Final_Grid.dta", replace
*/
merge 1:1 dhsclust dhsyear quarter  using "$output/Final_Grid.dta"
keep if _m == 3
drop _m

*Few grid_ids are missing (90) for which DHS cluster points not falling into any grids -  due to added noise in the GPS coords of the HHDs

rename id grid_id
order grid_id
sort grid_id dhsyear dhsclust quarter

drop if grid_id == .			  //The grid_ids where no dhscluster got overlayed
unique grid_id  				 //646 ids

*sort dhsyear quarter dhsclust
***************************Grid level collapse**********************************
*** collapsing at GRID and quarter-year 
collapse (mean) prec prec_rollMean_* temp temp_rollMean_* ///
all_population_count_2005-wet_days_2015  ///
access_electricity own_radio own_tv  own_refrigerator own_bicycle own_scooter own_car own_telephone ///
HH_head_female	HH_head_age hhsize  ///									//1 female 0 male	
head_* ///  //Household Head characteristics
hh_head_* ///
relg_* ///   //Religion of Head 
child_size_small_at_birth ///
No_min_diet_diversity_hh No_min_meal_freq_hh  only_breast_feeding_hh ///
new_No_min_diet_diversity_hh new_No_min_meal_freq_hh new_No_min_acc_diet_hh min_meal_freq_bf_inf min_meal_freq_bf_child ///	
HH_with_rud_floor_material rural_prop    ///
gini ///
infant_mortality ///
maize rice rice_usd fish fish_usd onions onions_usd irishpotatoes irishpotatoes_usd tomatoes tomatoes_usd cabbage cabbage_usd carrots carrots_usd meat*  /// foodprices (nned to make country specific choices)  
(sum) tot_*  ///	
sbv sbv_*  osv osv_*  ///    conflicts												
(median) median_wealth_index_quintile median_wealth_index_score,  /// 
by (grid_id dhsyear quarter region )    //rural_urban       

*rural_urban 	///													//1 Urban, 2 Rural

duplicates report grid_id dhsyear quarter region    //no repetitions  //rural_urban
*------------------------------------------------------------------------
*------------------------------------------------------------------------
*Descriptive stats table of final variables of interest

*Dummy for employed weomen head
gen dummy_wmhead_empl = head_un_wm == 0
replace dummy_wmhead_empl = . if head_un_wm == .
label var dummy_wmhead_empl  "Dummy for employed women head"

* MAX TEMP DUMMY POSITIVE
gen dummy_tmax12_pos =  temp_rollMean_p12 > 0 
gen dummy_tmax9_pos  =  temp_rollMean_p9  > 0
gen dummy_tmax6_pos  =  temp_rollMean_p6  > 0 
gen dummy_tmax3_pos  =  temp_rollMean_p3  > 0 

gen  dummy_rain12_neg =  prec_rollMean_p12  < 0
gen  dummy_rain9_neg  =  prec_rollMean_p9   < 0 
gen  dummy_rain6_neg  =  prec_rollMean_p6   < 0 
gen  dummy_rain3_neg  =  prec_rollMean_p3   < 0 


*Main Vars of interest

//rice  sbv sbv_fut    These vars taken out
*glo vars "maize osv osv_fut gini rural_prop temp_rollMean_* prec_rollMean_*"

glo vars "maize osv osv_fut gini rural_prop dummy_wmhead_empl  dummy_tmax*_pos dummy_rain*_neg"

tabstat $vars, stat(count mean sd max min) columns(statistics) format(%9.2f) 

mat d = J(16, 5, .)

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
mat rownames d =  "Retail Maize prices (pesos/kg)"  "Violent Conflicts" "Future Violent Conflicts" "Cluster Gini Coeff." "Households Rural Share" "Women head Employed (dummy)" "12-Month Temp anomalies (dummy)" "9-Month Temp anomalies (dummy)" "6-Month Temp anomalies (dummy)" "3-Month Temp anomalies (dummy)" "12-Month Prec anomalies (dummy)" "9-Month Prec anomalies (dummy)" "6-Month Prec anomalies (dummy)" "3-Month Prec anomalies (dummy)"

*mat rownames d =  "Retail Maize prices (pesos/kg)"  "One sided Violent Conflicts" "Future  Violent Conflicts" "Gini Coeff." "Households Rural Share" "Women head Employed (dummy)" "Temp anomalies (3 months)" "Temp anomalies (6 months)" "Temp anomalies (9 months)" "Temp anomalies (12 months)" "Prec anomalies (3 months)" "Prec anomalies (6 months)" "Prec anomalies (9 months)" "Prec anomalies (12 months)"
//"Retail Rice prices (pesos/kg)" "State Based  Conflicts" "Future State Based Conflicts"
mat list d

esttab matrix(d, fmt(2 2 2 2 2 ))  ///
using "$results/Descriptive_Table.rtf", replace   ///
addnotes("Author's Calculations") ///
title("TABLE 1. DESCRIPTIVE STATISTICS: MAIN VARIABLES OF INTEREST")

*------------------------------------------------------------------------
*------------------------------------------------------------------------

*Lookup 15446 in 2008   !!!!!!!!!!!!!!!!!!!!   Need to discuss 
*We need to take rural_urban out in by(), otherwise we cant have indicators at grid level. Since same grid has rural and urban cluster overlaid.which results in non-integer values for rural urban


*Still need to check - this  might cause issues in declaring dataets as panel
*------------------------------------------------------------------------

*new_dietary_diversity_sum new_dietary_diversity_sum_30 new_dietary_diversity_sum_80 ///
*new_min_acc_diet_sum new_min_acc_diet_sum_30 new_min_acc_diet_sum_80  ///
*new_child_size_small_at_birth new_child_size_small_at_birth_30 new_child_size_small_at_birth_80  ///

*------------------------------------------------------------------------
*Dunmmies for wealth inequality 
gen gini_20 = gini >= 0.2
gen gini_25 = gini >= 0.25
gen gini_30 = gini >= 0.3

label var gini_20 "Gini > 0.20"
label var gini_25 "Gini > 0.25"
label var gini_30 "Gini > 0.30"

*------------------------------------------------------------------------
*Further dummies
gen new_dietary_diversity_sum = 0
replace new_dietary_diversity_sum=1 if new_No_min_diet_diversity_hh >= 0.5
replace new_dietary_diversity_sum = . if new_No_min_diet_diversity_hh == .

gen new_dietary_diversity_sum_30 = 0
replace new_dietary_diversity_sum_30=1 if new_No_min_diet_diversity_hh >= 0.3
replace new_dietary_diversity_sum_30 = . if new_No_min_diet_diversity_hh == .


gen new_dietary_diversity_sum_80 = 0
replace new_dietary_diversity_sum_80=1 if new_No_min_diet_diversity_hh >= 0.8
replace new_dietary_diversity_sum_80 = . if new_No_min_diet_diversity_hh == .


gen new_min_acc_diet_sum = 0
replace new_min_acc_diet_sum=1 if new_No_min_acc_diet_hh >= 0.5
replace new_min_acc_diet_sum = . if new_No_min_acc_diet_hh == .

gen new_min_acc_diet_sum_30 = 0
replace new_min_acc_diet_sum_30=1 if new_No_min_acc_diet_hh >= 0.3
replace new_min_acc_diet_sum_30 = . if new_No_min_acc_diet_hh == .


gen new_min_acc_diet_sum_80 = 0
replace new_min_acc_diet_sum_80=1 if new_No_min_acc_diet_hh >= 0.8
replace new_min_acc_diet_sum_80 = . if new_No_min_acc_diet_hh == .


gen new_child_size_small_at_birth = 0
replace new_child_size_small_at_birth = 1 if child_size_small_at_birth >=0.5
replace new_child_size_small_at_birth = . if child_size_small_at_birth == .

gen new_child_size_small_at_birth_30 = 0
replace new_child_size_small_at_birth_30 = 1 if child_size_small_at_birth >=0.3
replace new_child_size_small_at_birth_30 = . if child_size_small_at_birth == .

gen new_child_size_small_at_birth_80 = 0
replace new_child_size_small_at_birth_80 = 1 if child_size_small_at_birth >=0.8
replace new_child_size_small_at_birth_80 = . if child_size_small_at_birth == .

label var new_child_size_small_at_birth "child_size_small_at_birth >50%"
label var new_child_size_small_at_birth_30 "child_size_small_at_birth >=30%"
label var new_child_size_small_at_birth_80 "child_size_small_at_birth >=80%"

*------------------------------------------------------------------------
*How to generate ethni deiversity variable
*gen ethnic_diversity egen ethnic_diversity = rowtotal(head_wolof_etn head_ss_etn head_serer_etn head_poular_etn head_other_etn head_nonseg_etn head_msm_etn head_diola_etn)
*-------------------------------------------------------------------------------
*Conflict dummies

gen dummy_sbv = sbv >= 1
label var dummy_sbv "Present State based voilnece incidence- dummy"

gen dummy_sbvfut = sbv_fut >=1
label var dummy_sbvfut "Future State based voilnece incidence- dummy"

gen dummy_osv = osv >= 1
label var dummy_osv "Present One sided voilnece incidence- dummy"

gen dummy_osvfut = osv_fut >= 1
label var dummy_osvfut "Future One sided voilnece incidence- dummy"
*-------------------------------------------------------------------------------
/*
*Addtional dummies
*Dummy for employed weomen head
gen dummy_wmhead_empl = head_un_wm == 0
replace dummy_wmhead_empl = . if head_un_wm == .
label var dummy_wmhead_empl  "Dummy for employed women head"
*/
*-------------------------------------------------------------------------------
compress

*Assiging var labels
*labels_dhs_indicators
*-------------------------------------------------------------------------------

*Final Dataset- Household level
save "$results/FinalDataSet.dta", replace
