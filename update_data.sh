#!/bin/bash

REGIONS=(',Italy,' ',Spain,' ',France,' ',US,' ',United Kingdom' ',Netherlands,' ',Germany,')
FIELDS="56-74"

for REGION in "${REGIONS[@]}"; do
  grep "^${REGION}" COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv | cut -d, -f${FIELDS} | tr "," " "
done > data.txt

./plot_data.m
