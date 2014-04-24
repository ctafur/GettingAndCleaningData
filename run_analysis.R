###############################################################################
#                                                                             #
# The below script processes a zip file in the working directory downloaded   #
# from the below URL, using the commented commands.                           #
#                                                                             #
# 1. The script reads a training and test set from this file, and recombines  #
#    the files into a full data set.                                          #                         #                                                                             #
# 2. Once complete this data is subsetted to include only variables           #
#    concerning the mean and standard deviation.                              #
#                                                                             #
# 3. Activities in the data set are labeled with descriptive labels.          #
#                                                                             #
# 4.These lables are then assigned to the corresponding id's in the data set. #
#   Variable names are cleaned up to be more easily read.                     #
#                                                                             #
# 5. Finally the data set is reshaped to form a tidy data                     #
#    set with the average of each variable for each activity and each subject.# 
#    This data set is then written to a tab delimited file.                   #
#                                                                             #
# Alternate larger data sets may be written to file by uncommenting code      #
# written below where indicated and running the relevant command.  For        #
# additional detail about decisions made please see README.md and CodeBook.md #
# that are included in the repository with this script.                       #
#                                                                             #
###############################################################################

###############################################################################
#                             Data Download                                   #
###############################################################################
#                                                                             #
#  # Set the URL                                                              #
#  url<-"https://d396qusza40orc.cloudfront.net/                               #
#  getdata%2Fprojectfiles%2FUCI%20HAR%2# 0Dataset.zip"                        #
#                                                                             #
#  #Download the file                                                         #
#  download.file(url,"Dataset.zip")                                           #
#                                                                             #
#  # Set a time stamp                                                         #
#  downloadTime<-Sys.time()                                                   #
#                                                                             #
#  # Print the time stamp to the console                                      #
#  downloadTime                                                               #
#                                                                             #
#  # For the original script the file was downloaded:                         #
#  # 2014-04-21 01:07:46 EDT                                                  #
#                                                                             # 
###############################################################################

###############################################################################
#                        Check Packages Are Installed                         #
###############################################################################

# If reshape2 is not installed install it.
if("reshape2" %in% rownames(installed.packages()) == FALSE) {
  install.packages("reshape2")
}

# Load reshape2
library(reshape2)
  
###############################################################################
#     Get the activity labels and column names from the data set              #
###############################################################################

# Read in the activity labels 
activityLabels <- read.table(unz("Dataset.zip", filename=
"UCI HAR Dataset/activity_labels.txt"), sep=" ",
col.names=c("activityID","activityLabel"))

# Read in the column names from features.txt
colNames <- read.table(unz("Dataset.zip", filename=
"UCI HAR Dataset/features.txt"), sep=" ", col.names=c("colNo","colName"))

###############################################################################
#          Clean up the column names and activity labels                      #
###############################################################################

# Make activity labels lower case
activityLabels[["activityLabel"]]<-tolower(activityLabels[["activityLabel"]])

# Replace underscore with camelCaps for upstairs
activityLabels[["activityLabel"]]<-sub("_u","U",
activityLabels[["activityLabel"]], fixed=F)

# Replace underscore with camelCaps for downstairs
activityLabels[["activityLabel"]]<-sub("_d","D",
activityLabels[["activityLabel"]], fixed=F)

# Make column names sytactically valid
colNames[["colName"]]<-make.names(colNames[["colName"]],unique=T)

# Remove excess .. from column names
colNames[["colName"]]<-sub("..","",colNames[["colName"]], fixed=T)

# Remove ending . from column names
colNames[["colName"]]<-sub("\\.$","",colNames[["colName"]], fixed=F)

# Lower case x's
colNames[["colName"]]<-sub("X","x",colNames[["colName"]], fixed=F)

# Lower case y's
colNames[["colName"]]<-sub("Y","y",colNames[["colName"]], fixed=F)

# Lower case z's
colNames[["colName"]]<-sub("Z","z",colNames[["colName"]], fixed=F)

# Fix variable to include dot
colNames[["colName"]]<-sub("tBodyAccJerkMeangravityMean",
"tBodyAccJerkMean.gravityMean",colNames[["colName"]], fixed=F)

# Fix variable to include label Mean at end
colNames[["colName"]]<-sub("angle.tBodyAccMean.gravity",
"angle.tBodyAccMean.gravityMean",colNames[["colName"]], fixed=F)

# Fix variable to include label Mean at end
colNames[["colName"]]<-sub(".gravityMean","BYgravityMean",
colNames[["colName"]], fixed=F)

# Fix variable to include label Mean at end
colNames[["colName"]]<-sub("angle.","angleV",colNames[["colName"]], fixed=F)

###############################################################################
#     Get the subject ID's from the training and test set and combine         #
###############################################################################

# Read in the subject ID's from the training set
subjectIDTrn<- read.table(unz("Dataset.zip", filename=
"UCI HAR Dataset/train/subject_train.txt"),col.names="subjectID")

# Read in the subject ID's from the test set
subjectIDTst<- read.table(unz("Dataset.zip", filename=
"UCI HAR Dataset/test/subject_test.txt"),col.names="subjectID")

# Append the test set subject ID's to the training set ID's
subjectID<-rbind(subjectIDTrn,subjectIDTst)
  
# Convert subjectID to a factor
subjectID<-factor(subjectID[[1]])

###############################################################################
#      Get the activity ID's from the training and test set and combine       #
###############################################################################

# Read in the activity ID's from the training set
activityIDTrn<- read.table(unz("Dataset.zip", filename=
"UCI HAR Dataset/train/y_train.txt"),col.names="activityID")

# Read in the activity ID's from the test set
activityIDTst<- read.table(unz("Dataset.zip", filename=
"UCI HAR Dataset/test/y_test.txt"),col.names="activityID")
  
# Append the test set activity ID's to the training set ID's
activityID<-rbind(activityIDTrn,activityIDTst)
  
# Convert activityID to a factor and label the levels
activityID<- factor(activityID[[1]], levels=activityLabels[["activityID"]],
labels=activityLabels[["activityLabel"]])
  
###############################################################################
#             Get the training and test data and combine                      #
###############################################################################

# Read in the main training data
trainMain<- read.table(unz("Dataset.zip", filename=
"UCI HAR Dataset/train/X_train.txt"),col.names=colNames[["colName"]])
  
# Read in the main test data
testMain<- read.table(unz("Dataset.zip",filename=
"UCI HAR Dataset/test/X_test.txt"),col.names=colNames[["colName"]])
  
# Append the test data to the training data
dataMain<-rbind(trainMain,testMain)

###############################################################################
#                       Assemble the full data set                            #
###############################################################################

# Create a data frame that includes the subjectID, activityID and main data
masterData<-data.frame(subjectID,activityID,dataMain)
  
###############################################################################
#                Extract a data set with only means and sd's                  #
###############################################################################
  
# Get the column names from the master data set
meanSdCols<-names(masterData)

# Create an index of any column name that includes mean or std
# (case insensitive)
meanSdInd<-grep("mean|std",meanSdCols,ignore.case=T)

# Subset the column names by the index above
meanSdCols<-meanSdCols[meanSdInd]

# Subset the masterData set to include subjectID, activityID and measures of
# means and sd's
subMaster<-masterData[,c("subjectID","activityID",meanSdCols)]

###############################################################################
# create a tidy data set with the average of each variable for each activity  #
# and each subject.                                                           #
###############################################################################
  
# Use the melt function from the reshape2 package to melt the data frame
subMelt<-melt(subMaster, id.vars=c("subjectID","activityID"))
  
# Cast the data frame to 30 rows (one for each subject) by 517 columns.  
# See the README.md for discussion of this decision.
meanSet<-dcast(subMelt,subjectID ~ activityID + variable,mean,drop=F)

# Replace underscore with . to be consistent
names(meanSet)<-sub("_",".",names(meanSet), fixed=F)
  
# Write the tidy data set (with the average of each variable for each
# activity and each subject) to a tab delimited text file.
write.table(meanSet, file="uciHarbySubActMean.txt", sep="\t")

###############################################################################
#                       Output additional data sets                           #
#                Unconmment where indicated for other data sets               #
###############################################################################

# Write the full data set to a tab delimited txt file.
# Uncomment the line below for an output of the full data set.
# write.table(masterData, file="uciHarFull.txt", sep="\t")


# Write data set (for the means and standard deviations) to a tab delimited 
# text file.
# Uncomment the line below for an output of the data set including mean and sd
# write.table(subMaster, file="uciHarMeanSdDataFull.txt", sep="\t")
