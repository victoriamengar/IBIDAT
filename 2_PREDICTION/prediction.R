# This script defines a function in R to predict VTR using
# machine learning techniques

# Loading required libraries
suppressPackageStartupMessages(library(tidyverse))
# For data manipulation
suppressPackageStartupMessages(library(xgboost))
# For gradient boosting modelling
suppressPackageStartupMessages(library(data.table))
# For efficient data manipulation
suppressPackageStartupMessages(library(randomForest))
# For random forest modelling

prediction <- function() {

  # Reading the training and prediction data
  train_data <- read.csv("df_train.csv")
  prediction_data <- read.csv("df_test_predict.csv")

  # Defining selected variables for prediction to extract them
  # from the training and prediction data
  selected_variables <- c("appType_vtr",
                          "creatSize_vtr",
                          "creatType_vtr",
                          "deviceOs_vtr",
                          "domain_vtr",
                          "tsHour_vtr",
                          "tsDow_vtr")

  ###########################################################################
  ############################# FIRST STEP ##################################
  ###########################################################################
  
  # Defining a function for performing the Exploratory Data Analysis (EDA)

  perform_eda <- function(train_data, selected_variables) {

    # Opening a PDF file for plots in the output
    pdf("eda_results.pdf")

    # Opening a txt file for text output
    sink("eda_results.txt")

    # Selecting relevant variables
    variables_train <- train_data[, selected_variables]

    # Displaying summary statistics
    print("Summary Statistics:\n")
    print(summary(variables_train))

    # Displaying data structure
    print("\nData Structure:\n")
    str(variables_train)

    # Displaying missing values
    print("\nMissing Values:\n")
    print(colSums(is.na(variables_train)))

    # Displaying data distribution for every variable
    namevar <- colnames(variables_train)
    for (i in 1:ncol(variables_train)) {
      boxplot(variables_train[, i],
              main = paste("Boxplot of", namevar[i]))
    }
    # Displaying correlation matrix
    print("\nCorrelation Matrix:\n")
    corr_matrix <- cor(cbind(variables_train, train_data$VTR))
    print(corr_matrix)
    corrplot::corrplot(corr_matrix,
                        method = "circle", 
                        main = "Correlation matrix")

    # Displaying distribution of target variable
    boxplot(train_data$VTR,
        main = "Boxplot of VTR")

    # Closing the PDF device and the txt device
    dev.off()
    sink()

    print("EDA completed and saved to eda_results.pdf and eda_results.txt")
  }

  perform_eda(train_data, selected_variables)

  ###########################################################################
  ############################# SECOND STEP #################################
  ###########################################################################

  # As concluded after EDA, a smaller set is created with the most
  # correlated variables
  correlated_vars <- c("appType_vtr",
                       "creatSize_vtr",
                       "domain_vtr",
                       "VTR")
  train_data_small <- train_data[, correlated_vars]

  ###########################################################################
  ############################# THIRD STEP ##################################
  ###########################################################################

  # Function to predict VTR
  prediction_modelling <- function(train_data,
                                   prediction_data,
                                   selected_variables) {

    # Setting seed for reproducibility
    set.seed(198)

    # Removing non-necessary variables from training dataset
    train_data <- train_data[, c(selected_variables, "VTR")]

    # Splitting the training data into training and validation sets
    # It is 80% train and 20% validation
    split <- sample(1:nrow(train_data), 0.8 * nrow(train_data))
    train_set <- train_data[split, ]
    validation_set <- train_data[-split, ]

    # Splitting also the reduced training data
    split_small <- sample(1:nrow(train_data_small), 0.8 * nrow(train_data_small))
    train_set_small <- train_data_small[split_small, ]
    validation_set_small <- train_data_small[-split_small, ]

    ###########################################################################
    ############################# FOURTH STEP #################################
    ###########################################################################

    print("Training models...")

    #1a Training linear regression model with complete data
    lm_model <- lm(VTR ~ ., data = train_set)

    #1b Training linear regression model with reduced data
    lm_model_small <- lm(VTR ~ ., data = train_set_small)

    #2a Training Random Forest model with complete data
    rf_model <- randomForest(VTR ~ ., data = train_set)

    #2b Training Random Forest model with reduced data
    rf_model_small <- randomForest(VTR ~ ., data = train_set_small)

    #3a Training XGBoost model with complete data
    xgb_model <- xgboost(data = as.matrix(train_set[, selected_variables]),
                         label = train_set$VTR,
                         nrounds = 50,
                         objective = "reg:squarederror")
    
    #3b Training XGBoost model with reduced data
    xgb_model_small <- xgboost(data = as.matrix(train_set_small),
                               label = train_set$VTR,
                               nrounds = 50,
                               objective = "reg:squarederror")

    ###########################################################################
    ############################# FIFTH STEP ##################################
    ###########################################################################

    #1a Making predictions on the validation set for linear regression model
    pred_vtr_valid_lm <- predict(lm_model, validation_set[, selected_variables])

    #1a Evaluating model performance on validation set
    # for linear regression model by mean squared error
    valid_err_lm <- mean((pred_vtr_valid_lm - validation_set$VTR)^2)

    #1a Printing validation error for linear regression model
    print(paste("Validation Mean Squared Error",
                "for Linear Regression Modelling:",
                valid_err_lm))

    #1b Making predictions on the validation set for
    # reduced linear regression model
    pred_vtr_valid_lm_small <- predict(lm_model_small, validation_set_small)

    #1b Evaluating model performance on validation set
    # for reduced linear regression model by mean squared error
    valid_err_lm_small <- mean((pred_vtr_valid_lm_small - validation_set_small$VTR)^2)

    #1b Printing validation error for reduced linear regression model
    print(paste("Validation Mean Squared Error",
                "for Reduced Linear Regression Modelling:",
                valid_err_lm_small))

    #2a Making predictions on the validation set for random forest model
    pred_vtr_valid_rf <- predict(rf_model, validation_set[, selected_variables])

    #2a Evaluating model performance on validation set
    # for random forest model by mean squared error
    valid_err_rf <- mean((pred_vtr_valid_rf - validation_set$VTR)^2)

    #2a Printing validation error for random forest model
    print(paste("Validation Mean Squared Error",
                "for Random Forest Modelling:",
                valid_err_rf))

    #2b Making predictions on the validation set for reduced random forest model
    pred_vtr_valid_rf_small <- predict(rf_model_small, validation_set_small)

    #2b Evaluating model performance on validation set
    # for random forest model by mean squared error
    valid_err_rf_small <- mean((pred_vtr_valid_rf_small - validation_set_small$VTR)^2)

    #2b Printing validation error for random forest model
    print(paste("Validation Mean Squared Error",
                "for Reduced Random Forest Modelling:",
                valid_err_rf_small))

    #3a Making predictions on the validation set for xgb model
    pred_vtr_valid_xgb <- predict(xgb_model, as.matrix(validation_set[, selected_variables]))

    #3a Evaluating model performance on validation set
    # for xgb model by mean squared error
    valid_err_xgb <- mean((pred_vtr_valid_xgb - validation_set$VTR)^2)

    #3a Printing validation error for xgb model
    print(paste("Validation Mean Squared Error",
                "for Gradient Boosting Modelling:",
                valid_err_xgb))

    #3b Making predictions on the validation set for reduced xgb model
    pred_vtr_valid_xgb_small <- predict(xgb_model_small, as.matrix(validation_set_small))

    #3b Evaluating model performance on validation set
    # for reduced xgb model by mean squared error
    valid_err_xgb_small <- mean((pred_vtr_valid_xgb_small - validation_set_small$VTR)^2)

    #3b Printing validation error for reduced xgb model
    print(paste("Validation Mean Squared Error",
                "for Reduced Gradient Boosting Modelling:",
                valid_err_xgb_small))

    ###########################################################################
    ############################# SIXTH STEP ##################################
    ###########################################################################

    # Making predictions on the prediction data by Linear Regression model
    # because it was the best one
    pred_vtr_lm <- predict(lm_model_small,
                           prediction_data[, c("appType_vtr",
                                               "creatSize_vtr",
                                               "domain_vtr")])

    # Ensuring predicted VTR values are non-negative
    predicted_vtr <- pmax(0, pred_vtr_lm)

    # Adding predicted VTR to prediction data
    prediction_data$VTR <- predicted_vtr

    # Writing prediction data to CSV file
    write.csv(prediction_data, "predicted_VTR.csv", row.names = FALSE)

    # Print completion message
    print("Prediction completed. Predicted VTR values saved to 'predicted_VTR.csv'")

  }

  prediction_modelling(train_data, prediction_data, selected_variables)
}