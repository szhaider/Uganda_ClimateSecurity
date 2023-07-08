* To check if survey has b19, which should be used instead to compute age
* Becuase in some rounds, b19_01 captures age

program define check_age_variable

scalar b19_included  =  1

capture confirm numeric variable b19_01, exact
if _rc > 0 {
	scalar b19_included = 0
} 
if _rc == 0 {
	sum b19_included 
	if r(mean) | r(sd) == . {
		b19_included = 0
	}
	
	if b19_included == 1 {
		drop age 
		gen age = b19_included
	}
}
end

