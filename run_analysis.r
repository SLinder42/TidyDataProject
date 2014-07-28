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
    rawmeanstdcols <- c(201,202,214,215,227,228,240,241,253,254,503,504,516,517,529,530,542,543)
    # Add 2 to each number to compensate for extra columns on the raw data frame
    meanstdcols <- rawmeanstdcols+2
    # Subset the data frame to show only those columns with activity and subject ID
    rawdf.sub1 <- rawdf[,c(1:2,meanstdcols)]
    
    # 3. Uses descriptive activity names to name the activities in the data set
    
    # Set up independent data frame
    df <- rawdf.sub1
    # Create a vector for all activity names in order
    activitynames <- c("Walking","Walking Upstairs","Walking Downstairs","Sitting","Standing","Laying")
    # Call library plyr
    library(plyr)
    # Assign activity names to the values
    df[,2]=mapvalues(df[,2],from=c(1:6),to=activitynames)
    
    # 4. Appropriately labels the data set with descriptive variable names.
    # Mean Acceleration on Body
    names(df)[3]="tBodyAccMag-mean"
    names(df)[4]="tBodyAccMag-std"
    names(df)[5]="tGravityAccMag-mean"
    names(df)[6]="tGravityAccMag-std"
    names(df)[7]="tBodyAccJerkMag-mean"
    names(df)[8]="tBodyAccJerkMag-std"
    names(df)[9]="tBodyGyroMag-mean"
    names(df)[10]="tBodyGyroMag-std"
    names(df)[11]="tBodyGyroJerkMag-mean"
    names(df)[12]="tBodyGyroJerkMag-std"
    names(df)[13]="fBodyAccMag-mean"
    names(df)[14]="fBodyAccMag-std"
    names(df)[15]="fBodyBodyAccJerkMag-mean"
    names(df)[16]="fBodyBodyAccJerkMag-std"
    names(df)[17]="fBodyBodyGyroMag-mean"
    names(df)[18]="fBodyBodyGyroMag-std"
    names(df)[19]="fBodyBodyGyroJerkMag-mean"
    names(df)[20]="fBodyBodyGyroJerkMag-std"
    
    # 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
    
    # Start again with the basic subset
    newdf <- rawdf.sub1
    # Reorder data frame so that Subject ID comes first then Activity
    orderdf <- newdf[order(newdf$'Subject ID',newdf$Activity),]
    # Initializes the empty data frame to get the tidy data set
    tidydf <- data.frame(matrix(ncol=20,nrow=0))
    # Initialize a start so that the loops keep moving through the rows
    q <- 0
    for (a in unique(orderdf$'Subject ID')) {
        for (b in unique(orderdf$Activity)) {
            # Move to the next row
            q <- q + 1
            # Subset all values for which Subject ID and Activity are in common
            x <- newdf[newdf$Activity==b&newdf$'Subject ID'==a,]
            # Take the mean of each column of values
            tidyvals <- apply(x,2,mean)
            # Put Subject ID, Activity, and Mean Values into the row
            tidydf[q,]=tidyvals            
        }
    }
    # Changes names of tidydf columns to match variables
    names(tidydf)=names(df)
    # Change activity values in tidydf to corresponding strings
    tidydf[,2]=mapvalues(tidydf[,2],from=c(1:6),to=activitynames)
    # Returns the tidy data set
    return(tidydf)
}

