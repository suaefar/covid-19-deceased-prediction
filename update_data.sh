#!/bin/bash

REGIONS=(',Italy,' ',Spain,' 'United Kingdom,United Kingdom' ',Germany,' ',Belgium,' ',Austria,')
DATES=( 03-13-2020 \
        03-14-2020 \
        03-15-2020 \
        03-16-2020 \
        03-17-2020 \
        03-18-2020 \
        03-19-2020 \
        03-20-2020 \
        03-21-2020 \
        03-22-2020 \
        03-23-2020 \
      )

for REGION in "${REGIONS[@]}"; do
  for DATE in "${DATES[@]}"; do
    MAGICTOKEN=$(head -n1 "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/${DATE}.csv" | cut -d, -f1)
    if [ "${MAGICTOKEN}" == "FIPS" ]; then
      REGION_TMP=$(echo ${REGION} | sed 's/[^,]*//')
      grep ",${REGION_TMP// /\\ }" "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/${DATE}.csv" | cut -d, -f9 | tr -d "\n"      
    else
      grep "${REGION// /\\ }" "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/${DATE}.csv" | cut -d, -f5 | tr -d "\n"
    fi
    echo -n " "
  done
  echo ""
done > data.txt

./plot_data.m
