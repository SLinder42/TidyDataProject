TidyDataProject ReadMe
===============

Coursera Project about Creating Tidy Data Sets

##Introduction
This program takes the raw text files from the UCI Har Dataset folder and converts them so that the program returns a tidy data set of measurements after doing the following steps:

1. Merge the training and test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Merging the Data Sets
In order to get a complete data set, the program needs to find all of the data in the Dataset folder. Since all relevant data is in txt files, the program moves into the directory with the txt files and calls the `read.table` function to create data sets for the subjects (subject_train.txt and subject_test.txt), the activities (y_train.txt and y_test.txt), and the measurements(X_train.txt and X_test.txt). All of the txt files in the current directory are converted to data sets before switching directories to convert the others. Additionally, for the subject and activity data sets, the names of the variables are set to 'Subject ID' and 'Activity' so that they can be combined. The function `rbind()` is utilized to combine the corresponding train and test sets. Finally, `cbind()` converts the corresponding data sets into one raw data frame containing, in column order, the Subject ID, the Activity, and the measurements.

##Extracting Means and Standard Deviations
To find the means and standard deviations in the raw data, look at features_info.txt. This document gives an overview of all of the variables and what they do. I specifically picked the means and standard deviations when they referred to variable magnitude instead of a value along one of the coordinate planes. For example, tBodyAcc-mean()-X is not one of the extracted variables because it refers to the linear acceleration along the X plane. However, tBodyAccMag-mean() is extracted because it is assumed to be derived from the calculations of tBodyAcc-mean()-X, tBodyAcc-mean()-Y, and tBodyAcc-mean()-Z.
It may be possible to read features.txt into a data frame, pick the names of the variables to be extracted, match them with the columns in the raw data frame that have those variable names, and subset the raw data frame based on them. However, my implementation just takes the row numbers of the variable names I want from features.txt in a numeric vector. From there the program adds 2 to the vector to shift it to the measured variables instead of looking at 'Subject ID' and 'Activity.' Finally, it subsets the columns containing those desired variables with the corresponding Subject ID and Activity values. If you change the vector that identifies the columns with the measured values, the subset will be Subject ID, Activity, then the measured values in the new columns chosen.
 
##Naming the Activities
The names of the activities are described in the activity_labels.txt document in the UCI HAR Dataset folder. I did not feel these names were formatted well enough to read in a tidy data set, so I just made a vector of strings with the same names except without all capitalization and with spaces instead of underscores. Like in the previous step, it would be possible to read activity_labels.txt into a data frame, match it to the numbers in the Activities column, and replace them with the descriptive terms. Either way the data set becomes easier to understand. The plyr library needs to be loaded in order to call `mapvalues()` since it is a way to find and replace the numeric values with the values in the string in one line of code.

##Labeling the Measured Variables
Like with the last step, it is possible to read features.txt into a data frame, match the names to the subsetted measured variable columns, and change the names from the generic V* designation to the more descriptive variable names. Since I called the variable columns manually, I just changed each variable name in the data frame separately based on what I found in the text document. You need to start with the third variable name because the first and second variables are Subject ID and Activity.

##Creating the Tidy Data Set
To make it easier to rearrange the data, I started with the original subset of the raw data frame. The new data frame still has the numbers associated with the activities. A new data frame is initialized so that when ordering the data in the old data frame the tidy rows can be deposited in the data frame in order. In a nested loop, the program takes all of the rows corresponding to Subject ID and then specific identity. The means of that subset x are found using `apply(x,2,mean)` to get the average of each column of values. After that, the row of means is added to the tidy data frame, and the loop moves onto the next activity with the same subject. If there are no more activities with the subject, then it moves onto the next subject until all subjects are exhausted.

The resulting data set is then a tidy data set. There is only one measurement for each varible corresponding to the subject performing an activity. Therefore a single observational unit is in one row, unlike in the raw data frame that stores one observational unit of subject and activity in multiple rows.

##Quality Assurance
If you want to test out the code, I recommend running the program, saving the result to a data frame, and writing the data frame to a txt file. Use these three lines of code to do it, assuming the R script is in the same directory of the UCI HAR Data set folder.
`source("run_analysis.r")`

`tdf <- run_analysis()`

`write.table(tdf,"TidyDataset.txt")`

##Additional Notes
This version of the project is supposed to be a complete implementation based on the instructions in the course project. You may notice that the txt file the program gives now is not the same one in the Course Project submission. The program run_analysis.r, the readme, and the codebook have all been modified since submission because they were incomplete and did not properly solve the problem given. Feel free to dock points accordingly.

##References

[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)