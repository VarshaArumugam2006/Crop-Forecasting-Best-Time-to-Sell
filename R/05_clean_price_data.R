# ============================================
# CLEAN MARKET PRICE DATA
# ============================================

price_data <- read.csv(
  "data/agridata_csv_202110311352.csv"
)

cat("Original rows:", nrow(price_data), "\n")

# Remove rows where important values are missing
price_data <- price_data[
  !is.na(price_data$commodity_name) &
  !is.na(price_data$modal_price) &
  !is.na(price_data$date),
]

# Convert date
price_data$date <- as.Date(price_data$date)

# Remove invalid dates
price_data <- price_data[
  !is.na(price_data$date),
]

# Create year and month
price_data$Year <- as.numeric(
  format(price_data$date, "%Y")
)

price_data$Month <- as.numeric(
  format(price_data$date, "%m")
)

price_data$Month_Name <- format(
  price_data$date,
  "%B"
)

# Remove invalid modal prices
price_data <- price_data[
  !is.na(price_data$modal_price) &
  price_data$modal_price > 0,
]

# Save cleaned dataset
write.csv(
  price_data,
  "data/market_price_clean.csv",
  row.names = FALSE
)

cat("\n=================================\n")
cat("PRICE DATA CLEANING COMPLETED!\n")
cat("=================================\n")

cat("\nCleaned rows:", nrow(price_data), "\n")

cat("\nColumns:\n")
print(names(price_data))

cat("\nFirst 10 rows:\n")
print(head(price_data, 10))