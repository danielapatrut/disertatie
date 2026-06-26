from themis_ml.metrics import mean_difference
import csv
import itertools
from io import BytesIO
from collections import defaultdict
from sklearn.preprocessing import LabelEncoder
from flask import send_file
from sklearn.model_selection import train_test_split
import pickle
from sklearn.metrics import confusion_matrix
import numpy as np
from io import StringIO
import csv
from flask import make_response
import matplotlib.pyplot as plt
import pandas as pd
from sklearn import metrics
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.base import clone
#from experiment import Experiment

from themis_ml.postprocessing.reject_option_classification import \
    SingleROClassifier
from themis_ml.linear_model import LinearACFClassifier

import seaborn as sns


class CensusDataset :

    def __init__(self):
        
        self.data = pd.read_csv("census.csv")
        tr_data = pd.read_csv("data3.csv")
        self.sex = self.data["sex"].map(
        lambda x: {"male": 0, "female": 1}[x.split("_")[0]])
        self.income = self.data["income_gt_50k"]
     
    def get_census_data(self):

        self.data.reset_index(drop=True, inplace=True)
        return self.data.to_json()

    def get_csv(self):
        response_stream = BytesIO(self.data.to_csv().encode())
        return send_file(
        response_stream,
        mimetype="text/csv",
        attachment_filename="export.csv",
    )

    def income_value_counts(self):

        return self.income.value_counts().to_json()

    def sex_value_counts(self):
        return self.sex.value_counts().to_json()

    def mean_difference_sex(self):
        return "protected class = sex: %0.03f, 95%% Confidence Interval [%0.03f-%0.03f]" % (mean_difference(self.income, self.sex))     

    def ten_most_correlated(self):
        # Select only numeric columns to avoid ValueError with string columns
        numeric_data = self.data.select_dtypes(include=['number'])
        corrmat = numeric_data.corr()
        corr_val = pd.DataFrame(np.abs(corrmat['income_gt_50k']))
        corr = corr_val.sort_values(by='income_gt_50k', ascending=False)  # We have the correlation in descending order and the first row is the variable y itself
        ten_most = corr[1:11]

        return ten_most.to_json()

    def train_logistic_regression(self):
# list to store the names of columns
        list_of_column_names = []
        tr_data = pd.read_csv('data3.csv')
        for row in tr_data:
            list_of_column_names.append(row)
        list_of_column_names.pop()
        list_of_column_names.pop()
        self.features = list_of_column_names
        self.features_no_sex = [
    f for f in list_of_column_names if "sex" not in f]
 
        self.training_data = pd.read_csv("data3.csv")
        self.X = self.training_data[self.features].values
        self.X_no_sex = self.training_data[self.features_no_sex].values
        self.y = self.training_data["income_gt_50k"].values
        self.x_train,self.x_val,self.y_train,self.y_val=train_test_split(self.X,self.y, test_size = 0.2)

        clf_LR=LogisticRegression()
        clf_LR=clf_LR.fit(self.x_train,self.y_train)

        return clf_LR

    def training_score(self):

        return ("\n Training score: " + str(self.train_logistic_regression().score(self.x_train, self.y_train)))    

    def calculate_accuracy(self,y,predictions):

        y=np.array(y)
        count = 0 
        for i in range(len(y)):
            if y[i]==predictions[i]:
                count += 1
        return count/len(y)


    def get_accuracy(self):
        predictions = self.train_logistic_regression().predict(self.x_val)
        score =  self.calculate_accuracy(self.y_val, predictions)
        return ("\nThe  accuracy in the validation set is: " + str(score))


    def classification_report_LR(self):

        predictions = self.train_logistic_regression().predict(self.x_val)
        _, self.X_test,_, self.y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        return metrics.classification_report(self.y_test,predictions)

    def confusion_matrix(self):
        predictions = self.train_logistic_regression().predict(self.x_val)
        _, self.X_test, _, self.y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        cm = confusion_matrix(self.y_test,predictions)
        df_cm = pd.DataFrame(cm, range(2), range(2))
        fig = plt.figure(figsize=(10,7))
        sns.set(font_scale=1.4) # for label size
        sns.heatmap(df_cm, annot=True, annot_kws={"size": 16}) # font size    
        return fig


    def ten_most_figure(self):
        # Select only numeric columns to avoid ValueError with string columns
        numeric_data = self.data.select_dtypes(include=['number'])
        corrmat = numeric_data.corr()
        fig = plt.figure(figsize=(15, 15))
        sns.heatmap(corrmat, vmax=.8, square=True, cmap='viridis', linecolor="white")
        return fig    


    def subplot(self):

        fig = plt.figure(figsize=(35,20))
        sns.set_context("paper", rc={"font.size":40,"axes.titlesize":40,"axes.labelsize":40}) 
        b = sns.countplot(y='sex', hue='income_gt_50k', data=self.data) 
        plt.xticks(rotation=45, horizontalalignment='right',fontweight='bold',fontsize=200)
        plt.yticks(fontweight='bold',fontsize=200)
        b.tick_params(labelsize=13.5)
        return fig

    def baseline_auc(self):
        baseline = self.train_logistic_regression()
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        b_preds = baseline.fit(
        X_train, y_train).predict(X_test)   
        return str(roc_auc_score(y_test, b_preds))


    def baseline_mean_difference_sex(self):

        baseline = self.train_logistic_regression()
        X_train, X_test, y_train, _  = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _ , sex_test, y_train, _ = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)
        b_preds = baseline.fit(
        X_train, y_train).predict(X_test)  

        return str(mean_difference(b_preds, sex_test)[0])

    def rpa_no_sex_auc(self):
        
        rpa_clf = self.train_logistic_regression()
        
        X_no_sex_train, X_no_sex_test, y_train, y_test = train_test_split(self.X_no_sex, self.y, test_size=0.2, random_state=1)
        rpa_preds_no_sex = rpa_clf.fit(
        X_no_sex_train, y_train).predict(X_no_sex_test)   
        return str(roc_auc_score(y_test, rpa_preds_no_sex))    
        

    def rpa_mean_difference_sex(self):

        rpa_clf = self.train_logistic_regression()
        
        X_no_sex_train, X_no_sex_test, y_train, _ = train_test_split(self.X_no_sex, self.y, test_size=0.2, random_state=1)
        rpa_preds_no_sex = rpa_clf.fit(
        X_no_sex_train, y_train).predict(X_no_sex_test) 
        _, sex_test, y_train, _ = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)  
        return str(mean_difference(rpa_preds_no_sex,sex_test)[0])


    def roc_mean_difference_sex(self):
        clf_LR = self.train_logistic_regression()
        roc_clf = SingleROClassifier(estimator=clf_LR)
        X_train, X_test, y_train, _  = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _ , sex_test, y_train, _  = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)
        roc_clf.fit(X_train, y_train)
        roc_preds_sex = roc_clf.predict(X_test, sex_test)
        return str(mean_difference(roc_preds_sex,sex_test)[0]) 
 

    def acf_mean_difference_sex(self):
        
        clf_LR = self.train_logistic_regression()
        acf_clf = LinearACFClassifier(target_estimator=clf_LR,binary_residual_type="absolute")    
        X_train, X_test, y_train, _  = train_test_split(self.X, self.y, test_size=0.2, random_state=1)   
        sex_train, sex_test, y_train, _ = train_test_split(self.sex.values, self.y, test_size=0.2, random_state=1)

        acf_preds_sex = acf_clf.fit(X_train, y_train, sex_train).predict(X_test, sex_test)
        return str(mean_difference(acf_preds_sex, sex_test)[0])  


    def roc_auc_sex(self):
        clf_LR = self.train_logistic_regression()
        roc_clf = SingleROClassifier(estimator=clf_LR)
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _ , sex_test, y_train, y_test = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)
        roc_clf.fit(X_train, y_train)
        roc_preds_sex = roc_clf.predict(X_test, sex_test)
        return str(roc_auc_score(y_test, roc_preds_sex)) 
   

    def acf_auc_sex(self):
        
        clf_LR = self.train_logistic_regression()
        acf_clf = LinearACFClassifier(target_estimator=clf_LR,binary_residual_type="absolute")    
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)   
        sex_train, sex_test, y_train, y_test = train_test_split(self.sex.values, self.y, test_size=0.2, random_state=1)

        acf_preds_sex = acf_clf.fit(X_train, y_train, sex_train).predict(X_test, sex_test)
        return str(roc_auc_score(y_test, acf_preds_sex))





