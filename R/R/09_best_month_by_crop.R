# ============================================
# FIND BEST MONTH TO SELL EACH CROP
# ============================================

# Load monthly prices
monthly_price <- read.csv(
  "data/monthly_crop_prices.csv"
)

# Load crop mapping
mapping <- read.csv(
  "data/crop_name_mapping.csv"
)

# Clean crop names
monthly_price$commodity_name <- trimws(
  monthly_price$commodity_name
)

mapping$matched_market_crop <- trimws(
  mapping$matched_market_crop
)

# Join production crop names with market prices
crop_prices <- merge(
  mapping,
  monthly_price,
  by.x = "matched_market_crop",
  by.y = "commodity_name"
)

# Find the highest monthly price for each production crop
best_month <- crop_prices[
  order(
    crop_prices$production_crop,
    -crop_prices$modal_price
  ),
]

best_month <- best_month[
  !duplicated(best_month$production_crop),
]

# Keep useful columns
best_month <- best_month[
  ,
  c(
    "production_crop",
    "matched_market_crop",
    "Month",
    "Month_Name",
    "modal_price",
    "distance"
  )
]

# Rename price column
names(best_month)[
  names(best_month) == "modal_price"
] <- "Best_Price"

# Save results
write.csv(
  best_month,
  "data/best_selling_month.csv",
  row.names = FALSE
)

cat("=================================\n")
cat("BEST SELLING MONTH CALCULATED\n")
cat("=================================\n\n")

cat("Number of crops analyzed:",
    nrow(best_month), "\n\n")

cat("Sample results:\n\n")

print(head(best_month, 20))

cat("\n=================================\n")
cat("BEST MONTH FILE SAVED!\n")
cat("=================================\n")