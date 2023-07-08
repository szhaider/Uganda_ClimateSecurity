/**************************************************************************************************************************************************************
----------------------------INTRO of the Analysis-------------------------------
Name: 					Master.do
Description: 			Master file for the Uganda DHS data across years. 
						The Master file will call other do files that will excecute the code for various DHS survey datasets preparation and further analyses.  

Purpose:   				To prepare the datasets for final econometric analysis - to be used in combination with geospatial and security datasets.	
						Finally, to employ econometric techniques to estmate the impact of climate change on conflicts, mediated by various socio-economic 	indicators. 

Country:				Uganda	
Time Periods:			Years:  DHS: 2000 + 2006 + 2011 + 2016 

Author: 				Zeeshan Haider
Email: 					szh223@nyu.edu (For any queries)

Collaborators:			Marina Mastrorillo (M.Mastrorillo@cgiar.org ) & Victor Villa (V.Villa@cgiar.org)

Date last modified:		July 7, 2023

****************************************************************************************************************************************************************/

/*
----------------------------General Comments------------------------------------

*/
*-------------------------------------------------------------------------------
*A.1. SETTINGS AND VERSION CONTROL	
	clear all							
	version 16.1 							
	set more off 						
	set linesize 120					
	macro drop all 					
	cls
	pause off
	set maxvar 120000
*-------------------------------------------------------------------------------

*	A.2. Set the user and main paths:  (Plz adjust the paths according to the folder structure and your machine settings)
	
	cap cd "D:\CGIAR\Uganda"
	
	global root "D:\CGIAR\Uganda"
	global rawdata "$root/dhs_raw"     //Not pushed to Github due to large file sizes; User may download raw DHS files   
	global do "$root/do"
	global dta "$root/dta"
	global xlsx "$root/xlsx"
	global logs "$root/log"	
	global output "$root/output"
	global results "$root/results"
	global figures "$root/figures"

*-----------------
	dir "${root}"
	dir "${do}"
	dir "${rawdata}"
	dir "${xlsx}"
	dir "${dta}"
	dir "${output}"
	dir "${results}"	
*-------------------------------------------------------------------------------
*	A.3. Packages used in the project

	local packages 0   //Change to 1 to install packages, once per machine
	if `packages'{
		ssc install 
	}
	
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*--A.4. To select from consistent File Structure for DHS Surveys datasets-------

	global ug2016  "${rawdata}/UG_2016_DHS_06082023_120_182699"
	
	global ug2011  "${rawdata}/UG_2011_DHS_06082023_125_182699"
	
	global ug2006  "${rawdata}/UG_2006_DHS_06082023_127_182699"
	
	global ug2001  "${rawdata}/UG_2000-01_DHS_06082023_128_182699"

	
	* HR Files (Hosehold Data)
	global   hrdata2016     "${ug2016}/UGHR7BDT/UGHR7BFL"
	global   hrdata2011 	"${ug2011}/UGHR61DT/UGHR61FL"
	global   hrdata2006 	"${ug2006}/UGHR52DT/UGHR52FL"
	global   hrdata2001		"${ug2001}/UGHR41DT/UGHR41FL"

	
	* PR Files  (Individual Data)
	global	 prdata2016 	"${ug2016}/UGPR7BDT/UGPR7BFL"
	global	 prdata2011 	"${ug2011}/UGPR61DT/UGPR61FL"
	global	 prdata2006 	"${ug2006}/UGPR52DT/UGPR52FL"
	global	 prdata2001 	"${ug2001}/UGPR41DT/UGPR41FL"

	* IR Files (Eligible Women's Data')
	global	 irdata2016 	"${ug2016}/UGIR7BDT/UGIR7BFL"
	global	 irdata2011 	"${ug2011}/UGIR61DT/UGIR61FL"
	global	 irdata2006 	"${ug2006}/UGIR52DT/UGIR52FL"
	global	 irdata2001 	"${ug2001}/UGIR41DT/UGIR41FL"

	* BR Files (Birth Data)
	global	 brdata2016 	"${ug2016}/UGBR7BDT/UGBR7BFL"
	global	 brdata2011 	"${ug2011}/UGBR61DT/UGBR61FL"
	global	 brdata2006 	"${ug2006}/UGBR52DT/UGBR52FL"
	global	 brdata2001 	"${ug2001}/UGBR41DT/UGBR41FL"

	* KR Files (Children Data: age <=5)
	global	 krdata2016	 	"${ug2016}/UGKR7BDT/UGKR7BFL"
	global	 krdata2011	 	"${ug2011}/UGKR61DT/UGKR61FL"
    global	 krdata2006		"${ug2006}/UGKR52DT/UGKR52FL"
	global	 krdata2001 	"${ug2001}/UGKR41DT/UGKR41FL"

	* MR Files (Mens Data)
	global	 mrdata2016	 	 "${ug2016}/UGMR7BDT/UGMR7BFL"
	global	 mrdata2011	 	 "${ug2011}/UGMR61DT/UGMR61FL"
	global	 mrdata2006		 "${ug2006}/UGMR52DT/UGMR52FL"
	global	 mrdata2001		 "${ug2001}/UGMR41DT/UGMR41FL"
	
	* CR Files (Couple's Data)
	global	 crdata2016 	"${ug2016}/UGCR7BDT/UGCR7BFL"
	global	 crdata2011 	"${ug2011}/UGCR61DT/UGCR61FL"
	global	 crdata2006 	"${ug2006}/UGCR52DT/UGCR52FL"
	global	 crdata2001 	"${ug2001}/UGCR41DT/UGCR41FL"
	
	*Geospatial Data (Cluster level)
	global	 geodata2016 	"${ug2016}/UGGC7BFL/UGGC7BFL"
	global	 geodata2011 	"${ug2011}/UGGC62FL/UGGC62FL"
	global	 geodata2006 	"${ug2006}/UGGC52FL/UGGC52FL"	
	global	 geodata2001 	"${ug2001}/UGGC42FL/UGGC42FL"	
	
*	A.5. Logs for the project

	capture log close
	
	log using "$logs/logfile", replace
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* A.6. General Labels for indicators created in the datasets
	

* A.7. Calling required Do files 

*quietly{
	
	*Check age varibale existence in the survey rounds
	do 		./do/check_age_variable.do
	
*	Labels Assignment to the indicators in resepective survey rounds
	*do 		 ./do/labels_naming.do
	
*	Value labels assignment in resepective survey rounds
	*do 		./do/value_labels_assignment.do	

*	2016 data preparation	

	do 		./do/data_prep_2016.do
	
*	2011 data preparation	
	do 		./do/data_prep_2011.do
	
*	2006 data preparation	
	do 		./do/data_prep_2006.do
	
*	2001 data preparation	
	do 		./do/data_prep_2001.do	
	
*	Combining clean DHS Datasets	
	use "$output/final_2016.dta", clear
	append using "$output/final_2011.dta", force
	append using "$output/final_2006.dta", force
	append using "$output/final_2001.dta", force
	
	qui:compress 
	
	*Can attach the general temperature and precipitation dataset, but refraining for simplicity in the output file
	
    *use "$output/final_phillipines", clear
	*merge m:1 dhsyear dhsclust using "$rawdata/Philippines/PH_precipitation_final_allyears.dta", nogen   //All precipitation data matched
	*merge m:1 dhsyear dhsclust using "$rawdata/Philippines/PH_temperature_final_allyears.dta", nogen   //All temperature data matched
	

	*Final DHS (2016+2011+2006+2001) Dataset	
	qui:compress
	gsort dhsyear dhsclust hhid
	rename hv006 month   //Month of interview and month of child birth (to merge with anomalies dataset)
	save "$output/final_Uganda.dta", replace
	
	*	Cluster level Gini Calculation and addition in the Final Dataset - Based on 0-transformed wealth index 
	*do      ./do/gini_cluster.do	
	

	*Merging Temperature and Precipitation Anomalies datasets (Extracted from .nc files and prepared in R - Using the prepared datasets here)
	*Combined Temperature and precipitation dataset 
	use "$rawdata/Uganda/Uganda_prec_final_anamoly.dta", clear
	merge 1:1 dhsyear dhsclust time adm1name latnum longnum  using "$rawdata/Uganda/Uganda_temp_final_anamoly.dta", nogen //All matched
	drop count
	compress
	*drop if prec == . | temp == .  //18,816 obs dropped in long
	save "$rawdata/Uganda/Final_Climate_anomalies_allyears.dta", replace
	
	
	*Merging DHS+GEO Final dataset with Climate Anomalies datasets (based on the month of interview of household in respective year)
	*do 		./do/dhs_climate_merge.do
	
	
	*Cleaning conflicts data from excel input (UPSALA)
	*do      ./do/Conflict_UCDP.do
	
	
	*This do file prepares Conflict events .csv files for further GIS analysis in QGIS
	*do      ./do/Acled_quarters_qgis.do
	
	
	**Cleaning and preparing WFP Food Prices data for overlay on Household clusters in QGIS
	*do 		./do/wfp_food_prices.do
	
	
	*Final Dataset (DHS + Clmate anomalies + Conflicts + Prices) [Grid level collapse for panel dataset]
	*do 		./do/Final_Dataset.do
	
	/*
	*Restrict age brackets of Household head :  for various analyses - Bring in Phillipines context
	local x = 25
	local y = 55
	local head_age 0    //Change to 1 to restrict household heads' age in regressions and analysis
	if `head_age' {
	 keep if inrange(hv220, `x', `y') 
	}
	
	*	Household level asset index (Land-NA + Livestock-NA + productive capital) (Wealth index is too broad)	
			*/
			
*	
*}
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
/*
	program drop labels_dhs_indicators
	program drop value_labels_aasignment
	program drop check_age_variable
	
	cap erase "$temp/*.dta"
	
	//Dropping for less file size
	cap erase "$output/final_2003.dta"
	cap erase "$output/final_2008.dta"
	cap erase "$output/final_2017.dta"
	cap erase "$dta/food_2003.dta"
	cap erase "$dta/food_2008.dta"
	cap erase "$dta/food_2017.dta"
    cap rm "$dta/HH_counts_2003.dta"
	cap rm "$dta/HH_counts_2008.dta"
    cap rm "$dta/HH_counts_2017.dta"
	cap rm "$dta/HHmen_2003.dta"
	cap rm "$dta/HHmen_2008.dta"
	cap rm "$dta/HHmen_2017.dta"
	cap rm "$dta/HHwomen_2003.dta"
	cap rm "$dta/HHwomen_2008.dta"
	cap rm "$dta/HHwomen_2017.dta"
	cap rm "$dta/NEW_1_food_2003.dta"
	cap rm "$dta/NEW_1_food_2008.dta"
	cap rm "$dta/NEW_1_food_2017.dta"

	log close
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
