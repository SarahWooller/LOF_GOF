
set.seed(12345)
library(caret)
library(dplyr)
library(plyr)
library(randomForest)
library(plotROC)
library(pROC)
library(ggplot2)

#first run LOF_GOF_trainer.R and then run this script
#Change my_trained_model_path to wherever you store the trained model

my_trained_model_path="trained_model.rds"

#Change data_for_testing to wherever you have stored your csv file
data_for_testing = "data_for_testing.csv"

#and change predictions_file to the path where you want to store the predictions
predictions_file = "predictions.csv"

#Nothing below this line should need changing
################################################################################
rf<-readRDS(my_trained_model_path)

SL_data<-read.csv(file = data_for_testing)

SL.new <- sapply(SL_data[,2:24], function(x){
  if(is.numeric(x)){
    impute.value(x)
  } else {
    x
  }
}
)
SL_predictions<-predict(rf,SL.new)
write.csv(SL_predictions, file = predictions_file)
