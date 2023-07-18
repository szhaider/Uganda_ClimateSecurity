
*******************************WFP Food Prices**********************************
********************************************************************************
********************************************************************************

*Cleaning and preparing WFP Food Prices data for overlay on Household clusters in QGIS  

import delimited "$xlsx/Prices_Data/wfp_food_prices_uga.csv", varnames(1) clear 

drop if _n == 1   

// Generate the date (DMY)
gen date_1 = date(date, "YMD")
format date_1 %td // format

// Generate the month
gen year= year(date_1)
gen month = month(date_1)
gen quarter = quarter(date_1)
sort admin1 admin2 month year

*Location ID
gen LOC_NAME = admin1 + "-" + admin2 
label var LOC_NAME "Location Name (admin1 & admin2)"
encode LOC_NAME, generate(LOC_ID)
codebook LOC_ID

*gen retail_price_local = price if pricetype=="Retail"
*gen retail_price_usd = usdprice if pricetype=="Retail"
*gen wholesale_price_local = price if pricetype=="Wholesale"
*gen wholesale_price_usd = usdprice if pricetype=="Wholesale"

/*
    pricetype |      Freq.     Percent        Cum.
-----------------+-----------------------------------
          Retail |     18,004       93.28       93.28
       Wholesale |      1,297        6.72      100.00
-----------------+-----------------------------------
           Total |     19,301      100.00
*/

*Keeping only retail prices
keep if pricetype == "Retail"    //1,297 obs wholesale

drop category date date_1 currency pricetype priceflag 		//unit

destring price usdprice, replace

/*
    unit |      Freq.     Percent        Cum.
------------+-----------------------------------
         KG |     13,919       77.31       77.31
          L |      2,053       11.40       88.71
     Packet |        224        1.24       89.96
       Pair |         96        0.53       90.49
       Unit |      1,712        9.51      100.00
------------+-----------------------------------
      Total |     18,004      100.00

*/

collapse price usdprice, by(commodity  LOC_NAME latitude longitude year quarter)

encode commodity, gen(commodity_1)
drop commodity

*keeping  58   Rice (regular, milled) - since available from 2000-2020
*keeping maize flour white (38) - since available from 2000-2020

drop if inlist(commodity_1, 2, 3, 6 ,7, 11, 20, 22, 23, 24, 25, 26, 27, 28, 29, 31, ///
 32, 35, 36,37, 39, 42, 44, 47, 48, 49, 52, 56, 57, 59, 60, 61, 63, 65, 67, 69)

keep if commodity_1 == 16 | commodity_1 == 17 
 
tab  commodity_1, m
/*
  commodity_1 |      Freq.     Percent        Cum.
-------------------------+-----------------------------------
           Maize (white) |        717       48.84       48.84
             Maize flour |        751       51.16      100.00
-------------------------+-----------------------------------
                   Total |      1,468      100.00

*/


/*
*Long term market average for each commodity - normalization
	egen panel = group(latitude longitude)
	drop if panel == .
	
	egen mean_price = mean(price) , by(commodity  panel)   
	egen sd_price = sd(price), by(commodity  panel)

*Some Sds are . since 1 obs in each quarter that year

gen normalized_price = (price - mean_price) / sd_price   //accounts for units diff in commodities

collapse normalized_price , by (commodity  LOC_NAME latitude longitude year quarter)
*/
 
reshape wide price usdprice, i(latitude longitude year quarter) j(commodity_1)


rename (usdprice* ) (maize_usd maizefloor_usd)   
rename (price* )    (maize_uga maizefloor_uga)   
/*
*Since 2008 HHds are interviewed in quarter 3
export delimited using "$xlsx/prices/Price_quarter3_2008.csv" if year==2008 & quarter==3, replace

*Since 2008 HHds are interviewed in quarter 2 & 3
export delimited using "$xlsx/prices/Price_quarter2_2003.csv" if year==2003 & quarter==2, replace
export delimited using "$xlsx/prices/Price_quarter3_2003.csv" if year==2003 & quarter==3, replace

*Since 2017 HHds are interviewed in quarter 3 & 4
export delimited using "$xlsx/prices/Price_quarter3_2017.csv" if year==2017 & quarter==3, replace
export delimited using "$xlsx/prices/Price_quarter4_2017.csv" if year==2017 & quarter==4, replace


*Post QGIS analytics Datasset (To be merged with final datasets)  Combined dataset prepared after joing attributes by the nearest alogortihm in QGIS

import delimited "$xlsx/prices/Final_prices_allyears_allquarters.csv", clear
drop n year_2 quarter_2 latitude longitude   //Dropping latitude and longitude of markets, since spatial jion to DHS clusters has been made already
rename year dhsyear
sort dhsyear dhsclust quarter

save "$output/prices.dta", replace