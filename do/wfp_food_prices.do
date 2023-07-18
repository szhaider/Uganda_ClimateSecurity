
*******************************WFP Food Prices**********************************
********************************************************************************
/*

Year 2000 is missing in Uganda Prices data.
If Retail kept, 2006 will be lost.
So keeping Whoesale and retail both
But most likely use Wholesale to keep 3 years rounds (2006 + 2011 + 2016)
Using Maize Wholesale Prices (Uganda Currency)
*/

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

tab  year pricetype  //If Retail kept, 2006 will be lost

gen n = _n
reshape wide price usdprice, i(date admin1 admin2 market latitude longitude n) j(pricetype) s

*Keeping only retail prices
*keep if pricetype == "Retail"    //1,297 obs wholesale

drop category date date_1 currency n priceflag 		//unit pricetype

destring *price* price*, replace

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

collapse priceRetail usdpriceRetail priceWholesale usdpriceWholesale, by(commodity  LOC_NAME latitude longitude year quarter)

encode commodity, gen(commodity_1)
drop commodity

*keeping  58   Rice (regular, milled) - since available from 2000-2020
*keeping maize flour white (38) - since available from 2000-2020

drop if inlist(commodity_1, 2, 3, 6 ,7, 11, 22, 23, 24, 25, 26, 27, 28, 29, 31, ///
 32, 36,37, 39, 42, 44, 47, 48, 49, 52, 56, 57, 59, 60, 61, 63, 65, 67, 69)

*Important Crops in Uganda:   corn,  millet, sorghum. 
 
keep if commodity_1 == 15 | commodity_1 == 16 | commodity_1 == 17 | commodity_1 == 19 | commodity_1 == 20 | commodity_1 == 30 | commodity_1 == 35   // Maize  rice + Sorghum
 
sort year quarter commodity_1
 
tab year commodity_1, m   //2010 onwards with Maize flour)
/*
Will use Maize > Rice > maize flour > Sorghum 
           |                                 commodity_1
      year |     Maize  Maize (wh  Maize flo     Millet  Millet fl       Rice    Sorghum |     Total
-----------+-----------------------------------------------------------------------------+----------
      2006 |        11          0          0          0          0          4          0 |        15 
      2007 |         7          0          0          0          0          4          0 |        11 
      2008 |         9          0          0          0          0          4          0 |        13 
      2009 |         8          0          0          0          0          3          0 |        11 
      2010 |         9          0         30          0          0          4          0 |        43 
      2011 |        10         23         31         22          0          4         22 |       112 
      2012 |        11         28         27         28          0          4         28 |       126 
      2013 |        12         31         31         31          0          4         30 |       139 
      2014 |        12         31         30         29          0          4         30 |       136 
      2015 |        12         23         23         23          0          4         23 |       108 
      2016 |        12         23         22         23          0          4         22 |       106 
      2017 |        11         24         23         24          0          4         23 |       109 
      2018 |        11         23         24         22          0          3         24 |       107 
      2019 |        14         46         46         40          0          4         47 |       197 
      2020 |        14         68         65         23         10          4         63 |       247 
      2021 |        16        107        109         35         52          4        101 |       424 
      2022 |        15        149        151         86         52          4        142 |       599 
      2023 |         0        141        139         71         50          0        128 |       529 
-----------+-----------------------------------------------------------------------------+----------
     Total |       194        717        751        457        164         66        683 |     3,032 



If we use Rice, we will be assigning prices of 1 market/Quarter to whole Uganda for all years

Almost 4 markets with Maize (While keeping 2006 intact)	 

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
 
reshape wide priceRetail usdpriceRetail priceWholesale usdpriceWholesale, i(latitude longitude year quarter) j(commodity_1)

sort year quarter

drop priceRetail16-usdpriceWholesale35  
drop priceRetail15 usdpriceRetail15

rename (usdprice* ) (maize_usd)   
rename (price* )    (maize_uga)   

*Since 2006 HHds are interviewed in quarter 2,3 and 4
export delimited using "$xlsx/Prices_Data/Prices_quarter2_2006.csv" if year==2006 & quarter==2, replace
export delimited using "$xlsx/Prices_Data/Prices_quarter3_2006.csv" if year==2006 & quarter==3, replace
export delimited using "$xlsx/Prices_Data/Prices_quarter4_2006.csv" if year==2006 & quarter==4, replace

*Since 2011 HHds are interviewed in quarter 2 & 3, 4
export delimited using "$xlsx/Prices_Data/Prices_quarter2_2011.csv" if year==2011 & quarter==2, replace
export delimited using "$xlsx/Prices_Data/Prices_quarter3_2011.csv" if year==2011 & quarter==3, replace
export delimited using "$xlsx/Prices_Data/Prices_quarter4_2011.csv" if year==2011 & quarter==4, replace

*Since 2016 HHds are interviewed in quarter 3 & 4
export delimited using "$xlsx/Prices_Data/Prices_quarter2_2016.csv" if year==2016 & quarter==2, replace
export delimited using "$xlsx/Prices_Data/Prices_quarter3_2016.csv" if year==2016 & quarter==3, replace
export delimited using "$xlsx/Prices_Data/Prices_quarter4_2016.csv" if year==2016 & quarter==4, replace


/*
*Post QGIS analytics Datasset (To be merged with final datasets)  Combined dataset prepared after joing attributes by the nearest alogortihm in QGIS

import delimited "$xlsx/prices/Final_prices_allyears_allquarters.csv", clear
drop n year_2 quarter_2 latitude longitude   //Dropping latitude and longitude of markets, since spatial jion to DHS clusters has been made already
rename year dhsyear
sort dhsyear dhsclust quarter

save "$output/prices.dta", replace