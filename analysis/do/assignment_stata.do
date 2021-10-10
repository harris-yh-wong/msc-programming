clear

// SETUP
cd "C:\Users\Harris\projects\asmhi_programming"
log using "analysis/do/assignment_stata.log", replace

// 1 The Titanic Analysis

// 1.1. First, import the titanic spend.xlsx data.
import excel "data/source/titanic_spend.xlsx", firstrow

// 1.2. In the next question we will want to merge this dataset with titanic main.dta which is in wide format, reshape your loaded dataset in order to make a 1:1 merge possible. 
// Hint: you should end up with four daily spend variables, one for each day.
reshape wide daily_spend, i(id) j(day)

// 1.3. Merge this data with titanic main.dta and drop any non-merged data
merge 1:1 id using "data/source/titanic_main.dta", keep(match) nogenerate

// 1.4. Generate a new variable called fare_round which will round the fare to the nearest penny and label this variable
generate fare_round = round(fare, 0.01)
label variable fare_round "Fare rounded to the nearest penny"

// 1.5. Create a new variable called date_purchased2 which is date_purchased as a numerical date (i.e. number of days since 01Jan1960). Format this to be displayed as 01Jan1960.
generate date_purchased2 = date(date_purchased, "DMY")


*! Interpretations!!!!

// 1.6. Calculate the mean and SD of age at launch by if they survived or not*.
tabstat age, by(survived) statistics(mean sd)

// 1.7. Use the tabulate command in order to compare percentage of those survived by class *.
tabulate survived class, cell

// 1.8. Calculate the minimum, maximum, inter quartile range (IQR) and median fare by class *.
tabstat fare, by(class) statistics(min max iqr median)

// 1.9. Generate a variable which contains the row mean for the daily_spend variables.
local daily_spends daily_spend1 daily_spend2 daily_spend3 daily_spend4
egen spends_mean = rowmean(`daily_spends')
label variable spends_mean "Mean daily spends"

// 1.10. Use a loop to replace any missing values in the daily spend variables with the row mean.
foreach v of local daily_spends {
	replace `v' = spends_mean if `v' == .
}

// 1.11. Generate a variable indicating the number of people per cabin.
bysort cabinnumber: generate n_ppl_per_cabin = _N
label variable n_ppl_per_cabin "Number of people per cabin"


// 1.12. Produce a scatter graph for daily_spend against age for each day. Include a line-of-best-fit for each day. Add a title. Remove the legend. Make sure you save each graph.

reshape long daily_spend, i(id) j(day)
label variable daily_spend "Daily spending"

twoway (scatter daily_spend age) (lfit daily_spend age), ///
	/// title("Scatter of daily spend against age for each day among passengers of Titanic") ///
	ytitle(Daily spending) ///
	by(day, total legend(off))

* use graph combine


