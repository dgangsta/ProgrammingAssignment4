# README.md

## Getting and Cleaning Data Course Project

<b>IMPORTANT NOTE:</b>  This script was tested on a Mac, directory references may need to be changed on a Windows computer.

The final data set was created by a single R script:
<b>run_analysis.R</b>

- run_analysus.R is broken up into several logical sections:
	1. Required Libraries (dplyr & reshape)
	2. Folder Setup
	3. Data Download
	4. Data Import into Memory
	5. Load Train Data
	6. Load Test Data
	7. Generate Desired Train Table
	8. Generated Desired Test Table
	9. Combine Test & Training Data
	10. Tidy Data
	11. Group & Average Data

	
Please refer to CodeBook.md and the inline comments of run_analysis.R for further implementation details.	

## How is the resulting data set tidy?
- As I am learning the concept of tidy data, I find myself constantly going back to the three main requirements that tidy data has:
	1. Each variable forms a column
	2. Each observation forms a row
	3. Each table/file stores data about one kind of observation
- Rule 1 is often up for interpretation and ultimately depends on the type of analysis you are trying to perform on your data.  It is fairly easy to be liberal with what makes up the scope of a "variable".  For our purposes, melting all features into a single column unified them as a single variable. This was possible due to the fact that all features hold the same kind of data (a normalized numeric value).  Subject_id and activity are also tidy as each are individual variables.  
- Rule 2 is satisfied by our melting of the original feature data sets. This took each feature recording into its own row, isolating it from the other readings and allowing us to treat them as individual observations.  I can see how this is quite useful. 
- Rule 3 is easy in this case as there is only one table.  The only question to ask if if this table needs to be split up into multiple tables.  This would only be the case if we consider the different features\measuremnets to be different kinds of observations.  These measurements are all taken at the same time for each subject_id and bodily gesture and hold simiilar data. In my opinion this safely binds them into the same kind of observation.   
	
	




