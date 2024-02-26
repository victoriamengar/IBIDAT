# IBIDAT PROJECT

Welcome to the IBIDAT project repository. This project contains solutions to two exercises focused on data analysis and web crawling. Each exercise tackles a specific problem, providing clear instructions for installation, usage, and expected output.

## Exercise 1

This is a Python script that retrieves the number of references to "Universidad Carlos III de Madrid" in the "Universidad Carlos III de Madrid" Wikipedia webpage and the number of students of the University.

### Installation

1. Clone this repository to your local machine:

  >git clone https://github.com/victoriamengar/IBIDAT.git

2. Navigate to the exercise 1 directory:

  >cd IBIDAT/1_CRAWLING

3. (Optional) Create a virtual environment

  In PowerShell execute 
  >python -m venv ibidat1-env (only the first time)

4. (Optional) Activate the virtual environment

  Activate it in CMD with 
  >.\ibidat1-env\Scripts\activate

5. Install the required Python packages:

  requirements1.txt

### Usage
Run the crawling.py script:

  >python crawling.py

The number of references to "Universidad Carlos III de Madrid" and the number of students
will be displayed in the output

### Expected output

Number of references to Universidad Carlos III de Madrid: 10
Number of students: 22913

## Exercise 2

This repository contains an R script designed to predict View Through Rate (VTR) using various machine learning techniques. Below is a guide on how to install, use, and interpret the script.

### Installation

1. Clone this repository to your local machine (if not done already):

  >git clone https://github.com/victoriamengar/IBIDAT.git

2. Navigate to the exercise 2 directory inside of the R terminal:

  >setwd(IBIDAT/2_PREDICTION)

5. Install the required R packages:

  requirements2.txt

### Usage
1. Open your preferred Integrated Development Environment (IDE) such as VS Code or RStudio

2. Source the prediction.R script into your IDE:

  >source("prediction.R")

2. Run the prediction() function:

  >prediction()

### Expected output

The script will perform the following steps:

1. Load the required R libraries
2. Read the training and prediction data from CSV files
3. Conduct exploratory data analysis (EDA) on the training data, including summary statistics, data structure, missing values, box plots, and correlation matrix. 
4. Save the results in eda_results.pdf and eda_results.txt
5. Create a smaller dataset with the most correlated variables identified during EDA
6. Train various machine learning models, including linear regression, random forest, and XGBoost, using both complete and reduced datasets
7. Evaluate the performance of each model on a validation set using mean squared error
8. Make predictions on the prediction data using the best-performing model (linear regression)
9. Ensure predicted VTR values are non-negative and save them to a CSV file named predicted_VTR.csv
