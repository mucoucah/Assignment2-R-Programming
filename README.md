# Assignment2-R-Programming
This is the assingment submission as required for the Getting and Cleaning Data Week 4 project on Coursera
The assignment consists in downloading a data file (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), 
performing a variety of data transformations as described below and finally creating a tidy data set. The dataset comes from the study (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). See Acknoledgement at the end [1] . 


# Deliverables
1. **Merges the training and the test sets to create one data set.**
2. **Extracts only the measurements on the mean and standard deviation for each measurement.**
3. **Uses descriptive activity names to name the activities in the data set**
4. **Appropriately labels the data set with descriptive variable names.**
5. **From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

The Project2b.R file contains the necessary scripts to achieve the transformations. 
First we must load the two libraries used in this script:
```R
library(tidyr)
library(dplyr)
```

For deliverables 1 and 2 the following functions will do the job (one function is the argument for another):

```R
group_data(get_data())
```

The R code will download the data set while checking for the existence of the folder structure to house is and to house the new files created. 
IT starts with function get_data() being called without arguments and returning a list of path and files which is then used as arguments to the next  function group_data(). 
Function group_data() opens each of the test and train text files, processes its contents into a dataframe, displays the mean and summary of each variable (transposed to amke it easier to read on the screen) and then writes a csv file with the combined data from test+train files. 

Several tables are generated and displayed using the ``` View()``` command. 
This is the one of the outputs: 

Variable | mean | std_dev
--- | --- | ---
V1 | 3.62462374987863 | 1.74369533846602

The files containing the full dataset (test+train) are also save to the drive.
 
For the nest two deliverables (items 3 and 4), the following function is used:
```R
data_X_Y <- load_full_list()
```
This function will list the contents of the "full" folder, load the data from the study in one dataframe and then perform several transformations:
* replace the Activity number with the actual description (from file activity_labels.txt ) on each row
* replace the generic column names with the names from the features.txt and include the "Activity" name for the proper row
* make sure all column names are unique
* ```View()``` the resulting table 
* return the table as a dataframe so it can be used in the next step

The ``` load_full_list()``` function makes use of another function that it calls to "clean up" the column names from file features.txt before using it. 
The cleanup is performed by function ``` row_names_features()``` and it performs the following functions:
* remove all parentheses "(" and ")"
* replace commas "," and dashes "-" with underscore "_"
* returns a clean list of names to be used by ``` load_full_list()```


This is the (partial) outcome of the table display:

Activity | tBodyAcc_mean_X | tBodyAcc_mean_Y | tBodyAcc_mean_Z
--- | --- | --- | ---
STANDING | 0.25717778 | -0.0232852300 | -0.01465376
STANDING | 0.28602671 | -0.0131633590 | -0.11908252

The last two steps (5 and 6) are to clean up the dataset, make it tidy and write a new tidy dataset. 
This is accomplished by the function:
```R
tidy_data(data_X_Y)
```

IT take the dataframe from the previous function and gathers all variables in the columns placing them in rows (making a wide table long)

Then it groups by Activity and measurement, summarize (producing mean and dev) and ungroup the dataset. It then displays the resul of the transformation to the screen using ```View()``` and writes the tidy tibble to a csv file. 

This is the partial screen output:

Activity | Measurement | Mean | Std_dev
--- | --- | --- | ---
LAYING | angletBodyAccJerkMean_gravityMean | 0.016012617 | 0.3437564168
LAYING | angletBodyAccMean_gravity | 0.010365992 | 0.2203197153
 
 
 
 
 
 
 
  
   
    
    
Acknoledgement
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
