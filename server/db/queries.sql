-- (join 3+ tables) What sport has the most teams from the USA
SELECT sp.name AS sport, COUNT(DISTINCT t.team_id) AS usa_teams
FROM sport sp
JOIN league l ON l.sport_id = sp.sport_id
JOIN season s ON s.league_id = l.league_id
JOIN league_entry le ON le.season_id = s.season_id
JOIN team t ON t.team_id = le.team_id
WHERE t.country = 'USA'
GROUP BY sp.sport_id, sp.name
ORDER BY usa_teams DESC;

-- (group by having) which league seasons have at least 4 games
SELECT l.name AS league, s.year, COUNT(g.game_id) AS games_played
FROM game g
JOIN season s ON s.season_id = g.season_id
JOIN league l ON l.league_id = s.league_id
GROUP BY s.season_id, l.name, s.year
HAVING COUNT(g.game_id) >= 4
ORDER BY games_played DESC;

-- (window function partition by) rank each team's players by goals
SELECT t.name AS team, p.name AS player, ps.value AS goals,
       RANK() OVER (PARTITION BY t.team_id ORDER BY ps.value DESC) AS team_rank
FROM player_stat ps
JOIN player p ON p.player_id = ps.player_id
JOIN team t ON t.team_id = p.team_id
WHERE ps.stat_name = 'goals'
ORDER BY t.name, team_rank;

-- (insert/update/delete) insert a new favorite team for a user
INSERT INTO user_tracks_team (u_id, team_id)
VALUES (5, 25);
SELECT u.username, t.name AS favorite_team
FROM app_user u
JOIN user_tracks_team ut ON ut.u_id = u.u_id
JOIN team t ON t.team_id = ut.team_id
WHERE u.u_id = 5
ORDER BY t.name;