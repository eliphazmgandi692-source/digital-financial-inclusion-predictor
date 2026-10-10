# Digital Financial Inclusion Predictor
# Interactive Shiny Application

library(shiny)
library(tidyverse)

# --------------------------------------------------
# 1. Load the trained model
# --------------------------------------------------

model_path <- "models/logistic_regression_model.rds"

if (!file.exists(model_path)) {
  stop(
    "The model file was not found. ",
    "Make sure models/logistic_regression_model.rds exists."
  )
}

model <- readRDS(model_path)

# --------------------------------------------------
# 2. Load the cleaned data
# --------------------------------------------------

data_path <- "data/processed/customers_clean.csv"

if (!file.exists(data_path)) {
  stop(
    "The cleaned dataset was not found. ",
    "Make sure data/processed/customers_clean.csv exists."
  )
}

customers <- read_csv(
  data_path,
  show_col_types = FALSE
)

# --------------------------------------------------
# 3. Helper functions
# --------------------------------------------------

# Convert common yes/no values into a factor
yes_no_factor <- function(value) {
  factor(
    value,
    levels = c("No", "Yes")
  )
}

# Safely select a column from the dataset
get_column <- function(data, column_name, default_value) {
  if (column_name %in% names(data)) {
    data[[column_name]]
  } else {
    rep(default_value, nrow(data))
  }
}

# --------------------------------------------------
# 4. User interface
# --------------------------------------------------

ui <- fluidPage(
  
  # Custom styling
  tags$head(
    tags$style(HTML("
      body {
        background-color: #f5f7fa;
        font-family: Arial, sans-serif;
      }

      .navbar {
        background-color: #123b63;
        border-color: #123b63;
      }

      .navbar-brand {
        color: white !important;
        font-weight: bold;
      }

      h2, h3 {
        color: #123b63;
        font-weight: bold;
      }

      .well {
        background-color: white;
        border: 1px solid #d9e2ec;
        border-radius: 6px;
        box-shadow: none;
      }

      .prediction-box {
        background-color: #123b63;
        color: white;
        padding: 25px;
        border-radius: 6px;
        text-align: center;
        margin-top: 20px;
      }

      .prediction-value {
        font-size: 42px;
        font-weight: bold;
        color: #f2c94c;
      }

      .recommendation-box {
        background-color: #e8f4f3;
        border-left: 5px solid #14817a;
        padding: 18px;
        margin-top: 20px;
      }

      .warning-box {
        background-color: #fff4d6;
        border-left: 5px solid #d4af37;
        padding: 18px;
        margin-top: 20px;
      }

      .btn-primary {
        background-color: #14817a;
        border-color: #14817a;
      }

      .btn-primary:hover {
        background-color: #0f625e;
        border-color: #0f625e;
      }
    "))
  ),
  
  navbarPage(
    title = "Digital Financial Inclusion Predictor",
    
    tabPanel(
      "Predict Adoption",
      
      fluidRow(
        column(
          width = 4,
          
          wellPanel(
            h3("Customer Information"),
            
            selectInput(
              inputId = "gender",
              label = "Gender",
              choices = c("Female", "Male"),
              selected = "Female"
            ),
            
            selectInput(
              inputId = "age_group",
              label = "Age Group",
              choices = c(
                "18-25",
                "26-35",
                "36-45",
                "46-55",
                "56+"
              ),
              selected = "26-35"
            ),
            
            selectInput(
              inputId = "location_type",
              label = "Location Type",
              choices = c(
                "Urban",
                "Peri-urban",
                "Rural"
              ),
              selected = "Urban"
            ),
            
            selectInput(
              inputId = "business_owner",
              label = "Business Owner",
              choices = c("No", "Yes"),
              selected = "No"
            ),
            
            numericInput(
              inputId = "monthly_income",
              label = "Monthly Income",
              value = 30000,
              min = 0,
              step = 1000
            ),
            
            numericInput(
              inputId = "monthly_expenses",
              label = "Monthly Expenses",
              value = 20000,
              min = 0,
              step = 1000
            ),
            
            numericInput(
              inputId = "monthly_savings",
              label = "Monthly Savings",
              value = 5000,
              min = 0,
              step = 500
            ),
            
            numericInput(
              inputId = "mobile_money_transactions",
              label = "Monthly Mobile-Money Transactions",
              value = 25,
              min = 0,
              step = 1
            ),
            
            numericInput(
              inputId = "average_transaction_value",
              label = "Average Transaction Value",
              value = 1500,
              min = 0,
              step = 100
            ),
            
            sliderInput(
              inputId = "loan_repayment_rate",
              label = "Loan Repayment Rate",
              min = 0,
              max = 1,
              value = 0.85,
              step = 0.01
            ),
            
            selectInput(
              inputId = "financial_education",
              label = "Received Financial Education",
              choices = c("No", "Yes"),
              selected = "No"
            ),
            
            numericInput(
              inputId = "agent_distance_km",
              label = "Distance to Nearest Agent (km)",
              value = 3,
              min = 0,
              step = 0.5
            ),
            
            numericInput(
              inputId = "app_login_frequency",
              label = "Monthly App Login Frequency",
              value = 10,
              min = 0,
              step = 1
            ),
            
            numericInput(
              inputId = "customer_service_contacts",
              label = "Customer-Service Contacts",
              value = 1,
              min = 0,
              step = 1
            ),
            
            actionButton(
              inputId = "predict_button",
              label = "Predict Adoption",
              class = "btn-primary btn-lg",
              width = "100%"
            )
          )
        ),
        
        column(
          width = 8,
          
          h2("Savings-Product Adoption Estimate"),
          
          p(
            "Enter customer characteristics on the left, then select ",
            strong("Predict Adoption"),
            " to generate an estimated probability."
          ),
          
          div(
            class = "prediction-box",
            h3("Estimated Probability of Adoption"),
            uiOutput("probability_output"),
            uiOutput("classification_output")
          ),
          
          div(
            class = "recommendation-box",
            h3("Interpretation"),
            uiOutput("recommendation_output")
          ),
          
          div(
            class = "warning-box",
            h3("Responsible Use Notice"),
            p(
              "This application is for educational and portfolio purposes only. ",
              "It uses synthetic data and should not be used to approve, deny, ",
              "price, or restrict financial services. Any real-world application ",
              "would require consent, fairness testing, security controls, ",
              "regulatory review, and human oversight."
            )
          )
        )
      )
    ),
    
    tabPanel(
      "About the Project",
      
      fluidRow(
        column(
          width = 10,
          offset = 1,
          
          h2("Project Overview"),
          
          p(
            "This project explores whether customer, financial, and ",
            "digital-engagement characteristics can help predict savings-product ",
            "adoption in a microfinance and digital-finance context."
          ),
          
          h3("Model Used"),
          
          p(
            "The application uses a logistic regression model trained on ",
            "synthetic customer data. Logistic regression was selected because ",
            "its results are easier to interpret and communicate to stakeholders."
          ),
          
          h3("Reported Model Results"),
          
          tableOutput("performance_table"),
          
          h3("Ethical Considerations"),
          
          tags$ul(
            tags$li("Protect customer privacy and minimise sensitive data."),
            tags$li("Test model performance across customer groups."),
            tags$li("Explain predictions clearly to stakeholders."),
            tags$li("Use human review for important financial decisions."),
            tags$li("Never use the model to automatically exclude customers.")
          )
        )
      )
    )
  )
)

# --------------------------------------------------
# 5. Server logic
# --------------------------------------------------

server <- function(input, output, session) {
  
  # Store the latest prediction
  prediction_result <- eventReactive(
    input$predict_button,
    {
      
      # Create a new customer record
      new_customer <- data.frame(
        gender = input$gender,
        age_group = input$age_group,
        location_type = input$location_type,
        business_owner = input$business_owner,
        monthly_income = input$monthly_income,
        monthly_expenses = input$monthly_expenses,
        mobile_money_transactions =
          input$mobile_money_transactions,
        average_transaction_value =
          input$average_transaction_value,
        monthly_savings = input$monthly_savings,
        loan_repayment_rate =
          input$loan_repayment_rate,
        financial_education =
          input$financial_education,
        agent_distance_km =
          input$agent_distance_km,
        app_login_frequency =
          input$app_login_frequency,
        customer_service_contacts =
          input$customer_service_contacts,
        stringsAsFactors = FALSE
      )
      
      # Convert categorical variables to factors
      new_customer$gender <- factor(
        new_customer$gender,
        levels = c("Female", "Male")
      )
      
      new_customer$age_group <- factor(
        new_customer$age_group,
        levels = c(
          "18-25",
          "26-35",
          "36-45",
          "46-55",
          "56+"
        )
      )
      
      new_customer$location_type <- factor(
        new_customer$location_type,
        levels = c(
          "Urban",
          "Peri-urban",
          "Rural"
        )
      )
      
      new_customer$business_owner <- factor(
        new_customer$business_owner,
        levels = c("No", "Yes")
      )
      
      new_customer$financial_education <- factor(
        new_customer$financial_education,
        levels = c("No", "Yes")
      )
      
      # Predict the adoption probability
      probability <- tryCatch(
        {
          predict(
            model,
            newdata = new_customer,
            type = "response"
          )[[1]]
        },
        error = function(e) {
          NA_real_
        }
      )
      
      # If the model cannot predict because the local variable
      # names differ, return an explanatory message
      if (is.na(probability)) {
        return(
          list(
            probability = NA_real_,
            error = TRUE
          )
        )
      }
      
      classification <- ifelse(
        probability >= 0.5,
        "Likely to adopt",
        "Less likely to adopt"
      )
      
      list(
        probability = probability,
        classification = classification,
        error = FALSE
      )
    },
    ignoreInit = TRUE
  )
  
  # Display probability
  output$probability_output <- renderUI({
    
    result <- prediction_result()
    
    if (isTRUE(result$error)) {
      return(
        div(
          style = "font-size: 18px;",
          "The model could not process the input. ",
          "Check that the variable names in app.R match the model-training script."
        )
      )
    }
    
    div(
      class = "prediction-value",
      paste0(round(result$probability * 100, 1), "%")
    )
  })
  
  # Display classification
  output$classification_output <- renderUI({
    
    result <- prediction_result()
    
    if (isTRUE(result$error)) {
      return(NULL)
    }
    
    div(
      style = "font-size: 22px; margin-top: 10px;",
      result$classification
    )
  })
  
  # Display interpretation
  output$recommendation_output <- renderUI({
    
    result <- prediction_result()
    
    if (isTRUE(result$error)) {
      return(
        p(
          "The prediction could not be generated. ",
          "Please compare the variables in app.R with the variables used ",
          "when training the model."
        )
      )
    }
    
    if (result$probability >= 0.5) {
      p(
        "The model estimates a higher probability of savings-product ",
        "adoption for the entered profile. This could indicate that the ",
        "customer may be suitable for voluntary product information or ",
        "financial education."
      )
    } else {
      p(
        "The model estimates a lower probability of savings-product ",
        "adoption for the entered profile. This should not be interpreted ",
        "as a rejection. The customer may still benefit from financial ",
        "education, product information, or improved access."
      )
    }
  })
  
  # Display model-performance table
  output$performance_table <- renderTable({
    
    if (file.exists("reports/model_performance.csv")) {
      
      read_csv(
        "reports/model_performance.csv",
        show_col_types = FALSE
      ) %>%
        mutate(
          value = round(as.numeric(value), 3)
        )
      
    } else {
      
      data.frame(
        Metric = c(
          "Specificity",
          "Precision",
          "F1-score",
          "ROC-AUC"
        ),
        Result = c(
          0.533,
          0.667,
          0.712,
          0.678
        )
      )
    }
  })
}

# --------------------------------------------------
# 6. Launch the application
# --------------------------------------------------

shinyApp(
  ui = ui,
  server = server
)
