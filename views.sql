-- Daily Counts

CREATE VIEW daily_counts AS
SELECT dates.date_key,
    dates.date AS date,
    dates.day_name AS day_name,
    dates.month_name AS month_name,
    COUNT(journeys.id) AS count_journeys,
    COUNT(demographics.user_type) FILTER (WHERE demographics.user_type = 'Subscriber') AS count_subscriber_journeys,
    COUNT(demographics.user_type) FILTER (WHERE demographics.user_type = 'Customer') AS count_customer_journeys,
    COUNT(demographics.user_type) FILTER (WHERE demographics.user_type = 'unknown') AS count_unknown_journeys,
    COUNT(journeys.over_24_hrs) FILTER (WHERE journeys.over_24_hrs = true) AS count_late_violations
FROM journeys
    RIGHT JOIN dates ON journeys.date_key = dates.date_key
    LEFT JOIN demographics ON journeys.demographics_id = demographics.id
GROUP BY dates.date_key
ORDER BY dates.date_key;

-- Daily Data
 CREATE VIEW daily_data AS
 SELECT daily_counts.date_key,
    daily_counts.date,
    daily_counts.month_name,
    daily_counts.day_name,
    daily_counts.count_journeys,
    sum(daily_counts.count_journeys) OVER (PARTITION BY daily_counts.month_name ORDER BY daily_counts.date) AS month_running_total,
    daily_counts.count_subscriber_journeys,
    daily_counts.count_customer_journeys,
    daily_counts.count_unknown_journeys,
    daily_counts.count_late_violations,
    weather.min_temperature,
    weather.avg_temperature,
    weather.max_temperature,
    weather.avg_wind_speed,
    weather.precipitation,
    weather.snow_amount,
    weather.rained,
    weather.snowed
   FROM daily_counts
     JOIN weather ON daily_counts.date = weather.date
  ORDER BY daily_counts.date;

-- Monthly Data
CREATE VIEW monthly_data AS
SELECT 
    dates.month,
    dates.month_name,
    ROUND(AVG(daily.count_journeys)) AS avg_daily_journeys,
    ROUND(AVG(daily.count_subscriber_journeys)) AS avg_daily_subscriber_journeys,
    ROUND(AVG(daily.count_customer_journeys)) AS avg_daily_customer_journeys,
    ROUND(AVG(daily.count_unknown_journeys)) AS avg_daily_unknown_journeys,
    ROUND(AVG(daily.count_late_violations)) AS avg_daily_late_violations,
    SUM(daily.count_journeys) AS sum_journeys,
    SUM(daily.count_subscriber_journeys) AS sum_subscriber_journeys,
    SUM(daily.count_customer_journeys) AS sum_customer_journeys,
    SUM(daily.count_unknown_journeys) AS sum_unknown_journeys,
    ROUND(AVG(daily.min_temperature)) AS month_avg_daily_min_temperature,
    ROUND(AVG(daily.avg_temperature)) AS month_avg_daily_avg_temperature,
    ROUND(AVG(daily.max_temperature)) AS month_avg_daily_max_temperature,
    ROUND(AVG(daily.avg_wind_speed)) AS month_avg_daily_wind_speed,
    ROUND(AVG(daily.precipitation)) AS month_avg_daily_precipitation,
    COUNT(daily.rained) FILTER (WHERE daily.rained) AS count_of_rainy_days,
    COUNT(daily.snowed) FILTER (WHERE daily.snowed) AS count_of_snowy_days
FROM dates
    JOIN daily_data daily ON dates.date_key = daily.date_key
GROUP BY dates.month, dates.month_name
ORDER BY dates.month;

-- Weather Journeys
CREATE VIEW weather_journeys AS
SELECT
    daily_data.date,
    daily_data.day_name,
    daily_data.count_journeys,
    LAG(daily_data.count_journeys, 7, 0) OVER (ORDER BY daily_data.date) prev_week_count_journeys,
    daily_data.count_subscriber_journeys,
    LAG(daily_data.count_customer_journeys, 7, 0) OVER (ORDER BY daily_data.date) prev_week_count_subscriber_journeys,
    daily_data.count_customer_journeys,
    LAG(daily_data.count_customer_journeys, 7, 0) OVER (ORDER BY daily_data.date) prev_week_count_customer_journeys,
    daily_data.count_unknown_journeys,
    LAG(daily_data.count_unknown_journeys, 7, 0) OVER (ORDER BY daily_data.date) prev_week_count_unknown_journeys,
    daily_data.min_temperature,
    LAG(daily_data.min_temperature, 7, 0) OVER (ORDER BY daily_data.date) prev_week_min_temperature,
    daily_data.avg_temperature,
    LAG(daily_data.avg_temperature, 7, 0) OVER (ORDER BY daily_data.date) prev_week_avg_temperature,
    daily_data.max_temperature,
    LAG(daily_data.max_temperature, 7, 0) OVER (ORDER BY daily_data.date) prev_week_max_temperature,
    daily_data.rained,
    daily_data.snowed
FROM daily_data
    JOIN weather ON daily_data.date_key = weather.date_key
ORDER BY daily_data.date;