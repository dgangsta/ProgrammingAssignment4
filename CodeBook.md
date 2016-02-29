
# Getting and Cleaning Data Course Project

## Data Dictionary - Tidy Human Activity Recognition Data 2016

### Source Data
The source of this data set can be found at:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

Please review ./UCI HAR Dataset/README.txt for a detailed explanation of the data sourced.

### Final Data Set

This data set was generated to obtain average of various mesurements that were calculated while observing subjects performing various bodily gestures.   

* subject_id		2
	- ID number of the subject recorded for this particular observation
		- 1..30

* activity 32
	- Description of activity performed during observation. Originally these values were referenced from activity_labels.txt and contain the following associated integer values
		- 1 - WALKING
		- 2 - WALKING_UPSTAIRS
		- 3 - WALKING_DOWNSTAIRS
		- 4 - SITTING
		- 5 - STANDING
		- 6 - LAYING 
* variable 128 
	- Description on the variable that was averaged.
	- The name identifies the following
		- measurement calculation averaged
			- mean
			- standard deviation
		- individual measurement recording
			- time
			- frequency
	   - signal type
	   		- Body Acceleration
	   		- Gravity Acceleration
	   		- Body Acceleration Jerk
	   		- Body Gyroscope 
	   		- Body Gyroscope Jerk
	   		- Body Acceleration Magnitude
	   		- Gravity Acceleration Magnitude
	   		- Body Body Acceleration Jerk Magnitude
	   		- Body Body Gyroscope Magnitude
	   		- Body Body Gyroscope Jerk Magnitude
	   		- Body Acceleration Jerk Magnitude
	   		- Body Gyroscope Jerk Magnitude-', feature_labels$feature) 
		- axis recorded
			- None specified
			- X-axis
			- Y-axis
			- Z-axis
	- Syntax of description:
		- `<Mean|Standard deviation> of <Signal Type> On <Individual Measurement Recording> <On <Axis>|''>`
			- e.g. Standard Deviation of Gravity Acceleration Time On Y-Axis
* average - 9
   - Calculated average for all mesurements types groups by activity and subject_id
   		- -1...1 (With a precision of 8 digits)

### Required Transformations

- In order to generate the data set above, the following transfomations were required:
	1. Data set located in /UCI HAR Dataset/activity_labels.txt were given labels (id, label)
	2. Data set located in /UCI HAR Dataset/Features.txt was extracted and give the following modifications:
		- Column names were changed to: feature_index and feature
		- Feature values were modified in the following manner
			- Features with a leading 't' were flagged as time related
			- Features with a leading 'f' were flagged as frequency related
			- Features containing 'mean()' were flagged as mean calculations
			- Features containing 'std()' were flagged as standard deviation calculations
			- The following string replacement were made across all features
				- BodyAcc -> Body Acceleration
				- GravityAcc -> Gravity Acceleration
             - BodyAccJerk -> Body Acceleration Jerk
             - BodyGyro -> Body Gyroscope
             - BodyGyroJerk -> Body Gyroscope Jerk
				- BodyAccMag -> Body Acceleration Magnitude
				- GravityAccMag -> Gravity Acceleration Magnitude
				- BodyBodyAccJerkMag -> Body Body Acceleration Jerk Magnitude
				- BodyBodyGyroMag -> Body Body Gyroscope Magnitude
				- BodyBodyGyroJerkMag -> Body Body Gyroscope Jerk Magnitude
				- BodyAccJerkMag -> Body Acceleration Jerk Magnitude
				- BodyGyroJerkMag -> Body Gyroscope Jerk Magnitude  
			- Features that ended with -X, -Y, -Z were respectfully replaces with strings ending with ' On X-Axis', ' On Y-Axis', 'On Z-axis'
			- Features flagged as mean calculations had the following operations performed
				- Prefixed with 'Mean of '
				- Replace 'mean()' with TYPEPLACEHOLDER 			- Features flagged as standard deviation calculations had the following operations
				- Prefixed with 'Standard Deviation of '
				- Replace 'std()' with TYPEPLACEHOLDER 			- Features flagged as time related had the following operations performed
				- Removal of leading t
				- Replace TYPEPLACEHOLDER with ' Time of '
		   - Features flagged as frequency related had the following operations performed
				- Removal of leading f
				- Replace TYPEPLACEHOLDER with ' Frequency of '
   3. A Temporary Train table was built with the following:
    	- Data set located in /UCI HAR Dataset/train/subject_train.txt was extracted to become the subject__id column 	
    	- Data set located in /UCI HAR Dataset/train/X_test.txt was extracted containing all measurement recording
    	- Data set located in /UCI HAR Dataset/train/Y_test.txt was extracted containing all activity indexes for each recording
    		- This data set was then joined wuth activity_labels.txt so that the activity label could be used in place of the name 	
    	- Data set in Step 2 containg feature was filtered to only contain features with 'mean()' and 'std()' in their names
  4. A temporary Test table was built in the same manner as step 3 using similarily named files in the /UCI HAR Dataset/test directory.
  5. Temporary Tables from steps 3 & 4 were merged to create a complete data set
  6. The complete data set was melted using subject_id and activity as ID variables.  This effectively moved all feature recordings into a variable column in order to make the table tidy by isolating individual observation in a single row.
  7. The complete data set was then grouped by subject_id, activity, & variable to generate the final data set containing average data.
 	
License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


   		
 	 			   	 	 	  	 

 