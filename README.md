# Blue Ridge Cabin Rentals — Demand Forecasting & Capacity Planning

**R | Time-series forecasting | ETS | Holt-Winters | Seasonal regression | Cross-validation | Capacity planning**

## Project overview

An academic business forecasting case study analyzing monthly cabin nights booked during **2014–2025**. The goal is to forecast monthly 2026 demand and translate the forecast into practical cleaning and maintenance capacity decisions.

This project demonstrates skills transferable to **supply chain operations, fulfillment planning, staffing, peak-season readiness, and demand forecasting**. The dataset models cabin bookings, **not** warehouse orders or real-time logistics operations.

## Business question

How many cabin nights should the business prepare to service each month, especially during the summer peak, while balancing the costs of insufficient and unused capacity?

## Methodology

1. Load and validate monthly bookings and check missing periods and values.
2. Examine trend, yearly seasonality, ACF, and STL decomposition.
3. Train on data through **December 2023** and evaluate on **January 2024–December 2025**.
4. Compare mean, naive, seasonal naive, and drift benchmarks; then seasonal regression (TSLM), additive/multiplicative Holt-Winters, and automatically selected ETS models.
5. Compare forecast errors using **ME, RMSE, MAE, MAPE, and MASE**; inspect residuals and Ljung–Box diagnostics.
6. Use expanding-window time-series cross-validation with 12-month forecasts.
7. Refit automatic ETS to the full historical series and forecast all 12 months of 2026 with **80% and 95% prediction intervals**.
8. Translate July forecast uncertainty into a staffing/capacity decision.

## Key observations and business implications

- The original analysis identifies a growing bookings trend and pronounced annual seasonality, with summer demand higher than winter demand.
- Forecasting evaluation uses a forward-looking holdout rather than a random sample to avoid leaking future observations into training.
- The recommended operating plan accounts for both expected demand **and uncertainty**, rather than relying exclusively on the point estimate.
- When an uncovered night costs **$120** and unused capacity costs **$40**, the critical ratio is `120 / (120 + 40) = 0.75`. The corresponding plan uses the **75th percentile** of July's forecast distribution.

**Verified dataset:** 144 consecutive monthly records, January 2014–December 2025, supplied by the project author. Charts below were generated from those actual observations. The 2024–2025 forecast comparison and 2026 forecast were **reproduced in Python using statsmodels**, not executed with the original R `fpp3` implementation. Therefore estimated model coefficients, accuracy values, forecasts and especially interval limits may differ from the R midterm results. The uncertainty bands are illustrative approximations, not calibrated `fable` prediction intervals. In this Python comparison, the lowest holdout MASE was **ETS candidate (AIC) (0.51)**. The AIC-selected Python ETS structure was **('mul', 'add', 'mul')**.

## Repository files

| File | Description |
|---|---|
| `forecast_analysis.Rmd` | Cleaned, portfolio-ready R Markdown source, with reproducible forecasting code and model-generated commentary |
| `Blue_Ridge_Forecasting_Portfolio_Report.pdf` | Short recruiter-friendly overview of business problem, methods, and decision framework |
| `data/README.md` | Expected dataset format and data availability note |
| `charts/*.png` | Five charts generated from supplied data, with Python model reproductions labeled |
| `charts/model_accuracy.csv` | 2024–2025 holdout comparison from Python reproduction |
| `charts/forecast_2026_python_approx.csv` | Illustrative 2026 forecast and interval bounds |
| `export_forecasting_charts.R` | RStudio script to generate the original R-based charts |
| `README.md` | Project overview and setup instructions |

## Run the analysis

**Prerequisites:** R, RStudio (optional), and R packages `fpp3`, `lubridate`, `dplyr`, `readr`, `knitr`, and `rmarkdown`.

1. Obtain the original authorized `BlueRidgeCabins.csv` source dataset and put it in the repository root beside `forecast_analysis.Rmd`. The CSV was supplied for figure creation but is intentionally **not included in this public repository** pending permission to publish.
2. Install packages as needed:

   ```r
   install.packages(c("fpp3", "lubridate", "dplyr", "readr", "knitr", "rmarkdown"))
   ```
3. Render in RStudio using **Knit**, or run:

   ```r
   rmarkdown::render("forecast_analysis.Rmd")
   ```

The original R Markdown reads `BlueRidgeCabins.csv` with columns `Date` and `Nights`; `Date` is parsed as month/day/year. Package versions and the source data may affect reproduced output.

## Limitations

- This is an **academic case study**, not a production deployment or a real fulfillment-center monitoring system.
- The original CSV is not included because public redistribution rights have not been established. The exported charts and tables were generated using a private copy supplied by the author. To fully reproduce the analysis, obtain the authorized CSV and run the R or Python scripts.
- The forecasts use historical booking demand and do not independently include weather, pricing, holiday/event, or macroeconomic covariates.
- Planning based on a forecast should be updated as new actual demand becomes available.

## Tools and skills

R, RStudio, `fpp3`, `fable`, `feasts`, `tsibble`, exploratory data analysis, demand forecasting, forecast model validation, MASE, residual diagnostics, and decision-making under uncertainty.

## Attribution and assistance

Developed by **Pavani Priyanka Merla** as an academic project (October 2026). ChatGPT assisted with organization, forecasting explanations, troubleshooting, and preparing the public-facing portfolio presentation. Analysis methods and numerical results in the R Markdown are data-driven and calculated by its code.

## Forecasting charts (generated from the original dataset)

**Note:** Charts 1–3 directly visualize the original monthly booking data; charts 4–5 are labeled Python/statsmodels reproductions of the R midterm modeling workflow, not exact R model outputs. The uncertainty intervals in chart 5 are approximations.

### 1. Historical bookings
![Historical bookings](historical_bookings.png)

### 2. Seasonality
![Monthly seasonality](seasonality.png)

### 3. Trend, seasonality, and residuals
![STL decomposition](decomposition.png)

### 4. Model comparison on held-out months
![Model comparison](model_comparison.png)

### 5. 2026 forecast (Python approximation)
![2026 forecast](forecast_2026.png)

The model accuracy and forecast CSV tables are in `charts/`. Use `export_forecasting_charts.R` in RStudio with the authorized CSV to generate native `fpp3`/`fable` forecasts.
