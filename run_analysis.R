
#########################
# Required Libraries
#########################
install.packages("reshape")
library(reshape)
install.packages("dplyr")
library(dplyr)

#########################
# Folder Setup
#########################
# Create a directory called week4_assignment if it doesn't already exist


if( !grep("week4_assignment$", getwd() )) {
  dir.create("./week4_assignment")
  setwd("./week4_assignment")
}


#########################
# Data Download
#########################
# Download the .zip file containing the raw assignment and extract it into a file called samsung.zip
URL_FOR_ZIP <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL_FOR_ZIP, dest="samsung.zip", method="curl")
unzip("samsung.zip", exdir = "./")

#########################
# Data Import in Memory
#########################
# Load Activity Lookup Data
activity_labels <- read.csv('./UCI HAR Dataset/activity_labels.txt', header=FALSE, sep="") %>%
  rename("id"=V1, "label"=V2)
# Load Feature Lookup Data
feature_labels <- read.csv('./UCI HAR Dataset/features.txt', header=FALSE, sep="") %>%
  rename( "feature_index"=V1, "feature"=V2 )
# We are only interested in measurement on the mean and standard deviation
requiredMesurementIndexes <- grep( "mean\\(\\)|std\\(\\)", feature_labels$feature)
# Create friendly feature names

meanMatches <- grep( '-mean\\(\\)', feature_labels$feature )
stdMatches <- grep( '-std\\(\\)', feature_labels$feature )
timeMatches <- grep( '^t', feature_labels$feature )
frequencyMatches <- grep( '^f', feature_labels$feature )

feature_labels$feature <- gsub('^t', '', feature_labels$feature)
feature_labels$feature <- gsub('^f', '', feature_labels$feature)
feature_labels$feature <- gsub('BodyAcc-', 'Body Acceleration-', feature_labels$feature)
feature_labels$feature <- gsub('GravityAcc-', 'Gravity Acceleration-', feature_labels$feature)
feature_labels$feature <- gsub('BodyAccJerk-', 'Body Acceleration Jerk-', feature_labels$feature)
feature_labels$feature <- gsub('BodyGyro-', 'Body Gyroscope-', feature_labels$feature)
feature_labels$feature <- gsub('BodyGyroJerk-', 'Body Gyroscope Jerk-', feature_labels$feature)
feature_labels$feature <- gsub('BodyAccMag-', 'Body Acceleration Magnitude-', feature_labels$feature)
feature_labels$feature <- gsub('GravityAccMag-', 'Gravity Acceleration Magnitude-', feature_labels$feature)
feature_labels$feature <- gsub('BodyBodyAccJerkMag-', 'Body Body Acceleration Jerk Magnitude-', feature_labels$feature)
feature_labels$feature <- gsub('BodyBodyGyroMag-', 'Body Body Gyroscope Magnitude-', feature_labels$feature)
feature_labels$feature <- gsub('BodyBodyGyroJerkMag-', 'Body Body Gyroscope Jerk Magnitude-', feature_labels$feature)
feature_labels$feature <- gsub('BodyAccJerkMag-', 'Body Acceleration Jerk Magnitude-', feature_labels$feature)
feature_labels$feature <- gsub('BodyGyroJerkMag-', 'Body Gyroscope Jerk Magnitude-', feature_labels$feature)
feature_labels$feature <- gsub('-X$', 'On X-Axis', feature_labels$feature)
feature_labels$feature <- gsub('-Y$', 'On Y-Axis', feature_labels$feature)
feature_labels$feature <- gsub('-Z$', 'On Z-Axis', feature_labels$feature)

# Ultimately, we want to swap the location of Time\Frequency with Mean\Std
# Prefix feature name with either "Mean of" or "Standard Deviation of" depending on type and replace original content with a placeholder
feature_labels$feature[meanMatches] <- paste0( "Mean of ", feature_labels$feature[meanMatches] ) 
feature_labels$feature <- gsub( '-mean\\(\\)', 'TYPEPLACEHOLDER', feature_labels$feature )
feature_labels$feature[stdMatches] <- paste0( "Standard Deviation of ", feature_labels$feature[stdMatches] ) 
feature_labels$feature <- gsub( '-std\\(\\)', 'TYPEPLACEHOLDER', feature_labels$feature )
# Move Time\Frequency to the new placeholder
feature_labels$feature[timeMatches] <- gsub( 'TYPEPLACEHOLDER', ' Time ', feature_labels$feature[timeMatches]  )
feature_labels$feature[frequencyMatches] <- gsub( 'TYPEPLACEHOLDER', ' Frequency ', feature_labels$feature[frequencyMatches]  )

#########################
# Load Train Data
#########################
# Subject for each train entry
subject_train <- read.csv('./UCI HAR Dataset/train/subject_train.txt', header=FALSE, sep="") %>%
  rename("subject_id"=V1)
# Test set of features
X_train <- read.csv('./UCI HAR Dataset/train/X_train.txt', header=FALSE, sep="")
# Load activity labels
Y_train <- read.csv('./UCI HAR Dataset/train/Y_train.txt', header=FALSE, sep="") %>%
  rename( "id"=V1 )

#########################
# Load Test Data
#########################
# Subject for each test entry
subject_test <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header=FALSE, sep="") %>%
  rename("subject_id"=V1)
# Test set of Features
X_test <- read.csv('./UCI HAR Dataset/test/X_test.txt', header=FALSE, sep="")
# Load activity labels
Y_test <- read.csv('./UCI HAR Dataset/test/Y_test.txt', header=FALSE, sep="") %>%
  rename( "id"=V1 ) 

################################
# Generate Desired Train Table
################################

# Use subject_train as the base train table
train <- subject_train
# Join Y_train with activity labels
train_activities <- inner_join(Y_train, activity_labels, by="id") %>% select(label)
# Add activity label to the base train table
train$activity <- train_activities$label
# Rename the feature columns
names(X_train) <- feature_labels$feature
# Create frame containing only the required measurement columns (mean & standard deviation measurements)
X_train_reduced <- X_train[,requiredMesurementIndexes]
# Combine the training measurements with the train table
train <- cbind(train,X_train_reduced)

################################
# Generate Desired Test Table
################################

# Use subject_train as the base test table
test <- subject_test
# Join Y_test with activity labels
test_activities <- inner_join(Y_test, activity_labels, by="id") %>% select(label)
# Add activity label to the base test table
test$activity <- test_activities$label
# Rename the feature columns
names(X_test) <- feature_labels$feature
# Create frame containing only the required measurement columns (mean & standard deviation measurements)
X_test_reduced <- X_test[,requiredMesurementIndexes]
# Combine the training measurements with the train table
test <- cbind(test,X_test_reduced)


################################
# Combine Test & Training Data 
################################

complete <- rbind(train,test) %>% arrange( subject_id )

################################
# The complete data frame should now satisfy the following assignment requirements 
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement.
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive variable names.
################################

################################
# Tidy Data
################################

# Melt all the Columns Except subject_id and activity
tidySet <- melt( complete, id = c( "subject_id", "activity")  )

################################
# Group & Average Data
################################

# Group the tidy data by subject_id, activity, and variable
tidyBySubjectActivityVariable <- group_by( tidySet, subject_id, activity, variable )

# Use the summarize function to apply an average to the groups
averageData <- summarize( tidyBySubjectActivityVariable, average = mean(value) )
write.table( averageData, "./step5_averages.txt", sep=" ", row.name=FALSE)





