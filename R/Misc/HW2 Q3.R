library('dplyr')
library('tidyverse')
library('ggplot2')
library('caret')
library('leaps')
library('MASS')
install.packages('ISLR')
library(ISLR)
install.packages('modelr')
library(modelr)
M1 <- lm(children ~ market_segment + adults + customer_type 
        +   is_repeated_guest, data = hotels_dev)
summary(M1)

M2 <- lm(children ~ . - arrival_date, data = hotels_dev)
summary(M2)


#make this example reproducible
set.seed(1)

#create ID column
hotels_dev$id <- 1:nrow(hotels_dev)

#use 70% of dataset as training set and 30% as test set 
train <- hotels_dev %>% dplyr::sample_frac(0.70)
test  <- dplyr::anti_join(hotels_dev, train, by = 'id')

full_model <- lm(children ~ . - arrival_date, data = train)
#best model by AIC, both forwards and backwards
# Stepwise regression model
AIC_Both <- stepAIC(full_model, direction = "both", 
                      trace = FALSE)
summary(AIC_Both)

#Best model by BIC
BIC_Model <- stepAIC(full_model, direction = "both", 
                      trace = FALSE, k = log(45000))
summary(BIC_Model)

#Best Subset


m4 <- regsubsets(children ~ . - arrival_date, data=hotels_dev, nvmax = 30)
summary(m4)

m4_coef <- coef(m4, 30)


#Test 
names(m4)

rmse(AIC_Both, test)
rmse(BIC_Model, test)

