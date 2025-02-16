-- Create enum for seat categories
CREATE TYPE seat_category AS ENUM ('Economy', 'Business', 'First Class');

-- Planes table
CREATE TABLE planes (
    id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    fabrication_date DATE NOT NULL
);

-- Seat configuration per plane
CREATE TABLE seat_configurations (
    id SERIAL PRIMARY KEY,
    id_plane INTEGER REFERENCES planes(id) ON DELETE CASCADE,
    category seat_category NOT NULL,
    number_of_seats INTEGER NOT NULL CHECK (number_of_seats > 0),
    UNIQUE(id_plane, category)
);

-- Cities table
CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    UNIQUE(city_name, country)
);

-- Flights table
CREATE TABLE flights (
    id SERIAL PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL UNIQUE,
    id_plane INTEGER REFERENCES planes(id) ON DELETE RESTRICT,
    id_origin_city INTEGER REFERENCES cities(id) ON DELETE RESTRICT,
    id_destination_city INTEGER REFERENCES cities(id) ON DELETE RESTRICT,
    departure_time TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival_time TIMESTAMP WITH TIME ZONE NOT NULL,
    reservation_deadline_hours INTEGER NOT NULL DEFAULT 3,
    cancellation_deadline_hours INTEGER NOT NULL DEFAULT 24,
    CHECK (id_origin_city != id_destination_city),
    CHECK (arrival_time > departure_time),
    CHECK (reservation_deadline_hours >= 0),
    CHECK (cancellation_deadline_hours >= 0)
);

-- Seat prices for each flight by category
CREATE TABLE flight_prices (
    id SERIAL PRIMARY KEY,
    id_flight INTEGER REFERENCES flights(id) ON DELETE CASCADE,
    category seat_category NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price > 0),
    UNIQUE(id_flight, category)
);

-- Clients table
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Admins table
CREATE TABLE admins (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Flight promotions table
CREATE TABLE flight_promotions (
    id SERIAL PRIMARY KEY,
    id_flight INTEGER REFERENCES flights(id) ON DELETE CASCADE,
    category seat_category NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL CHECK (discount_percentage > 0 AND discount_percentage <= 100),
    seats_available INTEGER NOT NULL CHECK (seats_available > 0),
    UNIQUE(id_flight, category)
);

-- Reservations table
CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    id_client INTEGER REFERENCES clients(id) ON DELETE RESTRICT,
    id_flight INTEGER REFERENCES flights(id) ON DELETE RESTRICT,
    seat_category seat_category NOT NULL,
    is_promotional BOOLEAN NOT NULL DEFAULT FALSE,
    price_paid DECIMAL(10, 2) NOT NULL CHECK (price_paid >= 0),
    reservation_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_cancelled BOOLEAN NOT NULL DEFAULT FALSE,
    cancellation_time TIMESTAMP WITH TIME ZONE,
    CHECK (cancellation_time IS NULL OR cancellation_time > reservation_time)
);