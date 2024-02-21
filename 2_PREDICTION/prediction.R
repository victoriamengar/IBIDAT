# This script defines a function in R to predict VTR using
# machine learning techniques.

# Loading required libraries
suppressPackageStartupMessages(library(tidyverse))
# For data manipulation
library(xgboost)
# For gradient boosting
library(data.table)
# For efficient data manipulation

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

  # First, we define a function for the exploratory data analysis

  # Function to perform Exploratory Data Analysis (EDA)
  perform_eda <- function(train_data) {

    # Open a PDF file for output
    pdf("eda_results.pdf")

    # Display summary statistics
    print("Summary Statistics:\n")
    print(summary(train_data))

    # Display data structure
    print("\nData Structure:\n")
    str(train_data)

    # Display missing values
    print("\nMissing Values:\n")
    print(colSums(is.na(train_data)))

    # Display correlation matrix
    print("\nCorrelation Matrix:\n")
    numeric_data <- train_data[, sapply(train_data, is.numeric), drop = FALSE]
    corr_matrix <- cor(numeric_data)
    corrplot::corrplot(corr_matrix, method = "circle")

    # Display distribution of target variable
    print("\nDistribution of Target Variable (VTR):\n")
    hist(train_data$VTR,
        main = "Histogram of VTR",
        xlab = "VTR",
        ylab = "Frequency")

    # Closing the PDF device
    dev.off()
    print("EDA completed and saved to eda_results.pdf.\n")
  }

  # Function to predict VTR
  prediction_modelling <- function(train_data, prediction_data, selected_variables) {

    # Setting seed for reproducibility
    set.seed(123)

    # Splitting the training data into training and validation sets
    # It is 80% train and 20% validation
    split <- sample(1:nrow(train_data), 0.8 * nrow(train_data))
    train_set <- train_data[split, ]
    validation_set <- train_data[-split, ]

    # Training XGBoost model
    xgb_model <- xgboost(data = as.matrix(train_set[, selected_variables]),
                        label = train_set$VTR,
                        nrounds = 500,
                        objective = "reg:squarederror")

    # Making predictions on the validation set
    predicted_vtr_validation <- predict(xgb_model, as.matrix(validation_set[, selected_variables]))

    # Evaluating model performance on validation set by mean squared error
    validation_error <- mean((predicted_vtr_validation - validation_set$VTR)^2)

    # Print validation error
    cat("Validation Mean Squared Error:", validation_error, "\n")

    # Making predictions on the prediction data
    predicted_vtr <- predict(xgb_model, as.matrix(prediction_data[, selected_variables]))

    # Ensuring predicted VTR values are non-negative
    predicted_vtr <- pmax(0, predicted_vtr)

    # Adding predicted VTR to prediction data
    prediction_data$VTR <- predicted_vtr

    # Writing prediction data to CSV file
    write.csv(prediction_data, "predicted_VTR.csv", row.names = FALSE)

    # Print completion message
    print("Prediction completed. Predicted VTR values saved to 'predicted_VTR.csv'.\n")

  }
  perform_eda(train_data)
  prediction_modelling(train_data, prediction_data, selected_variables)
}