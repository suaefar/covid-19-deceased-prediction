#!/bin/bash

REGIONS=(',US,' ',Italy,' ',Spain,' ',France,' ',United Kingdom,' ',Belgium,' ',Germany,' ',Netherlands,' ',Sweden,')
FIELDS="85-107"

for REGION in "${REGIONS[@]}"; do
  grep "^${REGION}" COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv | cut -d, -f${FIELDS} | tr "," " "
done > data.txt

./plot_data.m
