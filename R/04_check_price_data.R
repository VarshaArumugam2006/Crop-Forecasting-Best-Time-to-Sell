# Load market price dataset

price_data <- read.csv(
  "data/agridata_csv_202110311352.csv"
)

cat("=================================\n")
cat("MARKET PRICE DATASET CHECK\n")
cat("=================================\n\n")

cat("Rows and Columns:\n")
print(dim(price_data))

cat("\nColumn Names:\n")
print(names(price_data))

cat("\nFirst 10 Rows:\n")
print(head(price_data, 10))

cat("\nMissing Values:\n")
print(colSums(is.na(price_data)))

cat("\nData Structure:\n")
str(price_data)