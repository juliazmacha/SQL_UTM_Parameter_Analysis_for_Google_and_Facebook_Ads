# UTM Parameter Analysis for Google and Facebook Ads

This project involves merging data from Google and Facebook ad campaigns using CTE (Common Table Expressions) and performing detailed analysis on UTM parameters and ad performance metrics. The following steps outline the process.

## Steps Undertaken

### Step 1: SQL Query with CTE to Merge Data
A SQL query was written using CTE to merge data from the given tables and retrieve the following:
- **ad_date**: The date the ad was displayed on Google and Facebook.
- **url_parameters**: The URL parameters of the campaign containing UTM parameters.
- **spend, impressions, reach, clicks, leads, value**: Campaign and ad metrics for each day. If any metric had a NULL value, it was set to zero.

### Step 2: Process and Extract Data from CTE Results
Using the results obtained from the CTE, the following data were extracted:
- **ad_date**: The date the ad was displayed.
- **utm_campaign**: The value of the `utm_campaign` parameter from the `utm_parameters` field, with the following conditions:
  - All letters were converted to lowercase.
  - If the `utm_campaign` value in `utm_parameters` was 'nan', it was set to NULL in the result table.

### Step 3: Calculate Performance Metrics
Based on the extracted data, the following performance metrics were calculated for each day and campaign:
- **CTR (Click-Through Rate)**: Calculated as the number of clicks divided by the number of impressions.
- **CPC (Cost Per Click)**: Calculated as the total spend divided by the number of clicks.
- **CPM (Cost Per Thousand Impressions)**: Calculated as the total spend divided by the number of impressions, multiplied by 1,000.
- **ROMI (Return on Marketing Investment)**: Calculated as the total conversion value divided by the total spend.

### Step 4: Decode `utm_campaign` Values (TASK 5.2)
The `utm_campaign` values were decoded using a temporary function. The function code was sourced online to ensure accurate decoding.

## Final Product
The resulting analysis provides a comprehensive view of ad performance across Google and Facebook, with a focus on UTM parameters. By merging and aggregating key metrics and processing UTM parameters, this project enables detailed evaluation of campaign effectiveness, helping to identify the most cost-efficient and high-performing campaigns.
