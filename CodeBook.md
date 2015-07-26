# Getting and Cleaning Data Programming Assignment Code Book

This document describes the variables in data set, the way data is summarized, and the method for cleaning up the data.  

## Data Source

There original data comes from the smartphone accelerometer and gyroscope 3-axial raw signals, 
which have been processed using various signal processing techniques to measurement vector consisting of 561 features.
* [Raw dataset for this project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
* Data described at [this site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)       

## Data Sets

### Raw Data Set

The raw dataset was created using a regular expression to filter specific features (the measurements on the mean and standard deviation) from the original feature vector set:

`mean\\(\\)|std\\(\\)`

This regular expression selects 66 features from the original data set.
Combined with subject identifiers and activity labels, this makes up the
68 variables of the processed raw data set.

The training and test subsets of the original dataset were combined to produce final raw dataset.

### Output: Tidy Data Set

'uci-har-tidy-data.txt' contains the average of all feature standard deviation and mean values of the raw dataset. Original variable names were modified in the follonwing way:

 1. Replaced `-mean` with `Mean`
 2. Replaced `-std` with `Std`
 3. Replaced prefix 't' with 'time'
 4. Replaced 'Acc' with 'Accelerometer'
 5. Replaced 'Gyro' with 'Gyroscope'
 6. Replaced prefix 'f' with 'frequency'
 7. Replaced 'Mag' with 'Magnitude'
 8. Replaced 'BodyBody' with 'Body'
 9. Removed parenthesis `-()`

#### Sample of renamed variables compared to original variable name

 Raw data            | Tidy data 
 --------------------|--------------
 `subject`           | `subject`
 `activity`          | `activity`
 `tBodyAcc-mean()-X` | `timeBodyAccelerometerMeanX`
 `tBodyAcc-mean()-Y` | `timeBodyAccelerometerMeanY`
 `tBodyAcc-mean()-Z` | `timeBodyAccelerometerMeanZ`
 `tBodyAcc-std()-X`  | `timeBodyAccelerometerStdX`
 `tBodyAcc-std()-Y`  | `timeBodyAccelerometerStdY`
 `tBodyAcc-std()-Z`  | `timeBodyAccelerometerStdZ`

## Data Cleanup Method

The run_analysis.R script performs the following steps to clean the data:   

 1. Read X_train.txt, y_train.txt and subject_train.txt from the "./data/UCI HAR Dataset/train" folder and store them in *featuresTrain*, *activityTrain* and *subjectTrain* variables respectively.       
 2. Read X_test.txt, y_test.txt and subject_test.txt from the "./data/UCI HAR Dataset/test" folder and store them in *featuresTest*, *activityTest* and *subjectTest* variables respectively.  
 3. Concatenate *featuresTest* to *featuresTrain* to generate a new data frame, *features*; concatenate *activityTest* to *activityTrain* to generate a new data frame, *activity*; concatenate *subjectTest* to *subjectTrain* to generate a new data frame, *subject*.  
 4. Read the features.txt file from the "/data/UCI HAR Dataset/" folder and store the data in a variable called *featureNames*. Set variable names in *features* accordingly. 
 5. Combine *features*, *activity*, and *subject* into a single data frame, *allData*
 6. Extract only measurements on the mean and standard deviation, resulting in a 66 indices list. With the "subject" and "activity" columns added in, our data frame now has 68 columns. 
 7. Read the activity_labels.txt file from the "./data/UCI HAR Dataset/" folder and use to factorize the "activity" variable.
 8. Clean the column names of the subset as described in section above.   
 9. Use plyr library to create a new data frame, *finalData*, with aggregated data from *allData*: average all measurements for each combination of activity and subject, resulting in 180 total observations.
 
 
 10. Write the *finalData* out to "uci-har-tidy-data.txt" file in current working directory.  