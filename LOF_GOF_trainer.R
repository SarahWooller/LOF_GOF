set.seed(12345)
library(plyr)
library(randomForest)

#To use this script you will need to change my_training_file_path
#to wherever you have stored your training set in the line below

my_training_file_path = "TrainingSet-27features.csv"

# and also my_trained_model_path in the line
#to the path where you want to store your trained model

my_trained_model_path = 'trained_model.rds'

#Nothing below this line should need changing
#############################################################################
data <- read.csv(my_training_file_path,header=TRUE,row.names = 1) # Read Data

colnames(data)[1] <- "Class"  # assign response class
# split data in to predictors and response
dataX <- data[,2:length(data)]
dataY <- as.factor(data[,1])

# handle missing values to median. Can also use mean , mode
impute.value <- function(x) replace(x, is.na(x), median(x, na.rm = TRUE))
data.new <- sapply(dataX, function(x){
    if(is.numeric(x)){
        impute.value(x)
    } else {
        x
    }
}
)
dataX <- as.data.frame(data.new) # create data frame


#############################################################################################
#! MODEL WITHOUT CROSS-VALIDATION !#
# ""ntree"" represents number of trees allowed to grow set accoring to your convienience
# ""nodesize"" regulates the depth of search in this case search depth is '5'.

data.train.rf = randomForest(x=dataX,y=as.factor(dataY),ntree=10, importance=TRUE,nodesize=5)
data.train.rf
Accuracy <- (1 - (sum(as.numeric(format(data.train.rf$confusion[,3],digits=7,nsmall=7))) / 2))

paste("prediction accuracy is :",format(Accuracy,nsmall=6))
Error.rate <- format(1 - Accuracy,nsmall = 6)
paste("OOB estimate of  error rate:",Error.rate )

### extract important variables ###
imp.variable <- data.frame(importance(data.train.rf,type=2))   ### you may choose type 1
imp.variable$names <- row.names(imp.variable)
imp.variable <-  imp.variable[order(imp.variable$MeanDecreaseGini,decreasing = T),]  ## descending list of variable importance

###   plot important variable ###
###varImpPlot(data.train.rf,sort = TRUE,main="Variable Importance",n.var=21)  # set number of top variables to plot here its 5



#############################################################################################
#!MODEL WITH CROSS-VALIDATION!#

data <- cbind(dataX,dataY)
colnames(data)[length(data)] <- "Class"

## Using built-in function ## PREFFER THIS METHOD
K = 10
rf.cv <- rfcv(dataX,dataY,cv.fold=K,step=0.7)   ## change value of cv.fold as required using K. Here it gives 10 fold cross-validation

# plot cross validation result #
performance <- as.data.frame(cbind((1 - rf.cv$error.cv),rf.cv$error.cv))
colnames(performance) <- c("Accuarcy","Error.rate")
print("accuracy and error rate per cross validation")
t(performance)
avg.accuracy <- format(mean(1 - rf.cv$error.cv),nsmall =4)
sd.accuracy <- format(sd(1 - rf.cv$error.cv),nsmall = 4)
paste("Average Accuracy is :",avg.accuracy,"±",sd.accuracy,"for",K,"fold cross validation")

##with(rf.cv,plot(n.var,error.cv,type="l",lwd="2"))   # this command plots prediction error of each validation set


saveRDS(rf,my_trained_model_path)













