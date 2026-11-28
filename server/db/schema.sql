DROP DATABASE IF EXISTS sports_app;
CREATE DATABASE sports_app;
USE sports_app;

CREATE TABLE sport (
    sport_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE league (
    league_id INT AUTO_INCREMENT PRIMARY KEY,
    sport_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    team_limit INT NOT NULL,
    FOREIGN KEY (sport_id) REFERENCES sport (sport_id) ON DELETE RESTRICT,
    CHECK (team_limit > 0)
);

CREATE TABLE season (
    season_id INT AUTO_INCREMENT PRIMARY KEY,
    league_id INT NOT NULL,
    year INT NOT NULL,
    data_complete VARCHAR(5) NOT NULL,
    FOREIGN KEY (league_id) REFERENCES league (league_id) ON DELETE CASCADE,
    UNIQUE (league_id, year),
    CHECK (data_complete IN ('TRUE', 'FALSE'))
);

CREATE TABLE team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    player_limit INT NOT NULL,
    CHECK (player_limit > 0)
);

CREATE TABLE app_user (
    u_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- M:N between Season and Team
CREATE TABLE league_entry (
    season_id INT NOT NULL,
    team_id INT NOT NULL,
    points INT NOT NULL DEFAULT 0,
    PRIMARY KEY (season_id, team_id),
    FOREIGN KEY (season_id) REFERENCES season (season_id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES team (team_id) ON DELETE CASCADE,
    CHECK (points >= 0)
);

CREATE TABLE game (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    season_id INT NOT NULL,
    game_date DATE NOT NULL,
    home_team_id INT NOT NULL,
    away_team_id INT NOT NULL,
    home_score INT NOT NULL,
    away_score INT NOT NULL,
    FOREIGN KEY (season_id) REFERENCES season (season_id) ON DELETE CASCADE,
    FOREIGN KEY (home_team_id) REFERENCES team (team_id) ON DELETE RESTRICT,
    FOREIGN KEY (away_team_id) REFERENCES team (team_id) ON DELETE RESTRICT,
    CHECK (home_team_id != away_team_id),
    CHECK (home_score >= 0 AND away_score >= 0)
);

CREATE TABLE player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    team_id INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES team (team_id) ON DELETE RESTRICT
);

-- multivalued attribute table
CREATE TABLE player_stat (
    player_id INT NOT NULL,
    stat_name VARCHAR(50) NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (player_id, stat_name),
    FOREIGN KEY (player_id) REFERENCES player (player_id) ON DELETE CASCADE
);

-- M:N between User and Team
CREATE TABLE user_tracks_team (
    u_id INT NOT NULL,
    team_id INT NOT NULL,
    PRIMARY KEY (u_id, team_id),
    FOREIGN KEY (u_id) REFERENCES app_user (u_id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES team (team_id) ON DELETE CASCADE
);

-- M:N between User and Player
CREATE TABLE user_tracks_player (
    u_id INT NOT NULL,
    player_id INT NOT NULL,
    PRIMARY KEY (u_id, player_id),
    FOREIGN KEY (u_id) REFERENCES app_user (u_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES player (player_id) ON DELETE CASCADE
);