clear
graph drop _all

// Question 1: Preparing your do file 
// a) Open up Stata and open a new Do file 
// b) Set your working directory (hint: this should be where you have stored your data) 
cd "C:\Users\Harris\projects\asmhi_programming"
// c) Start a log file 
log using "analysis/do/stata_practical_4.log", replace
// d) Load your data from previous practical's saved mydata2.dta 
use "data/processed/mydata2.dta"

// Question 2: Data assumptions  

// a) For ghq12 total, bmi and age at interview check the distribution of your data by using the summarize, histogram and qnorm commands. Use the help files to make use of options to format your plots.  

local vars ghq_total bmi age

* (i)
summarize `vars'

foreach v of local vars {
	
	* (ii) histogram
	histogram `v', name("histo_`v'", replace) title("Histogram of `v'")
	
	* (iii) qnorm
	qnorm `v', name("qnorm_`v'", replace) title("Normality plot of `v'")
}

* combine all
#delim ;
graph combine 
histo_ghq_total histo_bmi histo_age
qnorm_ghq_total qnorm_bmi qnorm_age,
rows (2) name(p2a, replace);
#delim cr

// b) For ethnicity and sex check the distribution of your data by using the tabulate command
tabulate ethnicity sex, cell


// Question 3: Repeat question 2 but split the data by treatment allocation to look for differences in each population. Hint: use bysort, by and if options 

bysort treatment: summarize `vars'

foreach v of local vars {
	* (ii) histogram
	histogram `v', ///
		by(treatment) ///
		name("histo_`v'_byTrt", replace)
	
	* (iii) qnorm, see Q4 for alternative
	
	* qnorm `v' if treatment == 0, name("qnorm_`v'_byTrt0", replace)
	* qnorm `v' if treatment == 1, name("qnorm_`v'_byTrt1", replace)
}


// Question 4: 
// You will have noticed from question 3 you cannot use the by option for a qnorm plot so they appear in separate plots. Use the graph combine command to see them in the same plot. (Hint: make sure you have saved your plots in order to recall them in the graph combine command) 

local vars ghq_total bmi age

foreach v of local vars {
	
	* reset at the start of each loop
	local graphs
	levelsof treatment, local(trt_levels)
	
	foreach l of local trt_levels {
		tempname graph
		qnorm `v' if treatment == `l', ///
			name(`graph') title("treatment (`l')")
		local graphs `graphs' `graph'
	}
	graph combine `graphs', ///
		name("qnorm_`v'_byTrt", replace) ///
		title("Qnorm of `v' by treatment")
					
}


// Question 5: Scatter plot 

// a) Produce a scatter plot for weight vs height 
graph twoway ///
	(scatter weight height), ///
	name("p5a", replace)

// b) Add axis titles, title and a line of best fit 
graph twoway ///
	(scatter weight height) ///
	(lfit weight height), ///
	legend(off) ///
	name("p5b", replace) ///
	title("Scatterplot of weight against height") ///
	ytitle("Weight (kg)") ///
	xtitle("Height (m)")

// c) Add a sentence to your do file interpreting this plot 

// Question 6: reproducibility of work  

// a) Close your log file and have a look at it, it will be found where you specified your working directory as a .smcl or .log file. 
log close


// b) You may wish to run your whole do file again so that you have a clean log file showing everything you have done (hint: you will need the replace option when opening your log file at the start of the do file if you wish to rerun and replace with a clean version) 