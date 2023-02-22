#they used a linear modle for M3
install.packages('mosaic')
library(dplyr)
library(mosaic)

#Our m3 using stepwise variable selection 

m3_hotels_dev <- stepAIC(m2_hotels_dev, direction = "both", 
              trace = FALSE, k = log(36000))



m3_pred <- predict(m3, hotels_val, type = "response")

values <- seq(0.99, 0.01, by = -0.01)
roc <- foreach(thresh = values, .combine = "rbind") %do% {
  yhat_baseline_3 <- ifelse(m3_pred > thresh, 1, 0)

  confusion_out_baseline_3 <- table(y = hotels_val$children, yhat = yhat_baseline_3)
  
  accuracy_date <- (confusion_out_baseline_3[1,1]+confusion_out_baseline_3[2,2]/confusion)


  TPR <-confusion_out_baseline_3[2,2]/(confusion_out_baseline[2,1]+confusion_out_baseline_3[2,2])
  FPR <-confusion_out_baseline_3[1,2]/(confusion_out_baseline[1,2]+confusion_out_baseline_3[1,1])

  df_rates <- data.frame(TPR, FPR)
  rbind(df_rates)
}

roc_curve <- ggplot(roc, aes(x = FPR, y = TPR)) +
  geom_line() +
  labs(x = "", y = "") +
  ggtitle("")