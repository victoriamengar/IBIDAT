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

This is a Python script that 

### Installation

1. Clone this repository to your local machine (if not done already):

  >git clone https://github.com/victoriamengar/IBIDAT.git

2. Navigate to the exercise 2 directory:

  >cd IBIDAT/2_PREDICTION

5. Install the required R packages:

  requirements2.txt

### Usage
1. Source the prediction.R script into VS Code or RStudio IDEs:

  >source("prediction.R")

2. Run the prediction() function:

  >prediction()

### Expected output

