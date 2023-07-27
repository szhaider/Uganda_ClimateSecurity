/**************************************************************************************************************************************************************
----------------------------Data Prep 2016--------------------------------------

Name: 					data_prep_2016.do
Description: 			This file processes 2016 DHS for Uganda & prepares the clean/tidy dataset 
Time Period:			Years = 2016 (GPS data available for 2016)	
Date last modified:		July 08, 2023


Notes:
1. use v101, v102 for region, rural/urban FEs
2. WE have BMI v445, Rohrer's index v446 , height/age v440, weight/height v444a, anemia level v457
3. Religion v130,  ethnicity v131 (May be include later if needed)
4.

***********************************************************************************************************************************************************/

*Elegible Women Dataset - IR

use "${irdata2016}.dta", clear

keep caseid v000 v001 v002 v003 v004 v005 v006 v007 v008 v008a v042 v455 v457 v208 m45_1 m46_1 v213 b3_01 v012 v024 v025 v101 v102 v106 v107 v133 v131 v716 v717 v714 v705 v719 v440 v444a v445 v446 v439 v150 v151 v152 v501 v130 v131 m18_* m19_* v171a v190

sort v001 v002 v003

tostring v001 v002,g (v001s v002s)
g hhid=v001s+v002s
replace hhid =v001s+"0"+v002s if v002<10
order hhid
destring hhid, replace
drop v001s v002s v000
rename caseid hhid_dhs

* Number of women in the HH
bysort hhid: g n=_n
bysort hhid: egen tot_wmen=max(n)
sum tot_w
lab var tot_wm "Number of women in the HH"
drop n 


* Employment in agriculture
tab v717, g(occ)
bysort hhid: egen tot_wmen_un=sum(occ1) 
bysort hhid: egen tot_wmen_prof=sum(occ2)
bysort hhid: egen tot_wmen_cler=sum(occ3)
bysort hhid: egen tot_wmen_sales=sum(occ4)
bysort hhid: egen tot_wmen_agri=sum(occ5)
bysort hhid: egen tot_wmen_domes=sum(occ6)
bysort hhid: egen tot_wmen_serv=sum(occ7)
bysort hhid: egen tot_wmen_skman=sum(occ8)
bysort hhid: egen tot_wmen_uskman=sum(occ9)

sum tot_wmen_agri
lab var tot_wmen_agri "Number of women in agri-all"
lab var tot_wmen_un "Number of women in the HH - unemployed"
lab var tot_wmen_prof "Number of women in the HH - Professional jobs"
lab var tot_wmen_cler "Number of women in the HH - Clerical jobs"
lab var tot_wmen_sales "Number of women in the HH - sales employment"
lab var tot_wmen_uskman "Number of women in the HH - domestic employed"
lab var tot_wmen_serv "Number of women in the HH - services employment"
lab var tot_wmen_skman "Number of women in the HH - skilled manual employment"
lab var tot_wmen_uskman "Number of women in the HH - unskilled manual employment"

* Currently working
tab v714
bysort hhid: egen tot_wmen_work=sum(v714)
bysort hhid: egen tot_wmen_work_hd=sum(v714) if v150==1

*HH head occupation 
bysort hhid: g x = occ5==1 & v150==1
replace x = . if occ5 == . 
bysort hhid: egen head_ag_wm= max(x)
drop x

bysort hhid: g x= occ2==1 & v150==1
replace x = . if occ2 == .
bysort hhid: egen head_prof_wm=max (x)
drop x

bysort hhid: g x= occ3==1 & v150==1
replace x = . if occ3 == .
bysort hhid: egen head_cler_wm=max (x)
drop x

bysort hhid: g x= occ4==1 & v150==1
replace x = . if occ4 == .
bysort hhid: egen head_sales_wm=max (x)
drop x

bysort hhid: g x= occ7==1 & v150==1
replace x = . if occ7 == .
bysort hhid: egen head_serv_wm=max (x)
drop x

bysort hhid: g x= occ8==1 & v150==1
replace x = . if occ8 == .
bysort hhid: egen head_skman_wm=max (x)
drop x

bysort hhid: g x= occ1==1 & v150==1
replace x = . if occ1 == .
bysort hhid: egen head_un_wm=max (x)
drop x

lab var tot_wmen_work "Number of women currently working in the HH"
lab var tot_wmen_work_hd "Women head(s) currently working in the HH"
lab var head_ag_wm "Female head in the HH - wage or self agri -employed"
lab var head_prof_wm "Female head in the HH - Professional"
lab var head_cler_wm "Female head in the HH - Professional"
lab var head_un_wm "Female head in the HH - unemployed"
lab var head_sales_wm "Female head in the HH - sales employment"
lab var head_serv_wm "Female head in the HH - services employment"
lab var head_skman_wm "Female head in the HH - skilled manual employment"


* Education
tab v106, g(edu)
bysort hhid: egen tot_wmen_noedu=sum(edu1)
bysort hhid: egen tot_wmen_pri=sum(edu2)
bysort hhid: egen tot_wmen_sec=sum(edu3)
bysort hhid: egen tot_wmen_high=sum(edu4)

* Head 
bysort hhid: g x = edu1==1 & v150==1
replace x = . if edu1 == .
bysort hhid: egen head_noedu_wm=max (x)
drop x

bysort hhid: g x= edu2==1 & v150==1
replace x = . if edu2 == .
bysort hhid: egen head_pri_wm=max (x)
drop x

bysort hhid: g x= edu3==1 & v150==1
replace x = . if edu3 == .
bysort hhid: egen head_sec_wm=max (x)
drop x

bysort hhid: g x= edu4==1 & v150==1
replace x = . if edu4 == .
bysort hhid: egen head_high_wm=max (x)
drop x

lab var tot_wmen_noedu "Number of women in the HH - no education"
lab var tot_wmen_pri "Number of women in the HH - primary education"
lab var tot_wmen_sec "Number of women in the HH - secondary education"
lab var tot_wmen_high "Number of women in the HH - higher education"
lab var head_noedu_wm "Female head in the HH - no education"
lab var head_pri_wm "Female head in the HH - primary education"
lab var head_sec_wm "Female head in the HH - secondary education"
lab var head_high_wm "Female head in the HH - higher education"


// Anthropometry indicators

* Age of most recent child - to select women that are not post partum 
gen age = v008 - b3_01

* To check if survey has b19, which should be used instead to compute age (program)
check_age_variable

// Rohrer index (RI) ie Index  of Corpulence - NON PREGNANT-POST PARTUM WOMEN

// The range variation of RI (According to Pignet, cited in Bhasin and Singh, 2004) is also mentioned in this study: Rohrer Index=(Body weight (gm)/Stature 3 (cm)) × 100 //
/*
• Very low ≤ 1.12

• Low (1.13-1.19)

• Middle (1.20-1.25)

• Upper middle (1.26-1.32)

• High (1.33-1.39)

• Very high=1.40

• Healthy range 1.2-1.6
*/

sum v446
codebook v446
tab v446, nolabel
tab v445
foreach var of varlist v445 v446 {
replace `var' =. if `var'==9998 | `var'==9999
}

* RI creation
g RI_Low_w=1 if v446<=1190 //RI for low and very low//
replace RI_Low_w=0 if v446>1190
replace RI_Low_w= . if (v446==.| v213==1 | age<2)
lab var RI_Low_w "Rohrer Index - low or very low - women"
label define RI_Low_w 1 "Low or Very low Rohrer's Index" 0 "High Rohrer Index"
label values RI_Low_w RI_Low_w
tab RI_Low_w
bysort hhid: egen tot_RI_Low_w=total(RI_Low_w), missing
sum tot_RI_Low_w
lab var tot_RI_Low_w "Number of women in HH with low or very low Rohrer Index"

// BMI - NON PREGNANT-POST PARTUM WOMEN

/* https://dhsprogram.com/pubs/pdf/MR6/MR6.pdf
With standard terminology for this
measure, if the BMI is less than 16.0, the woman is ―severely thin;‖ if 16.0 to 16.9, she is ―moderately
thin;‖ if 17.0 to 18.4, she is ―mildly thin.‖ The entire range below 18.5 is ―thin.‖ If the BMI is 25.0 to
29.9, the woman is ―overweight;‖ if 30.0 or higher, she is ―obese.‖ For example, if v437 = 400 (40.0 kg)
and v438 = 1500 (1.500 meters) then v445 = 1778, the BMI is 17.78, and the woman is ―mildly thin.‖
For the ―malnourished‖ woman described in the last paragraph of section 4.2.2, with a weight of 35.1 kg
and a height of 1.500 meters, the BMI is 15.6, so she is ―severely thin.‖
*/

/* The DHS Guide to Statistics offers the following guidelines for interpreting BMI scores for women age 15-49:
 Severely thin: less than 16.0
Moderately thin: 16.0 to 16.9
Mildly thin: 17.0 to 18.4
Normal: 18.5 to 24.9
Overweight: 25.0 to 29.9
Obese: 30.0 or more*/

* BMI - moderately or severely thin DHS
gen nt_wm_modsevthin= inrange(v445,1200,1699) if inrange(v445,1200,6000)
replace nt_wm_modsevthin=. if (v445 ==. | v213==1 | age<2)
label var nt_wm_modsevthin "Moderately and severely thin BMI - women"
bysort hhid: egen DHS_tot_BMI_low_w=total(nt_wm_modsevthin), missing 
lab var DHS_tot_BMI_low_w "Number of women in HH with BMI <16.9 (severe or moderately thin)"

// SEVERE ANEMIA
gen nt_wm_sev_anem=0 if v042==1 & v455==0
replace nt_wm_sev_anem=1 if v457==1 | v457==2
label var nt_wm_sev_anem "Severe and Moderate anemia - women"
bysort hhid: egen sev_mod_anemia_hh=total(nt_wm_sev_anem), missing 
lab var sev_mod_anemia_hh "Number of women in HH with severe-moderate anemia"


// TOOK IRON supplements during last pregnancy
gen nt_wm_micro_iron= .
replace nt_wm_micro_iron=0 if m45_1==0
replace nt_wm_micro_iron=1 if inrange(m46_1,0,59)
replace nt_wm_micro_iron=2 if inrange(m46_1,60,89)
replace nt_wm_micro_iron=3 if inrange(m46_1,90,300)
replace nt_wm_micro_iron=4 if m45_1==8 | m45_1==9 | m46_1==998 | m46_1==999
replace nt_wm_micro_iron= . if v208==0
label define nt_wm_micro_iron 0"None" 1"<60" 2"60-89" 3"90+" 4"Don't know/missing"
label values nt_wm_micro_iron nt_wm_micro_iron
label var nt_wm_micro_iron "Number of days women took iron supplements during last pregnancy"

tab nt_wm_micro_iron, gen(nt_wm_micro_iron)


* Collapsing at HH level
sum  v001 v002
collapse tot_wmen* head* RI_Low_w tot_RI_Low_w nt_wm_modsevthin DHS_tot_BMI_low_w sev_mod_anemia_hh nt_wm_sev_anem nt_wm_micro_iron*, by (hhid v001 v002)

sum
order hhid v001 v002
sort hhid 

save "$dta/HHwomen_2016.dta", replace

*We have Occupation, Profession, of the women HH head
*And totals as well
*Rohrer, BMI and anemia, ironsuppliments are available

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

* Mens' Dataset - MR    

use "$mrdata2016.dta", clear

keep mcaseid mv000 mv001 mv002 mv003 mv004 mv005 mv006 mv007 mv008 mv008a mv012 mv024 mv025 mv101 mv102 mv106 mv107 mv133 mv131 mv717 mv714 mv150 mv151 mv152 mv501 mv130  

* ID
tostring mv001 mv002,g (v001s v002s)
g hhid=v001s+v002s
replace hhid =v001s+"0"+v002s if mv002<10
order hhid
destring hhid, replace
drop v001s v002s

rename mcaseid hhid_dhs

* Number of men in the HH
bysort hhid: g n=_n
bysort hhid: egen tot_men=max(n)
sum tot_m
lab var tot_m "Number of men in the HH"
drop n 

*Employment in agriculture

tab mv717, g(occ)

bysort hhid: egen tot_men_ag=sum(occ5)
bysort hhid: egen tot_men_dom=sum(occ6)
sum tot_men_ag

lab var tot_men_ag "Number of men in agri-self-employed"

*Other occupations
bysort hhid: egen tot_men_un=sum(occ1)
bysort hhid: egen tot_men_prof=sum(occ2)
bysort hhid: egen tot_men_cler=sum(occ3)
bysort hhid: egen tot_men_sales=sum(occ4)
bysort hhid: egen tot_men_serv=sum(occ7)
bysort hhid: egen tot_men_skman=sum(occ8)
bysort hhid: egen tot_men_uskman=sum(occ9)

lab var tot_men_un "Number of men in the HH - unemployed"
lab var tot_men_prof "Number of men in the HH - Professional jobs"
lab var tot_men_cler "Number of women in the HH - Clerical jobs"
lab var tot_men_sales "Number of men in the HH - sales employment"
lab var tot_men_serv "Number of men in the HH - services employment"
lab var tot_men_skman "Number of men in the HH - skilled manual employment"
lab var tot_men_uskman "Number of women in the HH - unskilled manual employment"

*Currently working
bysort hhid: egen tot_men_work=sum(mv714)
bysort hhid: egen tot_men_work_hd=sum(mv714) if mv150==1

*HH head occupation 
bysort hhid: gen x = (occ5==1) & mv150==1
replace x = . if (occ5==. )
bysort hhid: egen head_ag_m=max (x)
drop x

bysort hhid: g x = occ6==1 & mv150==1
replace x = . if occ6 == .
bysort hhid: egen head_dom_m=max (x)
drop x

bysort hhid: g x= occ1==1 & mv150==1
replace x = . if occ1 == .
bysort hhid: egen head_un_m=max (x)
drop x

bysort hhid: g x= occ2==1 & mv150==1
replace x = . if occ2 == .
bysort hhid: egen head_prof_m=max (x)
drop x

bysort hhid: g x = occ3==1 & mv150==1
replace x = . if occ3 == .
bysort hhid: egen head_cler_m=max (x)
drop x

bysort hhid: g x= occ4==1 & mv150==1
replace x = . if occ4== .
bysort hhid: egen head_sales_m=max (x)
drop x

bysort hhid: g x = occ7==1 & mv150==1
replace x = . if occ7== .
bysort hhid: egen head_serv_m=max (x)
drop x

bysort hhid: g x= occ8==1 & mv150==1
replace x = . if occ8== .
bysort hhid: egen head_skman_m=max (x)
drop x

bysort hhid: g x= occ9==1 & mv150==1
replace x = . if occ9== .
bysort hhid: egen head_uskman_m=max (x)
drop x

lab var tot_men_work "Number of men currently working in the HH"
lab var tot_men_work_hd "men head(s) currently working in the HH"

lab var head_ag_m "Male head in the HH - agri-employed"

lab var head_un_m "Male head in the HH - unemployed"
lab var head_prof_m "Male head in the HH - Professional"
lab var head_cler_m "Male head in the HH - Clerical"
lab var head_sales_m "Male head in the HH - sales employment"
lab var head_serv_m "Male head in the HH - services employment"
lab var head_skman_m "Male head in the HH - skilled manual employment"
lab var head_uskman_m "Male head in the HH - unskilled manual employment"


* Education
tab mv106, g(edu)
bysort hhid: egen tot_men_noedu=sum(edu1)
bysort hhid: egen tot_men_pri=sum(edu2)
bysort hhid: egen tot_men_sec=sum(edu3)
bysort hhid: egen tot_men_high=sum(edu4)

lab var tot_men_noedu "Number of men in the HH - no education"
lab var tot_men_pri "Number of men in the HH - primary education"
lab var tot_men_sec "Number of men in the HH - secondary education"
lab var tot_men_high "Number of men in the HH - higher education"


* Head - Education
bysort hhid: g x= edu1==1 & mv150==1
replace x = . if edu1 == .
bysort hhid: egen head_noedu_m=max (x)
drop x

bysort hhid: g x= edu2==1 & mv150==1
replace x = . if edu2 == .
bysort hhid: egen head_pri_m=max (x)
drop x

bysort hhid: g x= edu3==1 & mv150==1
replace x = . if edu3 == .
bysort hhid: egen head_sec_m=max (x)
drop x

bysort hhid: g x= edu4==1 & mv150==1
replace x = . if edu4 == .
bysort hhid: egen head_high_m=max (x)
drop x

lab var head_noedu_m "Male head in the HH - no education"
lab var head_pri_m "Male head in the HH - primary education"
lab var head_sec_m "Male head in the HH - secondary education"
lab var head_high_m "Male head in the HH - higher education"


* Collapsing at HH level
sum  mv001 mv002
collapse tot_men*  head* mv001 mv002, by (hhid)   
rename mv001 v001
rename mv002 v002
sum

order hhid v001 v002

save "$dta/HHmen_2016.dta", replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

********************************************************************************
* Household members - PR for FOOD SECURITY
********************************************************************************
use "$prdata2016.dta", clear

keep hhid hvidx hv001 hv002 hv003 hv004 hv005 hv007 hv021 hv022 hv023 hv024 hv025  hv101 hv103 hv104 hv105 hv106 hv107 hv270 hv271  hc57 hv006 hv007 hv008 hv009 hv220 hv219 hv204 hv205 hv206 hv207 hv208 hv201 hv213 hv214 hv215 ha5 ha11 hc1 hc56 hc70 hc71 hc72 hc73 

gen v001 = hv001
gen v002 = hv002
gen v003 = hv003
sort v001 v002 v003

order hvidx, after(hhid)

* ID
rename hhid hhid_dhs
tostring v001 v002,g (v001s v002s)
g hhid=v001s+v002s
replace hhid =v001s+"0"+v002s if v002<10
order hhid
destring hhid, replace
drop v001s v002s


* STUNTING
tab hc70, nolabel
tab hc71, nolabel
tab hc72, nolabel

foreach var of varlist hc70 hc71 hc72 {
replace `var' =. if `var'==9998 |`var'==9996 | `var'==9997 |`var'==9999
}

tab hc70
gen stunted_ch = 1 if hc70<=-200
replace stunted_ch=0 if hc70>-200
replace stunted_ch= . if hc70==.
tab stunted_ch
* count if hc70 <-200
bysort hhid: egen stunting_c_hh=total(stunted_ch), missing 
lab var stunting_c_hh "Number of stunted children in the HH"

* WASTING
gen wasted_ch = 1 if hc72<=-200
replace wasted_ch=0 if hc72>-200
replace wasted_ch = . if hc72==.
tab wasted_ch
* count if hc72 <-200
bysort hhid: egen wasted_c_hh=total(wasted_ch) , missing
lab var wasted_c_hh "Number of wasted children in the HH"


* UNDERWWEIGHT
gen underwht_ch = 1 if hc71<=-200
replace underwht_ch=0 if hc71>-200
replace underwht_ch = . if hc71==.
tab underwht_ch
bysort hhid: egen underwht_ch_hh=total(underwht_ch) , missing
lab var underwht_ch_hh "Number of underweighted children in the HH"
tab underwht_ch_hh
* count if hc71 <-200

* MODERATE AND SEVERE ANEMIA AMONG CHILDREN
gen nt_ch_sev_anem=0 if hc1>5 & hc1<60
replace nt_ch_sev_anem=1 if hc56<100 & hc1>5 & hc1<60
replace nt_ch_sev_anem=. if hc56==.
label var nt_ch_sev_anem "Moderate/severe anemia - child 6-59 months"
bysort hhid: egen anemia_ch_hh=total(nt_ch_sev_anem), missing 
label var anemia_ch_hh "Moderate/severe anemia HH - child 6-59 months"


* Sex
tab hv104, g(sex)
bysort hhid: egen tot_men_HH=total(sex1)
bysort hhid: egen tot_wmen_HH=total(sex2)
lab var tot_men_HH "Number of men in the HH"
lab var tot_wmen_HH "Number of women in the HH"
bysort hhid:egen tot_teen15=total(hv105<16)
lab var tot_teen15 "Number of teen below 16 in the HH"


* Head educational level (Both Men + Women)
gen head_no_edu =  (hv101==1 & hv106==0)
gen head_primary = (hv101==1 & hv106==1)
gen head_secondary = (hv101==1 & hv106==2)
gen head_higher = (hv101==1 & hv106==3)

bysort hhid: egen hh_head_no_edu =max(head_no_edu)
bysort hhid: egen hh_head_primary =max(head_primary)
bysort hhid: egen hh_head_secondary =max(head_secondary)
bysort hhid: egen hh_head_higher =max(head_higher)

tab hv206   //electricity access
tab hv205  //type of sewage access 

collapse  v003  hv001 hv002 hv003 hv009 hv206 tot_men_HH tot_wmen_HH tot_teen15  hh_head_* anemia_ch_hh nt_ch_sev_anem underwht_ch_hh underwht_ch wasted_c_hh wasted_ch stunted_ch stunting_c_hh , by(hhid v001 v002 hv007)

sort hhid

save "$dta/HH_2016.dta", replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

********************************************************************************
* Children data for FOOD DIVERSITY AND FREQUENCY
********************************************************************************

use "$krdata2016.dta", clear

gen age_in_months = v008 - b3
sum age_in_months //ok   < 60 months

keep if b9 == 0 & age_in_months < 24    							//5786 children

gsort caseid age_in_months
* and keep the last born of those.
* if caseid is the same as the prior case, then not the last born
keep if _n== 1 | caseid != caseid[_n-1]                        //209 deleted

*ID
tostring v001 v002, g(v001s v002s)
g hhid=v001s+v002s
replace hhid =v001s+"0"+v002s if v002<10
order hhid
destring hhid, replace
drop v001s v002s
order hhid

bysort hhid: g n=_n
bysort hhid: egen tot_ch=max(n)
sum tot_ch

gen hh_young_ch = .
replace hh_young_ch = 1 if tot_ch > 0 & tot_ch !=.
lab var hh_young_ch "youngest children living with their mother"


***children who are fed with milk products or are breastfeeding Milk or milk products two or more times during the day or night preceding the survey or are breastfeeding.

tab v411 //
tab v411a //
tab v414p //

replace v469e =.  if v469e == 8     //missing 
replace v469f = . if v469f == 8     //missing 
replace v469x = . if v469x == 8		//missing 

egen dairy_prod_amount = rowtotal(v469e v469f v469x), missing
label var dairy_prod_amount "Number of times child had dairy product"
gen dairy_prod = 0
replace dairy_prod = 1 if dairy_prod_amount >= 2
replace dairy_prod = . if dairy_prod_amount ==.
label var dairy_prod "1=Dairy given more than once versus 0=dairy given once"
label define dairy_prod 1 "Child had diary more than once" 0 "Child had dairy once"
label values dairy_prod dairy_prod


gen breast_or_subsidies = 0
replace breast_or_subsidies = 1 if dairy_prod == 1 | m4 == 95
replace breast_or_subsidies = . if dairy_prod == . & m4 != 95
label var breast_or_subsidies "Dairy given more than once + breast milk versus 0=dairy given once + no breast milk"
label define breast_or_subsidies 1 "Still breast feeding+dairy product once" 0 "Not breast feeding + diary more than once"
label values breast_or_subsidies breast_or_subsidies



*consumed in the last 24 hours

gen grains_oth = v414e == 1 | v412b == 1   
replace grains_oth = . if v414e == .
label var grains_oth "Child had grains (Local grains, tubers)"
label define grains_oth 1 "Child had grains" 0 "Had none"
label values grains_oth grains_oth
tab grains_oth, m

gen legume_nuts = v414o == 1   
replace legume_nuts = . if v414o == .
label var legume_nuts "Child had food (lentils, beans, peas, nuts)"
label define legume_nuts 1 "Child had lentils, beans, peas, nuts" 0 "Had none"
label values legume_nuts legume_nuts
tab legume_nuts, m

gen dairy_products =  dairy_prod ~= 0
replace dairy_products = . if   dairy_prod ==. 
label var dairy_products "Child had food (milk, formula, yogurt etc)"
label define dairy_products 1 "Child had milk, formular, yoghurt" 0 "Had none"
label values dairy_products dairy_products
tab dairy_products, m

gen flesh_food = v414h == 1 | v414m == 1 | v414g == 1  //NA
replace flesh_food = . if v414h == .
label var flesh_food "Child had food (meat, and fish, eggs)"
label define flesh_food 1 "Child had meat, eggs, and fish" 0 "Had none"
label values flesh_food flesh_food
tab flesh_food, m

gen vitamin_food = v414k == 1 | v414l == 1   //na
replace vitamin_food = . if v414k  == . & v414l == . 
label var vitamin_food "Child had food (Vitamin rich foodh)"
label define vitamin_food 1 "Child had Vitamin rich food" 0 "Had none"
label values vitamin_food vitamin_food
tab vitamin_food

gen oth_fruit_veg = v414f == 1 | v414i == 1 |v414j  == 1    //na
replace oth_fruit_veg = . if v414f == . & v414i  == . & v414j == .
label var oth_fruit_veg "Child had food (fruit and vegies)"
label define oth_fruit_veg 1 "Child had fruit and vegies" 0 "Had none"
label values oth_fruit_veg oth_fruit_veg
tab oth_fruit_veg, m

*****A minimum dietary diversity of 4 or more food groups: see https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5639776/ for relevant articled

gen breast_feeding = m4 == 95 

egen min_diet_diversity_h = rowtotal(grains_oth legume_nuts dairy_products flesh_food vitamin_food oth_fruit_veg breast_feeding)
label var min_diet_diversity_h "Total diet diversity - all food groups"
gen min_diet_diversity = 0
replace min_diet_diversity = 1 if min_diet_diversity_h >= 4   //Because we have 7 total groups. eggs are missing as a separate var
replace min_diet_diversity = . if grains_oth ==. & legume_nuts ==. & dairy_products ==. & flesh_food ==. & vitamin_food==. & oth_fruit_veg ==.
label var min_diet_diversity "Minimum diet diversity of 4 or more food groups (out of 7)"
replace min_diet_diversity=. if age_in_months < 6 

*** minimum meal frequency for breastfeeding****
gen infants = 1 if age_in_months >= 6 & age_in_months <=8
gen not_infants = 1 if age_in_months >=9
gen inf_min_breast = 0 if infants == 1
replace inf_min_breast = 1 if infants == 1 & m4 ==95 & inrange(m39,2,7)
gen not_inf_min_breast = 0 if not_infants ==1
replace not_inf_min_breast = 1 if not_infants ==1 & m4 ==95 & inrange(m39,3,7)

label var inf_min_breast "Household with infant (age 6:8 months) breastfeeding + solid-semisolid food 2-7 times"
label var not_inf_min_breast "Household with children (age >=9 months) breastfeeding + solid-semisolid food 3-7 times"




*for not breastfeeding child
*dairy_prod_amount m39 = both are times kids are fed - dairy_prod_amount not in 2008 (we have only yes no options)


egen min_food_help = rowtotal (dairy_prod_amount m39) if (m39 >=1 & m39<=7  & age_in_months < 6)
replace min_food_help=0 if m39==0 & dairy_prod_amount==0
gen min_no_breast = .
replace min_no_breast = 0 if m4 != 95
replace min_no_breast=1 if min_food_help >= 4 & m4 != 95
egen min_meal_freq = rowtotal (inf_min_breast not_inf_min_breast min_no_breast), missing


gen No_min_meal_freq =  min_meal_freq ==0
bys hhid : egen No_min_meal_freq_hh = max(No_min_meal_freq)
la var No_min_meal_freq_hh "HH has at least one young child that is not fed min frequency"

gen No_min_diet_diversity =  min_diet_diversity ==0
bys hhid : egen No_min_diet_diversity_hh = max(No_min_diet_diversity)
la var No_min_diet_diversity_hh "HH has at least one young child that is not fed with the min food diversity"

bys hhid : egen Meal_freq_hh = max(m39) if m39<=7
la var Meal_freq_hh "Times child(ren) in HH ate solid, semi-solid or soft food"
replace Meal_freq_hh=0 if Meal_freq_hh==.


count
sort hhid
collapse (max) hh_young_ch  min_diet_diversity No_min_diet_diversity_hh No_min_meal_freq No_min_meal_freq_hh inf_min_breast not_inf_min_breast, by (hhid v001 v002 v007)
   
save "$dta/food_2016.dta", replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
use "$krdata2016.dta", clear

// Child's age 

gen age = v008 - b3

keep if _n == 1 | caseid != caseid[_n-1]

gen age_in_months = v008 - b3
sum age_in_months

check_age_variable
	
* HHID
tostring v001 v002, g(v001s v002s)
g hhid=v001s+v002s
replace hhid =v001s+"0"+v002s if v002<10
order hhid
destring hhid, replace
drop v001s v002s
order hhid

// Given formula
gen nt_formula = v411a==1 
replace nt_formula = . if v411a == .
label var nt_formula "Child given infant formula in day/night before survey - last-born under 2 years"

// Give fortified baby food
gen nt_bbyfood= v412a==1
label var nt_bbyfood "Child given fortified baby food in day/night before survey- last-born under 2 years"


// Given other fresh animal milk
gen nt_milk = v411 == 1          
replace nt_milk = . if v411 == .
label var nt_milk "Child given other milk in day/night before survey- last-born under 2 years"

// Given grains & tubers
gen nt_grains_tuber = v414e == 1 
replace nt_grains_tuber = . if (v414e == .)
label var nt_grains_tuber "Child given grains in day/night before survey- last-born under 2 years"


// Given Vit rich foods
gen nt_vit =  v414k == 1 | v414l == 1 
replace nt_vit = . if(v414k == . | v414l == .)
label var nt_vit "Child given vitamin A rich food in day/night before survey- last-born under 2 years"

*Given other fruits or vegetables

gen  nt_frtveg = v414f == 1 | v414i == 1 |v414j  == 1
replace nt_frtveg = . if(v414f == . & v414i == .  & v414j  == .)
label var nt_frtveg "Child given other fruits or vegetables in day/night before survey- last-born under 2 years"


// Given nuts or legumes

gen nt_nuts = v414o == 1
replace nt_nuts = . if v414o == .
label var nt_nuts "Child given legumes or nuts in day/night before survey- last-born under 2 years"


// Given meat+ eggs

gen nt_meat = v414h == 1 | v414m == 1 | v414g == 1  //NA
replace nt_meat = . if  v414h == . & v414m == .  & v414g == 1
label var nt_meat "Child given meat, fish, shellfish, or poultry in day/night before survey- last-born under 2 years"



// Given eggs
gen nt_eggs = v414g==1
replace nt_eggs = . if  v414g == .
label var nt_eggs "Child given eggs in day/night before survey- last-born under 2 years"


// Given dairy
egen dairy_prod = rowtotal(v411 v411a v414p)


gen nt_dairy = dairy_prod != 0 
replace nt_dairy = . if (dairy_prod == .)
label var nt_dairy "Child given cheese, yogurt, or other milk products in day/night before survey- last-born under 2 years"


// Given other solid or semi-solid foods
gen nt_solids=  nt_grains_tuber==1 | nt_vit==1 | nt_frtveg==1 | nt_nuts==1 | nt_dairy==1 | nt_meat==1   
label var nt_solids "Child given any solid or semisolid food in day/night before survey- last-born under 2 years"


// Fed milk or milk products
gen totmilkf = 0
replace totmilkf=  1 if v411 ==1 
replace totmilkf=  1 if v411a ==1 
replace totmilkf = 1 if v414p == 1   
replace totmilkf = . if(v411 == . & v411a == . & v414p == .)
gen nt_fed_milk= ( totmilkf==1 | m4==95) if inrange(age_in_months,6,24)
label values nt_fed_milk yesno
label var nt_fed_milk "Child given milk or milk products- last-born 6-23 months"


// Min dietary diversity

	* 8 food groups
	*1. breastmilk
	gen group1= m4==95

	*2. infant formula, milk other than breast milk, cheese or yogurt or other milk products
	gen group2= nt_formula==1 | nt_milk==1 | nt_dairy==1

	*3. foods made from grains, roots, tubers, and bananas/plantains, including porridge and fortified baby food from grains
	gen group3= nt_grains_tuber==1 
	 
	*4. vitamin A-rich fruits and vegetables
	gen group4= nt_vit==1

	*5. other fruits and vegetables
	gen group5= nt_frtveg==1

	*6. eggs
	gen group6= nt_eggs==1  

	*7. legumes and nuts
	gen group7= nt_nuts==1
	
	*8. meat
	gen group8= nt_meat==1

// Min dietary diversity
egen foodsum = rsum(group1 group2 group3 group4 group5  group6 group7 group8)  
recode foodsum (1/3 =0 "No") (5/8=1 "Yes"), gen(nt_mdd)
replace nt_mdd=. if inrange(age_in_months, 6, 24)
label var nt_mdd "Child with minimum dietary diversity, 5 out of 8 food groups- last-born 6-23 months"

gen non_mdd =1 if nt_mdd==0   
replace non_mdd=0 if nt_mdd==1 
bys hhid : egen new_No_min_diet_diversity_hh = max(non_mdd) if non_mdd!=.
la var new_No_min_diet_diversity_hh "HH has at least one young child that is not fed with the min food diversity"



*minimum meal frequency
*https://dhsprogram.com/data/Guide-to-DHS-Statistics/index.htm#t=Minimum_Dietary_Diversity_Minimum_Meal_Frequency_and_Minimum_Acceptable_Diet.htm
/*
4)     A minimum meal frequency of:

a)      For breastfed children, receiving solid or semi-solid food

·        at least twice a day for infants 6-8 months (m4 = 95 & b19 in 6:8 & m39 in 2:7) or

·        at least three times a day for children 9-23 months (m4 = 95 & b19 in 9:23 & m39 in 3:7)

b)     For non-breastfed children age 6-23 months, receiving solid or semi-solid food or milk feeds at least four times a day (m4 ≠ 95 & total milk feeds (see Numerator 1) plus solid feeds (m39 – if in 1:7) >= 4) where at least one of the feeds must be a solid, semi-solid, or soft feed (m39 in 1:7)

*/

*NEW 

gen  x = m4 == 95 & inrange(age_in_months, 6,8) & inrange(m39, 2,7)
bys hhid: egen min_meal_freq_bf_inf = max(x)
drop x
replace min_meal_freq_bf_inf = . if (m4 == . | age_in_months == . | m39 == .)
label var min_meal_freq_bf_inf "Households with minimum meal frequency for breastfed infants -6:8 months"

gen x = m4 == 95 & inrange(age_in_months, 9,23) & inrange(m39, 3,7)
bys hhid: egen min_meal_freq_bf_child = max(x)
drop x
replace min_meal_freq_bf_child = . if (m4 == . | age_in_months == . | m39 == .)
label var min_meal_freq_bf_child "Households with minimum meal frequency for breastfed children -9:23 months"


count
sort hhid
collapse (max) nt_milk nt_formula nt_grains_tuber nt_vit nt_frtveg nt_nuts nt_meat nt_dairy nt_solids nt_mdd new_No_min_diet_diversity_hh  min_meal_freq_bf_* b1 b2 nt_fed_milk    , by (hhid v001 v002 v007)

save "$dta/NEW_1_food_2016.dta", replace

*********************************************************************************************************************************
* MERGING (Household Level)
*********************************************************************************************************************************

use "$hrdata2016.dta", clear

keep hhid hv001 hv002 hv003 hv005 hv007 hv021 hv022 hv023 hv024 hv025 hv006 hv008 hv009  hv204 hv205 hv206 hv207 hv208 hv201 hv213 hv214 hv215 hv270  hv271     hv220  hv209 hv210 hv211 hv212  hv221    hv219 hv220  hv012 hv244 hv245

*Wealth index and Gini Coeff- hv271

*population weight
gen popwt = (hv005/1e6) * hv012  



rename hv025 type_place 
rename hv024 region
rename hv270 wealth_index
rename hv271 wealth_index_score


gen v001 = hv001
gen v002 = hv002
gen v003 = hv003
sort v001 v002 v003

* ID
tostring v001 v002, g(v001s v002s)
rename hhid hhid_dhs
g hhid=v001s+v002s
replace hhid =v001s+"0"+v002s if v002<10
order hhid
destring hhid, replace
drop v001s v002s
order hhid

*Households with water available on premises
gen wat_avl_prms = hv204 == 996
replace wat_avl_prms = . if hv204 == .


*Poverty (Bottom 20 and 40 percent) Based on Wealth Index Combined
/*
definition
           1   lowest
           2   second
           3   middle
           4   fourth
           5   highest

   variables:  wealth_index

*/
*Bottom 20
gen pov_hd_bot_20 = wealth_index == 1
replace pov_hd_bot_20 = . if wealth_index == .

*Bottom 40
gen pov_hd_bot_40 = inrange(wealth_index, 1, 2)
replace pov_hd_bot_40 = . if missing(wealth_index)


* Year
gen year=2016


collapse hv003 hv005 hv007 hv021 hv022 hv023 hv006 hv008 hv009 type_place region hv204 hv205 hv206 hv207 hv208 hv201 hv213 hv214 hv215 hv244 hv245 year wealth_index wealth_index_score  hv219 hv220 hv209 hv210 hv211 hv212  hv221  popwt   wat_avl_prms pov_hd_bot_20 pov_hd_bot_40, by (hhid v001 v002 )

sort hhid 


* Merging

merge 1:1 hhid v001 v002 using "$dta/HHwomen_2016.dta"    
drop _merge

merge 1:1 hhid v001 v002 using "$dta/HHmen_2016.dta"
drop _merge

merge 1:1 hhid v001 v002 using "$dta/HH_2016.dta"
drop _merge

merge 1:1 hhid v001 v002 using "$dta/food_2016.dta"
drop _merge

merge 1:1 hhid v001 v002 using "$dta/NEW_1_food_2016.dta"
drop _merge

replace year=2016 if year==.
order hhid year
drop v001 v002 v003

*************************************************************************************************************************
* WEIGHTS
*************************************************************************************************************************

rename hv005 HH_wgt
gen wgt = HH_wgt/1e6

order hhid hv001 hv002 hv003
*************************************************************************************************************************
* LABELLING and Value Lables  - To make sense of data
*************************************************************************************************************************

*labels_dhs_indicators

*value_labels_aasignment

replace year = hv007 if year != hv007

rename (hv001 year) (dhsclust dhsyear)
/*
preserve

import delimited "$geodata2016.csv", case(lower) clear 
*Data cleaning of GPS Data (Missing values coded as -9999)
foreach var of varlist all_population_count_2005-wet_days_2015 {
	replace `var' = . if `var' == -9999
}

tempfile gps2017
save 	`gps2017', replace

restore

merge m:1 dhsclust dhsyear using `gps2017' 
keep if _merge == 3   // 1 obs unmatched
drop _merge

order dhsid-wet_days_2015

gsort dhsclust hv002
*/
order hhid dhsclust hv002 hv003 dhsyear

save "$output/final_2016.dta", replace
