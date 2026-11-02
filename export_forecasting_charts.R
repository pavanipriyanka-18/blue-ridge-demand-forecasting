# Blue Ridge Cabin Rentals — export real forecasting charts
# Run from the repository folder after adding the authorized BlueRidgeCabins.csv.
# Required CSV columns: Date (month/day/year), Nights (numeric).

library(fpp3)
library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

if (!file.exists('BlueRidgeCabins.csv')) {
  stop('Missing BlueRidgeCabins.csv. Place your original dataset beside this script.')
}
dir.create('charts', showWarnings = FALSE)

cabins <- read_csv('BlueRidgeCabins.csv', show_col_types = FALSE) |>
  mutate(Month = yearmonth(mdy(Date))) |>
  select(Month, Nights) |>
  as_tsibble(index = Month)

save_chart <- function(plot, filename, width = 11, height = 6) {
  ggsave(file.path('charts', filename), plot = plot,
         width = width, height = height, units = 'in', dpi = 300, bg = 'white')
}

p1 <- autoplot(cabins, Nights) +
  labs(title = 'Historical Monthly Cabin Nights', x = 'Month', y = 'Nights booked')
save_chart(p1, '01_historical_bookings.png')

p2 <- gg_season(cabins, Nights, labels = 'both') +
  labs(title = 'Seasonal Demand by Month and Year', y = 'Nights booked')
save_chart(p2, '02_seasonality.png')

components <- cabins |> model(STL(Nights)) |> components()
p3 <- autoplot(components) + labs(title = 'STL Trend and Seasonality Decomposition')
save_chart(p3, '03_stl_decomposition.png', height = 8)

train <- cabins |> filter(Month <= yearmonth('2023 Dec'))
fit <- train |> model(
  SNaive = SNAIVE(Nights),
  TSLM = TSLM(Nights ~ trend() + season()),
  HW_add = ETS(Nights ~ error('A') + trend('A') + season('A')),
  HW_mult = ETS(Nights ~ error('M') + trend('A') + season('M')),
  Auto = ETS(Nights)
)
forecast_test <- fit |> forecast(h = 24)
p4 <- autoplot(forecast_test, cabins, level = NULL) +
  labs(title = 'Forecast Model Comparison: 2024–2025', x = 'Month', y = 'Nights booked')
save_chart(p4, '04_model_comparison.png')

final_fit <- cabins |> model(Auto = ETS(Nights))
forecast_2026 <- final_fit |> forecast(h = 12)
p5 <- autoplot(forecast_2026, cabins, level = c(80, 95)) +
  labs(title = '2026 Demand Forecast with 80% and 95% Prediction Intervals',
       x = 'Month', y = 'Nights booked')
save_chart(p5, '05_forecast_2026.png')

model_accuracy <- forecast_test |> accuracy(cabins) |>
  select(.model, ME, RMSE, MAE, MAPE, MASE) |>
  arrange(MASE)
write_csv(as_tibble(model_accuracy), 'charts/model_accuracy.csv')

cat('Exported 5 PNG charts and charts/model_accuracy.csv successfully.\n')
