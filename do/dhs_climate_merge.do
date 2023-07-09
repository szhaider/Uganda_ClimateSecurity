
use "$output/final_Uganda.dta", clear

keep hhid dhsclust dhsyear  month     

tempfile month_int
save `month_int', replace

use "$output/Final_Climate_anomalies_allyears.dta", clear
drop if temp ==. | prec == .
keep if dhsyear == year        

merge 1:m dhsyear dhsclust month using `month_int'   
//Non-matching months unmatched  , also _m == 2 are those clusters for which GPS coords are (0,0), may check prepared excels; thus so unavailable   //OKAY!

keep if _merge == 3
drop _m

cou    // 2083 obs dropped, against those clusters where GPS were missing in DHS 

tab year if dhsyear == 2000
tab year if dhsyear == 2006
tab year if dhsyear == 2011
tab year if dhsyear == 2016

sum month    // 1 - 12 as in DHS years

* Alot of variation in months across DHS surveys
tab month if dhsyear == 2000
tab month if dhsyear == 2006
tab month if dhsyear == 2011
tab month if dhsyear == 2016


levelsof dhsyear, local(year)
foreach y of local year{
duplicates report hhid dhsclust if dhsyear == `y'    //okay!
}

*Lat-Longs ca repeat 
*duplicates report lat_long if year == 2017
*duplicates report lat_long if year == 2008
*duplicates report  lat_long if year == 2003

merge 1:1  dhsyear  dhsclust  hhid month using "$output/final_Uganda.dta", keep(3) nogen 
// 2083 obs dropped, against those clusters where GPS were missing in DHS      

sort dhsyear dhsclust hhid
order hhid, after(dhsclust)
drop year month day

label var time "time stamp for DHS Household's interview month and respective climate anomalies data for the same month"

destring quarter, replace

save "$results/Final_Uganda_DHS_GEO_CLimate.dta", replace

/*
order lat_long
drop adm1name urban_rura
drop dhsid
drop quarter
drop gps_dataset-surveyid

collapse (max) dhsyear-livestock_ducks  ,by(lat_long)
sort dhsyear dhsclust
*/

