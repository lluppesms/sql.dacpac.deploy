CREATE PROC [dbo].[sp_QueryJokes] (
  @category as varchar(255) = NULL,
  @searchTxt as varchar(255) = NULL
) AS
BEGIN
    SET @category = '%' + ISNULL(@category, '') + '%'
    SET @searchTxt = '%' + ISNULL(@searchTxt, '') + '%'
	SELECT j.JokeId, j.JokeCategoryId, j.JokeCategoryTxt, j.JokeTxt, j.ImageTxt, j.Rating
	FROM Joke j 
	WHERE JokeCategoryTxt LIKE @category AND JokeTxt LIKE @searchTxt
	ORDER BY j.JokeCategoryTxt, j.JokeTxt 
END