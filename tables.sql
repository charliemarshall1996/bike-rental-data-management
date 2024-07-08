CREATE TABLE dates (
  date_key VARCHAR PRIMARY KEY,
  date DATE,
  month INTEGER,
  month_name VARCHAR,
  day INTEGER,
  day_name VARCHAR,
  quarter INTEGER,
  weekend BOOL
);

CREATE TABLE demographics (
  id INTEGER PRIMARY KEY,
  user_type VARCHAR,
  birth_year INTEGER,
  gender INTEGER
);

CREATE TABLE stations (
  id INTEGER PRIMARY KEY,
  name VARCHAR,
  longitude REAL,
  latitude REAL
);

CREATE TABLE journeys (
  id INTEGER PRIMARY KEY,
  bike_id INTEGER,
  demographics_id INTEGER REFERENCES demographics(id) ON DELETE CASCADE,
  start_station_id INTEGER REFERENCES stations(id) ON DELETE CASCADE,
  end_station_id INTEGER REFERENCES stations(id) ON DELETE CASCADE,
  date_key VARCHAR REFERENCES dates(date_key) ON DELETE CASCADE,
  trip_duration INTEGER,
  start_date DATE,
  start_time TIME,
  stop_date DATE,
  stop_time TIME,
  over_24_hrs BOOL
);

CREATE TABLE weather (
  date_key VARCHAR REFERENCES dates(date_key) ON DELETE CASCADE,
  date DATE,
  avg_wind_speed REAL,
  rained BOOL,
  snowed BOOL,
  precipitation REAL,
  snow_amount REAL,
  snow_depth REAL,
  avg_temperature REAL,
  max_temperature REAL,
  min_temperature REAL,
  fastest_two_minute_wind_direction REAL,
  fastest_five_minute_wind_direction REAL,
  fastest_two_minute_wind_speed REAL,
  fastest_five_minute_wind_speed REAL
);