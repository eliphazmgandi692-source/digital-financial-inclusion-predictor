# Model Interpretation Report

## Objective

The logistic regression model predicts whether a customer is likely to adopt a savings product based on demographic, financial, and digital-engagement information.

## Model interpretation

Variables with odds ratios greater than 1 are associated with higher predicted odds of savings-product adoption. Variables with odds ratios below 1 are associated with lower predicted odds. These relationships are associations and do not prove that one variable causes adoption.

## Business relevance

The results can help a financial institution identify customers who may benefit from financial education, product information, or supportive outreach. The model should not be used to automatically approve or deny financial services.

## Ethical considerations

The dataset is synthetic. A real implementation would require informed consent, privacy protection, secure data storage, fairness testing, human review, and continuous monitoring.

## Limitations

The model was trained on synthetic data, so its results may not represent actual customer behaviour. The model should be validated using representative real-world data before any operational use.

## Next steps

Future improvements could include comparing the model with random forest, testing different probability thresholds, evaluating fairness across groups, and creating a simple interactive application.
