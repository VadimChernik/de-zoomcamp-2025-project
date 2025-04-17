{{ config(materialized='view') }}

with tripdata as 
(
  select 
    *,
    row_number() over(partition by trip_id, start_date) as rn
  from {{ source('staging','bikeshare_trips') }}
  where start_date is not null
)

select
    -- identifiers
    trip_id,
   
    -- time
    date(start_date) start_date,
    extract(hour from start_date) start_hour,

    start_date start_timestamp,
    end_date end_timestamp,
    
    -- trip info
    start_station_id,
    start_station_name,
    end_station_id,
    end_station_name,
    bike_number,
    duration_sec,

    -- member info
    {{ get_subscriber_type("subscriber_type") }} subscriber_type,
    member_birth_year,
    member_gender

from tripdata
where rn = 1

{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}