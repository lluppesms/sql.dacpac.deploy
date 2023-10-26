CREATE TABLE [dbo].[JokeRating] (
    [JokeRatingId]   INT            IDENTITY (1, 1) NOT NULL,
    [JokeId]         INT            NOT NULL,
    [UserRating]     INT            NOT NULL,
    [CreateDateTime] DATETIME       CONSTRAINT [DF_JokeRating_CreateDateTime] DEFAULT (getdate()) NOT NULL,
    [CreateUserName] NVARCHAR (255) CONSTRAINT [DF_JokeRating_CreateUserName] DEFAULT (N'UNKNOWN') NOT NULL,
    CONSTRAINT [PK_JokeRating] PRIMARY KEY CLUSTERED ([JokeRatingId] ASC),
    CONSTRAINT [FK_JokeRating_Joke] FOREIGN KEY ([JokeId]) REFERENCES [dbo].[Joke] ([JokeId]) ON DELETE CASCADE ON UPDATE CASCADE
);

