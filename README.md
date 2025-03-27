# project_four

* **Objectives**
  * Develop a predictive model for accurately forecasting housing prices.
    * Investigate: Can we create a reliable model to predict future home prices with precision?
  * Provide visualizations for what our training data looks like showing Real Estate market trends and outcomes over time using Matplotlib, Seaborn, and Tableau.
  * Compile an extensive set of features to strengthen our `Home Sales Price Prediction Model`. This project leverages Redfin real estate data and Freddie Mac mortgage rates to analyze and anticipate home prices.

## Data Sources

* Data provided by Redfin, a national real estate brokerage.
[Redfin Data-Center](https://www.redfin.com/news/data-center/)

* Freddie Mac, 30-Year Fixed Rate Mortgage Average in the United States [MORTGAGE30US], retrieved from FRED, Federal Reserve Bank of St. Louis;  
[Freddie Mac 30 year fixed rates](https://fred.stlouisfed.org/series/MORTGAGE30US)

## Pre-Processing

* Used Jupyter Notebook with standard imports of Pandas, Numpy for data preprocessing. Started with 5 data files, through cleaning and merging elimiated the national set as the state held the most data, approximately 250 datapoints per date.
* Updated dates, data formats, merged the price index with the month over month index and reordered columns.
* Formatted the `MORTGAGE30US` and corrected the date column from weekly to monthly `rates_df_copy` to dupliecate for each month
* Created copies of all DataFrames and merged `state_df_copy` with `hpi_index_copy` to make `combined_df`. With the first 3 DataFrames done, merged `combined_df` with `rates_df_copy` to have `complete_df`.
* Applied .fillna(0) to appropriate features based on percentages.
* Applied .mean() calculation to missing row data
* Saved new csv `complete_data_csv` and provided for SQL Database creation and further cleaning and exploration.

## Database Creation

* Implemented PostgreSQL and PySpark for database creation and management.

## Tableau

* Designed and developed an interactive dashboard.

## Linear Regression

* Model: `LinearRegression()`
  * `train_test_split`:
    * Training data: 01/01/2014 - 02/28/2023
    * Testing data: 03/01/2023 - 09/30/2024
  * Results:
    * Variance explained: ~76%
    * Average difference between actual and predicted values: $51,756.97
    * Mean Absolute Error (MAE): 51756.971365011486
    * R² Score: 0.760306234063732

## XgBoost

* Model 1 is `xg_reg = xgb.XGBRegressor(n_estimators=100, random_state=42, n_jobs=-1)`
  * `train_test_split`:
    * Training data: 01/01/2014 - 02/28/2023
    * Testing data: 03/01/2023 - 09/30/2024
  * Results:
    * Variance Explained: ~87%
    * Average difference between actual and predicted values: $31,085.42
    * Mean Absolute Error: 31085.416844472165
    * R² Score: 0.8782984667958691

* Model 2 added in the Top 25 Features, `xg_reg_top25 = xgb.XGBRegressor(n_estimators=75, random_state=42, n_jobs=-1)`
  * `train_test_split`:  No change
  * Results: {Reducing the n_estimators to 75 reduces the optimization}
    * Variance Explained: ~88%
    * Average difference between actual and predicted values: $33,659.20
    * Mean Absolute Error: 33659.201000361085
    * R² Score: 0.8825637115322471

## Random Forest Regressor

* Model 3: Iterated several versions to achieve the highest possible accuracy. The first step was to set a baseline to determine the number of
n_estimators to use. Worked up from 50 to 75 to 100. `rf_model = RandomForestRegressor(n_estimators=100,random_state=42, n_jobs=-1)` Determined how to establish the top contributors from the results as the results were mirroring the XgBoost model.
* Results:
  * Mean Absolute Error: 31887.499789915968
  * R² Score: 0.8714313381885137

```Python
# Calculate the top 25 features and sort in descending order
importances = rf_model.feature_importances_ 
feature_names = X_train.columns
sorted_indices = importances.argsort()[::-1]  

top_25_features = feature_names[sorted_indices][:25]  
print("Top 25 Features:", top_25_features)
```

* Added engineered features to improve feature reliance on calcuation between 2 existing numeric features.

```Python
# Multiply interactions that have higher influence in feature set 
X_train['ppsf_inventory_interaction'] = X_train['median_ppsf_log'] * X_train['inventory']
X_test['ppsf_inventory_interaction'] = X_test['median_ppsf_log'] * X_test['inventory']
```

* `train_test_split`:
  * Training data: 01/01/2014 - 02/28/2023
  * Testing data: 03/01/2023 - 09/30/2024
  * Results: {Reducing the n_estimators to 75 reduces the optimization}
    * Variance Explained: ~94%
    * Average difference between actual and predicted values: $8629.38
    * Mean Absolute Error: 8629.376680672269
    * R² Score: 0.9473431378488051

* Further optimization steps:
  * `upper_limit_price = 1500000` This filtered the max median_list_price at $1.5 million.
  * `upper_limit_dom = 730` This filtered out the outlier Days on Market and put max of 2 years.
  * Adjusted the `train_test_split` to begin (1/1/2013 - 2/28/2023), no change to the test split.
  * Completed GridSearchCV to determine what was the optimal set for n_estimators, max_depth and min_samples. After running with and without the min_samples it was determined that increasing n_estimators and putting a limit on the depth improved performance.
  * model - `best_rf_model = RandomForestRegressor(max_depth=20, n_estimators=300, random_state=42, n_jobs=-1)`
  * Results:
    * Variance Explained: ~94%
    * Average difference between actual and predicted values: $8234.14
    * Optimized Mean Absolute Error: 8234.135995214614
    * Optimized R² Score: 0.9479948988106021

* Final Model Prediction: Added in the min_samples from optimization results.
  * `final_model = RandomForestRegressor(max_depth=20, min_samples_leaf=1, min_samples_split=2, n_estimators=300, random_state=42, n_jobs=-1)`
  * `train_test_split` Training (03/01/2013 - 06/30/2024) and Testing (07/2024 - 09/2024) to predict future results.
  * Results:
    * Variance Explained: ~95%
    * Average difference between actual and predicted values: $7051.72
    * Mean Absolute Error (Holdout): 7051.7177115952245
    * R² Score (Holdout): 0.9526112229978853

## Tableau and Google classroom presentation links

[Project 4 Home Price Team](https://public.tableau.com/views/Project4-Home-Price-Team/Sheet9?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

[Google Slides](https://docs.google.com/presentation/d/1_ktoKaDu7wblDlKUY6hiMKfcIKENC8cLgnWRBOtgU1s/edit?slide=id.p#slide=id.p)

## Team

* Chad Hillman
* Mohamoud Jama
* DJ Dimetros
* Daniel Simonson

## License

This project is licensed under the terms of the GNU General Public License v3.0. For more details, see the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.en.html) file.
