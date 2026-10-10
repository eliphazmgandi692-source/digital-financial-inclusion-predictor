# Digital Financial Inclusion Predictor
# Step 7: Generate and save all report images

library(tidyverse)
library(broom)

# --------------------------------------------------
# 1. Project folders
# --------------------------------------------------

dir.create("images", showWarnings = FALSE)
dir.create("reports", showWarnings = FALSE)

# Use a consistent visual theme
report_theme <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 16,
      color = "#123B63"
    ),
    plot.subtitle = element_text(
      size = 11,
      color = "gray30"
    ),
    axis.title = element_text(
      face = "bold",
      color = "#123B63"
    ),
    axis.text = element_text(color = "gray20"),
    legend.title = element_text(face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    plot.margin = margin(15, 15, 15, 15)
  )

# Consistent colour palette
adoption_colours <- c(
  "Did not adopt" = "#D95F59",
  "Adopted" = "#2E8B8B"
)

# --------------------------------------------------
# 2. Load the cleaned customer data
# --------------------------------------------------

customers <- read_csv(
  "data/processed/customers_clean.csv",
  show_col_types = FALSE
)

# Create readable adoption labels
customers <- customers %>%
  mutate(
    adoption_status = factor(
      adopted_savings_product,
      levels = c(0, 1),
      labels = c("Did not adopt", "Adopted")
    )
  )

cat("Loaded", nrow(customers), "customer records.\n")

# --------------------------------------------------
# 3. Generate a branded report banner
# --------------------------------------------------

branding_plot <- ggplot() +
  annotate(
    "rect",
    xmin = 0,
    xmax = 10,
    ymin = 0,
    ymax = 3,
    fill = "#123B63"
  ) +
  annotate(
    "text",
    x = 5,
    y = 1.85,
    label = "DIGITAL FINANCIAL INCLUSION",
    color = "white",
    fontface = "bold",
    size = 8
  ) +
  annotate(
    "text",
    x = 5,
    y = 1.05,
    label = "Predicting Savings-Product Adoption",
    color = "#A9D6E5",
    size = 5
  ) +
  coord_cartesian(
    xlim = c(0, 10),
    ylim = c(0, 3),
    expand = FALSE
  ) +
  theme_void()

ggsave(
  "images/report_branding_banner.png",
  branding_plot,
  width = 10,
  height = 3,
  dpi = 300
)

# --------------------------------------------------
# 4. Overall adoption chart
# --------------------------------------------------

overall_adoption <- ggplot(
  customers,
  aes(
    x = adoption_status,
    fill = adoption_status
  )
) +
  geom_bar(width = 0.65) +
  scale_fill_manual(values = adoption_colours) +
  labs(
    title = "Overall Savings-Product Adoption",
    subtitle = "Number of customers by adoption status",
    x = "Adoption Status",
    y = "Number of Customers",
    fill = "Status"
  ) +
  report_theme

ggsave(
  "images/overall_adoption.png",
  overall_adoption,
  width = 8,
  height = 5.5,
  dpi = 300
)

# --------------------------------------------------
# 5. Adoption by gender
# --------------------------------------------------

gender_adoption <- customers %>%
  group_by(gender) %>%
  summarise(
    customers = n(),
    adoption_rate = mean(adopted_savings_product) * 100,
    .groups = "drop"
  )

adoption_by_gender <- ggplot(
  gender_adoption,
  aes(
    x = gender,
    y = adoption_rate,
    fill = gender
  )
) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_text(
    aes(label = paste0(round(adoption_rate, 1), "%")),
    vjust = -0.35,
    fontface = "bold"
  ) +
  scale_y_continuous(
    limits = c(0, 100),
    expand = expansion(mult = c(0, 0.08))
  ) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Savings-Product Adoption by Gender",
    subtitle = "Percentage of customers adopting the product",
    x = "Gender",
    y = "Adoption Rate (%)"
  ) +
  report_theme

ggsave(
  "images/adoption_by_gender.png",
  adoption_by_gender,
  width = 8,
  height = 5.5,
  dpi = 300
)

# --------------------------------------------------
# 6. Adoption by location
# --------------------------------------------------

location_adoption <- customers %>%
  group_by(location_type) %>%
  summarise(
    customers = n(),
    adoption_rate = mean(adopted_savings_product) * 100,
    .groups = "drop"
  )

adoption_by_location <- ggplot(
  location_adoption,
  aes(
    x = location_type,
    y = adoption_rate,
    fill = location_type
  )
) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_text(
    aes(label = paste0(round(adoption_rate, 1), "%")),
    vjust = -0.35,
    fontface = "bold"
  ) +
  scale_y_continuous(
    limits = c(0, 100),
    expand = expansion(mult = c(0, 0.08))
  ) +
  scale_fill_brewer(palette = "Dark2") +
  labs(
    title = "Savings-Product Adoption by Location",
    subtitle = "Comparison across location categories",
    x = "Location Type",
    y = "Adoption Rate (%)"
  ) +
  report_theme

ggsave(
  "images/adoption_by_location.png",
  adoption_by_location,
  width = 8,
  height = 5.5,
  dpi = 300
)

# --------------------------------------------------
# 7. Mobile-money activity by adoption status
# --------------------------------------------------

transactions_by_adoption <- ggplot(
  customers,
  aes(
    x = adoption_status,
    y = mobile_money_transactions,
    fill = adoption_status
  )
) +
  geom_boxplot(
    alpha = 0.85,
    width = 0.6,
    outlier.alpha = 0.5
  ) +
  scale_fill_manual(values = adoption_colours) +
  labs(
    title = "Mobile-Money Activity by Adoption Status",
    subtitle = "Monthly transaction frequency",
    x = "Adoption Status",
    y = "Monthly Mobile-Money Transactions",
    fill = "Status"
  ) +
  report_theme

ggsave(
  "images/transactions_by_adoption.png",
  transactions_by_adoption,
  width = 8,
  height = 5.5,
  dpi = 300
)

# --------------------------------------------------
# 8. Monthly savings by adoption status
# --------------------------------------------------

monthly_savings_by_adoption <- ggplot(
  customers,
  aes(
    x = adoption_status,
    y = monthly_savings,
    fill = adoption_status
  )
) +
  geom_boxplot(
    alpha = 0.85,
    width = 0.6,
    outlier.alpha = 0.5
  ) +
  scale_fill_manual(values = adoption_colours) +
  labs(
    title = "Monthly Savings by Adoption Status",
    subtitle = "Comparison of estimated monthly savings",
    x = "Adoption Status",
    y = "Monthly Savings",
    fill = "Status"
  ) +
  report_theme

ggsave(
  "images/monthly_savings_by_adoption.png",
  monthly_savings_by_adoption,
  width = 8,
  height = 5.5,
  dpi = 300
)

# --------------------------------------------------
# 9. Financial education and adoption
# --------------------------------------------------

education_adoption <- customers %>%
  group_by(financial_education) %>%
  summarise(
    customers = n(),
    adoption_rate = mean(adopted_savings_product) * 100,
    .groups = "drop"
  )

adoption_by_education <- ggplot(
  education_adoption,
  aes(
    x = financial_education,
    y = adoption_rate,
    fill = financial_education
  )
) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_text(
    aes(label = paste0(round(adoption_rate, 1), "%")),
    vjust = -0.35,
    fontface = "bold"
  ) +
  scale_y_continuous(
    limits = c(0, 100),
    expand = expansion(mult = c(0, 0.08))
  ) +
  scale_fill_brewer(palette = "Set1") +
  labs(
    title = "Savings-Product Adoption by Financial Education",
    subtitle = "Comparison of customers who attended education",
    x = "Financial Education",
    y = "Adoption Rate (%)"
  ) +
  report_theme

ggsave(
  "images/adoption_by_education.png",
  adoption_by_education,
  width = 8,
  height = 5.5,
  dpi = 300
)

# --------------------------------------------------
# 10. Income and savings relationship
# --------------------------------------------------

income_vs_savings <- ggplot(
  customers,
  aes(
    x = monthly_income,
    y = monthly_savings,
    color = adoption_status
  )
) +
  geom_point(
    alpha = 0.65,
    size = 2
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linewidth = 0.9
  ) +
  scale_color_manual(values = adoption_colours) +
  labs(
    title = "Relationship Between Income and Savings",
    subtitle = "Monthly income compared with monthly savings",
    x = "Monthly Income",
    y = "Monthly Savings",
    color = "Adoption Status"
  ) +
  report_theme

ggsave(
  "images/income_vs_savings.png",
  income_vs_savings,
  width = 8,
  height = 5.5,
  dpi = 300
)

# --------------------------------------------------
# 11. Model coefficient plot
# --------------------------------------------------

coefficient_file <- "reports/model_interpretation.csv"

if (file.exists(coefficient_file)) {
  
  coefficients <- read_csv(
    coefficient_file,
    show_col_types = FALSE
  )
  
  coefficient_plot_data <- coefficients %>%
    filter(term != "(Intercept)") %>%
    mutate(
      direction = if_else(
        odds_ratio >= 1,
        "Higher predicted adoption",
        "Lower predicted adoption"
      ),
      term = forcats::fct_reorder(
        term,
        odds_ratio
      )
    )
  
  coefficient_plot <- ggplot(
    coefficient_plot_data,
    aes(
      x = odds_ratio,
      y = term,
      color = direction
    )
  ) +
    geom_point(size = 3) +
    geom_vline(
      xintercept = 1,
      linetype = "dashed",
      color = "gray40"
    ) +
    scale_x_log10() +
    scale_color_manual(
      values = c(
        "Higher predicted adoption" = "#2E8B8B",
        "Lower predicted adoption" = "#D95F59"
      )
    ) +
    labs(
      title = "Model Coefficient Interpretation",
      subtitle = "Odds ratios from the logistic regression model",
      x = "Odds Ratio on Logarithmic Scale",
      y = "Model Variable",
      color = "Direction"
    ) +
    report_theme
  
  ggsave(
    "images/model_coefficient_plot.png",
    coefficient_plot,
    width = 9,
    height = 7,
    dpi = 300
  )
  
} else {
  
  cat(
    "Model coefficient file not found. ",
    "The coefficient chart was not generated.\n"
  )
}

# --------------------------------------------------
# 12. Copy or confirm the ROC curve
# --------------------------------------------------

# The ROC curve is generated by 06_interpret_model.R.
# Run that script before this script if the file is missing.

if (!file.exists("images/logistic_regression_roc_curve.png")) {
  
  cat(
    "ROC curve image not found.\n",
    "Run R/06_interpret_model.R to generate it.\n"
  )
  
} else {
  
  cat("ROC curve image found.\n")
}

# --------------------------------------------------
# 13. Verify all required files
# --------------------------------------------------

required_images <- c(
  "report_branding_banner.png",
  "overall_adoption.png",
  "adoption_by_gender.png",
  "adoption_by_location.png",
  "transactions_by_adoption.png",
  "monthly_savings_by_adoption.png",
  "adoption_by_education.png",
  "income_vs_savings.png",
  "logistic_regression_roc_curve.png",
  "model_coefficient_plot.png"
)

image_check <- tibble(
  file = required_images,
  exists = file.exists(
    file.path("images", required_images)
  )
)

print(image_check)

write_csv(
  image_check,
  "reports/image_check.csv"
)

cat("\nImage-generation process completed.\n")
cat("Images were saved in the images folder.\n")
cat("Verification results were saved to reports/image_check.csv.\n")
