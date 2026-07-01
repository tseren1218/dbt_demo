{#
    Module 5.2 — Doc Blocks.

    Define long/reusable descriptions once here, then reference them from any
    schema.yml with:  description: "{{ doc('block_name') }}"

    This keeps descriptions DRY and lets you write rich markdown once. Run
    `dbt docs generate` then `dbt docs serve` to see them in the docs site.
#}

{% docs customer_id %}
Surrogate **primary key** for a customer, sourced from `c_custkey` in the raw
TPC-H `customer` table. Unique and never null. Referenced as a foreign key by
`orders.customer_id`.
{% enddocs %}

{% docs order_status %}
Single-character status of an order:

| Code | Meaning     |
|------|-------------|
| `O`  | Open        |
| `F`  | Fulfilled   |
| `P`  | In progress |
{% enddocs %}

{% docs account_balance_currency %}
ISO-4217 currency code for `account_balance`. This project hard-codes `USD`
in staging because the raw TPC-H data has no currency column.
{% enddocs %}
