## Getting And Cleaning Data: Programming Assignment
## Brock Butler

## Dataset Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## Data collected from the accelerometers from the Samsung Galaxy S smartphone

## This R script does the following:
##   - Merges the training and the test sets to create one data set.
##   - Extracts only the measurements on the mean and standard deviation for each measurement.
##   - Uses descriptive activity names to name the activities in the data set
##   - Appropriately labels the data set with descriptive variable names.
##   - From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Download data 
if(!file.exists("./data")) {
    dir.create("./data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/smartphoneData.zip",method="curl")

## Unzip file
unzip(zipfile="./data/smartphoneData.zip",exdir="./data")

## Read data from the following "UCI HAR Dataset" files
##   - test/subject_test.txt
##   - test/X_test.txt
##   - test/y_test.txt
##   - train/subject_train.txt
##   - train/X_train.txt
##   - train/y_train.txt
filePath <- file.path("./data" , "UCI HAR Dataset")

## Read activity files
activityTest  <- read.table(file.path(filePath, "test" , "Y_test.txt" ), header = FALSE)
activityTrain <- read.table(file.path(filePath, "train", "Y_train.txt"), header = FALSE)

## Read subject files
subjectTrain <- read.table(file.path(filePath, "train", "subject_train.txt"), header = FALSE)
subjectTest  <- read.table(file.path(filePath, "test" , "subject_test.txt"), header = FALSE)

## Read features files
featuresTest  <- read.table(file.path(filePath, "test" , "X_test.txt" ), header = FALSE)
featuresTrain <- read.table(file.path(filePath, "train", "X_train.txt"), header = FALSE)

## Merge training and test data
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

## Name variables
names(subject) <- c("subject")
names(activity) <- c("activity")
featuresNames <- read.table(file.path(filePath, "features.txt"), header = FALSE)
names(features) <- featuresNames$V2

## Merge all into a single data frame
subjectActivity <- cbind(subject, activity)
allData <- cbind(features, subjectActivity)

## Subset features to select only mean and stdev measurements
subsetFeatures <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
selectedNames <- c(as.character(subsetFeatures), "subject", "activity" )
allData <- subset(allData, select=selectedNames)

## Name activities with descriptive names
activityLabels <- read.table(file.path(filePath, "activity_labels.txt"), header = FALSE)
allData$activity <- as.factor(allData$activity)
levels(allData$activity) <- activityLabels$V2

## Label data set with descriptive variable names
names(allData)<-gsub("-mean", "Mean", names(allData))
names(allData)<-gsub("-std", "Std", names(allData))
names(allData)<-gsub("^t", "time", names(allData))
names(allData)<-gsub("^f", "frequency", names(allData))
names(allData)<-gsub("Acc", "Accelerometer", names(allData))
names(allData)<-gsub("Gyro", "Gyroscope", names(allData))
names(allData)<-gsub("Mag", "Magnitude", names(allData))
names(allData)<-gsub("BodyBody", "Body", names(allData))
names(allData)<-gsub("[()-]", "", names(allData))

## Write tiday data to text file
# write.table(finalData, file = "tidy_data.txt",row.name=FALSE)

## Create a second, independent tidy data set with the average of each 
## variable for each activity and each subject
library(plyr);
finalData <- aggregate(. ~subject + activity, allData, mean)
finalData <- finalData[order(finalData$subject,finalData$activity),]
write.table(finalData, file = "uci-har-tidy-data.txt",row.name=FALSE)

## All Done!
print("Processing Complete. Tidy dataset is written to uci-har-tidy-data.txt")

