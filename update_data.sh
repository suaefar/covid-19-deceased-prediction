#!/bin/bash

REGIONS=(',Italy,' ',Spain,' 'France,France,' 'United Kingdom,United Kingdom' 'Netherlands,Netherlands,' ',Germany,' ',Belgium,' ',Sweden,' ',Austria,')
DATES=( 03-21-2020 \
        03-22-2020 \
        03-23-2020 \
        03-24-2020 \
        03-25-2020 \
        03-26-2020 \
        03-27-2020 \
        03-28-2020 \
        03-29-2020 \
      )

for REGION in "${REGIONS[@]}"; do
  for DATE in "${DATES[@]}"; do
    MAGICTOKEN=$(head -n1 "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/${DATE}.csv" | sed 's/^[^A-Za-z0-9]*//' | cut -d, -f1)
    if [ "${MAGICTOKEN}" == "FIPS" ]; then
      REGION_TMP=$(echo ${REGION} | sed 's/[^,]*//')
      VALUE=$(grep ",${REGION_TMP// /\\ }" "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/${DATE}.csv" | cut -d, -f9 | tr -d "\n")
    else
      VALUE=$(grep "${REGION// /\\ }" "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/${DATE}.csv" | cut -d, -f5 | tr -d "\n")
    fi
    if [ -n "$VALUE" ]; then
      echo -n "$VALUE "
    else
      echo -n "Nan "
    fi
  done
  echo ""
done > data.txt

./plot_data.m
