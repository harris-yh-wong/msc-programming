clear

// Question 1: Preparing your do file 
// a) Open up Stata and open a new Do file 
// b) Set your working directory (hint: this should be where you have stored your data) 
cd "C:\Users\Harris\projects\asmhi_programming"
// c) Start a log file 
log using "analysis/do/stata_practical_3.log", replace


// Question 2: Merge your data 

// a) Import your data Follow-up_interview_2.dta
use "data/source/Follow-up_interview_2.dta"

// b) Merge with allocation.dta 
merge 1:1 id using "data/source/allocation.dta", keep(match) nogenerate

// Question 3: Reshape your data 

// a) What kind of format is this data in? (hint: is it long or wide?) 
* wide

// b) Reshape your data to long format generating a new variable called interview to indicate visit number (hint: think about what the stubs are here, which variables are recorded again at follow up?) 

* there are a set of 01-12 GHQ questions, they are recorded at each followup
* note that after the reshape, the ID is no longer the primary key

#delim ;
local GHQ 
GHQ_12_01 GHQ_12_02 GHQ_12_03 GHQ_12_04 GHQ_12_05 GHQ_12_06
GHQ_12_07 GHQ_12_08 GHQ_12_09 GHQ_12_10 GHQ_12_11 GHQ_12_12;
#delim cr

reshape long interview_date `GHQ', i(id) j(interview)

// c) What do you notice about the variables that do not change over time? i.e. ethnicity, sex, dob, height and weight? Write as a comment in your do file 

* their values are duplicated across different observations for the same id

// Question 4: Formatting your data 

// a) We need to format the data as we did in earlier practical sessions. Copy sections of your code from practical 1 question 3 to format your string variables 

* format ethnicity
#delim ;
label define label_ethnicity
1 "White"
2 "Black"
3 "Asian"
4 "Mixed" 
5 "Other";
#delim cr

encode ethnicity, generate(ethnicity_n) label(label_ethnicity)
drop ethnicity
rename ethnicity_n ethnicity

* format sex
label define label_sex 1 "Male" 2 "Female"

encode sex, generate(sex_n) label(label_sex)
drop sex
rename sex_n sex


// b) Generate bmi again using sections of your code from practical 1 question 4 (hint: make sure your missing values are recoded and your height is in metres) 

replace weight = . if inlist(weight, 777, 888, 999)
replace height = . if inlist(height, 777, 888, 999)
replace height = height / 100
generate bmi = weight / (height ^ 2)

// c) Format your missing data for interview_date
replace interview_date = . if interview_date == `=td(01jan1900)'
replace interview_date = . if interview_date == -21914

// d) As before, drop any participants who had an interview_date for interview 1 in December 
drop if month(interview_date) == 12


// e) Generate age using code from practical 2 question 4 
personage dob interview_date, gen(age_fi)
label variable age_fi "age at first interview"


// Question 5: Using loops  

// a) Previously we removed missing data codes from the GHQ-12 variable by variable. Can you use a loop to perform this task much more efficiently? (hint: remember the inlist command, this will make your code even more efficient) 
foreach v of local GHQ {
	replace `v' = . if inlist(`v', 777, 888, 999)
}

// b) You have been asked by investigators to recode the GHQ-12 scoring from 1, 2, 3, 4 to 0, 0, 1, 1 respectively. Use a loop and the recode command to do this (hint: (1 2 = 0) and (3 4 = 1))
foreach v of local GHQ {
	recode `v' (1 2 = 0) (3 4 = 1)
}

// c) Now that you have recoded GHQ-12, copy over your code from practical 2 to score it again (hint: egen) 
egen ghq_missing = rowmiss(`GHQ')
label variable ghq_missing "number of missing GHQ items"

egen ghq_total = rowtotal(`GHQ') if ghq_missing == 0
label variable ghq_total "total GHQ score"
codebook ghq_total

** extra
egen ghq_mean = rowmean(`GHQ') if ghq_missing == 0
label variable ghq_mean "mean GHQ score"
codebook ghq_mean
** end of chunk


// Question 6: reproducibility of work  

// a) Save your modified dataset with the name follow_up.dta 
save "data/processed/follow_up.dta", replace

// b) Close your log file and have a look at it, it will be found where you specified your working directory as a .smcl or.log file. 
log close

// c) You may wish to run your whole do file again so that you have a clean log file showing everything you have done (hint: you will need the replace option when opening your log file at the start of the do file if you wish to rerun and replace with a clean version) 

// EOF
