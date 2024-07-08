CREATE TABLE dates (
  date DATE PRIMARY KEY ON DELETE CASCADE,
  month integer,
  month_name varchar,
  day integer,
  day_name varchar,
  quarter integer,
  weekend bool
);

CREATE TABLE demographics (
  id integer PRIMARY KEY ON DELETE CASCADE,
  user_type varchar,
  birth_year integer,
  gender integer
);

CREATE TABLE stations (
  id integer PRIMARY KEY ON DELETE CASCADE,
  name varchar,
  longitude float,
  latitude float
);

CREATE TABLE journeys (
  id integer PRIMARY KEY,
  bike_id integer,
  demographics_id integer REFERENCES demographics(id) ON DELETE CASCADE,
  start_station_id integer REFERENCES stations(id) ON DELETE CASCADE,
  end_station_id integer REFERENCES stations(id) ON DELETE CASCADE,
  trip_duration integer,
  start_date DATE REFERENCES dates(date) ON DELETE CASCADE,
  start_time TIME,
  stop_date DATE REFERENCES dates(date) ON DELETE CASCADE,
  stop_time TIME
);

CREATE TABLE weather (
  date date REFERENCES dates(date) ON DELETE CASCADE,
  avg_wind_speed float,
  rained bool,
  snowed bool,
  precipitation float,
  snow_amount float,
  snow_depth float,
  avg_temperature float,
  max_temperature float,
  min_temperature float,
  fastest_two_minute_wind_direction float,
  fastest_five_minute_wind_direction float,
  fastest_two_minute_wind_speed float,
  fastest_five_minute_wind_speed float
);