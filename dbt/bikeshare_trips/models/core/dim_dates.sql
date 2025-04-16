{{ config(materialized='table') }}

with dates as (
  select distinct
    start_date
    ,format_date('%u', start_date) dayofweek
    ,extract(month from start_date) month
    ,extract(quarter from start_date) quarter
    ,extract(year from start_date) year
  from {{ ref('stg_bikeshare_trips') }})

select 
  *
  ,year || 'Q' || quarter year_quarter
  ,year || '-' || format('%02d',month) year_month
from dates