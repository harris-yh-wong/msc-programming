clear

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

// b) For ethnicity and sex check the distribution of your data by using the tabulate command

// Question 3: Repeat question 2 but split the data by treatment allocation to look for differences in each population. Hint: use bysort, by and if options 


// Question 4: 
// You will have noticed from question 3 you cannot use the by option for a qnorm plot so they appear in separate plots. Use the graph combine command to see them in the same plot. (Hint: make sure you have saved your plots in order to recall them in the graph combine command) 

// Question 5: Scatter plot 

// a) Produce a scatter plot for weight vs height 

// b) Add axis titles, title and a line of best fit 

// c) Add a sentence to your do file interpreting this plot 


// Question 6: reproducibility of work  

// a) Close your log file and have a look at it, it will be found where you specified your working directory as a .smcl or .log file. 

// b) You may wish to run your whole do file again so that you have a clean log file showing everything you have done (hint: you will need the replace option when opening your log file at the start of the do file if you wish to rerun and replace with a clean version) 