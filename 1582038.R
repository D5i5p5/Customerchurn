#a

library(readxl)
library(AppliedPredictiveModeling)
library(caret)
library(lattice)
library(pROC)

# b
# Import CustomerChurn_1
Churn_1=read_excel(file.choose())
View(Churn_1)

# Import CustomerChurn_2 
Churn_2=read_excel(file.choose())
View(Churn_2)

#c
#Combine CustomerChurn_1 and CustomerChurn_2 into a complete data file
Churn_df=rbind(Churn_1,Churn_2)
View(Churn_df)

colnames(Churn_df)
str(Churn_df)

#d
#Covert categorical variable into factor variable. 
#Categoricsal variable State,area_code,international_plan,voice_mail_plan,churn are converted into factor
Churn_df[,c(1,3,4,5,20)]=lapply(Churn_df[,c(1,3,4,5,20)],as.factor)
str(Churn_df)

#Answer 1
#In the dataset the dependent variable is the churn, The variable churn has binary outcomes,yes and no
View(Churn_df[Churn_df$churn=="yes",]) # dependent variable output yes
View(Churn_df[Churn_df$churn=="no",])  # dependent variable output no

#Answer 2(a) Checking null values
colSums(is.na(Churn_df)) #

#b
#Checkining any near zero variance predictor
nearZeroVar(Churn_df)
#Remove zero variance
Churn_df=Churn_df[,-nearZeroVar(Churn_df)]
View(Churn_df)

#Answer 3
#Data spliting into training and testing

set.seed(1000)
ranuni=sample(x=c("Training","Testing"),size=nrow(Churn_df),replace=T,prob=c(0.8,0.2))
ranuni

TrngDt=Churn_df[ranuni=="Training",]
TstDt=Churn_df[ranuni=="Testing",]

nrow(TrngDt)
View(TrngDt)
nrow(TstDt)
View(TstDt)

#Training model

Training_model=glm(churn~.,family="binomial",Churn_df)
summary(Training_model)

#Optimize model by finding minimum AIC
Training_model=step(object=Training_model,direction = "both")
summary(Training_model)

#Roc curve for training data
train_roc=roc(response=Training_model$y,predictor=Training_model$fitted.values,plot=T)
train_roc$auc

#Creating classification table
train_pred = ifelse(test=Training_model$fitted.values>0.5,yes=1,no=0)
View(train_pred)

#Confusion matrix
table(Training_model$y,train_pred)




#Testing dataset
TstDt$churn=ifelse(TstDt$churn=="yes",1,0)
View(TstDt)

#Testing model
Testing_model=predict.glm(object=Training_model,newdata=TstDt,type="response")
summary(Testing_model)

#Roc curve for testing data
test_roc=roc(response=TstDt$churn,predictor =Testing_model,plot=T)
test_roc$auc

#Creating classification table
test_pred = ifelse(test=Testing_model>0.5,yes=1,no=0)
View(test_pred)

#Answer 4
#Confusion matrix
table(TstDt$churn,test_pred)





