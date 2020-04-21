#!/bin/bash

# Pulls latest COVID-19 Milwaukee time series data from the CSSEGISandData GitHub project
# and outputs it to two csv files.  The latest vaules from each file are printed to stdout.

workingdir=/Volumes/128GB-SD/tmp

# Initial Clone
# if cd $workingdir
# then
    # git clone https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/04-20-2020.csv
# else
 # printf "%s doesn't exist\n" $workingdir
 # exit 1
# fi

# Update Source Data
printf "Updating Data from https://github.com/CSSEGISandData/COVID-19/\n"
if cd $workingdir/COVID-19
then
  git fetch
  git rebase origin/master
else
  printf "%s doesn't exist\n" $workingdir
  exit 1
fi

# Get Milwakee Time Series Data
printf "\nMilwaukee Confirmed Cases Time Series\n"
casefile=$workingdir/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv
head -1 $casefile > $workingdir/mke-cases-time-series.csv
grep Milwaukee $casefile >> $workingdir/mke-cases-time-series.csv
printf "Latest Data:\n"
date=$(head -1 $workingdir/mke-cases-time-series.csv)
echo "${date##*,}"
cases=$(tail -1 $workingdir/mke-cases-time-series.csv)
echo "${cases##*,}"

printf "\nMilwaukee Confirmed Deaths Time Series\n"
deathsfile=$workingdir/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv
head -1 $deathsfile > $workingdir/mke-deaths-time-series.csv
grep Milwaukee $deathsfile >> $workingdir/mke-deaths-time-series.csv
printf "Latest Data:\n"
date=$(head -1 $workingdir/mke-deaths-time-series.csv)
echo "${date##*,}"
deaths=$(tail -1 $workingdir/mke-deaths-time-series.csv)
echo "${deaths##*,}"
