-- Create enum for seat categories
CREATE TYPE seat_category AS ENUM ('Economy', 'Business', 'First Class');

-- Planes table
CREATE TABLE planes (
    plane_id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    fabrication_date DATE NOT NULL,
);

-- Seat configuration per plane
CREATE TABLE seat_configurations (
    config_id SERIAL PRIMARY KEY,
    plane_id INTEGER REFERENCES planes(plane_id) ON DELETE CASCADE,
    category seat_category NOT NULL,
    number_of_seats INTEGER NOT NULL CHECK (number_of_seats > 0),
    UNIQUE(plane_id, category)
);

-- Cities table
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    UNIQUE(city_name, country)
);

-- Flights table
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL UNIQUE,
    plane_id INTEGER REFERENCES planes(plane_id) ON DELETE RESTRICT,
    origin_city_id INTEGER REFERENCES cities(city_id) ON DELETE RESTRICT,
    destination_city_id INTEGER REFERENCES cities(city_id) ON DELETE RESTRICT,
    departure_time TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival_time TIMESTAMP WITH TIME ZONE NOT NULL,
    reservation_deadline_hours INTEGER NOT NULL DEFAULT 3,
    cancellation_deadline_hours INTEGER NOT NULL DEFAULT 24,
    CHECK (origin_city_id != destination_city_id),
    CHECK (arrival_time > departure_time),
    CHECK (reservation_deadline_hours >= 0),
    CHECK (cancellation_deadline_hours >= 0)
);

-- Seat prices for each flight by category
CREATE TABLE flight_prices (
    price_id SERIAL PRIMARY KEY,
    flight_id INTEGER REFERENCES flights(flight_id) ON DELETE CASCADE,
    category seat_category NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price > 0),
    UNIQUE(flight_id, category)
);

-- Clients table
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
);

-- Admins table
CREATE TABLE admins (
    admin_id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
);

-- Flight promotions table
CREATE TABLE flight_promotions (
    promotion_id SERIAL PRIMARY KEY,
    flight_id INTEGER REFERENCES flights(flight_id) ON DELETE CASCADE,
    category seat_category NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL CHECK (discount_percentage > 0 AND discount_percentage <= 100),
    seats_available INTEGER NOT NULL CHECK (seats_available > 0),
    UNIQUE(flight_id, category)
);

-- Reservations table
CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    client_id INTEGER REFERENCES clients(client_id) ON DELETE RESTRICT,
    flight_id INTEGER REFERENCES flights(flight_id) ON DELETE RESTRICT,
    seat_category seat_category NOT NULL,
    is_promotional BOOLEAN NOT NULL DEFAULT FALSE,
    price_paid DECIMAL(10, 2) NOT NULL CHECK (price_paid >= 0),
    reservation_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_cancelled BOOLEAN NOT NULL DEFAULT FALSE,
    cancellation_time TIMESTAMP WITH TIME ZONE,
    CHECK (cancellation_time IS NULL OR cancellation_time > reservation_time)
);

-- Add indexes for common lookups
CREATE INDEX idx_flights_departure_time ON flights(departure_time);
CREATE INDEX idx_flights_origin_destination ON flights(origin_city_id, destination_city_id);
CREATE INDEX idx_reservations_client ON reservations(client_id);
CREATE INDEX idx_reservations_flight ON reservations(flight_id);
CREATE INDEX idx_reservations_is_cancelled ON reservations(is_cancelled);