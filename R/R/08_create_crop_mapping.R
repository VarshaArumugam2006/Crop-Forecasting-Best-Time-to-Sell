# ============================================
# CREATE CROP NAME MAPPING
# ============================================

production_data <- read.csv(
  "data/crop_production_clean.csv"
)

price_data <- read.csv(
  "data/market_price_clean.csv"
)

# Unique crop names
production_crops <- sort(unique(production_data$Crop))
market_crops <- sort(unique(price_data$commodity_name))

# Clean names for comparison
production_clean <- tolower(
  trimws(production_crops)
)

market_clean <- tolower(
  trimws(market_crops)
)

# Find closest market crop for each production crop
mapping <- data.frame(
  production_crop = production_crops,
  matched_market_crop = NA_character_,
  distance = NA_integer_
)

for (i in seq_along(production_clean)) {

  distances <- adist(
    production_clean[i],
    market_clean
  )

  best_match <- which.min(distances)

  mapping$matched_market_crop[i] <-
    market_crops[best_match]

  mapping$distance[i] <-
    distances[best_match]
}

# Save mapping
write.csv(
  mapping,
  "data/crop_name_mapping.csv",
  row.names = FALSE
)

cat("=================================\n")
cat("CROP MAPPING CREATED\n")
cat("=================================\n\n")

cat("Total production crops:",
    nrow(mapping), "\n\n")

cat("First 30 suggested matches:\n\n")

print(head(mapping, 30))

cat("\n=================================\n")
cat("MAPPING FILE SAVED!\n")
cat("=================================\n")