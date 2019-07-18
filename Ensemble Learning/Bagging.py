
# coding: utf-8

# In[259]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.naive_bayes import GaussianNB


# In[326]:


# Import test dataset and train dataset
trainset = pd.read_csv("TrainsetTugas4ML.csv")
testset = pd.read_csv("TestsetTugas4ML.csv")

# Define independent varible and dependent variable used for this data
independent = ["X1", "X2"]
dependent = "Class"

# Number of model that will be ensembled
M = 100


# In[327]:


def predict(testset, trainset, M):
    bagging_pred = np.zeros(len(testset))
    
    for i in range(M):
        # Create new sub-trainset with length of n
        new_trainset = trainset.sample(n=150)
        
        # Create Naive Bayes model
        model = GaussianNB()
        model.fit(new_trainset[independent].values, new_trainset[dependent])
        
        # Convert value of Class 1 to -1 and 2 to 1
        # For easy predicting the data
        pred = np.array([-1 if p==1 else 1 for p in model.predict(testset[independent])])
        bagging_pred = np.add(bagging_pred, pred)
        
    # Convert value back to its original Class
    # If many result of predicitons are Class 1 then the sign of value will be -1(negative)
    # Else if the predictions are Class 2 then the sign will be 1(positive)
    bagging_pred = [1 if np.sign(p) == -1 else 2 for p in bagging_pred]
    return bagging_pred


# In[347]:


# Export result to CSV
y = pd.DataFrame(predict(testset, trainset, M), columns=["Class"])
y.to_csv("TebakanTugas4ML.csv", header=None, index=None)


# In[336]:


# Calculate Accuracy
accuracy = (predict(trainset, trainset, M) == trainset[dependent]).sum() / len(trainset) * 100
print("Accuracy= {}%".format(round(accuracy, 2)))

