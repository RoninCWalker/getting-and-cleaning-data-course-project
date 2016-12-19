# 1 - Merges the training and the test sets to create one data set.
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 - Uses descriptive activity names to name the activities in the data set
# 4 - Appropriately labels the data set with descriptive variable names.
# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of 
#     each variable for each activity and each subject.
#
# Author: Fei
####################################################################################

library(dplyr)

############
# Constants
DATASET_DIR <- paste(getwd(),"UCI HAR Dataset", sep="/")

###########
# Functions
downloadAndUnzipDataFile <- function() {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipFile <- paste(getwd(),"data.zip",sep = "/")
    dataDir <- NULL
    
    download.file(url, destfile = "data.zip")
    unzip(zipFile, exdir = ".")
}

# Returns the full path filename from the dataset base directory
getBaseDataFile <- function(name) {
    result <- paste(DATASET_DIR, name, sep="/")
}

# Returns the full path filename from the dataset base directory
getTestDataFile <- function(name) {
    result <- paste(DATASET_DIR, "test", name, sep="/")
}

# Returns the full path filename from the dataset base directory
getTrainDataFile <- function(name) {
    result <- paste(DATASET_DIR, "train", name, sep="/")
}
    

############
# Main() -->

downloadAndUnzipDataFile()

# Load Features and Label
features <- read.table(getBaseDataFile("features.txt"))
features_meanstd <- features[grep("mean[a-zA-Z]*\\(\\)|std\\(\\)", features[,2]),]

# Load the Labels
activity_labels <- read.table(getBaseDataFile("activity_labels.txt"))
activity_labels <- activity_labels[,2]

## TEST Data Set
# Load test data and subject
x_test <- read.table(getTestDataFile("X_test.txt"))
y_test <- read.table(getTestDataFile("y_test.txt"))
subject_test <- read.table(getTestDataFile("subject_test.txt"))
names(subject_test) = "subject" # Rename to column to subject
subject_test$type <- "test" # Add 1 more column to identify test dataset

# Filter out the features with Means and Standard Deviation measurements
names(x_test) = features[,2]
x_test = x_test[,features_meanstd[,1]]

# Map the id with the activity label, name it as Activity
# Rename the first column as Id
y_test$activity <- activity_labels[y_test[,1]]  
names(y_test)[1] <- "activityId"                        

# Bind both table together
test_data <- cbind(subject_test,y_test,x_test)


## TRAIN Data Set
# Load train data and subject
x_train <- read.table(getTrainDataFile("X_train.txt"))
y_train <- read.table(getTrainDataFile("y_train.txt"))
subject_train <- read.table(getTrainDataFile("subject_train.txt"))
names(subject_train) <- "subject"
subject_train$type <- "train" # Add 1 more column to identify train dataset

# Filter out the features with Means and Standard Deviation measurements
names(x_train) = features[,2]
x_train = x_train[,features_meanstd[,1]]

# Map the id with the activity label, name it as Activity
# Rename the first column as Id
y_train$activity <- activity_labels[y_train[,1]]  
names(y_train)[1] <- "activityId" 

# Bind all the training data
train_data <-cbind(subject_train, y_train, x_train)

## Row Merged both test data & train data
merged_data <- rbind(test_data, train_data)

# Final Steps
groupby_data <- merged_data %>% select(-type, -activityId) %>% group_by(subject, activity)
mean_colnames <- names(select(merged_data, -subject, -activity, -type, -activityId))
result <- result <- groupby_data %>% summarise_each(funs(mean))

write.table(result, "tidyMeans.txt", row.names = FALSE)
