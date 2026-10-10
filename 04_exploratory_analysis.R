# Digital Financial Inclusion Predictor
# Step 4: Exploratory Data Analysis and Visualizations

library(tidyverse)

# Create the images folder if it does not already exist
dir.create("images", showWarnings = FALSE)

# Load the cleaned dataset
customers <- read_csv(
  "data/processed/customers_clean.csv",
  show_col_types = FALSE
)

# Inspect the dataset
glimpse(customers)

# Create readable labels for the target variable
customers <- customers %>%
  mutate(
    adoption_status = factor(
      adopted_savings_product,
      levels = c(0, 1),
      labels = c("Did not adopt", "Adopted")
    )
  )

# --------------------------------------------------
# 1. Overall adoption summary
# --------------------------------------------------

adoption_summary <- customers %>%
  count(adopted_savings_product) %>%
  mutate(
    percentage = round(n / sum(n) * 100, 1)
  )

print(adoption_summary)

# --------------------------------------------------
# 2. Overall savings-product adoption plot
# --------------------------------------------------

adoption_plot <- ggplot(
  customers,
  aes(x = adoption_status, fill = adoption_status)
) +
  geom_bar() +
  labs(
    title = "Savings-Product Adoption",
    x = "Adoption Status",
    y = "Number of Customers"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(adoption_plot)

ggsave(
  "images/overall_adoption.png",
  adoption_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 3. Adoption by gender
# --------------------------------------------------

gender_adoption <- customers %>%
  group_by(gender) %>%
  summarise(
    customers = n(),
    adopters = sum(adopted_savings_product),
    adoption_rate = round(
      mean(adopted_savings_product) * 100,
      1
    ),
    .groups = "drop"
  )

print(gender_adoption)

gender_plot <- ggplot(
  gender_adoption,
  aes(
    x = gender,
    y = adoption_rate,
    fill = gender
  )
) +
  geom_col() +
  geom_text(
    aes(label = paste0(adoption_rate, "%")),
    vjust = -0.3
  ) +
  labs(
    title = "Savings-Product Adoption Rate by Gender",
    x = "Gender",
    y = "Adoption Rate (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(gender_plot)

ggsave(
  "images/adoption_by_gender.png",
  gender_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 4. Adoption by location
# --------------------------------------------------

location_adoption <- customers %>%
  group_by(location_type) %>%
  summarise(
    customers = n(),
    adoption_rate = round(
      mean(adopted_savings_product) * 100,
      1
    ),
    .groups = "drop"
  )

print(location_adoption)

location_plot <- ggplot(
  location_adoption,
  aes(
    x = location_type,
    y = adoption_rate,
    fill = location_type
  )
) +
  geom_col() +
  geom_text(
    aes(label = paste0(adoption_rate, "%")),
    vjust = -0.3
  ) +
  labs(
    title = "Savings-Product Adoption by Location",
    x = "Location Type",
    y = "Adoption Rate (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(location_plot)

ggsave(
  "images/adoption_by_location.png",
  location_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 5. Mobile-money transactions by adoption status
# --------------------------------------------------

transaction_plot <- ggplot(
  customers,
  aes(
    x = adoption_status,
    y = mobile_money_transactions,
    fill = adoption_status
  )
) +
  geom_boxplot() +
  labs(
    title = "Mobile-Money Transactions by Adoption Status",
    x = "Savings-Product Adoption",
    y = "Monthly Mobile-Money Transactions"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(transaction_plot)

ggsave(
  "images/transactions_by_adoption.png",
  transaction_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 6. Monthly savings by adoption status
# --------------------------------------------------

savings_plot <- ggplot(
  customers,
  aes(
    x = adoption_status,
    y = monthly_savings,
    fill = adoption_status
  )
) +
  geom_boxplot() +
  labs(
    title = "Monthly Savings by Adoption Status",
    x = "Savings-Product Adoption",
    y = "Monthly Savings"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(savings_plot)

ggsave(
  "images/monthly_savings_by_adoption.png",
  savings_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 7. Adoption by financial education
# --------------------------------------------------

education_adoption <- customers %>%
  group_by(financial_education) %>%
  summarise(
    customers = n(),
    adoption_rate = round(
      mean(adopted_savings_product) * 100,
      1
    ),
    .groups = "drop"
  )

print(education_adoption)

education_plot <- ggplot(
  education_adoption,
  aes(
    x = financial_education,
    y = adoption_rate,
    fill = financial_education
  )
) +
  geom_col() +
  geom_text(
    aes(label = paste0(adoption_rate, "%")),
    vjust = -0.3
  ) +
  labs(
    title = "Savings-Product Adoption by Financial Education",
    x = "Attended Financial Education",
    y = "Adoption Rate (%)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(education_plot)

ggsave(
  "images/adoption_by_education.png",
  education_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 8. Relationship between income and savings
# --------------------------------------------------

income_savings_plot <- ggplot(
  customers,
  aes(
    x = monthly_income,
    y = monthly_savings,
    color = adoption_status
  )
) +
  geom_point(alpha = 0.6) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  labs(
    title = "Monthly Income and Monthly Savings",
    x = "Monthly Income",
    y = "Monthly Savings",
    color = "Adoption Status"
  ) +
  theme_minimal()

print(income_savings_plot)

ggsave(
  "images/income_vs_savings.png",
  income_savings_plot,
  width = 7,
  height = 5
)

# --------------------------------------------------
# 9. Gender and location summary
# --------------------------------------------------

gender_location_summary <- customers %>%
  group_by(gender, location_type) %>%
  summarise(
    customers = n(),
    adoption_rate = round(
      mean(adopted_savings_product) * 100,
      1
    ),
    average_savings = round(
      mean(monthly_savings),
      0
    ),
    average_transactions = round(
      mean(mobile_money_transactions),
      1
    ),
    .groups = "drop"
  )

print(gender_location_summary)

# --------------------------------------------------
# Completion message
# --------------------------------------------------

cat("\nStep 4 completed successfully.\n")
cat("Charts were saved in the images folder.\n")
