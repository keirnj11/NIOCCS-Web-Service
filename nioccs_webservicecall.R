library(tidyverse)
library(httr)
library(jsonlite)
library(REDCapR)
token <- "E10CCF6DCD3E1F56DC100D3E8754F691"
uri <- "https://redcap.doh.wa.gov/api/"

#Read the dataset
result_read1 <- redcap_read_oneshot(redcap_uri =uri, token = token)
redcap_df1 <- result_read1$data

#Filter by Accepted Value
redcap_df1$accept___1==0
redcap_df2 <-redcap_df1[redcap_df1$accept___1==0,]

#Create values for web service function
id = redcap_df2$case_id
industry = redcap_df2$industry_txt
occupation = redcap_df2$occupation_txt

#Function to call NIOCCS webservice
NIOCCS_WebService <- function(id, industry, occupation)
  #Send GET request
  {response <- httr::GET(url = "https://wwwn.cdc.gov/nioccs/IOCode.ashx",
                          query = list(i = industry,
                                       o = occupation,
                                       c =2))
  #Parse response to JSON
  response_df <- content(response, as="text")
  json_results <- fromJSON(response_df)
  json_results$id <- id
  return(json_results)}

#Batch Iterate Rows, Input into DF





