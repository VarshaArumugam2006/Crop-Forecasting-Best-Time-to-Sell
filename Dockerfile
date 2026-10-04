FROM rocker/shiny:latest

RUN R -e "install.packages('ranger', repos='https://cloud.r-project.org')"

COPY app.R /srv/shiny-server/app.R

COPY data/crop_production_clean.csv /srv/shiny-server/data/crop_production_clean.csv
COPY data/best_selling_month.csv /srv/shiny-server/data/best_selling_month.csv

COPY models /srv/shiny-server/models

RUN sed -i 's/listen 3838;/listen 10000;/' /etc/shiny-server/shiny-server.conf

EXPOSE 10000

CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=10000)"]