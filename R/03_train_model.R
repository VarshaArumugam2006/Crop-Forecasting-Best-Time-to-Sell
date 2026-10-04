# ============================================
# CROP PRODUCTION MODEL TRAINING
# ============================================

library(ranger)

# ============================================
# LOAD CLEAN PRODUCTION DATA
# ============================================

crop_data <- read.csv(
  "data/crop_production_clean.csv",
  stringsAsFactors = FALSE
)

cat("Production data loaded:\n")
print(dim(crop_data))

# ============================================
# CONVERT CATEGORICAL COLUMNS TO FACTORS
# ============================================

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

# ============================================
# TRAIN SMALL RANGER MODEL
# ============================================

cat("\nTraining smaller model...\n")

model <- ranger(

  Production ~
    State_Name +
    District_Name +
    Crop_Year +
    Season +
    Crop +
    Area,

  data = crop_data,

  # Fewer trees = much smaller model
  num.trees = 5,

  # Larger nodes = smaller trees
  min.node.size = 20,

  # Limit tree depth
  max.depth = 12,

  # Reduce memory usage during training
  save.memory = TRUE,

  importance = "impurity",

  seed = 123

)

# ============================================
# DISPLAY MODEL INFORMATION
# ============================================

print(model)

cat("\nVariable Importance:\n")

print(
  model$variable.importance
)

# ============================================
# SAVE MODEL
# ============================================

saveRDS(
  model,
  "models/crop_production_model.rds",
  compress = TRUE
)

# ============================================
# COMPLETED
# ============================================

cat("\n====================================\n")
cat("SMALL MODEL TRAINING COMPLETED!\n")
cat("====================================\n")

cat(
  "\nModel saved to:\n"
)

cat(
  "models/crop_production_model.rds\n"
)