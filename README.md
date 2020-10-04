# Getting-and-Cleaning-Data-Course-Project

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
>
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
>
> <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>
>
> Here are the data for the project:
>
> <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
>
> You should create one R script called run_analysis.R that does the following.
>
>   1. Merges the training and the test sets to create one data set.
>   2. Extracts only the measurements on the mean and standard deviation for each measurement.
>   3. Uses descriptive activity names to name the activities in the data set
>   4. Appropriately labels the data set with descriptive variable names.
>   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
***

## Code walkthrough

A function is created which contains all the necessary code blocks that is required to turn an unstructured data into tidy data by following the instructions given.
```
cleaningData <- function() {
```
The working directory is set outside the UCI HAR Dataset folder and the appropriate path names are given while reading the data which is scattered through multiple folders.
The features and activity label are read first using `read.table()`.

        features <- read.table("../UCI HAR Dataset/features.txt")  
        activityLabels <- read.table("../UCI HAR Dataset/activity_labels.txt") 

The measurements of both the training set and the test set are read into R and are merged together using `rbind()`.

        ## The measurements read are merged first.
        trainSet <- read.table("../UCI HAR Dataset/train/X_train.txt")
        testSet <- read.table("../UCI HAR Dataset/test/X_test.txt")
        dataSet <- rbind(trainSet,testSet)

The same is done for both the sets of activity data and the subject ID data.

        ## The data regarding the activities are read and merged in his step.
        trainActivities <- read.table("../UCI HAR Dataset/train/Y_train.txt")
        testActivities <- read.table("../UCI HAR Dataset/test/Y_test.txt")
        mergedActivities <- rbind(trainActivities, testActivities)
    
        ## The data regarding the subjects are read and merged finally.
        trainSubject <- read.table("../UCI HAR Dataset/train/subject_train.txt")
        testSubject <- read.table("../UCI HAR Dataset/test/subject_test.txt")
        mergedSubject <- rbind(trainSubject, testSubject)

In order to extract only those measurements on the mean and standard deviation for each measurement, the merged data set is subset using `grepl()`.  
The column names are changed accordingly from the names given in the features.txt file.

        colnames(dataSet) <- features[,2]
        dataSet <- dataSet[grepl("mean()|std()",colnames(dataSet),ignore.case = TRUE)]
    
The activity data from the txt file is a vector of integers and should be changed so it uses descriptive activity names. The activity labels are descriptive enough and thus are used as the activity names for that variable in the data set.

        fac <- factor(mergedActivities$V1)
        levels(fac) <- activityLabels$V2
        mergedActivities$V1 <- fac
    
The different columns are merged here using `cbind()` to form the complete data set consisting of the activities, the subjectID and the measurements.
The variables should have proper descriptive names and are changed using `gsub()`. 
    
        ## The measurements, activity data and subject ID are merged altogether.
        mergedDataSet <- cbind(mergedSubject, mergedActivities$V1, dataSet)
  
        ## Appropriately labels the data set with descriptive variable names.
        cnames <- colnames(mergedDataSet)
        cnames[1:2] <- c("SubjectID", "Activities")
        cnames <- gsub("[()]","",cnames)
        cnames <- gsub("^t","Time",cnames)
        cnames <- gsub("^f","Frequency",cnames)
        cnames <- gsub("-", ".", cnames)
        colnames(mergedDataSet) <- cnames
  
Finally, a tidy data set with the average of each variable for each activity and each subject is created by using some `dplyr::` functions which are chained.
> Note : The `dplyr::` package should be loaded onto the workspace initially.

A csv file is exported containing the tidy data set using `write.csv()`.
```
    tidyData <- mergedDataSet %>% group_by(SubjectID, Activities) %>% summarise(across(.fns = mean))
    write.csv(tidyData, "TidyData.csv")
```
Or alternatively `write.table()` function can be used to export the data set in .txt format.
```
    write.table(tidyData, "TidyData.txt", row.names = FALSE)
```

***
