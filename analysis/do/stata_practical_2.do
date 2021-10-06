clear

// Question 1: Preparing your do file 

// a) Open up Stata and open a new Do file 

// b) Set your working directory (hint: this should be where you have stored your data) 
cd "C:\Users\Harris\projects\asmhi_programming"

// c) Start a log file 
log using "analysis/do/stata_practical_2.log", replace

// d) Use mydata.dta from practical 1 
use "data/processed/my_data.dta"

// Question 2: Append with january_interview_1.dta 

// a) Use the append command to add the dataset january_interview_1.dta to your existing saved dataset 
append using "data/source/january_interview_1.dta"

// b) You will notice bmi isn't included in the new data. Use your code from practical 1 question 4(i) to generate bmi again for all participants.  

* note that the heights and weights are already in the right format in the right new dataset
replace bmi = weight / (height ^ 2)

// c) Save your data as mydata2.dta 
save "data/processed/mydata2.dta", replace

// Question 3: Merge with allocation.dta 

// a) Open the allocation.dta dataset. You may wish to use the browse and codebook functions to explore what variables you have. Are there any variables in this dataset you do not need to merge with your existing dataset? 
use "data/source/allocation.dta"
describe
* id is the primary key
* treatment does not exist in mydata2
* sex already eixsts in mydata2, no need to merge

// b) Open your saved dataset mydata2.dta 

use "data/processed/mydata2.dta"
describe

// c) Use the merge command to merge this `master' dataset with the `using' dataset allocation.dta. Hint: You should use the help file to find an option where you can specify which variables you wish to merge

merge 1:1 id using "data/source/allocation.dta", keepusing(id treatment)
browse

// d) Save your data as mydata2.dta. (Hint: remember to use the replace option)
save "data/processed/mydata2.dta", replace

// Question 4: Dates  

// a) Replace any interview dates `01/01/1900' with `.'. (Hint: You could use the display date command to help you with this) 

* display date("01/01/1900", "MDY") /// -21914
* date is stored as int
replace interview_date1 = . if interview_date1 == `=td(01jan1900)'
replace interview_date1 = . if interview_date1 == -21914

// b) List participants id and interview date for those who have interviews in December. (Hint: display date and inrange could help you with this) 
list id interview_date1 if month(interview_date1) == 12

// c) We do not want to include these participants in our analysis. Drop these participants from your dataset.
drop if month(interview_date1) == 12

// d) Use the interview date and date of birth variables to generate a new variable `age at first interview'. Don't forget to label any new variables you create. 

personage dob interview_date1, gen(age_fi)
label variable age_fi "age at first interview"
* alternatively
*** generate age_fi = year(interview_date1) - year(dob)

/// Question 5: GHQ 12 

// a) Replace any GHQ items that have missing data codes `777', `888' or `999' with `.'. (Hint: inlist could make your code more efficient) 

foreach v of varlist GHQ_12_01 - GHQ_12_12 {
	replace `v' = . if inlist(`v', 777, 888, 999)
}
*! How do I select these columns more generally with regex?

// b) Use the egen command to generate a variable called `ghq_missing' which will contain the number of missing GHQ items for each participant. Don't forget to label any new variables you create. 
egen ghq_missing = rowmiss(GHQ_12_01 - GHQ_12_12)
label variable ghq_missing "number of missing GHQ items"

// c) Use the egen command to generate a variable called `ghq_total' which will contain the total GHQ 12 score for those who had no missing items. Don't forget to label any new variables you create. (hint: if ghq_missing==0) 
egen ghq_total = rowtotal(GHQ_12_01 - GHQ_12_12) if ghq_missing == 0
label variable ghq_total "total GHQ score"
browse
* for reference, the GHQ total ranges from 0 to 36, with higher scores indiating worse conditions

// Question 6: reproducibility of work  

// d) Save your modified dataset with the name mydata2.dta 
save "data/processed/mydata2.dta", replace

// e) Close your log file and have a look at it, it will be found where you specified your working directory as a .smcl or.log file. 
log close

// f) You may wish to run your whole do file again so that you have a clean log file showing everything you have done (hint: you will need the replace option when opening your log file at the start of the do file if you wish to rerun and replace with a clean version) 

// EOF