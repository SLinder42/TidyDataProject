run_analysis <- function(dir=getwd()) {
    
    # Directory starts at working directory and is assumed to have the data set folder.
    # You can change the directory if necessary.
    
    # 1. Merges the training and the test sets to create one data set.
    
    # First, get the data sets in the training folder
    
    # Set the directory to the train folder
    setwd(paste(dir,"UCI HAR Dataset/train",sep="/"))
    # Reads the subjects into a data frame
    subjecttrain <- read.table("subject_train.txt")
    # Sets the column name to define subject ID
    names(subjecttrain)="Subject ID"
    # Read activities into a data frame
    activitytrain <- read.table("y_train.txt")
    # Sets the column name to define activity
    names(activitytrain)="Activity"
    # Read measurements into a data frame
    measuretrain <- read.table("X_train.txt")
    
    # Second, get the data sets in the test folder
    
    # Set the directory to the test folder
    setwd(paste(dir,"UCI HAR Dataset/test",sep="/"))
    # Reads the subjects into a data frame
    subjecttest <- read.table("subject_test.txt")
    # Sets the column name to define subject ID
    names(subjecttest)="Subject ID"
    # Read activities into a data frame
    activitytest <- read.table("y_test.txt")
    # Sets the column name to define activity
    names(activitytest)="Activity"
    # Read measurements into a data frame
    measuretest <- read.table("X_test.txt")
    
    # Third, combine data sets into one data set with train set first
    
    # Add subject ID train data frame to subject ID test data frame
    allsubjects <- rbind(subjecttrain,subjecttest)
    # Add activity train data frame to activity test data frame
    allactivities <- rbind(activitytrain,activitytest)
    # Add measurements train data frame to measurements test data frame
    allmeasurements <- rbind(measuretrain,measuretest)
    # Combine columns so that data frame columns are subject ID, activity,
    # and all measurements from that activity
    rawdf <- cbind(allsubjects,allactivities,allmeasurements)    
    
    # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
    
    # Get columsn on all mean and std magnitudes based on features.txt
    rawmeanstdcols <- c(201,202,214,215)
    # Add 2 to each number to compensate for extra columns on the raw data frame
    meanstdcols <- rawmeanstdcols+2
    # Subset the data frame to show only those columns with activity and subject ID
    rawdf.sub1 <- rawdf[,c(1:2,meanstdcols)]
    
    # 3. Uses descriptive activity names to name the activities in the data set
    
    # Create a vector for all activity names in order
    activitynames <- c("Walking","Walking Upstairs","Walking Downstairs","Sitting","Standing","Laying")
    for (i in nrow(rawdf)) {
        x <- rawdf.sub1[i,2]
        # Check the raw number against its actual descriptive activity name
        name <- activitynames[x]
        # Rename it to descriptive activity
        rawdf.sub1[i,2]=name
    }
    
    # 4. Appropriately labels the data set with descriptive variable names.
    df <- rawdf.sub1
    names(df)[3]="Mean Acceleration on Body"
    names(df)[4]="Standard Deviation Acceleration on Body"
    names(df)[5]="Mean Acceleration due to Gravity"
    names(df)[6]="Standard Deviation Acceleration due to Gravity"
    
    
    # 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
    
    return(df)
}

