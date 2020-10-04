## Function cleaningData reads the unstructured data, process it and gives back a tidy data convenient for further analysis.
## Note that the function does not require any arguments.

cleaningData <- function() {
  
  ## Working directory is outside the "UCI HAR Dataset" folder and therefore the necessary path is given to read the file.
  features <- read.table("../UCI HAR Dataset/features.txt")
  activityLabels <- read.table("../UCI HAR Dataset/activity_labels.txt")
  
  ## The training and the test sets are merged into one data set. The merging is done through different steps.
  ## The measurements read are merged first
  trainSet <- read.table("../UCI HAR Dataset/train/X_train.txt")
  testSet <- read.table("../UCI HAR Dataset/test/X_test.txt")
  dataSet <- rbind(trainSet,testSet)
  
  ## The data regarding the activities are read and merged in his step.
  trainActivities <- read.table("../UCI HAR Dataset/train/Y_train.txt")
  testActivities <- read.table("../UCI HAR Dataset/test/Y_test.txt")
  mergedActivities <- rbind(trainActivities, testActivities)
  
  ## The data regarding the subjects are read and merged finally.
  trainSubject <- read.table("../UCI HAR Dataset/train/subject_train.txt")
  testSubject <- read.table("../UCI HAR Dataset/test/subject_test.txt")
  mergedSubject <- rbind(trainSubject, testSubject)
  
  ## Only those measurements on the mean and standard deviation for each measurement are extracted.
  colnames(dataSet) <- features[,2]
  dataSet <- dataSet[grepl("mean()|std()",colnames(dataSet),ignore.case = TRUE)]
  
  ## Uses descriptive activity names to name the activities in the data set.
  fac <- factor(mergedActivities$V1)
  levels(fac) <- activityLabels$V2
  mergedActivities$V1 <- fac
  
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
  
  ## The tidy data set with the average of each variable for each activity and each subject is created and is exported as a csv file.
  tidyData <- mergedDataSet %>% group_by(SubjectID, Activities) %>% summarise(across(.fns = mean))
  write.table(tidyData, "TidyData.txt", row.names = FALSE)
}