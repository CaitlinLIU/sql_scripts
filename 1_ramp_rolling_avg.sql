-- we can use the following approach:
-- Aggregate the transactions by date to get the total transaction amount per day.
-- Calculate the rolling 3-day average.
-- Extract the value for January 31, 2021.

WITH daily_totals AS (
  SELECT
    DATE(transaction_time) AS transaction_date,
    SUM(transaction_amount) AS total_amount
  FROM
    transactions
  GROUP BY
    DATE(transaction_time)
),
rolling_avg AS (
  SELECT
    transaction_date,
    AVG(total_amount) OVER (
      ORDER BY transaction_date
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_day_avg
  FROM
    daily_totals
)
SELECT
  transaction_date,
  rolling_3_day_avg
FROM
  rolling_avg
WHERE
  transaction_date = '2021-01-31';
