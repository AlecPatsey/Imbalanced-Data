Hello friends!
This is code and a link to a prezi presentation for an introduction to imbalanced classification. 
Some of what works and what doesnt!

Github limits the size of files, so the link to the data on kaggle is included below. 

This workflow can be run by downloading the data on your local machine and changing the directory
in the data variable in the first part of the workflow 'FraudEDA_Enginerring.R'.

Link to the data: 
https://www.kaggle.com/code/hjismshow/credit-card-fraud-prediction-in-r-accuracy-99-9/input

The end of the 'FraudEDA_Engineering.R' outputs a csv with the original data plus engineered features. 
Edit the directory to store it somewhere accessible on your local machine. 
We use this data to do feature selection for models downstream. 

To use LogisticRegressionFraud.R and TreesFraud.R you must change the data variable
in each file to the engineered fraud dataset that we created in the first part of the analysis.
I opted out of using Rmarkdown and instead chose to present results in presentation format
via prezi for a better learning experience. A link to the presentation is below. 

If you have any advice on how to make this a better learning experience please submit a request! 
This is intended to be a simple module for understanding imbalanced classification, I am not concerned
with increasing the complexity of the models to result in better performance. 

Link to presentation:
https://prezi.com/view/mhvwH3ugBWWTVNpyrK5o/
