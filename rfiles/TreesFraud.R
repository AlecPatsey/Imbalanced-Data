######Random Forrest#########
rm(list = ls())
library(tidyverse)
library(dplyr)
library(caret)
library(randomForest)
library(tree)
library(pROC)
library(PRROC)

source("/Users/alecpatsey/Downloads/Stats/myfunctions.R")
data = read.csv("/Users/alecpatsey/Downloads/DataMining/334 Project/EngineeredFraud")
RNGkind (sample.kind = "Rounding") 
set.seed(0)

names(data)
data_types <- sapply(data, class)
data.frame(Data_Type = data_types, stringsAsFactors = FALSE)

RF_Model_df <-data %>% select(merchant,category,amt,gender,lat,long,city_pop,
                              job,merch_lat,merch_long,month,age_of_user,num_of_transactions,
                              trans_day, hour, is_fraud)

RF_Model_df <- RF_Model_df %>% mutate(is_fraud = ifelse(is_fraud==0, "no","yes"))
RF_Model_df$is_fraud <- as.factor(RF_Model_df$is_fraud)
str(RF_Model_df)


p2 <- partition.2(RF_Model_df, 0.7) ## creating 70:30 partition
training.data <- p2$data.train
test.data <- p2$data.test

sum(training.data$is_fraud=="yes") / sum(training.data$is_fraud=="no")
sum(test.data$is_fraud=="yes") / sum(test.data$is_fraud=="no")


rf_model<-randomForest(is_fraud~.,data=training.data,mtry=11,ntree=50,nodesize=1,importance=T)
importance(rf_model)
varImpPlot(rf_model,col=12,pch=19)


predicted_probabilities <- predict(rf_model, newdata = test.data, type="prob")
df <- as.data.frame(predicted_probabilities)
predicted_probabilities_no<- df[, 1]
predicted_probabilities_yes <- df[, 2]
predicted_labels <- ifelse(predicted_probabilities_yes > .12, "yes", "no")
confusionMatrix(as.factor(predicted_labels), as.factor(test.data$is_fraud), positive="yes")

#ROC#
roc_curve <- roc(test.data$is_fraud, predicted_probabilities_yes)
plot(roc_curve, main = "ROC Curve", col = "blue")
auc_value <- auc(roc_curve)
text(0.7, 0.5, paste("AUC =", round(auc_value, 2)), col = "black", cex = 1.2)


#PRROC#
pr_values <- pr.curve(scores.class0 = predicted_probabilities_yes,
                      weights.class0 = as.numeric(test.data$is_fraud == "yes"), curve = TRUE)
plot(pr_values, main = "Precision-Recall Curve", xlab = "Recall", ylab = "Precision", type = "l", lwd = 2)
