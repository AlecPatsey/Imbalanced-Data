## Clear workspace/Load Data and Packages ##
################################################
rm(list = ls())
library(tidyverse)
library(dplyr)
library(caret)

source("/Users/alecpatsey/Downloads/DataMining/334 Project/myfunctions.R")
data = read.csv("/Users/alecpatsey/Downloads/DataMining/334 Project/fraud test.csv")

RNGkind (sample.kind = "Rounding") 
set.seed(0)

#########EDA/Engineering #######################
################################################
length(data)
sum(is.na(data))
table(data$is_fraud) ##Comment on class imbalances 

# Count unique values for each column
uniques <- sapply(data, function(x) n_distinct(x))
data.frame(Unique_Values = uniques)

# Group by category, return summary statistics about each category
df_grouped <- data %>% 
  group_by(category) %>%
  summarize(n(), Fraud_Rate_percent=100*mean(is_fraud))
print(df_grouped)
## Comment on fraud rate for categories


# Extract date and month, create age.
data$date <- as.Date(data$trans_date_trans_time)
data$month <- month(data$date)
data$dob_year<-as.Date(data$dob, format = "%d/%m/%Y")
data$dob_year <- format(data$dob_year, "%Y")
data$transaction_year<-as.Date(dmy_hm(data$trans_date_trans_time), format = "%d/%m/%Y")
data$transaction_year <- format(data$transaction_year, "%Y")
data$age_of_user <- as.double(data$transaction_year)-as.double(data$dob_year)

hist(data$amt, breaks = 20, col = "lightblue", main = "Histogram of AMT", xlab = "Amount")
data$log_amt <- log(data$amt)
hist(data$log_amt, breaks = 20, col = "lightblue", main = "Histogram of Log-transformed 'amt'", xlab = "Log(Amount)")
names(data)

data$age_binned <- cut(data$age_of_user, 
                       breaks = c(15, 25, 35,45, 55, 65, 75, 85, 100),
                       labels = c("15-25", "25-35", "35-45", "45-55","55-65","65-75","75-85","85-100"),
                       right = FALSE)
df_grouped <- data %>% 
  group_by(age_binned) %>%
  summarize(n(), Fraud_Rate_percent=100*mean(is_fraud)) ## It seems the older you get the more susceptible to fraud
print(df_grouped)

###Create number of transactions on this account###
data$full_name<- paste0(data$first," ",data$last)
data <- data %>%
  group_by(full_name) %>%
  mutate(num_of_transactions = row_number()) %>%
  ungroup()

# Create DOW column, check rates for each DOW, and if its weekend. 
data <- data %>%
  mutate(
    trans_day = wday(as.Date(trans_date_trans_time, format="%d/%m/%Y"), label=TRUE))

df_grouped <- data %>% 
  group_by(trans_day) %>%
  summarize(n(), Fraud_Rate_percent=100*mean(is_fraud))
print(df_grouped)


# Bin Time and check rates.
data$trans_date_trans_time <- as.POSIXct(data$trans_date_trans_time, format = "%d/%m/%Y %H:%M")
data$time <- format(data$trans_date_trans_time, "%H:%M")
data$hour <- hour(data$trans_date_trans_time)
data$time_of_day <- cut(data$hour, 
                        breaks = c(0, 6, 12, 18, 24),
                        labels = c("Early Morning", "Morning", "Afternoon", "Evening"),
                        right = FALSE)
df_grouped <- data %>% 
  group_by(time_of_day) %>%
  summarize(n(), Fraud_Rate_percent=100*mean(is_fraud)) 
print(df_grouped)
## Interesting find, fraud rate is almost 12x higher @ night/Early

hist(data$hour,  main="Histogram of hour", xlab="Hour", col="pink", border="white")
fraud_data <- data[data$is_fraud == 1, ]
hist(fraud_data$hour, main="Histogram of hour (is_fraud = 1)", xlab="Hour", col="pink", border="white")

write.csv(data, "/Users/alecpatsey/Downloads/DataMining/334 Project/EngineeredFraud", row.names = FALSE)
