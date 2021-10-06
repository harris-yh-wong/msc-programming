clear

// Question 1: Preparing your do file 

// a) Open up Stata and open a new Do file 

// b) Set your working directory (hint: this should be where you have stored your data) 
cd "C:\Users\Harris\projects\asmhi_programming"

// c) Start a log file 
log using "analysis/do/stata_practical_1.log", replace

// Question 2: Get to know your data 

// a) Import your data 
import excel "data/source/November_interview_1.xlsx", firstrow
* first row as feature names

// b) Use the codebook command to have a look at the variables. Write as a comment in your do file which variables are string. 

codebook
* the following variables are string
* ds, has(type string)
* ethnicity  sex

// c) Label the variable dob with "Date of Birth" to make understanding easier 
label variable dob "Date of Birth"

// d) Label all the GHQ-12 variables such as GHQ_12_01 with "GHQ-12 question 1" 

foreach var of varlist GHQ_12_01 - GHQ_12_12 {
        label variable `var' "GHQ-12 question `=real(substr("`var'",8,9))'"
}




// Question 3: Format your data 



// a) Replace the ethnicity variable with the following codes: 1=White, 2=Black, 3=Asian, 4= Mixed and 5=Other (hint as this is a string variable, what you replace it with must also be string) 

replace ethnicity = "1" if ethnicity == "White"
replace ethnicity = "2" if ethnicity == "Black"
replace ethnicity = "3" if ethnicity == "Asian"
replace ethnicity = "4" if ethnicity == "Mixed"
replace ethnicity = "5" if ethnicity == "Other"


// b) Destring ethnicity so that it is a numeric variable 
destring ethnicity, replace

// c) Browse your data, what do you notice about this numeric variable compared to sex which is a string variable? Write as a comment in your do file.
browse ethnicity sex
* different text colour

// d) Label the ethnicity variable with the codes you replaced with. 

#delim ;
label define label_ethnicity
1 "White"
2 "Black"
3 "Asian"
4 "Mixed" 
5 "Other";
#delim cr

label value ethnicity label_ethnicity

// ALTERNATIVELY, parts (a) to (d) can be summarised as:
*** encode ethnicity, generate(ethnicity_n) label(label_ethnicity)
*** drop ethnicity
*** rename ethnicity_n ethnicity


// e) Browse your data, what do you notice about the labelled numeric ethnicity data compared to sex which is a string variable? Write as a comment in your do file. 
browse ethnicity sex
* different text color. Label values are displayed instead of the key

// f) Repeat this process for sex with 1=Male and 2=Female 

label define label_sex 1 "Male" 2 "Female"

encode sex, generate(sex_n) label(label_sex)
drop sex
rename sex_n sex

browse ethnicity sex

// Question 4: Generate a variable 

// a) BMI = weight/(height)^2, generate a variable called bmi using this formula 
generate bmi = weight / (height ^ 2)

// b) Use the codebook command to look at the variable you have generated 
codebook bmi

// c) BMI should always be greater than 1, clearly something is not right here 

// d) View your data in Stata and see if you can see any issues 


// e) An issue in the calculation is the missing date codes. List id and weight if weight = 777 or weight = 888 or weight = 999 
list id weight if inlist(weight, 777, 888, 999)

// f) Replace weight = . if weight =777 or 888 or 999 
replace weight = . if inlist(weight, 777, 888, 999)

// g) Do the same for height
replace height = . if inlist(height, 777, 888, 999)

// h) Another issue is that height must be metres for this formula to work. Replace height= height/100 in order to convert these heights to metres 
replace height = height / 100

// i) Generate bmi again using the same formula (hint: remember you will need to drop the old incorrect variable called bmi) 

replace bmi = weight / (height ^ 2)


// j) Use the codebook command to check that bmi now looks sensible. Remember to label any new variables you generate. 
label variable bmi "body-mass index"
codebook bmi

// Question 5: exploring the data  

// a) Browse the data for all females (hint: remember you have already recoded the sex variable to female = 2) 
browse if sex == 2

// b) List id sex and bmi if bmi is greater than 25 and the participants are female 
list id sex bmi if bmi > 25 & sex == 2

// c) Do the same for if participants are male 
list id sex bmi if bmi > 25 & sex == 1

// d) What do you notice about the list for males compared to the list for females? Can you recall from the lecture why this is happening? Write this as a comment in your do file. 
* include missing values (anything else?)

// e) Can you think how you would overcome this? Have a go at writing some code so that the missing values are not included 
list id sex bmi if bmi>25 & bmi != . & sex == 2
list id sex bmi if bmi>25 & bmi != . & sex == 1

** alternatives
*** !missing(bmi)
*** bmi != .

// Question 6: reproducibility of work  

// a) Save your modified dataset with the name my_data.dta 
save "data/processed/my_data.dta", replace

// b) Close your log file and have a look at it, it will be found where you specified your working directory as a .smcl or .log file. 


// c) You may wish to run your whole do file again so that you have a clean log file showing everything you have done (hint: you will need the replace option when opening your log file at the start of the do file if you wish to rerun and replace with a clean version) 

// end
log close