rm(list = ls())
library(tidyverse)
library(dplyr)
library(caret)
library(PRROC)
library(pROC)
source("/Users/alecpatsey/Downloads/Stats/myfunctions.R")
data = read.csv("/Users/alecpatsey/Downloads/DataMining/334 Project/EngineeredFraud")
RNGkind (sample.kind = "Rounding") 
set.seed(0)

column_names <- names(data)
data_types <- sapply(data, class)
data.frame(Data_Type = data_types, stringsAsFactors = FALSE)

data$month <- as.factor(data$month)

LR_Model_df <-data %>% select(category,gender,city_pop,month,
                              age_of_user,log_amt, num_of_transactions,trans_day,time_of_day,is_fraud)
str(LR_Model_df)

p2 <- partition.2(LR_Model_df, 0.7) ## creating 70:30 partition
training.data <- p2$data.train
test.data <- p2$data.test


training.data$city_pop <- scale(training.data$city_pop)
training.data$age_of_user <- scale(training.data$age_of_user)
training.data$num_of_transactions <- scale(training.data$num_of_transactions)
training.data$log_amt <- scale(training.data$log_amt)

test.data$city_pop <- scale(test.data$city_pop)
test.data$age_of_user <- scale(test.data$age_of_user)
test.data$num_of_transactions <- scale(test.data$num_of_transactions)
test.data$log_amt <- scale(test.data$log_amt)

head(training.data)
head(test.data)

sum(test.data$is_fraud == 0)
sum(test.data$is_fraud == 1)
sum(training.data$is_fraud==1) / sum(training.data$is_fraud==0)
sum(test.data$is_fraud==1) / sum(test.data$is_fraud==0)

model <- glm(is_fraud ~ ., family = binomial(link='logit'), data=training.data)
summary(model)
predictions <- predict(model, newdata = test.data, type = "response")
data.frame(predictions)

###ROC CURVE###
roc_curve <- roc(test.data$is_fraud, predictions)
plot(roc_curve, main = "ROC Curve", col = "blue")
auc_value <- auc(roc_curve)
text(0.7, 0.5, paste("AUC =", round(auc_value, 2)), col = "black", cex = 1.2)

###PR CURVE###
pr_curve <- pr.curve(scores.class0 = predictions, weights.class0 = test.data$is_fraud, curve=TRUE)

plot(pr_curve, main = "Precision-Recall Curve")

###CONFUSION MATRIX###
pred.y.test <- ifelse(predictions > 0.04, 1, 0) 
confusionMatrix(as.factor(pred.y.test), as.factor(test.data$is_fraud), 
                positive = "1") 

## PRROC Is probably better for this data since imbalanced ##
## Logistic regression can be bad at unbalanced data because the training algorithm doesn't account for the 
## skewed distribution. This affects the model's intercept estimate, which skews the predicted probabilities.

## Down sampling or SMOTE can be used but not ideal, lets try another model. 
