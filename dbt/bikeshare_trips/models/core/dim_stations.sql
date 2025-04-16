{{ config(materialized='table') }}

with stations as (
  select 
    station_id
    ,name stations_name
    ,region_id
    ,capacity station_capacity 
  from {{ source('staging','bikeshare_stations') }})

,regions as (
  select 
    region_id
    ,name region_name
  from {{ source('staging','bikeshare_regions') }}
)

select 
  cast(stations.station_id as integer) station_id
  ,stations.stations_name
  ,stations.station_capacity
  ,coalesce(stations.region_id,0) region_id
  ,coalesce(regions.region_name,'Unknown') region_name
from stations
  left join regions
    on stations.region_id = regions.region_id
