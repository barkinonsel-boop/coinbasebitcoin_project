{{ config(
    materialized='table',
    schema='marts'
) }}

with intermediate as (

    select * from {{ ref('int_coinbasebitcoin_cleaned') }}

),

unique_pairs as (

    select distinct
        trading_pair_key,
        base_currency,
        quote_currency
    from intermediate

)

select * from unique_pairs