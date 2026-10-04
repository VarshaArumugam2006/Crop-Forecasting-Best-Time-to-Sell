# ============================================
# CHECK CROP NAME MATCHING
# ============================================

# Load production data
production_data <- read.csv(
  "data/crop_production_clean.csv"
)

# Load market price data
price_data <- read.csv(
  "data/market_price_clean.csv"
)

# Get unique crop names
production_crops <- sort(
  unique(production_data$Crop)
)

market_crops <- sort(
  unique(price_data$commodity_name)
)

cat("=================================\n")
cat("CROP NAME MATCHING CHECK\n")
cat("=================================\n\n")

cat("Number of production crops:",
    length(production_crops), "\n")

cat("Number of market commodities:",
    length(market_crops), "\n\n")

# Convert names to lowercase for comparison
production_lower <- tolower(
  trimws(production_crops)
)

market_lower <- tolower(
  trimws(market_crops)
)

# Find exact matches
matched_crops <- production_crops[
  production_lower %in% market_lower
]

# Find production crops without matches
unmatched_crops <- production_crops[
  !(production_lower %in% market_lower)
]

cat("=================================\n")
cat("MATCHED CROPS\n")
cat("=================================\n")

cat("Number of matched crops:",
    length(matched_crops), "\n\n")

print(matched_crops)

cat("\n=================================\n")
cat("UNMATCHED PRODUCTION CROPS\n")
cat("=================================\n")

cat("Number of unmatched crops:",
    length(unmatched_crops), "\n\n")

print(unmatched_crops)