# Digital Financial Inclusion Predictor
# Step 5: Building and evaluating a logistic regression model

library(tidyverse)
library(caret)
library(pROC)
library(broom)


# Create folders if they do not already exist
dir.create("images", showWarnings = FALSE)
dir.create("reports", showWarnings = FALSE)
dir.create("models", showWarnings = FALSE)

# Make results reproducible
set.seed(123)

# --------------------------------------------------
# 1. Load the cleaned dataset
# --------------------------------------------------

customers <- read_csv(
  "data/processed/customers_clean.csv",
  show_col_types = FALSE
)

# Convert categorical variables to factors
customers <- customers %>%
  mutate(
    gender = as.factor(gender),
    age_group = as.factor(age_group),
    location_type = as.factor(location_type),
    business_owner = as.factor(business_owner),
    financial_education = as.factor(financial_education),
    adopted_savings_product = as.integer(adopted_savings_product)
  )

# Check the target variable
print(table(customers$adopted_savings_product))

# --------------------------------------------------
# 2. Split the data into training and testing sets
# --------------------------------------------------

train_index <- createDataPartition(
  customers$adopted_savings_product,
  p = 0.80,
  list = FALSE
)

train_data <- customers[train_index, ]
test_data <- customers[-train_index, ]

cat("Training records:", nrow(train_data), "\n")
cat("Testing records:", nrow(test_data), "\n")

# --------------------------------------------------
# 3. Build the logistic regression model
# --------------------------------------------------

logistic_model <- glm(
  adopted_savings_product ~
    gender +
    age_group +
    location_type +
    business_owner +
    monthly_income +
    monthly_expenses +
    mobile_money_transactions +
    average_transaction_value +
    monthly_savings +
    loan_repayment_rate +
    financial_education +
    agent_distance_km +
    app_login_frequency +
    customer_service_contacts,
  data = train_data,
  family = binomial
)

# Display the model summary
summary(logistic_model)

# --------------------------------------------------
# 4. Make predictions on the test data
# --------------------------------------------------

predicted_probability <- predict(
  logistic_model,
  newdata = test_data,
  type = "response"
)

# Convert probabilities into predicted classes
# Probability >= 0.50 is classified as adoption
predicted_class <- ifelse(
  predicted_probability >= 0.50,
  1,
  0
)

# --------------------------------------------------
# 5. Evaluate the classification results
# --------------------------------------------------

actual_class <- factor(
  test_data$adopted_savings_product,
  levels = c(0, 1),
  labels = c("Did not adopt", "Adopted")
)

predicted_class_factor <- factor(
  predicted_class,
  levels = c(0, 1),
  labels = c("Did not adopt", "Adopted")
)

confusion_results <- confusionMatrix(
  data = predicted_class_factor,
  reference = actual_class,
  positive = "Adopted"
)

print(confusion_results)

# --------------------------------------------------
# 6. Calculate ROC-AUC
# --------------------------------------------------

roc_result <- roc(
  response = test_data$adopted_savings_product,
  predictor = predicted_probability,
  quiet = TRUE
)

auc_value <- auc(roc_result)

cat("ROC-AUC:", round(as.numeric(auc_value), 3), "\n")

# --------------------------------------------------
# 7. Plot the ROC curve
# --------------------------------------------------

roc_plot <- ggroc(roc_result) +
  geom_abline(
    slope = 1,
    intercept = 0,
    linetype = "dashed",
    color = "gray"
  ) +
  labs(
    title = paste(
      "ROC Curve - Logistic Regression",
      "\nAUC =",
      round(as.numeric(auc_value), 3)
    ),
    x = "False Positive Rate",
    y = "True Positive Rate"
  ) +
  theme_minimal()

print(roc_plot)

ggsave(
  "images/logistic_regression_roc_curve.png",
  roc_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 8. Examine model coefficients
# --------------------------------------------------

coefficient_results <- broom::tidy(logistic_model) %>%
  mutate(
    odds_ratio = exp(estimate)
  ) %>%
  arrange(desc(abs(estimate)))

print(coefficient_results)

write_csv(
  coefficient_results,
  "reports/logistic_model_coefficients.csv"
)

# --------------------------------------------------
# 9. Save predictions
# --------------------------------------------------

prediction_results <- test_data %>%
  mutate(
    predicted_probability = predicted_probability,
    predicted_class = predicted_class
  )

write_csv(
  prediction_results,
  "reports/test_set_predictions.csv"
)

# --------------------------------------------------
# 10. Save the trained model
# --------------------------------------------------

saveRDS(
  logistic_model,
  "models/logistic_regression_model.rds"
)

# --------------------------------------------------
# Completion message
# --------------------------------------------------

cat("\nStep 5 completed successfully.\n")
cat("The trained model was saved in the models folder.\n")
cat("The ROC curve was saved in the images folder.\n")
cat("Model coefficients and predictions were saved in the reports folder.\n")
