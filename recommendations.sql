/*CREATE DATABASE IF NOT EXISTS recommendation_db;*/


USE recommendation_db;


CREATE TABLE IF NOT EXISTS recommendations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_input VARCHAR(50) NOT NULL UNIQUE,
    recommended_item VARCHAR(100) NOT NULL
);

TRUNCATE TABLE recommendations;

INSERT INTO recommendations (user_input, recommended_item) VALUES 
('hot', 'Summer'),
('cold', 'Winter'),
('hungry', 'Shawarma'),
('tired', 'Sleep'),
('bored', 'Play Minecraft'),
('happy', 'Watch a Real Madrid match'),
('sad', 'Take a walk'),
('rainy', 'Autumn'),
('spicy', 'Drink cold milk'),
('active', 'Go for a run');