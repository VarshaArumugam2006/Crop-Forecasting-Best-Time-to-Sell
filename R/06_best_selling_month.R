# ============================================
# FIND BEST MONTH TO SELL CROPS
# ============================================

price_data <- read.csv(
  "data/market_price_clean.csv"
)

# Calculate average modal price
monthly_price <- aggregate(
  modal_price ~ commodity_name + Month + Month_Name,
  data = price_data,
  FUN = mean,
  na.rm = TRUE
)

# Round prices
monthly_price$modal_price <- round(
  monthly_price$modal_price,
  2
)

# Save monthly price data
write.csv(
  monthly_price,
  "data/monthly_crop_prices.csv",
  row.names = FALSE
)

cat("=================================\n")
cat("BEST SELLING MONTH ANALYSIS\n")
cat("=================================\n\n")

cat("Total crop-month combinations:",
    nrow(monthly_price), "\n\n")

# Show some results
cat("Sample monthly prices:\n")
print(head(monthly_price, 20))

cat("\n=================================\n")
cat("ANALYSIS COMPLETED!\n")
cat("=================================\n")