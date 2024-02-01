
*Final Dataset (DHS + Clmate anomalies + Conflicts + Prices)

*DHS + Geo + Climate Dataset + Prices + Grid - All Years  [For prices: 2000 drppoed since WFP prices data begins by 2006 & only maize covers all years from 2006]

*DROP Prices if choose to include DHS 2000



*NOTE: After discussion with the team, inlcude DHS 2000 if stunting finalized as mediator. Only re-run for Battles and Riots for final report tables.






*merged DHS household and climate dataset at household level
use "results/Final_Uganda_DHS_GEO_CLimate.dta", clear

order dhsclust longnum latnum dhsyear quarter 
*-------------------------------------------------------------------------------

gen HH_head_female = hv219  == 2    // Proportion of female headed households

gen rural_prop = type_place == 2   // Proportion of rural households


*Dummy for employed weomen head
gen share_wmhead_unempl = head_un_wm != 0
replace share_wmhead_unempl = . if head_un_wm == .
label var share_wmhead_unempl  "Share for unemployed women head"


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


*Proprotion of ag employed hhds

rename     hv244     agri_land_hhds
*replace agri_land_hhds = 0 if agri_land_hhds == 9   // miscoded


* MAX TEMP DUMMY POSITIVE
gen share_tmax12_pos =  temp_rollMean_p12 > 0 
gen share_tmax9_pos  =  temp_rollMean_p9  > 0
gen share_tmax6_pos  =  temp_rollMean_p6  > 0 
gen share_tmax3_pos  =  temp_rollMean_p3  > 0 

gen  share_rain12_neg =  prec_rollMean_p12  < 0
gen  share_rain9_neg  =  prec_rollMean_p9   < 0 
gen  share_rain6_neg  =  prec_rollMean_p6   < 0 
gen  share_rain3_neg  =  prec_rollMean_p3   < 0 

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

collapse (mean) prec prec_rollMean_* temp temp_rollMean_* share_tmax* share_rain* ///
access_electricity=hv206 own_radio=hv207 own_tv=hv208 own_refrigerator=hv209 own_bicycle=hv210 own_scooter=hv211 own_car=hv212 own_telephone= hv221  ///
HH_head_female	HH_head_age= hv220 hhsize = hv009 ///	
pov_hd_bot_20 pov_hd_bot_40  gini wealth_index_score /// Poverty (Bottom 20 & 40 percent) & Inequlaity	
share_wmhead_unempl ///				
head_* ///  //Household Head characteristics (Ocuupation (women + men), Education (women + men), )
hh_head_* agri_land_hhds /// Household head education (no, prim, sec, higher)
RI_Low_w nt_wm_modsevthin nt_wm_sev_anem nt_wm_micro_iron* /// women BMI, Rohrer's index (low/very low), Severe/Moderate Anemia-women, 
stunted_ch wasted_ch underwht_ch 	nt_ch_sev_anem		///   Stunt, Wast, Underw, Moderate/severe Anemia
HH_with_rud_floor_material HH_with_improved_tiolet rural_prop  ///
No_min_diet_diversity_hh  inf_min_breast not_inf_min_breast min_diet_diversity   /// children diet and food nutrition No_min_meal_freq_hh Meal_freq_hh
new_No_min_diet_diversity_hh nt_mdd min_meal_freq_bf_inf min_meal_freq_bf_child /// children diet and food nutrition
new_dietary_diversity_* ///
(sum) hhsum tot_* No_of_stunt=stunting_c_hh No_of_wast=wasted_c_hh No_of_undw=underwht_ch_hh No_of_anemic=anemia_ch_hh ///
No_of_lowrohrer_w=tot_RI_Low_w No_of_lowBMI_w=DHS_tot_BMI_low_w No_of_anem_w=sev_mod_anemia_hh /// number of stunted, wasted, underweight , low rohrer women, 	low BMI women										
(median) median_wealth_index_quintile=wealth_index median_wealth_index_score=wealth_index_score  ///
[pw=wgt], by (dhsyear quarter  dhsclust latnum longnum region)  // no. of regions goes down back in early years 

sort dhsyear dhsclust
*-------------------------------------------------------------------------------
*Final Conflicts Data - all years
merge 1:1 dhsyear dhsclust quarter using "$results/final_conflicts_DHS_Uganda.dta", nogen  // All matched



*Final Prices Data - All years
merge m:1  dhsyear quarter    dhsclust   using "$output/prices.dta"   // Unmatched belong to 2000, which will be dropped sice we don't have prices for 2000 in WFP data 
keep if _m == 3
drop _m

*-------------------------------------------------------------------------------
*Conflict dummies

gen share_battles_p = battles_present_number_of_confli >= 1
label var share_battles_p "Present battles - dummy"

gen share_battles_f = battles_future_number_of_conflic >=1
label var share_battles_f "Future battles - dummy"

gen share_vac_p = vac_present_number_of_conflicts >= 1
label var share_vac_p "Present vac - dummy"

gen share_vac_f = vac_future_number_of_conflicts >=1
label var share_vac_f "Future vac - dummy"

gen share_riots_p = riots_present_number_of_conflict >= 1
label var share_riots_p "Present riots - dummy"

gen share_riots_f = riots_future_number_of_conflicts >=1
label var share_riots_f "Future riots - dummy"


gen share_protests_p = protests_present_number_of_confl >= 1
label var share_protests_p "Present protests - dummy"

gen share_protests_f = protests_future_number_of_confli >=1
label var share_protests_f "Future protests - dummy"

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Merging Grid level Data

*Importing grid ids after creation in qgis (Now saving new file Final_Grid_New)
/*
*GRID csv converted to dta after QGIS algorithms   - PANEL Structure Given
	import delimited "$qgis/Final_Grid_New.csv", clear
	sort id dhsyear
	save "$results/Final_Grid_New.dta", replace
*/

*merge 1:1 dhsclust dhsyear quarter  using "$results/Final_Grid.dta" , keep(3) nogen   //All matched  (275 unmatched for dhsyear 2000 since it is dropped with prices)

*Using new grid based on new shapefile of Uganda wiht 4 admin1. Previously I was using older version (02/01/24). New grid ids are dif because of new shape file so just updating. All matched since no 2000
merge 1:1 dhsclust dhsyear quarter  using "$results/Final_Grid_New.dta" , keep(3) nogen

rename id grid_id
order grid_id
sort grid_id dhsyear dhsclust quarter

drop if grid_id == .			  //The grid_ids where no dhscluster got overlayed  = 1obs
unique grid_id  				 //380 unique ids  , New 369 uniques IDS

************************
*Drop Region and Subregion, since these are not consistent in DHS rounds across years. We have made our own region variable with GIS techniques

* i.e. We overlayed the admin 1 shape file. Then we created a Grid and clipped it. Then we estimated the centroids of each clipped grid.
* Finally we matched the Admin 1 polygons with centroids of the Clipped grid with the QGIS algorithm i.e. Jion attributes by location.

* We save the final file in the respective foder to bring in our own region variable, 
* which is Mapping each Grid id to respective region as given in shapefile (admin1)
* This mapping is consistent across years to control for region F.E.s in the regressions (to account for unobservables) 
*Importing grid ids after creation in qgis (Now saving new file Final_Grid_New)

/*
*Region New csv converted to dta after QGIS algorithms   
	import delimited "$qgis/RegionAdmin1_New.csv", clear
	sort id 
	rename id grid_id
	keep grid_id adm1_en
	save "$results/RegionAdmin1_New.dta", replace
*/

*drop region //To bring in our adm1_en variable
merge m:1 grid_id using "$results/RegionAdmin1_New.dta", keep(3) nogen

order adm1_en, after(dhsclust)


***************************Grid level collapse**********************************

*** collapsing at GRID and quarter-year 

collapse (mean) prec prec_rollMean_* temp temp_rollMean_* ///
access_electricity own_radio own_tv own_refrigerator own_bicycle own_scooter own_car own_telephone  ///
HH_head_female	HH_head_age hhsize  ///				
pov_hd_bot_20 pov_hd_bot_40  gini wealth_index_score ///	
 share_* ///	
head_* ///  
hh_head_* agri_land_hhds /// 
RI_Low_w nt_wm_modsevthin nt_wm_sev_anem nt_wm_micro_iron* ///  
stunted_ch wasted_ch underwht_ch 	nt_ch_sev_anem		///  
HH_with_rud_floor_material HH_with_improved_tiolet rural_prop  ///
No_min_diet_diversity_hh  inf_min_breast not_inf_min_breast min_diet_diversity   /// 
new_No_min_diet_diversity_hh nt_mdd min_meal_freq_bf_inf min_meal_freq_bf_child ///
maize_uga maize_usd /// maize prices 
(sum) hhsum tot_* No_of_stunt No_of_wast No_of_undw No_of_anemic ///
No_of_lowrohrer_w No_of_lowBMI_w No_of_anem_w *_present_* *_future_* /// 	 									
(median) median_wealth_index_quintile median_wealth_index_score  ///
(firstnm) adm1_en, ///
by(grid_id dhsyear quarter region)         //rural_urban

order adm1_en, after(quarter)

*duplicates report grid_id dhsyear quarter region    //no repetitions  
*------------------------------------------------------------------------
*------------------------------------------------------------------------
*Descriptive stats table of final variables of interest


* For descriptives Table
*Main Vars of interest
/*
glo vars "rural_prop agri_land_hhds hh_head_primary  share_wmhead_unempl stunted_ch maize_uga battles_present_number_of_confli battles_future_number_of_conflic temp_rollMean* prec_rollMean*" 

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
mat rownames d = "Share of Rural Households" "Share of HHDs with Agri Land" "Share of Primary Educated Heads" "Share of Women Heads Unemployed" "Share of Stunted Children" "Wholesale Maize prices (UGX/kg)" "Present No. of Conflicts (Battles)" "Future No. of Conflicts (Battles)" "3-Month Temp anomalies" "6-Month Temp anomalies" "9-Month Temp anomalies" "12-Month Temp anomalies" "3-Month Rainfall anomalies" "6-Month Rainfall anomalies" "9-Month Rainfall anomalies" "12-Month Rainfall anomalies"

mat list d

esttab matrix(d, fmt(2 2 2 2 2 ))  ///
using "$results/Descriptive_Table.rtf", replace   ///
addnotes("Source: Author's Calculations") ///
title("DESCRIPTIVE STATISTICS: MAIN VARIABLES OF INTEREST")
*/

*-------------------------------------------------------------------------------
compress

*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------

*Final Dataset- Household level
save "$results/FinalDataSet.dta", replace
