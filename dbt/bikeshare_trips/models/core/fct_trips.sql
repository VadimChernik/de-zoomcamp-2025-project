{{ config(
    materialized='table',
    partition_by={
      "field": "start_date",
      "data_type": "date",
      "granularity": "day"
    }
)}}

with tripdata as (
    select 
        *
    from {{ ref('stg_bikeshare_trips') }}
),

dates as (
    select 
        *
    from {{ ref('dim_dates') }}
),

stations as (
    select 
        *
    from {{ ref('dim_stations') }}
)

select 
    tripdata.trip_id,

    tripdata.start_date,
    tripdata.start_hour,
    tripdata.start_timestamp,
    tripdata.end_timestamp,

    dayofweek,
    month,
    quarter,
    year,
    year_quarter,
    year_month,

    tripdata.start_station_id,
    tripdata.start_station_name,
    start_stations.region_name start_region_name,

    tripdata.end_station_id,
    tripdata.end_station_name,
    end_stations.region_name end_region_name,

    tripdata.bike_number,
    
    tripdata.subscriber_type,
    tripdata.member_birth_year,
    tripdata.member_gender,

    tripdata.duration_sec

from tripdata
    inner join dates
        on tripdata.start_date = dates.start_date
    inner join stations as start_stations
        on tripdata.start_station_id = start_stations.station_id
    inner join stations as end_stations
        on tripdata.end_station_id = end_stations.station_id