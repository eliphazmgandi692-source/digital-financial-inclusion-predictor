# Digital Financial Inclusion Predictor
# Step 2: Generate synthetic customer data

library(tidyverse)

# Make the results reproducible
set.seed(123)

# Number of synthetic customers
n_customers <- 1000

# Generate customer data
customers <- tibble(
  customer_id = 1:n_customers,
  
  gender = sample(
    c("Female", "Male"),
    size = n_customers,
    replace = TRUE,
    prob = c(0.65, 0.35)
  ),
  
  age_group = sample(
    c("18-25", "26-35", "36-45", "46-55", "56+"),
    size = n_customers,
    replace = TRUE,
    prob = c(0.20, 0.35, 0.25, 0.15, 0.05)
  ),
  
  location_type = sample(
    c("Urban", "Peri-urban", "Rural"),
    size = n_customers,
    replace = TRUE,
    prob = c(0.35, 0.30, 0.35)
  ),
  
  business_owner = sample(
    c("Yes", "No"),
    size = n_customers,
    replace = TRUE,
    prob = c(0.45, 0.55)
  ),
  
  monthly_income = round(
    pmax(rnorm(n_customers, mean = 30000, sd = 12000), 5000)
  ),
  
  monthly_expenses = round(
    pmax(rnorm(n_customers, mean = 19000, sd = 8000), 3000)
  ),
  
  mobile_money_transactions = rpois(
    n_customers,
    lambda = 25
  ),
  
  average_transaction_value = round(
    pmax(rnorm(n_customers, mean = 1200, sd = 500), 100)
  ),
  
  monthly_savings = round(
    pmax(rnorm(n_customers, mean = 4500, sd = 2500), 0)
  ),
  
  loan_repayment_rate = round(
    runif(n_customers, min = 0.55, max = 1.00),
    2
  ),
  
  financial_education = sample(
    c("Yes", "No"),
    size = n_customers,
    replace = TRUE,
    prob = c(0.40, 0.60)
  ),
  
  agent_distance_km = round(
    runif(n_customers, min = 0.2, max = 15),
    1
  ),
  
  app_login_frequency = rpois(
    n_customers,
    lambda = 8
  ),
  
  customer_service_contacts = rpois(
    n_customers,
    lambda = 2
  )
)

# Calculate a realistic adoption probability
adoption_score <- with(
  customers,
  -2.2 +
    0.035 * mobile_money_transactions +
    0.00008 * monthly_savings +
    1.4 * loan_repayment_rate +
    0.7 * (financial_education == "Yes") +
    0.04 * app_login_frequency -
    0.08 * agent_distance_km +
    0.5 * (business_owner == "Yes")
)

adoption_probability <- plogis(adoption_score)

# Create the target variable
customers <- customers %>%
  mutate(
    adopted_savings_product = rbinom(
      n = n_customers,
      size = 1,
      prob = adoption_probability
    )
  )

# Save the raw synthetic dataset
write_csv(
  customers,
  "data/raw/digital_finance_customers.csv"
)

# Display confirmation messages
cat("Dataset created successfully.\n")
cat("Number of customers:", nrow(customers), "\n")
cat("Number of columns:", ncol(customers), "\n")

# Display the first six rows
print(head(customers))

# Display the target distribution
print(table(customers$adopted_savings_product))
