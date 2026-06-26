# Master Thesis Project

A web application for measuring and visualizing discrimination (bias) in machine
learning models. The goal is to make it easier to see how a model behaves across
different groups of people and to apply fairness-aware techniques when training it.

The project has two parts: a Flask backend that runs the models and computes the
fairness metrics, and a Flutter frontend that talks to the backend and shows the
results in the browser.

## Datasets

The experiments are built around a couple of well-known datasets used in fairness
research, such as the German Credit and Census (Adult) datasets.

## Running the project

You need two terminals.

Backend (from the `backend` folder):

    flask run

Frontend (from the `frontend` folder):

    flutter run -d chrome

I used Chrome during development, but any browser should work.

## Requirements

The backend was written for Python 3.8. Install the Python dependencies:

    pip install themis-ml scikit-learn matplotlib Flask numpy pandas seaborn flask_cors

For the frontend you need Flutter installed and added to your PATH (the `dart`
tool comes with it).
