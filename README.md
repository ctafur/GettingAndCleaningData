GettingAndCleaningData
======================

## Getting and Cleaning Data Project for Peer Assessment

This repo includes information for a peer assessed data project for the April 2014 offering of the Coursera Class Getting and Cleaning Data by Jeff Leek, Roger D. Peng, Brian Caffo, PhD.

The project assignment is to:

Prepare tidy data that can be used for later analysis using data at the below URL:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Project Requirements

The project requires submission of:

1) a tidy data set as described below under **Data Set Instructions** below

2) a link to a Github repository (this repository) with a script (run_analysis.R included in this repo) for performing the analysis

3) a code book that describes the variables, the data, and any transformations or work performed to clean up the data (CodeBook.md included in this repo). 

4) a README.md in the repo (the current file you are reading) that explains how all of the scripts work and how they are connected.  

## Data Set Instructions

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Project Description

### Files included:

As per the **Project Requirements** above this repo includes:

1. **README.md** - The current file that explains the assignment, documents the decisions made to address the assignment, identifies the files written to address the project requirements and documents the relationships between these files.
2. **run_analysis.R** - An R script that executes the analysis from download to data set creation and output (additional documentation on the operation of this file is available in the header of the file and the comments in the script).
3. **CodeBook.md** - A markdown file describing the variables, the data, and conventions used for the data set creation process (data transformations were all performed and are documented in the file **run_analysis.R**.

### Data Set Creation Decisions

Based on the **Data Set Instructions** above, the following interpretations / decisions were made:

1. **run_analysis.R** downloads the data set from the URL provided, reads the main files for the training and test data sets, and merges the test and training data sets to create a master data set (masterData in the run_analysis.R file) that is 10299 rows by 563 columns.  That is 7352 rows for the training set + 2947 rows for the test set for 10299 rows.  And 561 columns from the main data files + 1 subjectID column and 1 activityID column for 563 columns.  

  The complete data package includes a folder labeled "InertialSignals" in both the training and test folders.  After reviewing the course discussion forums it was  decided that for the purposes of this analysis the variables would be defined as those documented in the data set 'README.txt' file as the training set,'train/X_train.txt' and the test set, 'test/X_test.txt'.  Those variables available in the "IntertialSignals" folder were excluded for the purposes of this analysis.  

  For more information on this discussion please see: https://class.coursera.org/getdata-002/forum/thread?thread_id=28 (in particular Community TA David Hood's comment: "People have generally ignored the inertial signals, but like in any project where you are not sure about the spec, the magic sentence for the analyst is "for the purposes of this analysis, the variables were defined as...")

2. Since the instruction states extract "only the measurements on the mean and standard deviation for each measurement" it was decided to include all variable names that included either mean or std (for standard deviation) regardless of case or placement in the variable name.  This resulted in a selection of 86 variables in all. Other possible choices were names explicitly labeled mean() or std() (66 variables), or mean() + std() + meanFreq() (79 variables). The additional 7 variables included in this analysis represent those that represent the angle between two vectors.  As the instruction is somewhat ambiguous it was decided to err on the side of including excess information that could later be dropped rather than exclude information that might be required.

  In accordance with this instruction the master data set 'masterData' was subsetted to include only these 86 variables plus the subject and activity ID's for a total of 10299 rows by 88 columns.  This subsetting is reflected in **run_analysis.R** as subMaster.  After additional processng (run_analysis.R) this subset is written to the file 'uciHarMeanSdDataFull.csv' as tidy data set 1.

3. In order to label activities in the data set the 'activity_labels.txt' file was imported from the downloaded data and used to label the activity ID's provided with the test and training data sets by converting the activityID variable to a factor variable setting the levels equal to the id's and the labels for those levels equal to labels in the 'activity_labels.txt' file.  These steps are outlined and commented on in **run_analysis.R**.

4. Instruction 4 was interpreted as equivalent to instruction 3.  The data set was labeled with activity labels as described above.  Please see the discussion forum thread below for additional discussion of this topic.
https://class.coursera.org/getdata-002/forum/thread?thread_id=396

5. In order to create the second independent tidy data set with the average of each variable for each activity and each subject the final subsetted data used for tidy data set 1 'uciHarMeanSdDataFull.csv' was restructured using the melt and dcast functions in Hadley Wickham's reshape2 package using the casting formula: subjectID ~ activityID + variable, resulting in a data set with 30 rows (one for each subject) and 517 columns, where each column measure was appended with one of the 6 activities performed by the subject (6 activities * 86 variables = 516 + 1 subject ID = 517 **note:** activityID is eliminated since this information is merged with the variable names.  This data set was then written to the file 'uciHarDataSubbyActMean.csv'.

  This format was based on the tidy data principles as explained below:
  1. Each variable forms a column.
  2. Each observation forms a row.
  3. Each type of observational unit forms a table.

  Observational units are something like (a person, or a day, or a race) across attributes.

  So, in 'uciHarDataSubbyActMean.csv' the observational unit is the person which forms a row and the variables measure each person's movement (in various ways) across different activities. For additional discussion of this topic see:

  https://class.coursera.org/getdata-002/forum/thread?thread_id=146#comment-934



