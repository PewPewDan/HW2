### Problem #3

```{r}
library(readr)
library(dplyr)
library(MASS)
library(ISLR)
library(tidyverse)
library(ggplot2)
library(modelr)
library(rsample)
library(mosaic)
library(caret)
library(purrr)
data(SaratogaHouses)
hotels_dev = read_csv("Data/hotels_dev.csv")
hotels_val = read.csv("Data/hotels_val.csv")

hotels_dev$id <- 1:nrow(hotels_dev)

hotels_dev_split = initial_split(hotels_dev, prop = 0.8)
hotels_dev_train = training(hotels_dev_split)
hotels_dev_test = testing(hotels_dev_split)

#m0 is a model with no coefficients, it is an input for m3 
m0 = glm(children ~ 1,data = hotels_dev_train)

m1_hotels_dev = glm(children ~ market_segment + adults + customer_type + is_repeated_guest, data = hotels_dev_train, family = 'binomial')
m2_hotels_dev = glm(children ~ . - arrival_date, data = hotels_dev_train, family = 'binomial')

#m3 uses forward selection starting with a null model
m3_hotels_dev = stepAIC(m0, direction = "forward", trace = FALSE, k = log(36000))
#m4 uses backward selection starting with a full model (m2)
m_4_hotels_dev = stepAIC(m2_hotels_dev, direction = "backward", trace = FALSE, k = log(36000))
```
##RMSE Test
```{r}
rmse(m1_hotels_dev, data = hotels_dev_test)
rmse(m2_hotels_dev, data = hotels_dev_test)
rmse(m3_hotels_dev, data = hotels_dev_test)
```
##Out-of-Sample Predict test
```{r}
phat_test_children1 = predict(m1_hotels_dev, hotels_dev_test, type = 'response')
yhat_test_children1 = ifelse(phat_test_children1 > 0.5, 1, 0)
confusion_m1 = table(y = hotels_dev_test$children, yhat = yhat_test_children1)
confusion_m1

phat_test_children2 = predict(m2_hotels_dev, hotels_dev_test, type = 'response')
yhat_test_children2 = ifelse(phat_test_children2 > 0.5, 1, 0)
confusion_m2 = table(y = hotels_dev_test$children, yhat = yhat_test_children2)
confusion_m2

phat_test_children3 = predict(m3_hotels_dev, hotels_dev_test)
yhat_test_children3 = ifelse(phat_test_children3 > 0.5, 1, 0)
confusion_m3 = table(y = hotels_dev_test$children, yhat = yhat_test_children3)
confusion_m3

table(hotels_dev_test$children)
```

```{r}
# Accuracy Calculations
m1_accuracy = sum(diag(confusion_m1))/sum(confusion_m1)
m2_accuracy = sum(diag(confusion_m2))/sum(confusion_m2)
m3_accuracy = sum(diag(confusion_m3))/sum(confusion_m3)
null_accuracy = 8276/(8276+724)

m1_accuracy
m2_accuracy
m3_accuracy
null_accuracy

# Absolute Improvement 

m1_absimpr = m1_accuracy - null_accuracy
m2_absimpr = m2_accuracy - null_accuracy
m3_absimpr = m3_accuracy - null_accuracy

# Lift

m1_lift = m1_accuracy/null_accuracy
m2_lift = m2_accuracy/null_accuracy
m3_lift = m3_accuracy/null_accuracy
```

