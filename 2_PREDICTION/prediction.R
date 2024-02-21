# This script defines a function in R to predict...

prediction <- function() {

  # Loading required libraries:

  suppressPackageStartupMessages(library(tidyverse))
  # For data manipulation

  #library(xgboost)            # for gradient boosting
  #library(caret)              # for model training and evaluation
  library(data.table)         # for efficient data manipulation

  # Reading the data
  train_data <- read.csv("df_train.csv")
  prediction_data <- read.csv("df_test_predict.csv", )

  # Obtaining the training VTR and starting the vector for predicted VTR
  train_vtr <- train_data$VTR
  predicted_vtr <- c()

  # Creating a dataframe with the relevant variables for prediction

  selected_variables <- c("appType_vtr",
                          "creatSize_vtr",
                          "creatType_vtr",
                          "deviceOs_vtr",
                          "domain_vtr",
                          "tsHour_vtr",
                          "tsDow_vtr")
  variables_train <- train_data[, selected_variables]
  variables_prediction <- prediction_data[, selected_variables]

  print("HASTA AQUÍ BIENNNNN")
}