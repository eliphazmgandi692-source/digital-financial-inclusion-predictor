Digital Financial Inclusion Predictor

Predicting Savings-Product Adoption Using R

A beginner-friendly data science portfolio project that explores how customer, financial, and digital-engagement characteristics can be used to predict savings-product adoption in a microfinance and digital-finance context.



Important: This project uses synthetic data for learning and portfolio purposes. The model is a decision-support demonstration and must not be used to automatically approve, deny, or restrict access to financial services.

Project Overview

Financial institutions often have limited resources for reaching customers who may benefit from savings products and financial education. Customers can differ in their income, savings behaviour, mobile-money activity, repayment history, access to financial agents, and exposure to financial education.

This project investigates whether these characteristics are associated with savings-product adoption. It follows an end-to-end data science workflow, from synthetic data generation and cleaning to exploratory analysis, logistic regression, model evaluation, interpretation, and business recommendations.

Research Question



Which customer characteristics and financial behaviours are associated with savings-product adoption?

Objectives

The project aims to:

•
Generate a realistic synthetic customer dataset.

•
Clean and validate the data.

•
Explore adoption patterns using visualisations.

•
Build an interpretable logistic regression model.

•
Evaluate the model using classification metrics.

•
Interpret important predictors and odds ratios.

•
Translate analytical findings into responsible business recommendations.

•
Discuss privacy, fairness, transparency, and human oversight.

Key Results

The baseline logistic regression model produced the following reported test-set results:

Metric
Result
Specificity
0.533
Precision
0.667
F1-score
0.712
ROC-AUC
0.678





An ROC-AUC of 0.678 indicates weak-to-moderate ability to distinguish between customers who adopted the savings product and those who did not. The model performs better than random guessing, but it is not sufficiently strong to operate without validation, monitoring, and human review.

The analysis identified positive associations between adoption and factors such as:

•
Loan repayment rate.

•
Financial education.

•
Business ownership.

Agent distance showed a negative association with predicted adoption, suggesting that physical access may be relevant to financial-product participation. These results are associations from synthetic data and do not prove causation.

Dataset

The project uses synthetic records representing approximately 1,000 fictional customers. No real names, phone numbers, identification numbers, account numbers, or exact addresses are included.

The dataset contains variables representing:

•
Customer demographics.

•
Age group.

•
Gender.

•
Location type.

•
Business ownership.

•
Monthly income.

•
Monthly expenses.

•
Mobile-money transaction frequency.

•
Average transaction value.

•
Monthly savings.

•
Loan repayment rate.

•
Financial education.

•
Distance to the nearest financial agent.

•
Mobile-application login frequency.

•
Customer-service contacts.

•
Savings-product adoption.

The target variable is defined as:

•
0 — Did not adopt the savings product.

•
1 — Adopted the savings product.

Analytical Workflow

Plain Text



Synthetic data generation
↓
Data cleaning and validation
↓
Exploratory data analysis
↓
Train-test split
↓
Logistic regression model
↓
Performance evaluation
↓
Model interpretation
↓
Business and ethical recommendations



Project Structure

Plain Text



digital-financial-inclusion-predictor/
├── data/
│   ├── raw/
│   └── processed/
│       └── customers\_clean.csv
├── images/
│   ├── report\_branding\_banner.png
│   ├── overall\_adoption.png
│   ├── adoption\_by\_gender.png
│   ├── adoption\_by\_location.png
│   ├── transactions\_by\_adoption.png
│   ├── monthly\_savings\_by\_adoption.png
│   ├── adoption\_by\_education.png
│   ├── income\_vs\_savings.png
│   ├── logistic\_regression\_roc\_curve.png
│   └── model\_coefficient\_plot.png
├── models/
│   └── logistic\_regression\_model.rds
├── reports/
│   ├── model\_performance.csv
│   └── model\_interpretation.csv
├── R/
│   ├── 01\_generate\_data.R
│   ├── 02\_clean\_data.R
│   ├── 03\_exploratory\_analysis.R
│   ├── 04\_build\_model.R
│   ├── 05\_interpret\_model.R
│   └── 07\_generate\_report\_images.R
├── project\_report.qmd
├── project\_report.pdf
├── README.md
└── .gitignore





Update the script filenames above if your local project uses different names.

Technologies and Tools

•
R—Data generation, cleaning, modelling, and analysis.

•
RStudio—Development environment.

•
Tidyverse—Data manipulation and visualisation.

•
ggplot2 — Exploratory charts.

•
Caret — Model training and evaluation.

•
pROC—ROC curve and AUC analysis.

•
Quarto—Reproducible PDF reporting.

•
Git and GitHub—Version control and portfolio publishing.

Installation

Install R and RStudio, then install the required packages in the R Console:

Plain Text



install.packages(c(
"tidyverse",
"caret",
"pROC",
"broom",
"knitr",
"rmarkdown"
))



If you want to render the PDF report, install Quarto from:



https://quarto.org/docs/get-started/

How to Run the Project

Open the project in RStudio and set the working directory to the project root.

Run the scripts in sequence:

Plain Text



R/01\_generate\_data.R
R/02\_clean\_data.R
R/03\_exploratory\_analysis.R
R/04\_build\_model.R
R/05\_interpret\_model.R
R/07\_generate\_report\_images.R



Alternatively, run each script using the Source button in RStudio.

The scripts generate cleaned data, model files, performance results, and PNG visualisations in the relevant folders.

Render the Report

From the RStudio Terminal, confirm that you are in the project root and run:

Bash



quarto render project\_report.qmd --to pdf



The final report will be generated as:

Plain Text



project\_report.pdf



The Quarto report includes:

•
Project background.

•
Data description.

•
Data-cleaning approach.

•
Exploratory visualisations.

•
Predictive-modelling methodology.

•
Model-performance results.

•
Coefficient interpretation.

•
Business recommendations.

•
Ethical considerations.

•
Limitations and future improvements.

Business Applications

Subject to proper validation and governance, the analytical approach could support:

•
Financial-education targeting.

•
Voluntary customer outreach.

•
Savings-product communication.

•
Agent-location planning.

•
Small-business financial support.

•
Customer-service prioritisation.

The model should support helpful engagement, not automated exclusion or discriminatory decision-making.

Ethical Considerations

A real-world implementation would require:

•
Informed customer consent.

•
Data minimisation.

•
Secure storage and encryption.

•
Controlled access to sensitive data.

•
Fairness testing across customer groups.

•
Transparent communication about model use.

•
Human review of important decisions.

•
Monitoring for model drift and changing customer behaviour.

•
Compliance with applicable data-protection and financial-sector requirements.

The project uses synthetic data to avoid exposing real customer information.

Limitations

This project has several limitations:

•
The dataset is synthetic and may not reflect real customer behaviour.

•
The sample may not represent all customer groups.

•
The model identifies associations rather than causal effects.

•
Logistic regression is used as a baseline model.

•
The reported ROC-AUC indicates that performance is useful but limited.

•
Further validation would be required before any operational deployment.

Future Improvements

Possible extensions include:

•
Compare logistic regression with random forest and other models.

•
Use cross-validation to produce more reliable performance estimates.

•
Test probability thresholds for different outreach objectives.

•
Evaluate calibration and subgroup performance.

•
Add fairness metrics across gender, age, and location groups.

•
Build an interactive Shiny application.

•
Add model monitoring and drift detection.

•
Use representative, consented real-world data.

•
Conduct controlled experiments to evaluate outreach effectiveness.

Portfolio Value

This project demonstrates practical skills in:

•
Data generation.

•
Data cleaning.

•
Exploratory data analysis.

•
Statistical modelling.

•
Classification evaluation.

•
Data visualisation.

•
Report writing.

•
Business interpretation.

•
Ethical data-science practice.

•
Reproducible project organisation.

It is especially relevant to roles in data analysis, operations analytics, credit and asset finance, microfinance, customer insights, and digital financial services.

Author

Mgandi Mgala
Data Science Learner | Microfinance Operations | Digital Financial Inclusion



LinkedIn

License

This project is intended for educational and portfolio purposes.

