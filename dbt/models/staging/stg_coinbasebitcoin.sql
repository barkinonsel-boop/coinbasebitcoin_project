{{ config(
    materialized='view',
    schema='staging'
) }}

with source_data as (

    select * from {{ source('coinbase_bitcoin_raw', 'raw_coinbasebitcoin') }}

),

flattened as (

    select
        -- Extract JSON elements
        json_data:data.base::string as base_currency,
        json_data:data.currency::string as quote_currency,
        json_data:data.amount::string as raw_amount,
        
        -- Metadata columns
        file_path,
        ingested_at
    from source_data

)

select * from flattened