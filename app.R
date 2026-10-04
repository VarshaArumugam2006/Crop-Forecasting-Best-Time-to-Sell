# ============================================
# CROP FORECASTING AND BEST TIME TO SELL
# ============================================

library(shiny)
library(ranger)

# ============================================
# LOAD PRODUCTION MODEL
# ============================================

model <- readRDS(
  "models/crop_production_model.rds"
)

# ============================================
# LOAD PRODUCTION DATA
# ============================================

crop_data <- read.csv(
  "data/crop_production_clean.csv"
)

crop_data$State_Name <- as.factor(crop_data$State_Name)
crop_data$District_Name <- as.factor(crop_data$District_Name)
crop_data$Season <- as.factor(crop_data$Season)
crop_data$Crop <- as.factor(crop_data$Crop)

# ============================================
# LOAD BEST SELLING MONTH DATA
# ============================================

best_month <- read.csv(
  "data/best_selling_month.csv"
)

# ============================================
# USER INTERFACE
# ============================================

ui <- fluidPage(

  titlePanel(
    "🌾 Crop Forecasting and Best Time to Sell"
  ),

  sidebarLayout(

    sidebarPanel(

      h3("Crop Details"),

      # STATE
      selectInput(
        "state",
        "Select State:",
        choices = sort(
          unique(crop_data$State_Name)
        )
      ),

      # DISTRICT
      selectInput(
        "district",
        "Select District:",
        choices = NULL
      ),

      # CROP
      selectInput(
        "crop",
        "Select Crop:",
        choices = NULL
      ),

      # SEASON
      selectInput(
        "season",
        "Select Season:",
        choices = NULL
      ),

      numericInput(
        "year",
        "Crop Year:",
        value = 2025,
        min = 1997,
        max = 2035
      ),

      numericInput(
        "area",
        "Cultivation Area:",
        value = 100,
        min = 1
      ),

      actionButton(
        "predict",
        "PREDICT PRODUCTION"
      )
    ),

    # ========================================
    # MAIN PANEL
    # ========================================

    mainPanel(

      h2("Prediction Result"),

      verbatimTextOutput(
        "prediction"
      ),

      hr(),

      h2("💰 Best Time to Sell"),

      verbatimTextOutput(
        "selling_advice"
      ),

      hr(),

      h3("Selected Crop Information"),

      tableOutput(
        "crop_info"
      )
    )
  )
)

# ============================================
# SERVER
# ============================================

server <- function(
  input,
  output,
  session
) {

  # ==========================================
  # STATE → DISTRICT
  # ==========================================

  observeEvent(
    input$state,
    {

      req(input$state)

      districts <- crop_data[
        crop_data$State_Name == input$state,
      ]

      districts <- sort(
        unique(
          as.character(
            districts$District_Name
          )
        )
      )

      updateSelectInput(
        session,
        "district",
        choices = districts,
        selected = districts[1]
      )
    },
    ignoreInit = FALSE
  )


  # ==========================================
  # STATE + DISTRICT → CROP
  # ==========================================

  observeEvent(
    c(
      input$state,
      input$district
    ),
    {

      req(
        input$state,
        input$district
      )

      crops <- crop_data[
        crop_data$State_Name == input$state &
        crop_data$District_Name == input$district,
      ]

      crops <- sort(
        unique(
          as.character(
            crops$Crop
          )
        )
      )

      updateSelectInput(
        session,
        "crop",
        choices = crops,
        selected = crops[1]
      )
    },
    ignoreInit = FALSE
  )


  # ==========================================
  # STATE + DISTRICT + CROP → SEASON
  # ==========================================

  observeEvent(
    c(
      input$state,
      input$district,
      input$crop
    ),
    {

      req(
        input$state,
        input$district,
        input$crop
      )

      seasons <- crop_data[
        crop_data$State_Name == input$state &
        crop_data$District_Name == input$district &
        crop_data$Crop == input$crop,
      ]

      seasons <- sort(
        unique(
          as.character(
            seasons$Season
          )
        )
      )

      updateSelectInput(
        session,
        "season",
        choices = seasons,
        selected = seasons[1]
      )
    },
    ignoreInit = FALSE
  )


  # ==========================================
  # PRODUCTION + SELLING PREDICTION
  # ==========================================

  observeEvent(
    input$predict,
    {

      req(
        input$state,
        input$district,
        input$crop,
        input$season
      )

      # ======================================
      # CREATE NEW DATA FOR MODEL
      # ======================================

      new_data <- data.frame(

        State_Name = factor(
          input$state,
          levels = levels(
            crop_data$State_Name
          )
        ),

        District_Name = factor(
          input$district,
          levels = levels(
            crop_data$District_Name
          )
        ),

        Crop_Year = input$year,

        Season = factor(
          input$season,
          levels = levels(
            crop_data$Season
          )
        ),

        Crop = factor(
          input$crop,
          levels = levels(
            crop_data$Crop
          )
        ),

        Area = input$area
      )

      # ======================================
      # PREDICT PRODUCTION
      # ======================================

      prediction <- predict(
        model,
        data = new_data
      )$predictions

      # ======================================
      # DISPLAY PRODUCTION
      # ======================================

      output$prediction <- renderText({

        paste(
          "🌾 Predicted Crop Production:",
          round(
            prediction,
            2
          ),
          "tonnes"
        )

      })


      # ======================================
      # FIND BEST SELLING MONTH
      # ======================================

      crop_result <- best_month[
        tolower(
          trimws(
            best_month$production_crop
          )
        ) ==
        tolower(
          trimws(
            input$crop
          )
        ),
      ]


      # ======================================
      # DISPLAY SELLING ADVICE
      # ======================================

      output$selling_advice <- renderText({

        if (
          nrow(crop_result) == 0
        ) {

          return(
            paste(
              "No market price information found for",
              input$crop
            )
          )

        }

        best_price <- crop_result$Best_Price[1]

        best_month_name <- crop_result$Month_Name[1]

        paste0(

          "🌾 Crop: ",
          input$crop,

          "\n\n",

          "📅 Best Month to Sell: ",
          best_month_name,

          "\n\n",

          "💰 Expected Best Market Price: ₹",
          round(
            best_price,
            2
          ),

          "\n\n",

          "✅ Recommendation: ",
          "Consider selling during ",
          best_month_name,
          " when market conditions are favorable."

        )

      })

    }
  )


  # ==========================================
  # SELECTED CROP INFORMATION
  # ==========================================

  output$crop_info <- renderTable({

    data.frame(

      State = input$state,

      District = input$district,

      Crop = input$crop,

      Season = input$season,

      Year = input$year,

      Area = input$area

    )

  })

}

# ============================================
# RUN APPLICATION
# ============================================

shinyApp(
  ui = ui,
  server = server
)