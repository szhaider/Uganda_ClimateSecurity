************************************
************************************
* CONFLICT Data Cleaning - ACLED 
************************************
************************************

*Conflict Raw Data 
*import delimited "$xlsx/Africa_1997-2021_May07_update.csv", clear

*rename ïiso iso

*keep if country == "Uganda"

*save "$output/Uganda_raw_conflicts.dta", replace

use "$output/Uganda_raw_conflicts", clear

* Admin (adjust admin name using DHS or a shape file as reference - so that we have the same names across all the datasets)
// replace adm_1= "Amazonas" if adm_1 == "Amazonas department"
// encode adm_1, gen (adm_1_code)

*Need to adjust admin names with DHS admin names

* Months    
 gen date = date(event_date, "DMY")
 format date %td
 gen month = month(date)
 gen quarter = quarter(date)
 gen day = day(date)
 gen year_check = year(date)

 drop if missing(year)
 
 drop if year_check != year                //Okay


* LOC NAME
gen LOC_NAME = admin1 + "-" + admin2 // Location Name 
encode LOC_NAME, gen (LOC_ID) // Location ID                   

keep LOC_NAME LOC_ID day month quarter year latitude longitude fatalities event_type  actor1 actor2  admin1 admin2 admin3 country

drop if event_type == "Explosions/Remote violence" | event_type == "Strategic developments"  //only 98 obs, too sparse

sort year quarter month LOC_ID LOC_NAME latitude longitude 

order country year quarter month latitude longitude

save "$output/Uganda_conflicts.dta", replace


*Chart for conflicts over years
preserve

collapse (sum) fatalities, by(year event_type)
drop if year == .

graph twoway 	line  fatalities year if event_type == "Battles", xtitle("Years") ytitle(Fatalities) note("Source: ACLED") title("Battles") name("battles", replace) 
graph twoway line  fatalities year if event_type == "Riots", xtitle("Years") ytitle(Fatalities) note("Source: ACLED") title("Riots")  name("riots", replace)
graph twoway line  fatalities year if event_type == "Protests", xtitle("Years") ytitle(Fatalities) note("Source: ACLED") title("Protests")  name("protests", replace)
graph twoway line  fatalities year if event_type == "Violence against civilians", xtitle("Years") ytitle(Fatalities) note("Source: ACLED") title("Violence against civilians")  name("vac", replace)
*graph twoway line  fatalities year if event_type == "Strategic developments", xtitle("Years") ytitle(Fatalities) note("Source: ACLED") title("Strategic developments")  name("sd", replace)

graph combine battles riots protests vac, title("Uganda: Conflicts (over the years)")
graph export "$figures/conflicts.png", replace

restore

*Reshaping wide

encode event_type, gen(event)
gen n = _n
reshape wide longitude latitude , i(year n) j(event) 

rename (latitude1 longitude1 latitude2 longitude2 latitude3 longitude3 latitude4 longitude4) (latitude_b longitude_b latitude_p longitude_p latitude_r longitude_r latitude_v longitude_v)

drop n

preserve
drop if longitude_b ==.
drop latitude_p-longitude_v
save "$output/battles_wide.dta", replace
restore

/*
preserve
drop if longitude_b ==.
drop latitude_p-longitude_v
save "$output/protests_wide.dta"
restore

preserve
drop if longitude_b ==.
drop latitude_p-longitude_v
save "$output/riots_wide.dta"
restore

preserve
drop if longitude_b ==.
drop latitude_p-longitude_v
save "$output/vc_wide.dta"
restore

/*
bysort year: gen n = _n
separate fatalities, by(event_type)
rename (fatalities1 fatalities2 fatalities3 fatalities4) (Battles Protests Riots ViolenceAgainstCivilians  )
collapse Battles Protests Riots ViolenceAgainstCivilians, by(year) 

twoway (scatter  Protests Riots ,  xtitle("Protests") ytitle("Riots") note("Source: Uppsala Conflicts Data Program") title("Uganda: Correlation b/w State-Based and One-Sided Conflicts")) (lfit Protests Riots )
graph export "$figures/conflicts_correlation.png", replace

