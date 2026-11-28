-- What sport has the most teams from the USA
SELECT sp.name AS sport, COUNT(DISTINCT t.team_id) AS usa_teams
FROM sport sp
JOIN league l ON l.sport_id = sp.sport_id
JOIN season s ON s.league_id = l.league_id
JOIN league_entry le ON le.season_id = s.season_id
JOIN team t ON t.team_id = le.team_id
WHERE t.country = 'USA'
GROUP BY sp.sport_id, sp.name
ORDER BY usa_teams DESC;

-- which league seasons have at least 4 games
SELECT l.name AS league, s.year, COUNT(g.game_id) AS games_played
FROM game g
JOIN season s ON s.season_id = g.season_id
JOIN league l ON l.league_id = s.league_id
GROUP BY s.season_id, l.name, s.year
HAVING COUNT(g.game_id) >= 4
ORDER BY games_played DESC;

-- 