training_set <- read.csv2("TrainsetTugas1ML.csv", sep=",")
# dataset <- read.csv2("TrainsetTugas1ML.csv", sep=",")

### Split dataset to train and test set
# library(caTools)
# set.seed(123)
# split <- sample.split(dataset$income, SplitRatio = 0.8)
# training_set <- subset(dataset, split == TRUE)
# test_set <- subset(dataset, split == FALSE)

# Remove column 'id'
training_set$id <- NULL

# Feature Selection
# training_set$marital.status <- NULL

### Create table of probabilistics

# Initialize data frame containing probabilistic from 
# categories in each attributes
likelihood <- data.frame()

# Count prior probabilistics
# Here i simplified dependent value ">50K" as "Y or y" and "<=50K" as "N or n" 
Y <- training_set$income == ">50K"
lengthY <-length(Y[Y == TRUE])
lengthN <- length(Y[Y == FALSE])
lengthDependent <- length(Y)

priorY <- lengthY / lengthDependent
priorN <- lengthN / lengthDependent


# Iterate all column of training set excluding "income"
for (i in 1:(length(training_set)-1)){
  # Split an attribute based on its category
  colSplit <- split(training_set, training_set[i])
  
  # Initialize vectors containing likelihood probabilistics
  cPY <- cPN <- c()
  
  # Initialize data frame to summarize the likelihood
  pColDf <- data.frame()
  
  # Iterate for each cateogry
  for (x in colSplit) {
    # Get frequency of this category with label as ">50K"
    y <- x$income == ">50K"
    pY <- (length(y[y == TRUE]))
    pN <- (length(y[y == FALSE]))
    
    cPY <- c(cPY, pY)
    cPN <- c(cPN, pN)
  }
  
  cPY <- cPY / sum(cPY)
  cPN <- cPN / sum(cPN)
  
  # Merge the result data frame
  pColDf <- data.frame(y = cPY, n = cPN)
  row.names(pColDf) <- names(colSplit)  
  likelihood <- rbind(likelihood, pColDf)
}

### Predict
test_set <- read.csv2("TestsetTugas1ML.csv", sep=",")
test_set$id <- NULL

pred <- c()
for (i in 1:nrow(test_set)){
  posteriorY <- priorY
  posteriorN <- priorN
  
  for (col in test_set[i,]){
    category = as.character(col)
    posteriorY <- posteriorY * likelihood[category, "y"]
    posteriorN <- posteriorN * likelihood[category, "n"]
  }

  class <- ifelse(posteriorY > posteriorN, ">50K", "<=50K")
  pred <- c(pred, class)
}

write.table(pred, "TebakanTugas1ML.csv", row.names = FALSE, col.names = FALSE, quote=FALSE)
