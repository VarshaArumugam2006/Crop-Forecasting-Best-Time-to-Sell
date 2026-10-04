# =========================================
# CROP PRODUCTION PREDICTION MODEL
# RANGER RANDOM FOREST
# =========================================

# Load Ranger package
library(ranger)


# =========================================
# LOAD CLEANED DATASET
# =========================================

crop_data <- read.csv(
  "data/crop_production_clean.csv"
)


# =========================================
# CONVERT TEXT COLUMNS TO FACTORS
# =========================================

crop_data$State_Name <- as.factor(
  crop_data$State_Name
)

crop_data$District_Name <- as.factor(
  crop_data$District_Name
)

crop_data$Season <- as.factor(
  crop_data$Season
)

crop_data$Crop <- as.factor(
  crop_data$Crop
)


# =========================================
# TRAIN RANDOM FOREST MODEL
# =========================================

model <- ranger(
  Production ~
    State_Name +
    District_Name +
    Crop_Year +
    Season +
    Crop +
    Area,
  data = crop_data,
  num.trees = 100,
  importance = "impurity"
)


# =========================================
# DISPLAY MODEL
# =========================================

print(model)


# =========================================
# DISPLAY VARIABLE IMPORTANCE
# =========================================

print(model$variable.importance)


# =========================================
# SAVE TRAINED MODEL
# =========================================

saveRDS(
  model,
  "models/crop_production_model.rds"
)


# =========================================
# SUCCESS MESSAGE
# =========================================

cat("\n=================================\n")
cat("MODEL TRAINING COMPLETED!\n")
cat("=================================\n")