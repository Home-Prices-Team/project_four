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

* Utilized Pandas for data preprocessing.

## Database Creation

* Implemented PostgreSQL and PySpark for database creation and management.

## Tableau

* Designed and developed an interactive dashboard.

## Linear Regression

* Model: LinearRegression()
  * `train_test_split`:
    * Training data: 01/01/2014 - 02/28/2023
    * Testing data: 03/01/2023 - 09/30/2024
  * Results:
    * Variance explained: ~76%
    * Average difference between actual and predicted values: $51,756.97
    * Mean Absolute Error (MAE): 51756.971365011486
    * R² Score: 0.760306234063732

## XgBoost

* Model 1 is xg_reg = xgb.XGBRegressor(n_estimators=100, random_state=42, n_jobs=-1)
  * `train_test_split`:
    * Training data: 01/01/2014 - 02/28/2023
    * Testing data: 03/01/2023 - 09/30/2024
  * Results:
    * Variance Explained: ~87%
    * Average difference between actual and predicted values: $31,085.42
    * Mean Absolute Error: 31085.416844472165
    * R² Score: 0.8782984667958691

* Model 2 added in the Top 25 Features, xg_reg_top25 = xgb.XGBRegressor(n_estimators=75, random_state=42, n_jobs=-1)
  * `train_test_split`:  No change
  * Results: {Reducing the n_estimators to 75 reduces the optimization}
    * Variance Explained: ~88%
    * Average difference between actual and predicted values: $33,659.20
    * Mean Absolute Error: 33659.201000361085
    * R² Score: 0.8825637115322471

## Random Forest Regressor

* Model 3: Iterated several versions to achieve the highest possible accuracy.

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
