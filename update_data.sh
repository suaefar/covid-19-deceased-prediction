#!/bin/bash

REGIONS=(',US,' ',United Kingdom,' ',Brazil,' ',Spain,' ',Mexico,' ',Germany,' ',India,' ',Russia,' ',Sweden,')
FIELDS="123-145"

for REGION in "${REGIONS[@]}"; do
  grep "^${REGION}" COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv | cut -d, -f${FIELDS} | tr "," " "
done > data.txt

./plot_data.m
