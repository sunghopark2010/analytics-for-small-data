# Load the data
setwd("~/analytics-for-small-data")
source.data <- read.csv("adult.data", col.names=c('age', 'workclass', 'fnlwgt', 'education', 'education-num', 'maritual-status', 'occupation', 'relationship', 'race', 'sex', 'capital-gain', 'capital-loss', 'hours-per-week', 'native-country', 'income-level'))
str(source.data)

library(mlbench)
data(Sonar)
str(Sonar[, 1:10])

# GBM
library(caret)
set.seed(2)
in.training <- createDataPartition(Sonar$Class, p=0.75, list=FALSE)
training <- Sonar[in.training, ]
testing <- Sonar[-in.training, ]

# Basic Parameter Tuning
fitControl <- trainControl(method="repeatedcv", number=10, repeats=1)
set.seed(825)
gbmFit1 <- train(Class ~ ., data=training, method="gbm", trControl=fitControl, verbose=FALSE)
gbmFit1

# Alternate Tuning Grids
gbmGrid <- expand.grid(interaction.depth = c(1, 5, 9), n.trees = (1:30) * 50, shrinkage = 0.1)
nrow(gbmGrid)
set.seed(231)
gbmFit2 <- train(Class ~ ., data=training, method="gbm", trControl = fitControl, verbose=FALSE, tuneGrid=gbmGrid)
gbmFit2

trellis.par.set(caretTheme())
plot(gbmFit2)

trellis.par.set(caretTheme())
plot(gbmFit2, metric="Kappa")

ggplot(gbmFit2)

# Change performance metric
fitControl <- trainControl(method = "repeatedcv", number=10, repeats=1, classProbs=TRUE, summaryFunction=twoClassSummary)
set.seed(825)
gbmFit3 <- train(Class ~ ., data=training, method="gbm", trControl=fitControl, verbose=FALSE, tuneGrid=gbmGrid, metric="ROC")
gbmFit3

# Choosing the best model
whichTwoPct <- tolerance(gbmFit3$results, metric="ROC", tol=2, maximize=TRUE)
cat("best model within 2 pct of best:\n")

gbmFit3$results[whichTwoPct, 1:6]

# Predict
predict(gbmFit3, newdata=head(testing))
pred <- prediction(predict(gbmFit3, newdata=testing, type="prob")$M, testing$Class=="M")
perf <- performance(pred, "auc")
perf
plot(perf)

# SVM
set.seed(825)
svmFit <- train(Class ~ ., data=training, method="svmRadial", trControl=fitControl, preProc=c("center", "scale"), tuneLength=8, metric="ROC")
pred <- prediction(predict(svmFit, newdata=testing, type="prob")$M, testing$Class=="M")
perf <- performance(pred, "tpr", "fpr")#, "auc")
perf
plot(perf)

# RDA
set.seed(825)
rdaFit <- train(Class ~ ., data=training, method="rda", trControl=fitControl, tuneLength=4, metric="ROC")
rdaFit

# Compare
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 2

resamps <- resamples(list(GBM=gbmFit3, SVM=svmFit, RDA=rdaFit))
resamps
summary(resamps)

trellis.par.set(theme1)
bwplot(resamps, layout=c(3, 1))

trellis.par.set(caretTheme())
dotplot(resamps, metric="ROC")

trellis.par.set(caretTheme())
xyplot(resamps, what="BlandAltman")

splom(resamps)

difValues <- diff(resamps)
difValues

summary(difValues)

trellis.par.set(theme1)
bwplot(difValues, layout=c(3, 1))

trellis.par.set(caretTheme())
dotplot(difValues)

# KS Graph
predicted.probs <- predict(gbmFit3, newdata=testing, type="prob")$M
predicted.probs.good <- predicted.probs[testing$Class=="M"]
predicted.probs.bad <- predicted.probs[!testing$Class=="M"]

x <- seq(min(predicted.probs.good, predicted.probs.bad), max(predicted.probs.good, predicted.probs.bad), length.out=max(length(predicted.probs.good), length(predicted.probs.bad)))
x0 <- x[which(abs(ecdf(predicted.probs.good)(x) - ecdf(predicted.probs.bad)(x)) == max(abs(ecdf(predicted.probs.good)(x) - ecdf(predicted.probs.bad)(x))))]
y0 <- ecdf(predicted.probs.good)(x0)
y1 <- ecdf(predicted.probs.bad)(x0)


ks.result <- ks.test(predicted.probs.good, predicted.probs.bad)
plot(ecdf(predicted.probs.good), do.points=FALSE, verticals=TRUE, col="blue")
lines(ecdf(predicted.probs.bad), do.points=FALSE, verticals=TRUE, col="green", add=TRUE)
#points(c(x0, y0), c(x0, y1), pch=16, col="red")
segments(x0, y0, x0, y1, col="red", lty="dotted")




# Decision Tree
# Random Forest
# Naive Bayes
# SVM
# Neural Network
# Logistic Regression
