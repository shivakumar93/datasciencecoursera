## Course Project - Getting and cleaning data
###Data Source 
Data was collected from [UCI machine learning repository]
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

###Data set Information:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
More information on the data collection method can be found on the link above
###Attribute Information:
For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

###Step1-Loading data sets :
First the zip file is downloaded using download.file(URL,destfile, mode="wb") and unzipped using unzip(). Note that mode is specified to be binary to facilitate error free reading of zip files. 
From the unzipped folder, data is transformed into variables in R using the read.table() function
- activity_labels.txt as activity_labels
- features.txt as features

###Step2 - Filter out only the values with mean and std deviation attributes from the files and merge the two tables :
firstly column 2 of features is read and the grep function is used to find only the names of the values which have the words 
mean or std in them. The result which is a series of row numbers is stored in featuresReq. The required column names in the second column of 
featuresreq is subsetted into featuresReq.Variables, which would facilitate the naming of columns for the final merged data. 
Next, the gsub function is used to replace the abbreviated values in featuresReq.Variables into proper descriptive names, ex:- f is replaced by frequency, t by time etc

Now the rest of the data from the unzipped folder is loaded into the workspace.

The following items are loaded now
- subject_test.txt as testSubID
- y_test.txt as testactlabels
- X_test.txt as testx, subsetted wrt to featuresReq to get only mean and std columns
- subject_train.txt as trainSubID
- y_train.txt as trainactlabels
- X_train.txt as trainx again by subsetting according to featuresReq

The train data columns are bound using cbind, similarly with the test data, then these two tables are merged by row using rbind 
to form a single data frame called MergedData. Then, the first 2 columns of MergedData are names as SubjectID and Activity resp, 
the rest of the column names are got from featuresReq.Variables.

###Step3 - create an independent tidy data set with the average of each variable for each activity and each subject.
 For this step we use the reshape2 package
 - We know from the above step heading that SubjectID and Activity are the deciding variables, hence converting them into factors.
 - Then we use the melt() func from reshape2 to convert MergedData according to SubjectID and Activity, 
  into a long narrow dataframe with the activity and their values listed according to the two factors specified.
 - Next using the dcast() func, we get the average of each variable in the MeltedData for each SubjectID and Activity and store this newtable into the variable CastedData.
 - Finally the CastedData is saved as a txt file called Tidy-Data.txt using write.table
 
 NOTE: -The above steps were performed on windows 10 64bit version. 
       - Rstudio version 3.3.1 nickname "Bug in Your Hair
 
 

