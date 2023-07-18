
*Cluster level Gini Coefficient based on wealth Index score

* It is expected to reveal intersting cluster level patterns in combination with cluster level conflict and climate trends 

//Using Popwt because used in computation (https://dhsprogram.com/data/Guide-to-DHS-Statistics/index.htm#t=Wealth_Quintiles.htm)

*transforming the negative values - to circumvent gini > 1
*https://userforum.dhsprogram.com/index.php?t=msg&goto=12517&S=Google

use "$output/final_Uganda.dta", clear

cap drop w_i 
cap drop g_s
cap drop gini
cap drop wscore_trans

clonevar w_i = wealth_index_score
replace w_i = w_i/1e5 if dhsyear != 2000  //Since 2000 is already in raw form

gen gini = . 

qui: levelsof dhsyear, local(year)
qui: levelsof dhsclust, local(clust)

di `year'
di `clust'

************* Transformed wealth score - 0 based********************************
gen wscore_trans = .
foreach y of local year{
sum w_i if dhsyear == `y'
local w_min = r(min)
replace wscore_trans = w_i - `w_min' if dhsyear == `y'
}

qui{
foreach y of local year{
	qui: ineqdec0 wscore_trans [pw=popwt] if dhsyear == `y', by(dhsclust) 
	
	foreach cl of local clust{

	replace gini = r(gini_`cl') if dhsclust == `cl' & dhsyear == `y'
		}		
	}
}

gsort dhsclust dhsyear 

*labels_dhs_indicators

label variable gini "Gini Coeffcient"

save "$output/final_Uganda.dta", replace

/*

*Lorenz curve over the years (-ve values in index messing up the curve's interpretibility')
preserve
glcurve w_i [aw=popwt], by(dhsyear) split gl(gl) p(p) lorenz ytitle("Cumulative Asset Ownership)") title("Lorenz Curves Over the years") subtitle("Asset Ownership Inequality")  legend(label(1 "2003") label(2 "2008") label(3 "2017")) plotregion(margin(zero)) aspectratio(1)
graph export "$output/graphs/Lorenz.png", replace

graph export "$figures/Lorenz.png", replace

restore		
		