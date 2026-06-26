import flask
from german_credit import GermanDataset
from census import CensusDataset
from flask_cors import CORS
from flask import request, send_file, safe_join
from werkzeug.utils import secure_filename
import pandas as pd
import io
import numpy as np
from matplotlib.figure import Figure
import matplotlib
matplotlib.use("Agg")
import fairness_metrics
import fairness_themisml
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
import os
from flask import Response
from themis_ml.metrics import mean_difference
import csv
import itertools
from sklearn.model_selection import train_test_split
import seaborn as sns
from sklearn import metrics
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.base import clone

UPLOAD_FOLDER = '/path/to/the/uploads'
ALLOWED_EXTENSIONS = {'csv'}

app = flask.Flask(__name__, static_url_path='')
CORS(app)
cors = CORS(app, resource={
    r"/*":{
        "origins":"*"
    }
})
app.config["DEBUG"] = True

gd = GermanDataset()
ci = CensusDataset()

@app.route('/',methods=['GET'])
def german_data():    
    german_dataset = gd.get_data()
    return german_dataset

@app.route('/census_income',methods=['GET'])
def census():
    census_dataset = ci.get_census_data()
    return census_dataset

@app.route('/census_csv',methods=['GET'])
def csvf():
    return send_file('./csv_files_download/census_csv.html', as_attachment=True)

@app.route('/german_csv',methods=['GET'])
def gdcsv():
    return send_file('./csv_files_download/gd_csv.html', as_attachment=True)    


@app.route('/mitigating_models_german', methods=['GET'])   
def mitigatingScores_gd():

    baseline_auc_score_sex = gd.baseline_auc()
    baseline_auc_score_foreign = gd.baseline_auc()
    baseline_mean_diff_sex = gd.baseline_mean_difference_sex()
    baseline_mean_diff_foreign = gd.baseline_mean_difference_foreign()

    rpa_mean_difference_no_sex = gd.rpa_mean_difference_sex()
    rpa_mean_difference_no_foreign = gd.rpa_mean_difference_foreign()
    rpa_auc_score_no_sex = gd.rpa_no_sex_auc()
    rpa_auc_score_no_foreign = gd.rpa_no_foreign_auc()

    roc_auc_score_sex = gd.roc_auc_sex()
    roc_auc_score_foreign = gd.roc_auc_foreign()
    roc_mean_difference_sex = gd.roc_mean_difference_sex()
    roc_mean_difference_foreign = gd.roc_mean_difference_foreign()

    acf_mean_difference_sex = gd.acf_mean_difference_sex()
    acf_mean_difference_foreign = gd.acf_mean_difference_foreign()
    acf_auc_score_sex = gd.acf_auc_sex()
    acf_auc_score_foreign = gd.acf_auc_foreign()

    scores = {"B":{"mean(auc_sex)":baseline_auc_score_sex,"mean(auc_foreign)": baseline_auc_score_foreign,"mean(mean_difference_sex)":baseline_mean_diff_sex,"mean(mean_difference_foreign)":baseline_mean_diff_foreign}, "RPA":{"mean(auc_sex)":rpa_auc_score_no_sex,"mean(auc_foreign)":rpa_auc_score_no_foreign, "mean(mean_difference_sex)":rpa_mean_difference_no_sex,
    "mean(mean_difference_foreign)": rpa_mean_difference_no_foreign},"ROC":{"mean(auc_sex)":roc_auc_score_sex,"mean(auc_foreign)":roc_auc_score_foreign, "mean(mean_difference_sex)":roc_mean_difference_sex,"mean(mean_difference_foreign)":roc_mean_difference_foreign},
    "ACF":{"mean(auc_sex)":acf_auc_score_sex,"mean(auc_foreign)":acf_auc_score_foreign,"mean(mean_difference_sex)":acf_mean_difference_sex,"mean(mean_difference_foreign)":acf_mean_difference_foreign}}
                
    return scores

@app.route('/mitigating_models_census', methods=['GET'])   
def mitigatingScores_ci():

    baseline_auc_score_sex = ci.baseline_auc()
 
    baseline_mean_diff_sex = ci.baseline_mean_difference_sex()

    rpa_mean_difference_no_sex = ci.rpa_mean_difference_sex()

    rpa_auc_score_no_sex = ci.rpa_no_sex_auc()
    roc_auc_score_sex = ci.roc_auc_sex()
 
    roc_mean_difference_sex = ci.roc_mean_difference_sex()
  
    acf_mean_difference_sex = ci.acf_mean_difference_sex()
   
    acf_auc_score_sex = ci.acf_auc_sex()
  

    scores = {"B":{"auc_sex":baseline_auc_score_sex,"mean_difference_sex":baseline_mean_diff_sex}, "RPA":{"auc_sex":rpa_auc_score_no_sex, "mean_difference_sex":rpa_mean_difference_no_sex},"ROC":{"auc_sex":roc_auc_score_sex, "mean_difference_sex":roc_mean_difference_sex},
    "ACF":{"auc_sex":acf_auc_score_sex,"mean_difference_sex":acf_mean_difference_sex}}
                
    return scores

@app.route('/census_scores', methods=['GET'])   
def scores_ci():

    scorres = {
        "ACF": {
            "mean(auc_sex)": "0.6105622581286345", 
            "mean(mean_difference_sex)": "0.01653507697707088"
        }, 
        "B": {
            "mean(auc_sex)": "0.5807130371463403", 
            "mean(mean_difference_sex)": "0.017278735874393908"
        }, 
        "ROC": {
            "mean(auc_sex)": "0.5836808508385515", 
            "mean(mean_difference_sex)": "0.0201649312254917"
        }, 
        "RPA": {
            "mean(auc_sex)": "0.5817406965702814", 
            "mean(mean_difference_sex)": "0.016561630072712046"
        }
        }

    return scorres

@app.route('/censusinfo', methods=['GET'])
def censusInfo():
    incomeCounts = ci.income_value_counts()
    sexCounts = ci.sex_value_counts()
    meanDifferenceSex = ci.mean_difference_sex()
    tenMostCorrelatedFeatures = ci.ten_most_correlated()
    LR_accuracy = ci.get_accuracy()
    LR_training_score = ci.training_score()
    LR_classification_report = ci.classification_report_LR()
    return {"income_counts": incomeCounts, 'sex_counts': sexCounts, 'mean_difference_sex': meanDifferenceSex,'ten_most_correlated':tenMostCorrelatedFeatures,
    "lr_accuracy":LR_accuracy, "LR_training_score":LR_training_score,
    "lr_classification_report":LR_classification_report}


@app.route('/germaninfo', methods=['GET'])
def germanInfo():
    creditRisk = gd.get_credit_risk_counts()
    sexCounts = gd.sex_value_counts()
    foreignCounts = gd.foreign_value_counts()
    meanDifferenceSex = gd.mean_difference_sex()
    meanDifferenceForeign = gd.mean_difference_foreign()
    tenMostCorrelatedFeatures = gd.ten_most_correlated()
    LR_accuracy = gd.get_accuracy()
    LR_training_score = gd.training_score()
    LR_classification_report = gd.classification_report_LR()
   
    return {"credit_risk_counts": creditRisk, 'sex_counts': sexCounts, 'foreign_counts': foreignCounts, 'mean_difference_sex': meanDifferenceSex, 'mean_difference_foreign': meanDifferenceForeign,'ten_most_correlated':tenMostCorrelatedFeatures,
    "lr_accuracy":LR_accuracy, "LR_training_score":LR_training_score,
    "lr_classification_report":LR_classification_report}

@app.route('/correlation.png')
def create_figure():
    fig = GermanDataset().ten_most_figure()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')


@app.route('/subplot.png')    
def create_plot():
    fig = GermanDataset().subplot()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')

@app.route('/confusion_matrix.png')
def create_matrix():
    fig = GermanDataset().confusion_matrix()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')

@app.route('/correlation_ci.png')
def create_figure2():
    fig = ci.ten_most_figure()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')


@app.route('/subplot2.png')    
def create_plot2():
    fig = ci.subplot()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')

@app.route('/confusion_matrix2.png')
def create_matrix2():
    fig = ci.confusion_matrix()
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(), mimetype='image/png')    


@app.route('/your_csv_plot.png',methods = ['POST'])
def subplot_csv():
    file = request.files['file']
    data_processing = pd.read_csv(file)
    fig = fairness_themisml.subplot(data_processing)
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(),mimetype='image.png') 

@app.route('/your_csv_matrix.png',methods = ['POST'])
def matrix_csv():
    file = request.files['file']
    data_processing = pd.read_csv(file)
    fig = fairness_themisml.confusion_matrix_csv(data_processing)
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(),mimetype='image.png') 


@app.route('/your_csv_heatmap.png',methods = ['POST'])
def heatmap_csv():
    file = request.files['file']
    data_processing = pd.read_csv(file)
    fig = fairness_themisml.correlated_figure(data_processing)
    output = io.BytesIO()
    FigureCanvas(fig).print_png(output)
    return Response(output.getvalue(),mimetype='image.png')     


@app.route('/your_csv',methods=['POST'])
def do_fairness_analysis():

    file = request.files['file']
    data_processing = pd.read_csv(file)

    #This dictionary will hold all the values for the fairness report and de-biasing experiment
    fairness_analysis = {}

    fairness_analysis["disparate_impact_r"] = fairness_metrics.disp_impact(data_processing['race'].values, data_processing['prediction'].values)
    fairness_analysis["disparate_impact_g"] = fairness_metrics.disp_impact(data_processing['gender'].values, data_processing['prediction'].values)

    fairness_analysis['fairness_based_on_race'] = fairness_metrics.demographic_parity(data_processing['race'].values, data_processing['prediction'].values)
    fairness_analysis['fairness_based_on_sex'] = fairness_metrics.demographic_parity(data_processing['gender'].values, data_processing['prediction'].values)

    fairness_analysis['mean_difference_sex'] = "protected class = sex: %0.03f, 95%% Confidence Interval [%0.03f-%0.03f]" % (mean_difference(data_processing['prediction'].values, data_processing['gender'].values)) 
    fairness_analysis['mean_difference_race'] = "protected class = race: %0.03f, 95%% Confidence Interval [%0.03f-%0.03f]" % (mean_difference(data_processing['prediction'].values, data_processing['race'].values)) 
    corrmat = data_processing.corr()

    corr_val = pd.DataFrame(np.abs(corrmat['prediction']))
    corr=corr_val.sort_values(by='prediction',ascending=False) # We have the correlation in descending order and the first row is the variable y itself
    five_most=corr[1:6]


    fairness_analysis["five_most"] = five_most.to_json()
    fairness_analysis['get_ts'] = fairness_themisml.training_score(data_processing)
    fairness_analysis['get_accuracy'] = fairness_themisml.get_accuracy(data_processing)
    fairness_analysis['report'] = fairness_themisml.classification_report_LR(data_processing)

    baseline_mean_diff_sex = fairness_themisml.baseline_mean_difference_sex(data_processing)
    baseline_mean_diff_race = fairness_themisml.baseline_mean_difference_race(data_processing)

    acf_mean_diff_race = fairness_themisml.acf_mean_difference_race(data_processing)
    acf_mean_diff_sex = fairness_themisml.acf_mean_difference_sex(data_processing)

    fairness_analysis['favourable_results'] = len(data_processing[data_processing['prediction'] == 1])
    fairness_analysis['unfavourable_results'] = len(data_processing[data_processing['prediction'] == 0])

    fairness_analysis['advantaged_counts_race'] = len(data_processing[data_processing['race'] == 1])
    fairness_analysis['disadvantaged_counts_race'] = len(data_processing[data_processing['race'] == 0])

    rpa_mean_diff_sex = fairness_themisml.rpa_mean_difference_sex(data_processing)
    rpa_mean_diff_race = fairness_themisml.rpa_mean_difference_race(data_processing)

    rpa_sex_auc = fairness_themisml.rpa_auc_sex(data_processing)
    rpa_race_auc = fairness_themisml.rpa_auc_race(data_processing)

    baseline_sex_auc = baseline_race_auc = fairness_themisml.baseline_auc(data_processing)

    roc_mean_diff_sex = fairness_themisml.roc_mean_difference_sex(data_processing)
    roc_mean_diff_race = fairness_themisml.roc_mean_difference_race(data_processing)
    roc_auc_sex = fairness_themisml.roc_auc_sex(data_processing)
    roc_auc_race = fairness_themisml.roc_auc_race(data_processing)

    acf_auc_sex = fairness_themisml.acf_auc_sex(data_processing)
    acf_auc_race = fairness_themisml.acf_auc_race(data_processing)



    scores_csv = {"B":{"mean(auc_sex)":baseline_sex_auc,"mean(auc_race)": baseline_race_auc,"mean(mean_difference_sex)":baseline_mean_diff_sex,"mean(mean_difference_race)":baseline_mean_diff_race}, "RPA":{"mean(auc_sex)":rpa_sex_auc,"mean(auc_race)":rpa_race_auc, "mean(mean_difference_sex)":rpa_mean_diff_sex,
    "mean(mean_difference_race)": rpa_mean_diff_race},"ROC":{"mean(auc_sex)":roc_auc_sex,"mean(auc_race)":roc_auc_race, "mean(mean_difference_sex)":roc_mean_diff_sex,"mean(mean_difference_race)":roc_mean_diff_race},
    "ACF":{"mean(auc_sex)":acf_auc_sex,"mean(auc_race)":acf_auc_race,"mean(mean_difference_sex)":acf_mean_diff_sex,"mean(mean_difference_race)":acf_mean_diff_race}}
   
    data_processing_one = data_processing[data_processing['prediction'] == 1]

    fairness_analysis['disadvantaged_race_counts_one'] = len(data_processing_one[data_processing_one['race'] == 0])
    fairness_analysis['advantaged_race_counts_one'] = len(data_processing_one[data_processing_one['race'] == 1])

    fairness_analysis['advantaged_sex_counts'] = len(data_processing[data_processing['gender'] == 1])
    fairness_analysis['disadvantaged_sex_counts'] = len(data_processing[data_processing['gender'] == 0])
    fairness_analysis['disadvantaged_sex_counts_one'] = len(data_processing_one[data_processing_one['gender'] == 0])
    fairness_analysis['advantaged_sex_counts_one'] = len(data_processing_one[data_processing_one['gender'] == 1])

    fairness_analysis['error_measure_race'], fairness_analysis['error_measure_race_one'], fairness_analysis['error_measure_race_zero'] = fairness_metrics.error_measure(data_processing['race'].values, data_processing['prediction'].values, data_processing['expected'].values)
    fairness_analysis['error_measure_sex'], fairness_analysis['error_measure_sex_one'], fairness_analysis['error_measure_sex_zero'] = fairness_metrics.error_measure(data_processing['gender'].values, data_processing['prediction'].values, data_processing['expected'].values)


    data_processing_one = data_processing[data_processing['expected'] == 1]
    data_processing['error_value'] = np.abs(data_processing_one['prediction'] - data_processing_one['expected'])


    return {"fairness_analysis": fairness_analysis,"scores_csv":scores_csv}


app.run()   


