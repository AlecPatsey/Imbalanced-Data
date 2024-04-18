Github limits the file size to 25mb. The data was well over 200mb. Even zipped it was just shy of 100mb. 
 
Here I provide a link to the orignial data which can be run in the workflow by 
downloading the data on your local machine and changing the directory
in the data variable in the first part of the workflow 'FraudEDA_Enginerring'.

Link to the data: 
https://www.kaggle.com/code/hjismshow/credit-card-fraud-prediction-in-r-accuracy-99-9/input

The end of the 'FraudEDA_Engineering.R' outputs a csv with the original data plus engineered features. 
Edit the directory to store it somewhere accessible on your local machine. 
We use this data to do feature selection for models downstream. 

To use LogisticRegressionFraud.R and TreesFraud.R you must change the data variable
in each file to the engineered fraud dataset that we created in the first part of the analysis.
I opted out of using Rmarkdown and instead chose to present results in presentation format
via prezi for a better learning experience. A link to the presentation is below. 

Link to presentation:
https://prezi.com/view/mhvwH3ugBWWTVNpyrK5o/
