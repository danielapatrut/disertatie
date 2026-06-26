from themis_ml.datasets import german_credit
from themis_ml.metrics import mean_difference
import csv
import itertools
from sklearn.model_selection import train_test_split
import pickle
import numpy as np
import seaborn as sns
from io import BytesIO
from flask import send_file
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


class GermanDataset :

    METRICS_COLUMNS = [
        "mean_diff_sex", "mean_diff_foreign", "auc_sex", "auc_foreign"]

    def __init__(self):
        self.data = german_credit(raw=True)
        self.sex = self.data["personal_status_and_sex"].map(
        lambda x: {"male": 0, "female": 1}[x.split("_")[0]])
        self.foreign = self.data["foreign_worker"]


    def get_csv(self):
        response_stream = BytesIO(self.data.to_csv().encode())
        return send_file(
        response_stream,
        mimetype="text/csv",
        attachment_filename="export.csv",
    )

    def get_data(self):
        self.data.reset_index(inplace=True)
        return self.data.to_json()

    def get_credit_risk_counts(self):
        credit_risk = self.data["credit_risk"]
        return (credit_risk.value_counts()).to_json()
    # display frequency counts of each value

    def sex_value_counts(self):
        return self.sex.value_counts().to_json()

    # get foreign worker status: 1 = yes, 0 = no
    def foreign_value_counts(self):
        return self.foreign.value_counts().to_json()

    def mean_difference_sex(self):
        credit_risk = self.data["credit_risk"]
        return "protected class = sex: %0.03f, 95%% Confidence Interval [%0.03f-%0.03f]" % (mean_difference(credit_risk, self.sex)) 

    def mean_difference_foreign(self):
        credit_risk = self.data["credit_risk"]
        return "protected class = foreign: %0.03f, 95%% Condifence Interval [%0.03f-%0.03f]" % (mean_difference(credit_risk,self.foreign))  

    def ten_most_correlated(self):
        # Select only numeric columns to avoid ValueError with string columns
        numeric_data = self.data.select_dtypes(include=['number'])
        corrmat = numeric_data.corr()
        corr_val = pd.DataFrame(np.abs(corrmat['credit_risk']))
        corr = corr_val.sort_values(by='credit_risk', ascending=False)  # We have the correlation in descending order and the first row is the variable y itself
        ten_most = corr[1:11]

        return ten_most.to_json()

    def subplot(self):

        fig = plt.figure(figsize=(35,20))
        sns.set_context("paper", rc={"font.size":40,"axes.titlesize":40,"axes.labelsize":40}) 
        b = sns.countplot(y='personal_status_and_sex', hue='credit_risk', data=self.data) 
        plt.xticks(rotation=45, horizontalalignment='right',fontweight='bold',fontsize=200)
        plt.yticks(fontweight='bold',fontsize=200)
        b.tick_params(labelsize=13.5)
        return fig
        
    def train_logistic_regression(self):

        csv_reader = csv.reader(german_credit(), delimiter = ',')

# list to store the names of columns
        list_of_column_names = []

        for row in csv_reader:
            list_of_column_names.append(row)

        merged_list = list(itertools.chain(*list_of_column_names))    
        merged_list.pop()
        merged_list.pop()
        self.features_no_sex = [
    f for f in merged_list if "sex" not in f]
        self.features = merged_list 
        self.training_data = german_credit()
        self.X = self.training_data[self.features].values
        self.X_no_sex = self.training_data[self.features_no_sex].values
        self.features_no_foreign = [
    f for f in merged_list if "foreign" not in f]
        self.y = self.training_data["credit_risk"].values
        self.x_train,self.x_val,self.y_train,self.y_val=train_test_split(self.X,self.y, test_size = 0.2)

        clf_LR=LogisticRegression()
        clf_LR=clf_LR.fit(self.x_train,self.y_train)

        return clf_LR

    def pred_data(self):
        clf_LR = self.train_logistic_regression()
        X_train, X_test, y_train,_ = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        b_preds = clf_LR.fit(
        X_train, y_train).predict_proba(self.X) 
        second_prob = b_preds[:,1]
        first_prob = b_preds[:,0]
        pred_data = self.data
        pred_data["f_prob_lr"] = first_prob
        pred_data['s_prob_lr'] = second_prob
        roc_clf = SingleROClassifier(estimator=clf_LR)
        _ , sex_test, y_train, _  = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)
        roc_clf.fit(X_train, y_train)
        roc_preds_sex = roc_clf.predict_proba(X_test, sex_test)

        return pred_data

    def rpa_no_sex_auc(self):
        rpa_clf = self.train_logistic_regression()
        
        X_no_sex_train, X_no_sex_test, y_train, y_test = train_test_split(self.X_no_sex, self.y, test_size=0.2, random_state=1)
        rpa_preds_no_sex = rpa_clf.fit(
        X_no_sex_train, y_train).predict(X_no_sex_test)   
        return str(roc_auc_score(y_test, rpa_preds_no_sex))

    def rpa_no_foreign_auc(self):
        rpa_clf = self.train_logistic_regression()
        self.X_no_foreign = self.training_data[self.features_no_foreign].values
        X_no_foreign_train, X_no_foreign_test, y_train, y_test = train_test_split(self.X_no_foreign, self.y, test_size=0.2, random_state=1)
        rpa_preds_no_foreign = rpa_clf.fit(
        X_no_foreign_train, y_train).predict(X_no_foreign_test)   
        return str(roc_auc_score(y_test, rpa_preds_no_foreign))

    def baseline_auc(self):
        baseline = self.train_logistic_regression()
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        b_preds = baseline.fit(
        X_train, y_train).predict(X_test)   
        return str(roc_auc_score(y_test, b_preds))


    def baseline_mean_difference_sex(self):

        baseline = self.train_logistic_regression()
        X_train, X_test, y_train, _ = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _, sex_test, y_train, _ = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)
        b_preds = baseline.fit(
        X_train, y_train).predict(X_test)  

        return str(mean_difference(b_preds, sex_test)[0])
        

    def baseline_mean_difference_foreign(self):

        baseline = self.train_logistic_regression()
        X_train, X_test, y_train,_ = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _ , foreign_test, y_train, _  = train_test_split(self.foreign, self.y, test_size=0.2, random_state=1)
        b_preds = baseline.fit(
        X_train, y_train).predict(X_test)  

        return str(mean_difference(b_preds, foreign_test)[0])    

    def rpa_mean_difference_sex(self):

        rpa_clf = self.train_logistic_regression()
        
        X_no_sex_train, X_no_sex_test, y_train, _  = train_test_split(self.X_no_sex, self.y, test_size=0.2, random_state=1)
        rpa_preds_no_sex = rpa_clf.fit(
        X_no_sex_train, y_train).predict(X_no_sex_test) 
        _ , sex_test, y_train, _  = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)  
        return str(mean_difference(rpa_preds_no_sex,sex_test)[0])

    def rpa_mean_difference_foreign(self):

        rpa_clf = self.train_logistic_regression()
        
        X_no_sex_train, X_no_sex_test, y_train, _  = train_test_split(self.X_no_sex, self.y, test_size=0.2, random_state=1)
        rpa_preds_no_foreign = rpa_clf.fit(
        X_no_sex_train, y_train).predict(X_no_sex_test) 
        _ , foreign_test, y_train, _  = train_test_split(self.foreign, self.y, test_size=0.2, random_state=1)  
        return (mean_difference(rpa_preds_no_foreign,foreign_test)[0])

    def roc_mean_difference_sex(self):
        clf_LR = self.train_logistic_regression()
        roc_clf = SingleROClassifier(estimator=clf_LR)
        X_train, X_test, y_train, _  = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _ , sex_test, y_train, _  = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)
        roc_clf.fit(X_train, y_train)
        roc_preds_sex = roc_clf.predict(X_test, sex_test)
        return str(mean_difference(roc_preds_sex,sex_test)[0]) 

    def roc_mean_difference_foreign(self):
        clf_LR = self.train_logistic_regression()
        roc_clf = SingleROClassifier(estimator=clf_LR)
        X_train, X_test, y_train, _  = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _ , foreign_test, y_train, _  = train_test_split(self.foreign, self.y, test_size=0.2, random_state=1)
        roc_clf.fit(X_train, y_train)
        roc_preds_foreign = roc_clf.predict(X_test, foreign_test)
        return str(mean_difference(roc_preds_foreign, foreign_test)[0])  

    def acf_mean_difference_sex(self):
        
        clf_LR = self.train_logistic_regression()
        acf_clf = LinearACFClassifier(target_estimator=clf_LR,binary_residual_type="absolute")    
        X_train, X_test, y_train, _ = train_test_split(self.X, self.y, test_size=0.2, random_state=1)   
        sex_train, sex_test, y_train, _  = train_test_split(self.sex.values, self.y, test_size=0.2, random_state=1)

        acf_preds_sex = acf_clf.fit(X_train, y_train, sex_train).predict(X_test, sex_test)
        return str(mean_difference(acf_preds_sex, sex_test)[0])  

    def acf_mean_difference_foreign(self):
        
        clf_LR = self.train_logistic_regression()
        acf_clf = LinearACFClassifier(target_estimator=clf_LR,binary_residual_type="absolute")    
        X_train, X_test, y_train, _  = train_test_split(self.X, self.y, test_size=0.2, random_state=1)   
        foreign_train, foreign_test, y_train, _  = train_test_split(self.foreign.values, self.y, test_size=0.2, random_state=1)

        acf_preds_foreign = acf_clf.fit(X_train, y_train, foreign_train).predict(X_test, foreign_test)
        return str(mean_difference(acf_preds_foreign, foreign_test)[0])

    def roc_auc_sex(self):
        clf_LR = self.train_logistic_regression()
        roc_clf = SingleROClassifier(estimator=clf_LR)
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _, sex_test, y_train, y_test = train_test_split(self.sex, self.y, test_size=0.2, random_state=1)
        roc_clf.fit(X_train, y_train)
        roc_preds_sex = roc_clf.predict(X_test, sex_test)
        return str(roc_auc_score(y_test, roc_preds_sex)) 

    def roc_auc_foreign(self):
        clf_LR = self.train_logistic_regression()
        roc_clf = SingleROClassifier(estimator=clf_LR)
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        _, foreign_test, y_train, y_test = train_test_split(self.foreign, self.y, test_size=0.2, random_state=1)
        roc_clf.fit(X_train, y_train)
        roc_preds_foreign = roc_clf.predict(X_test, foreign_test)
        return str(roc_auc_score(y_test, roc_preds_foreign))     

    def acf_auc_sex(self):
        
        clf_LR = self.train_logistic_regression()
        acf_clf = LinearACFClassifier(target_estimator=clf_LR,binary_residual_type="absolute")    
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)   
        sex_train, sex_test, y_train, y_test = train_test_split(self.sex.values, self.y, test_size=0.2, random_state=1)

        acf_preds_sex = acf_clf.fit(X_train, y_train, sex_train).predict(X_test, sex_test)
        return str(roc_auc_score(y_test, acf_preds_sex))  
           

    def acf_auc_foreign(self):
        
        clf_LR = self.train_logistic_regression()
        acf_clf = LinearACFClassifier(target_estimator=clf_LR,binary_residual_type="absolute")    
        X_train, X_test, y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)   
        foreign_train, foreign_test, y_train, y_test = train_test_split(self.foreign.values, self.y, test_size=0.2, random_state=1)

        acf_preds_foreign = acf_clf.fit(X_train, y_train, foreign_train).predict(X_test, foreign_test)
        return str(roc_auc_score(y_test, acf_preds_foreign))         

    def training_score(self):

        return ("\n Training score: " + str(self.train_logistic_regression().score(self.x_train, self.y_train)))    

    def calculate_accuracy(self,y,predictions):

        y=np.array(y)
        count = 0 
        for i in range(len(y)):
            if y[i]==predictions[i]:
                count += 1
        return count/len(y)

    def ten_most_figure(self):
        # Select only numeric columns to avoid ValueError with string columns
        numeric_data = self.data.select_dtypes(include=['number'])
        corrmat = numeric_data.corr()
        fig = plt.figure(figsize=(15, 15))
        sns.heatmap(corrmat, vmax=.8, square=True, cmap='viridis', linecolor="white")
        return fig

    def get_accuracy(self):
        predictions = self.train_logistic_regression().predict(self.x_val)
        score =  self.calculate_accuracy(self.y_val,predictions)#metrics.accuracy_score(pred, y_val)
        return ("\nThe  accuracy in the validation set is: " + str(score))

    def confusion_matrix(self):
        predictions = self.train_logistic_regression().predict(self.x_val)
        _ , self.X_test, _ , self.y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        cm=confusion_matrix(self.y_test,predictions)
        df_cm = pd.DataFrame(cm, range(2), range(2))
        fig = plt.figure(figsize=(10,7))
        sns.set(font_scale=1.4) # for label size
        sns.heatmap(df_cm, annot=True, annot_kws={"size": 16}) # font size    
        return fig


    def classification_report_LR(self):

        predictions = self.train_logistic_regression().predict(self.x_val)
        _ , self.X_test,_ , self.y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=1)
        return metrics.classification_report(self.y_test,predictions)



