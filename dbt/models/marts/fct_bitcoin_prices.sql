{{ config(
    materialized='table',
    schema='marts'
) }}

with intermediate as (

    select * from {{ ref('int_coinbasebitcoin_cleaned') }}

)

select
    -- Primary key for the fact grain
    md5(trading_pair_key || '|' || cast(record_snapshot_at as string)) as price_fact_id,
    
    -- Foreign Key
    trading_pair_key,
    
    -- Metrics
    price_amount,
    
    -- Dates / Timestamps
    record_snapshot_at,
    ingested_at,
    file_path
from intermediate