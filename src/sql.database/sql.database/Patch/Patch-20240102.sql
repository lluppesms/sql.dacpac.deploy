--------------------------------------------------------------------------------------
-- This file contains SQL statements that will be appended to the build script.
--------------------------------------------------------------------------------------
-- DELETE From Joke Where JokeTxt = 'What do you call a Jedi with anxiety? A p-Anakin Skywalker'
--------------------------------------------------------------------------------------

DECLARE 
  @JokeCategoryId  int = 0,
  @JokeCategoryTxt nvarchar(500) = 'What do you call...',
  @JokeTxt         nvarchar(max) = 'What do you call a Jedi with anxiety? A p-Anakin Skywalker',
  @ImageTxt        nvarchar(max) = 'A Jedi Knight'

Print 'Getting category...'
SELECT @JokeCategoryId = JokeCategoryId FROM JokeCategory WHERE JokeCategoryTxt = @JokeCategoryTxt

Print 'Inserting fresh joke...'
IF NOT EXISTS(Select JokeTxt FROM Joke WHERE JokeTxt = @JokeTxt)
  INSERT INTO Joke (JokeCategoryId, JokeCategoryTxt, JokeTxt, ImageTxt)
    SELECT @JokeCategoryId, @JokeCategoryTxt, @JokeTxt, @ImageTxt

Print 'Displaying Joke...'
SELECT j.JokeId, j.JokeCategoryId, j.JokeCategoryTxt, j.JokeTxt, j.ImageTxt, j.Rating, j.CreateDateTime 
FROM Joke j
WHERE JokeTxt = @JokeTxt
