# Data Quality & Preparation Log

## Objective

Prepare the customer trend dataset so revenue, customer segment performance, regional performance, and loyalty member performance can be analyzed more accurately.

| Issue Area | What Was Found | Business Risk | Action Taken |
|---|---|---|---|
| Duplicate records | Some transaction IDs appeared more than once. | Duplicate records can overstate value and order count. | Dropped duplicate records. |
| Inconsistent city name | Some text fields used different casing or abbreviations. | MySQL may split the same category into multiple labels. | Converted city name into consistent name format. |
| Date formatting | Some order dates used different formats or were blank. | Monthly trend analysis may become inaccurate. | Converted valid dates into a consistent date format. |
| Numeric fields | Some values were stored as text. | Value calculations may fail or return incorrect totals. | Converted valid numeric fields into analysis-ready values. |


## Data Quality Summary

| Quality Flag | Rows |
|---|---:|
| Clean | 40.000 |
| Duplicate Records | 2 |

## Summary

The dashboard focuses on clean rows so business decisions are based on reviewed data. Rows that require review are still documented because they may reveal process, data entry, or order management issues.
