CREATE VIEW vw_Jokes AS
SELECT TOP (100) PERCENT j.JokeId, j.JokeCategoryId, j.JokeCategoryTxt, j.JokeTxt, j.ImageTxt, j.Rating
FROM Joke j 
ORDER BY j.JokeCategoryTxt, j.JokeTxt

-- Select * from vw_Jokes

-- DROP VIEW vw_Jokes