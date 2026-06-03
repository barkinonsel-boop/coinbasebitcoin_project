{{ config(
    materialized='view',
    schema='intermediate'
) }}

with staging_data as (

    select * from {{ ref('stg_coinbasebitcoin') }}

),

cleaned as (

    select
        -- Deterministic Surrogate Key for the Dimension table
        md5(coalesce(base_currency, '') || '|' || coalesce(quote_currency, '')) as trading_pair_key,
        
        base_currency,
        quote_currency,
        
        -- Cast string money amount to a proper numeric structure
        cast(raw_amount as numeric(18, 4)) as price_amount,
        
        -- Manipulate file_path to extract timestamp (Format: YYYYMMDD_HHMISS)
        to_timestamp_ntz(
            regexp_substr(split_part(file_path, '/', -1), '\\d{8}_\\d{6}'), 
            'YYYYMMDD_HHMISS'
        ) as record_snapshot_at,
        
        ingested_at,
        file_path
    from staging_data

)

select * from cleaned