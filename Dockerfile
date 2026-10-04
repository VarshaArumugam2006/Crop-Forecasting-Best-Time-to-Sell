FROM rocker/shiny:latest

# Install ranger
RUN R -e "install.packages('ranger', repos='https://cloud.r-project.org')"

# Copy Shiny application
COPY app.R /srv/shiny-server/app.R

# Copy only the small data files required by the application
COPY data/crop_options.csv /srv/shiny-server/data/crop_options.csv
COPY data/best_selling_month.csv /srv/shiny-server/data/best_selling_month.csv

# Copy trained model
COPY models/crop_production_model.rds /srv/shiny-server/models/crop_production_model.rds

# Render port
EXPOSE 10000

# Start Shiny application
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=10000)"]