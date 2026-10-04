# =========================================
# CROP PRODUCTION DATA CLEANING
# =========================================

# Load dataset
crop_data <- read.csv(
  "data/crop_production.csv"
)

# Show original dataset size
cat("Original dataset size:\n")
print(dim(crop_data))


# =========================================
# REMOVE MISSING PRODUCTION VALUES
# =========================================

crop_data <- crop_data[
  !is.na(crop_data$Production),
]


# =========================================
# REMOVE DUPLICATE ROWS
# =========================================

crop_data <- unique(crop_data)


# =========================================
# REMOVE INVALID AREA VALUES
# =========================================

crop_data <- crop_data[
  crop_data$Area > 0,
]


# =========================================
# SAVE CLEANED DATASET
# =========================================

write.csv(
  crop_data,
  "data/crop_production_clean.csv",
  row.names = FALSE
)


# =========================================
# SHOW FINAL DATASET SIZE
# =========================================

cat("Cleaned dataset size:\n")
print(dim(crop_data))

cat("Cleaning completed successfully!\n")