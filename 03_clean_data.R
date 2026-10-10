# Digital Financial Inclusion Predictor
# Step 3: Check and clean the dataset

library(tidyverse)

# Load the raw dataset
customers_raw <- read_csv(
  "data/raw/digital_finance_customers.csv",
  show_col_types = FALSE
)

# Inspect the dataset
cat("Dataset structure:\n")
glimpse(customers_raw)

cat("\nNumber of rows and columns:\n")
print(dim(customers_raw))

cat("\nColumn names:\n")
print(names(customers_raw))

# Check missing values in each column
missing_values <- customers_raw %>%
  summarise(
    across(
      everything(),
      ~ sum(is.na(.x))
    )
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "column",
    values_to = "missing_count"
  )

cat("\nMissing values by column:\n")
print(missing_values)

# Check duplicated rows
duplicate_rows <- customers_raw %>%
  duplicated() %>%
  sum()

cat("\nNumber of duplicated rows:", duplicate_rows, "\n")

# Check duplicated customer IDs
duplicate_customer_ids <- customers_raw %>%
  count(customer_id) %>%
  filter(n > 1)

cat("\nDuplicated customer IDs:\n")
print(duplicate_customer_ids)

# Check invalid numeric values
cat("\nInvalid numeric values:\n")

print(
  customers_raw %>%
    summarise(
      negative_income = sum(monthly_income < 0, na.rm = TRUE),
      negative_expenses = sum(monthly_expenses < 0, na.rm = TRUE),
      negative_savings = sum(monthly_savings < 0, na.rm = TRUE),
      invalid_repayment_rate = sum(
        loan_repayment_rate < 0 |
          loan_repayment_rate > 1,
        na.rm = TRUE
      ),
      invalid_adoption_values = sum(
        !adopted_savings_product %in% c(0, 1),
        na.rm = TRUE
      )
    )
)

# Begin cleaning
customers_clean <- customers_raw %>%
  # Remove completely duplicated rows
  distinct() %>%
  
  # Keep one record per customer ID
  distinct(customer_id, .keep_all = TRUE) %>%
  
  # Standardize categorical values
  mutate(
    gender = str_to_title(str_trim(gender)),
    age_group = str_trim(age_group),
    location_type = str_to_title(str_trim(location_type)),
    business_owner = str_to_title(str_trim(business_owner)),
    financial_education = str_to_title(str_trim(financial_education))
  ) %>%
  
  # Replace missing categorical values with "Unknown"
  mutate(
    across(
      c(gender, age_group, location_type,
        business_owner, financial_education),
      ~ replace_na(.x, "Unknown")
    )
  ) %>%
  
  # Replace missing numeric values with the median
  mutate(
    across(
      c(monthly_income,
        monthly_expenses,
        mobile_money_transactions,
        average_transaction_value,
        monthly_savings,
        loan_repayment_rate,
        agent_distance_km,
        app_login_frequency,
        customer_service_contacts),
      ~ replace_na(.x, median(.x, na.rm = TRUE))
    )
  ) %>%
  
  # Remove records where the prediction target is missing
  filter(!is.na(adopted_savings_product)) %>%
  
  # Ensure the target variable is numeric
  mutate(
    adopted_savings_product = as.integer(adopted_savings_product)
  )

# Validate that values are within acceptable ranges
customers_clean <- customers_clean %>%
  filter(
    monthly_income >= 0,
    monthly_expenses >= 0,
    monthly_savings >= 0,
    average_transaction_value >= 0,
    mobile_money_transactions >= 0,
    app_login_frequency >= 0,
    customer_service_contacts >= 0,
    agent_distance_km >= 0,
    loan_repayment_rate >= 0,
    loan_repayment_rate <= 1,
    adopted_savings_product %in% c(0, 1)
  )

# Final validation checks
cat("\nFinal dataset structure:\n")
glimpse(customers_clean)

cat("\nFinal dataset dimensions:\n")
print(dim(customers_clean))

cat("\nRemaining missing values:\n")
print(
  customers_clean %>%
    summarise(
      total_missing_values = sum(is.na(.))
    )
)

cat("\nRemaining duplicate rows:\n")
print(sum(duplicated(customers_clean)))

cat("\nTarget variable distribution:\n")
print(
  customers_clean %>%
    count(adopted_savings_product)
)

# Save the cleaned dataset
write_csv(
  customers_clean,
  "data/processed/customers_clean.csv"
)

cat("\nCleaned dataset saved successfully.\n")
