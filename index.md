---
title: "Filter observations"
output: 


learnr::tutorial:
progressive: true
allow_skip: true
runtime: shiny_prerendered
---



## Welcome to our R (pun intended) rundown!

To merge two quotes from Sam's Rolodex of sayings I've heard in the past week or so, "R is the second best tool to do 5 million things and there are 5 thousand ways of doing each of these things." This tutorial is not meant to be a resource that you have open as you start your first project, it is meant to allow you to use the three best tools of R progress (Google, Google, and Google) to effectively write code that looks similar to how the other members of SomerStat write code in R. In an attempt to have you see the value of this similar coding style, I will show you the code that I (Derek) wrote in my first major project and the functionally identical code that Sam would have told me to use if this training existed when I started. This is by no means law, and if you prefer something by all means tell us about it and there's a good chance we will agree and change how we do things! 

Derek's code to combine two datasets on a column (i.e. there is an id field shared between two files and I want to merge these columns):


``` r
merged <- merge(x = merged, y = geolocationData, by = 'id', all.x = TRUE)
```

Sam's much more readable code:


``` r
merged <- merged %>% dplyr::left_join(geolocationData, by = 'id')
```

For those natural coders among us, you may be about to google what I already have, and yes, under the hood left_join takes a very convoluted path to doing nearly exactly this base R line with lots of error checking. Dplyr abstracts a lot of common lines of code (like merging two datasets) away and makes the code much more readable, and is widely used throughout the office. Let's load in some data and try some other features of dplyr out! In case of getting stuck, all of the answers are in an R file that probably lives right next to the one you ran to open the browser on your localhost unless I miraculously fixed the web-hosting problem. We do not care / track if you ended up getting the little textbox to be green, I just thought it would make the tutorial a bit more fun and interactive.

The data we will be using comes from our annual Happiness Survey (insert description of this here), which this website reads from the [Open Data Portal](https://data.somervillema.gov/Health-Wellbeing/Somerville-Happiness-Survey-Responses-2011-2021/pfjr-vzaw/about_data)

There is a good chance that your time here will include analyzing data in R and/or reading/writing data to/from the Open Data Portal, so I hope this little tutorial is more helpful than harmful.

### Common mistakes

Me (Derek) thinking I can code in R

## Loading in the Happiness Survey Data from the Open Data Portal

This is roughly the workflow that I use to read data from the Open Data portal.

First I make sure to load in all the packages, I use pacman to do this nasty install vs load in business for me. 

``` r
if (!require(pacman)){
  install.packages("pacman")
}
```

```
## Loading required package: pacman
```

```
## Warning: package 'pacman' was built under R version 4.3.2
```

``` r
pacman::p_load(RSocrata, tidyverse) ## this loads in RSocrata and the entire tidyverse, which includes dplyr and many of the packages we use!
```


``` r
socrataUrl <-"https://data.somervillema.gov/resource" ## not sensitive

generateUrl <- function (datasetID) paste(
  socrataUrl, 
  paste(datasetID, 'json', sep="."), 
  sep="/"
)
```


``` r
## if the bottom of this exercise says 404 not found, you do not have the right datasetID
datasetID <- 'some-string' ## TODO
url <- generateUrl(datasetID)   
happinessSurveyData <- RSocrata::read.socrata(url)
```

```
## 2024-06-18 14:17:51.448 getResponse: Error in httr GET: 404  https://data.somervillema.gov/resource/some-string.json?$order=:id
```

```
## Error in getResponse(validUrl, email, password): Not Found (HTTP 404).
```


``` r
# Check for the dataset id here, I typically find it in the url! <https://data.somervillema.gov/Health-Wellbeing/Somerville-Happiness-Survey-Responses/pfjr-vzaw/about_data>
# click Next Hint to see the solution!
```



``` r
## TODO, find the datasetId on the Open Data Portal
datasetID <- "pfjr-vzaw" 
url <- generateUrl(datasetID) 
happinessSurveyData <- RSocrata::read.socrata(url) 
```


``` r
"test"
```

```
## [1] "test"
```

## Let's Explore this data some!

### Initial QA

Something I often do once the code will compile and run is assume that I've made every mistake possible, so I like to get an overview of the dataset. For a dataset as large as the happiness survey, it can be tough to just open up excel and take a peek, so I often do this in R.


``` r
dplyr::glimpse(happinessSurveyData)
```

```
## Rows: 11,191
## Columns: 127
## $ id                                                   <chr> "560", "561", "562", "563", "564", "565", "566", "567", "568", "569", "570", "571"~
## $ year                                                 <chr> "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2~
## $ survey_method                                        <chr> "Paper", "Paper", "Paper", "Paper", "Paper", "Paper", "Paper", "Paper", "Paper", "~
## $ gender                                               <chr> "Man", "Woman", "Man", "Woman", "Man", "Man", "Woman", "Man", "Woman", "Woman", "M~
## $ age                                                  <chr> "61 or older", "26-30", "61 or older", "61 or older", "26-30", "26-30", "61 or old~
## $ age_mid                                              <chr> "61", "28", "61", "61", "28", "28", "61", "28", "23.5", "45.5", "28", "35.5", "61"~
## $ race_ethnicity                                       <chr> "White", "White", "White", "White", "White", "White", "White", "White", "White", "~
## $ household_income                                     <chr> "Less than $10,000", "$60,000 to $79,999", "$10,000 to $19,999", "$40,000 to $59,9~
## $ household_income_mid                                 <chr> "9999", "69999.5", "14999.5", "49999.5", "29999.5", "49999.5", "29999.5", "69999.5~
## $ happiness_5pt_num                                    <chr> "5", "4", "4", "5", "3", "4", "2", "3", "4", "3", "5", "4", "2", "5", "5", "4", "5~
## $ life_satisfaction_5pt_num                            <chr> "5", "5", "4", "4", "3", "4", "3", "4", "4", "3", "5", "4", "2", "5", "5", "4", "5~
## $ life_satisfaction_5pt_label                          <chr> "Very Satisfied", "Very Satisfied", "Satisfied", "Satisfied", "Neutral", "Satisfie~
## $ somerville_satisfaction_5pt_num                      <chr> "5", "5", "4", "5", "3", "5", "4", "4", "3", "4", "5", "3", "5", "4", "5", "5", "5~
## $ somerville_satisfaction_5pt_label                    <chr> "Very Satisfied", "Very Satisfied", "Satisfied", "Very Satisfied", "Neutral", "Ver~
## $ public_school_satisfaction_5pt_num                   <chr> "5", NA, "3", NA, "3", "3", "4", NA, NA, "4", "2", "1", NA, NA, "4", "3", "4", "2"~
## $ public_school_satisfaction_5pt_label                 <chr> "Very Satisfied", NA, "Neutral", NA, "Neutral", "Neutral", "Satisfied", NA, NA, "S~
## $ acs_year                                             <chr> "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2011", "2~
## $ acs_somerville_median_income                         <chr> "64480", "64480", "64480", "64480", "64480", "64480", "64480", "64480", "64480", "~
## $ acs_somerville_avg_household_size                    <chr> "2.29", "2.29", "2.29", "2.29", "2.29", "2.29", "2.29", "2.29", "2.29", "2.29", "2~
## $ inflation_adjustment                                 <chr> "1.35", "1.35", "1.35", "1.35", "1.35", "1.35", "1.35", "1.35", "1.35", "1.35", "1~
## $ tenure                                               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ tenure_mid                                           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ children                                             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ student                                              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ ward                                                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ neighborhood_satisfaction_5pt_num                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ neighborhood_satisfaction_5pt_label                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ beauty_neighborhood_satisfaction_5pt_num             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ beauty_neighborhood_satisfaction_5pt_label           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ streets_sidewalks_maintenance_satisfaction_5pt_num   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ streets_sidewalks_maintenance_satisfaction_5pt_label <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ social_community_events_5pt_num                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ social_community_events_5pt_label                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ housing_status                                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ language_spoken                                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ police_department_satisfaction_5pt_num               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ police_department_satisfaction_5pt_label             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ city_services_information_5pt_num                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ city_services_information_5pt_label                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ transportation_options_satisfaction_5pt_num          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ transportation_options_satisfaction_5pt_label        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ transportation_bicycle                               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ transportation_car                                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ transportation_public_transit                        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ transportation_walk                                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ getting_around_convenience_satisfaction_5pt_num      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ getting_around_convenience_satisfaction_5pt_label    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ housing_condition_satisfaction_5pt_num               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ housing_condition_satisfaction_5pt_label             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ disability                                           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ days_in_person_commute                               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ transportation_rideshare                             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ cultural_religious_minority                          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ immigrant                                            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ lgbtqia                                              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ veteran                                              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ difficulty_paying                                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ discrimination                                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ household_size                                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ household_size_num                                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ bedrooms                                             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ bedrooms_num                                         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ cars                                                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ cars_num                                             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ income_per_number_in_household                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ likely_low_income                                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ rent_mortgage                                        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ rent_mortgage_mid                                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ rent_as_percent_of_income                            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ rent_mortgage_per_bedroom                            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ likely_cost_burdened                                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ cleanliness_neighborhood_satisfaction_5pt_num        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ cleanliness_neighborhood_satisfaction_5pt_label      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ parks_proximity_satisfaction_5pt_num                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ parks_proximity_satisfaction_5pt_label               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ grocery_proximity_satisfaction_5pt_num               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ grocery_proximity_satisfaction_5pt_label             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ city_services_quality_satisfaction_5pt_num           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ city_services_quality_satisfaction_5pt_label         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ housing_cost_satisfaction_5pt_num                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ housing_cost_satisfaction_5pt_label                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ sidewalks_accessibility_satisfaction_5pt_num         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ sidewalks_accessibility_satisfaction_5pt_label       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ childcare_availability_satisfaction_5pt_num          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ childcare_availability_satisfaction_5pt_label        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ neighbors_relationship_satisfaction_5pt_num          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ neighbors_relationship_satisfaction_5pt_label        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ priced_out_concern_3pt_num                           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ priced_out_concern_3pt_label                         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ crime_violence_concern_3pt_num                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ crime_violence_concern_3pt_label                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ rats_mice_concern_3pt_num                            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ rats_mice_concern_3pt_label                          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ crossing_street_safety_concern_3pt_num               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ crossing_street_safety_concern_3pt_label             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ biking_safety_concern_3pt_num                        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ biking_safety_concern_3pt_label                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ walking_safety_concern_3pt_num                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ walking_safety_concern_3pt_label                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ extreme_weather_safety_concern_3pt_num               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ extreme_weather_safety_concern_3pt_label             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ tenure_address                                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ tenure_address_mid                                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ service_311_quality_5pt_num                          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ service_311_quality_5pt_label                        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ language_access_satisfaction_5pt_num                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ language_access_satisfaction_5pt_label               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ housing_stability_initiatives_5pt_num                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ housing_stability_initiatives_5pt_label              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ severe_weather_response_5pt_num                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ severe_weather_response_5pt_label                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ covid_resources_satisfaction_5pt_num                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ covid_resources_satisfaction_5pt_label               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ virtual_meetings_satisfaction_5pt_num                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ virtual_meetings_satisfaction_5pt_label              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ outdoor_dining_satisfaction_5pt_num                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ outdoor_dining_satisfaction_5pt_label                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ participatory_budgeting_5pt_num                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ participatory_budgeting_5pt_label                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ community_choice_electricity_5pt_num                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ community_choice_electricity_5pt_label               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ green_line_extension_5pt_num                         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ green_line_extension_5pt_label                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ bus_bicycle_lanes_satisfaction_5pt_num               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ bus_bicycle_lanes_satisfaction_5pt_label             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ bluebikes_satisfaction_5pt_num                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
## $ bluebikes_satisfaction_5pt_label                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
```

I also often like to see if any of the rows are obviously junk, so I look to see if whatever unique identifier I'm using is NA.

``` r
nrow(happinessSurveyData %>% dplyr::filter(is.na(id)))
```

```
## [1] 0
```

As we can see, the team did at least a bit of QA on this dataset before releasing it (thank goodness it would have been embarrassing if we found QA issues in the Happiness Survey this early in an R training).

Besides the joining that I showed you in the beginning, a large amount of what I do in R is dropping columns, especially those that may include sensitive information. A common issue that we have to tackle at SomerStat is a limited number of respondants who fit any of the questions we have talke about. We rarely want uniquely identifying information in any datset we release, and age can be uniquely identifying if it is a unique value from the rest of the dataset. We often group data to solve this problem: for example we have grouped age in the Happiness Survey. 


``` r
unique(happinessSurveyData$age)
```

```
##  [1] "61 or older"          "26-30"                "22-25"                "41-50"                "31-40"                "51-60"               
##  [7] NA                     "18-21"                "45-54"                "25-34"                "35-44"                "55-64"               
## [13] "65-74"                "18-24"                "75 or older"          "17 or younger"        "Prefer not to answer"
```

After you have identified the issue with age, and bucketed out the ages you may think the problem is solved; however, you still need to be mindful of the size of these buckets. 


``` r
table(happinessSurveyData$age)
```

```
## 
##        17 or younger                18-21                18-24                22-25                25-34                26-30 
##                    8                   55                  174                  479                 1479                 1289 
##                31-40                35-44                41-50                45-54                51-60                55-64 
##                 1564                  963                  847                  537                  679                  613 
##          61 or older                65-74          75 or older Prefer not to answer 
##                  992                  553                  306                   10
```

As we can see, there have only been 8 survey respondents ages 17 or younger that have submitted the Happiness Survey. Let's see what years these responses came in:


``` r
only17Younger <- happinessSurveyData %>% dplyr::filter(happinessSurveyData$age == "17 or younger") 
only17Younger$year
```

```
## [1] "2019" "2021" "2021" "2021" "2023" "2023" "2023" "2023"
```

As we can see, there is only one respondent from 2019 that was 17 or younger and responded to the Happiness Survey. Is this a problem? Probably not (but we may actually consider this in a future meeting because it's interesting), but this is exactly the kind of thing that we interrogate the data for to either find obvious problems or allow us to consciously make a decision about whether or not to further aggregate the data and make is less identifiable. This is especially true when we are dealing with more sensitive data, such as Police or fill in other sensitive data here. 

## Mean/median/stdev QA

Another very standard exercise is finding the mean/median/stdev of data. Let's try this with people's happiness here in Somerville. We convert all of the previous years scales to a 5 point scale in the happiness_5pt_num. It could be interesting to see how to mean/median/stdev over all of the years in the dataset. This exercise is a bit tricky and I'm sure there are perfectly acceptable answers that will not be accepted due to the fact that the checker is a function written by me (Derek) so do your best but don't stress too hard! Also [here](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) is some pretty good dplyr documentation that you may find helpful ;)


``` r
## this dataframe should have four columns: year, mean, median, and stdev with 7 rows.
QAdataframe <- 0 ## TODO
```


``` r
"I would look into the dplyr package documentation, especially for group_by and summarise."
```

```
## [1] "I would look into the dplyr package documentation, especially for group_by and summarise."
```



``` r
QAdataframe <- happinessSurveyData %>%
    group_by(year) %>%
    summarise(mean = mean(happiness_5pt_num, na.rm = TRUE), median = median(happiness_5pt_num, na.rm = TRUE), stdev = sd(happiness_5pt_num, na.rm = TRUE))
```

```
## Error in `summarise()`:
## i In argument: `median = median(happiness_5pt_num, na.rm = TRUE)`.
## Caused by error:
## ! `median` must return compatible vectors across groups.
## i Result of type <character> for group 2011: `year = "2011"`.
## i Result of type <double> for group 2017: `year = "2017"`.
```


``` r
"Still not sure why there needs to be text here"
```

```
## [1] "Still not sure why there needs to be text here"
```

## One last dplyr excercise!

Back to the 17 or younger issue, you brought up your QA finding in this week's Happiness Survey meeting and the team was really impressed with this and we've decided to completely overreact to this finding (we can act like there was some really damning information in this or whatever you need to convince yourself this exercise is a real thing we would do, it's hard to find a data cleaning task on our cleaned dataset). We decided to remove each row (survey response) that was from someone who was 17 or younger and decided to drop the age column. You will probably want to refer to that dplyr cheatsheet once again!


``` r
## this dataframe should be just like the happinessSurveyData one, just without the rows that were the 17 or younger and without the age column. 
happinessDataCleaned <- 0 ## TODO
```


``` r
"I would look into the dplyr package documentation, especially for filter and select. You may also need to look into how you handle NA comparisions"
```

```
## [1] "I would look into the dplyr package documentation, especially for filter and select. You may also need to look into how you handle NA comparisions"
```



``` r
happinessDataCleaned <- happinessSurveyData %>% filter(!(age == "17 or younger" & !is.na(age))) %>% select(-age)
```


``` r
"Still not sure why there needs to be text here"
```

```
## [1] "Still not sure why there needs to be text here"
```

## Okay you are now ready to start your own project, what does that look like?

This office uses github (kind of I swear) to track coding projects, allow for collaboration between many coders in the office, and add some sense of accountability in the code written. Sam has created a template repo for our projects as well, which includes the usual file format we use. This template is always a suggestion, and each project's needs are slightly different so please do not feel entrapped by it. Nevertheless I will explain how to use github for the limited uses we need in the office. If questions come up please do not hesitate to reach out to Sam or Derek (who will probably ask Sam either way but may be less scary since I'm also an intern). 

### Setting up the repo

Once again foreseeing the making of this training, Sam has already done the work that I will show you how to run to set up a repository for your project.

Firstly if you do not already have a github, make one and have Sam add you to the SomerStat team.

If you download the api_key and the new-repo-from-template-interns files from [here](https://somervillema.sharepoint.com/sites/SomerStat2/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FSomerStat2%2FShared%20Documents%2FTools%2FGitHub%20Helper&viewid=1c921e9c%2Dd682%2D49c9%2D83c3%2Da5ee71285b85) you will be able to very easily create a new repo by running the batch file. A brand-new repo should appear, and you can rename it by going to settings in the top right of the nav pane. This repo includes the usual format that we use in a project, with a, rproj file that is a useful tool for Rstudio, a readme.md per usual github fashion, and finally folders for the data. figures, markdown figures, and scripts. Sam has done a great job explaining this template in the readme. so I will not steal his thunder here. 

### The first git clone (instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent))
Now that you have a new repo, and probably have renamed it, we need to get it onto you machine so you can begin coding away in R. Use the terminal to cd into a new folder, and run the command ssh-keygen. Press enter to keep the defaults for all of the questions. There should now be a file called ~/.ssh/id_rsa in the folder you cd'd into, copy the content of that file that into github > Settings ? SSH and GPG Keys > New SSH key > key field and create a SSH key. (Please if you are doing this training get Derek for this part, my advice is entirely untested) Now that we have the proper authentication, we will git clone onto your computer by clicking on the <> Code green button on the github page, and then copying the url shown for HTTPS. You should mpw be able to clone the repo onto your machine by cd'ing into where you want to be in terminal, and running git clone url (where the url is the one you copied from the green code button).

### File management in git

If you use the file explorer to go to the directory you cloned into, you should see a new folder with the name of your repo. You should now do all of the R coding your heart desires until you get to a good break point. I usually check the state of the repo with "git status". You would then "git add ." to add all of the files. At this point I usually do "git status" again to see what all changes I have added, then "git commit -m"This is a commit message where you detail the changes you made in this commit"" stages these changes. Finally, git push will apply these changes to the repo on github. 

### Git branch

If you have a working version of something and want to make changes to be applied only in the future when we are sure our new version also works, we use "git branch". To pick something up and do this, I would cd to the directory, and then "git pull" to get any changes. Then "git branch new-branch-name" will create a branch for you to work on. All commits that you make will be push to this branch. 

This is a very simplified viewing of git, and if it is your first time using it please ask questions of the other people in the office sooner rather than later, as it is a very complicated piece of version control software. I would recommend reading at least one or two intro articles on it and maybe even talking to Sam to set up github desktop which can simplify things.

