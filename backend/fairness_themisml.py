from themis_ml.datasets import german_credit
from themis_ml.metrics import mean_difference
import csv
import itertools
from sklearn.model_selection import train_test_split
import pickle
import numpy as np
import seaborn as sns
from sklearn import metrics
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.base import clone
#from experiment import Experiment

from themis_ml.postprocessing.reject_option_classification import \
SingleROClassifier
from themis_ml.linear_model import LinearACFClassifier


def subplot(data_csv):

    fig = plt.figure(figsize=(15,15))
    sns.set_context("paper", rc={"font.size":40,"axes.titlesize":40,"axes.labelsize":40}) 
    b = sns.countplot(y='gender', hue='prediction', data = data_csv) 
    plt.xticks(rotation=45, horizontalalignment='right',fontweight='bold',fontsize=200)
    plt.yticks(fontweight='bold',fontsize=200)
    b.tick_params(labelsize=13.5)
    return fig


def correlated_figure(data_csv):
    corrmat = data_csv.corr()
    fig = plt.figure(figsize=(10, 10))
    sns.heatmap(corrmat,vmax=.8, square=True,cmap='viridis',linecolor="white")
    return fig       

def confusion_matrix_csv(data_csv):

    lr,_,_,x_val,_,X,y = train_logistic_regression(data_csv)
    predictions = lr.predict(x_val)
    _, _, _, y_test = train_test_split(X, y, test_size=0.2, random_state=1)
    cm = confusion_matrix(y_test,predictions)
    df_cm = pd.DataFrame(cm, range(2), range(2))
    fig = plt.figure(figsize=(10,7))
    sns.set(font_scale=1.4) # for label size
    sns.heatmap(df_cm, annot=True, annot_kws={"size": 16}) # font size    
    return fig    
    
def train_logistic_regression(data_csv):

# list to store the names of columns
    list_of_column_names = []

    for row in data_csv:
        list_of_column_names.append(row)
    list_of_column_names.pop()
    list_of_column_names.pop()
    features = list_of_column_names
    training_data = data_csv
    X = training_data[features].values
    y = training_data["prediction"].values
    x_train, x_val,y_train,y_val=train_test_split(X,y, test_size = 0.2)

    clf_LR=LogisticRegression()
    clf_LR=clf_LR.fit(x_train,y_train)

    return clf_LR,x_train,y_train,x_val,y_val,X,y

def baseline_mean_difference_sex(data_csv):

    lr,_,_,_,_,X,y = train_logistic_regression(data_csv)
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    _ , sex_test, y_train, _ = train_test_split(data_csv["gender"], y, test_size=0.2, random_state=1)
    b_preds = lr.fit(
    X_train, y_train).predict(X_test)  

    return str(mean_difference(b_preds, sex_test)[0])  

def baseline_auc(data_csv):

    lr,_,_,_,_,X,y = train_logistic_regression(data_csv)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1)
    b_preds = lr.fit(
    X_train, y_train).predict(X_test)  

    try:
        ras = roc_auc_score(y_test, b_preds)
    except ValueError:
        ras = 0

    return str(ras)      
  

def baseline_mean_difference_race(data_csv):

    lr,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    _ , race_test, y_train, _ = train_test_split(data_csv["race"], y, test_size=0.2, random_state=1)
    b_preds = lr.fit(
    X_train, y_train).predict(X_test)  

    return str(mean_difference(b_preds, race_test)[0])  

def rpa_auc_sex(data_csv):
    lr,_,y_train,_,_,_,y = train_logistic_regression(data_csv)
    list_of_column_names = []

    for row in data_csv:
        list_of_column_names.append(row)
    list_of_column_names.pop()
    list_of_column_names.pop()
    features = list_of_column_names
    features_no_sex = [
    f for f in features if "gender" not in f]
    X_no_sex = data_csv[features_no_sex].values
    X_no_sex_train, X_no_sex_test, y_train, _  = train_test_split(X_no_sex, y, test_size=0.2, random_state=1)
    rpa_preds_no_sex = lr.fit(
    X_no_sex_train, y_train).predict(X_no_sex_test) 
    _ , _, y_train, y_test = train_test_split(data_csv["gender"], y, test_size=0.2, random_state=1)  

    try:
        ras = roc_auc_score(y_test, rpa_preds_no_sex)
    except ValueError:
        ras = 0

    return str(ras)      

def roc_auc_sex(data_csv):
    clf_LR,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    roc_clf = SingleROClassifier(estimator=clf_LR)
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    _ , sex_test, y_train, y_test = train_test_split(data_csv['gender'], y, test_size=0.2, random_state=1)
    roc_clf.fit(X_train, y_train)
    roc_preds_sex = roc_clf.predict(X_test, sex_test)
    try:
        ras = roc_auc_score(y_test, roc_preds_sex)
    except ValueError:
        ras = 0

    return str(ras)     

def roc_auc_race(data_csv):
    clf_LR,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    roc_clf = SingleROClassifier(estimator=clf_LR)
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    _ , race_test, y_train, y_test  = train_test_split(data_csv['race'], y, test_size=0.2, random_state=1)
    roc_clf.fit(X_train, y_train)
    roc_preds_race = roc_clf.predict(X_test, race_test)

    try:
        ras = roc_auc_score(y_test, roc_preds_race)
    except ValueError:
        ras = 0

    return str(ras)   

   

def rpa_auc_race(data_csv):
    lr,_,y_train,_,_,_,y = train_logistic_regression(data_csv)
    list_of_column_names = []

    for row in data_csv:
        list_of_column_names.append(row)
    list_of_column_names.pop()
    list_of_column_names.pop()
    features = list_of_column_names
    features_no_race = [
    f for f in features if "race" not in f]
    X_no_race = data_csv[features_no_race].values
    X_no_race_train, X_no_race_test, y_train, _  = train_test_split(X_no_race, y, test_size=0.2, random_state=1)
    rpa_preds_no_race = lr.fit(
    X_no_race_train, y_train).predict(X_no_race_test) 
    _ , _, y_train, y_test = train_test_split(data_csv["race"], y, test_size=0.2, random_state=1)  

    try:
        ras = roc_auc_score(y_test, rpa_preds_no_race)
    except ValueError:
        ras = 0

    return str(ras)   
           

def rpa_mean_difference_sex(data_csv):
    lr,_,y_train,_,_,_,y = train_logistic_regression(data_csv)
    list_of_column_names = []

    for row in data_csv:
        list_of_column_names.append(row)
    list_of_column_names.pop()
    list_of_column_names.pop()
    features = list_of_column_names
    features_no_sex = [
    f for f in features if "gender" not in f]
    X_no_sex = data_csv[features_no_sex].values
    X_no_sex_train, X_no_sex_test, y_train, _  = train_test_split(X_no_sex, y, test_size=0.2, random_state=1)
    rpa_preds_no_sex = lr.fit(
    X_no_sex_train, y_train).predict(X_no_sex_test) 
    _ , sex_test, y_train, _  = train_test_split(data_csv["gender"], y, test_size=0.2, random_state=1)  
    return str(mean_difference(rpa_preds_no_sex,sex_test)[0])

def rpa_mean_difference_race(data_csv):

    lr,_,y_train,_,_,_,y = train_logistic_regression(data_csv)
    list_of_column_names = []

    for row in data_csv:
        list_of_column_names.append(row)
    list_of_column_names.pop()
    list_of_column_names.pop()
    features = list_of_column_names
    features_no_race = [
    f for f in features if "race" not in f]
    X_no_race = data_csv[features_no_race].values
    X_no_race_train, X_no_race_test, y_train, _  = train_test_split(X_no_race, y, test_size=0.2, random_state=1)
    rpa_preds_no_race = lr.fit(
    X_no_race_train, y_train).predict(X_no_race_test) 
    _ , race_test, y_train, _  = train_test_split(data_csv["race"], y, test_size=0.2, random_state=1)  
    return str(mean_difference(rpa_preds_no_race,race_test)[0])    


def roc_mean_difference_sex(data_csv):

    lr,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    roc_clf = SingleROClassifier(estimator=lr)
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    _ , sex_test, y_train, _  = train_test_split(data_csv['gender'], y, test_size=0.2, random_state=1)
    roc_clf.fit(X_train, y_train)
    roc_preds_sex = roc_clf.predict(X_test, sex_test)
    return str(mean_difference(roc_preds_sex,sex_test)[0]) 

def roc_mean_difference_race(data_csv):

    lr,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    roc_clf = SingleROClassifier(estimator=lr)
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    _ , race_test, y_train, _  = train_test_split(data_csv['race'], y, test_size=0.2, random_state=1)
    roc_clf.fit(X_train, y_train)
    roc_preds_sex = roc_clf.predict(X_test, race_test)
    return str(mean_difference(roc_preds_sex,race_test)[0]) 

def acf_mean_difference_race(data_csv):

    lr,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    acf_clf = LinearACFClassifier(target_estimator=lr,binary_residual_type="absolute") 
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    race_train, race_test, y_train, _  = train_test_split(data_csv['race'].values, y, test_size=0.2, random_state=1)
    acf_preds_race = acf_clf.fit(X_train, y_train,race_train).predict(X_test, race_test)
    return str(mean_difference(acf_preds_race,race_test)[0])     

def acf_mean_difference_sex(data_csv):

    lr,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    acf_clf = LinearACFClassifier(target_estimator=lr,binary_residual_type="absolute") 
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    sex_train, sex_test, y_train, _  = train_test_split(data_csv['gender'].values, y, test_size=0.2, random_state=1)
    acf_clf.fit(X_train, y_train,sex_train)
    acf_preds_sex = acf_clf.predict(X_test, sex_test)
    return str(mean_difference(acf_preds_sex, sex_test)[0])      

def acf_auc_sex(data_csv):

    lr,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    acf_clf = LinearACFClassifier(target_estimator=lr,binary_residual_type="absolute") 
    X_train, X_test, y_train, _  = train_test_split(X, y, test_size=0.2, random_state=1)
    sex_train, sex_test, y_train, y_test  = train_test_split(data_csv['gender'].values, y, test_size=0.2, random_state=1)
    acf_clf.fit(X_train, y_train,sex_train)
    acf_preds_sex = acf_clf.predict(X_test, sex_test)

    try:
        ras = roc_auc_score(y_test, acf_preds_sex)
    except ValueError:
        ras = 0

    return str(ras)     


def acf_auc_race(data_csv):

    lr,_,y_train,_,_,X,y = train_logistic_regression(data_csv)
    acf_clf = LinearACFClassifier(target_estimator=lr,binary_residual_type="absolute") 
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1)
    race_train, race_test, y_train, _  = train_test_split(data_csv['race'].values, y, test_size=0.2, random_state=1)
    acf_preds_race = acf_clf.fit(X_train, y_train,race_train).predict(X_test, race_test)

    try:
        ras = roc_auc_score(y_test, acf_preds_race)
    except ValueError:
        ras = 0

    return str(ras)     
  

def training_score(data_csv):

    lr,x_train,y_train,_,_,_,_ = train_logistic_regression(data_csv)

    return ("\n Training score: " + str(lr.score(x_train, y_train)))    

def calculate_accuracy(y,predictions):

    y=np.array(y)
    count = 0 
    for i in range(len(y)):
        if y[i]==predictions[i]:
            count += 1
    return count/len(y)



def get_accuracy(data_csv):

    lr,_,_,x_val,y_val,_,_ = train_logistic_regression(data_csv)
    predictions = lr.predict(x_val)
    score = calculate_accuracy(y_val,predictions)
    return ("\nThe  accuracy in the validation set is: " + str(score))


def classification_report_LR(data_csv):
    
    lr,_,_,x_val,_,X,y = train_logistic_regression(data_csv)
    predictions = lr.predict(x_val)
    _, _, _, y_test = train_test_split(X, y, test_size=0.2, random_state=1)
    return metrics.classification_report(y_test,predictions)    
