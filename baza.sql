CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    avatar_url VARCHAR(255),
    bio TEXT
);

CREATE TABLE Routes (
    route_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
  	activity_type VARCHAR(20) CHECK (activity_type IN ('rolki', 'rower', 'bieganie')),
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    distance_km DECIMAL(5, 2),
    surface_type VARCHAR(50),
    created_by INT REFERENCES Users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE UserRoutes (
    user_route_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    route_id INT REFERENCES Routes(route_id) ON DELETE CASCADE,
    status VARCHAR(20) CHECK (status IN ('favorite', 'completed', 'in_progress')),
    top_completion_time_minutes INT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Challenges (
    challenge_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    goal_distance_km DECIMAL(6, 2),
    start_date DATE,
    end_date DATE
);
CREATE TABLE UserChallenges (
    user_challenge_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    challenge_id INT REFERENCES Challenges(challenge_id) ON DELETE CASCADE,
    progress_distance_km DECIMAL(6, 2) DEFAULT 0.0,
    completed BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE UserHistory (
    users_history_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,  
    user_route_id INT REFERENCES UserRoutes(user_route_id) ON DELETE CASCADE,  
    user_challenge_id INT REFERENCES UserChallenges(user_challenge_id) ON DELETE CASCADE,  
    activity_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    distance_km DECIMAL(6, 2),  
    duration_minutes INT, 
    calories_burned DECIMAL(6,2)
);

CREATE TABLE WeatherData (
    weather_id SERIAL PRIMARY KEY,
    route_id INT REFERENCES Routes(route_id) ON DELETE CASCADE,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    temperature_celsius DECIMAL(4, 2),
    wind_speed_kmh DECIMAL(4, 2),
    weather_condition VARCHAR(50)
);
CREATE TABLE CommunityPosts (
    post_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    likes INT DEFAULT 0
);
CREATE TABLE Comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INT REFERENCES CommunityPosts(post_id) ON DELETE CASCADE,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users (username, email, password_hash, avatar_url, bio) VALUES
('agata_fąk', 'agataf@example.com', 'hashed_password_1', 'https://strona.com/avatar1.jpg', 'Pasja do rolek i sportu'),
('alice_smith', 'alice@example.com', 'hashed_password_2', 'https://strona.com/avatar2.jpg', 'Miłośniczka biegania i zdrowego stylu życia'),
('mike_jones', 'mike@example.com', 'hashed_password_3', 'https://strona.com/avatar3.jpg', 'Rowerzysta i entuzjasta przyrody');


INSERT INTO Routes (name, description, activity_type, difficulty_level, distance_km, surface_type, created_by) VALUES
('Plażowa trasa rolkarska', 'Piękna trasa wzdłuż plaży, idealna dla rolkarzy', 'rolki', 'medium', 10.5, 'asfalt', 1),
('Leśna ścieżka biegowa', 'Leśna trasa dla biegaczy z lekkimi wzniesieniami', 'bieganie', 'easy', 7.0, 'szutrowa', 2),
('Górska trasa rowerowa', 'Trasa rowerowa z górskimi podjazdami, przeznaczona dla zaawansowanych rowerzystów', 'rower', 'hard', 35.0, 'kamienista', 3);

INSERT INTO UserRoutes (user_id, route_id, status, top_completion_time_minutes) VALUES
(1, 1, 'favorite', NULL),
(2, 2, 'in_progress', NULL),
(3, 3, 'completed', 120);

INSERT INTO Challenges (name, description, goal_distance_km, start_date, end_date) VALUES
('Zimowe wyzwanie biegowe', 'Pokonaj 100 km w trakcie zimy', 100.0, '2025-01-01', '2025-03-31'),
('Wiosenne wyzwanie rowerowe', 'Pokonaj 200 km w ciągu wiosny', 200.0, '2025-04-01', '2025-06-30');

INSERT INTO UserChallenges (user_id, challenge_id, progress_distance_km, completed) VALUES
(1, 1, 50.0, FALSE),
(2, 2, 150.0, TRUE);

INSERT INTO UserHistory (user_id, user_route_id, user_challenge_id, activity_date, distance_km, duration_minutes, calories_burned) VALUES
(1, 1, NULL, '2025-01-21 09:30:00', 10.5, 60, 350), 
(2, 2, 1, '2025-01-21 08:00:00', 7.0, 45, 250),  
(3, 3, 2, '2025-01-21 10:00:00', 35.0, 120, 700);  

INSERT INTO WeatherData (route_id, temperature_celsius, wind_speed_kmh, weather_condition) VALUES
(1, 22.5, 15.0, 'słonecznie'),
(2, 18.0, 10.0, 'pochmurno'),
(3, 16.5, 20.0, 'wietrznie');

INSERT INTO CommunityPosts (user_id, content) VALUES
(1, 'Dzisiaj pokonałem moją ulubioną trasę rolkarską nad morzem! Cudowna pogoda!'),
(2, 'Nowa trasa biegowa leśna to prawdziwa przyjemność. Polecam!'),
(3, 'Górska trasa rowerowa jest świetna na wyzwania, ale daje w kość!');

INSERT INTO Comments (post_id, user_id, content) VALUES
(1, 2, 'Super! Jakie tempo?'),
(2, 1, 'Brzmi świetnie, muszę spróbować!'),
(3, 2, 'Czy możesz polecić jakieś inne trasy rowerowe w górach?');

