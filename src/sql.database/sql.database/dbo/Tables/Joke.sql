CREATE TABLE [dbo].[Joke] (
    [JokeId]          INT            IDENTITY (1, 1) NOT NULL,
    [JokeTxt]         NVARCHAR (MAX) NOT NULL,
    [JokeCategoryId]  INT            NULL,
    [JokeCategoryTxt] NVARCHAR (500) NULL,
    [Attribution]     NVARCHAR (500) NULL,
    [ImageTxt]        NVARCHAR (MAX) NULL,
    [Rating]          DECIMAL (3, 1) NULL,
    [VoteCount]       INT            NULL,
    [SortOrderNbr]    INT            CONSTRAINT [DF_Joke_SortOrderNbr] DEFAULT ((50)) NOT NULL,
    [ActiveInd]       NCHAR (1)      CONSTRAINT [DF_Joke_ActiveInd] DEFAULT (N'Y') NOT NULL,
    [CreateDateTime]  DATETIME       CONSTRAINT [DF_Joke_CreateDateTime] DEFAULT (getdate()) NOT NULL,
    [CreateUserName]  NVARCHAR (255) CONSTRAINT [DF_Joke_CreateUserName] DEFAULT (N'UNKNOWN') NOT NULL,
    [ChangeDateTime]  DATETIME       CONSTRAINT [DF_Joke_CreateDateTime1] DEFAULT (getdate()) NOT NULL,
    [ChangeUserName]  NVARCHAR (255) CONSTRAINT [DF_Joke_ChangeUserName] DEFAULT (N'UNKNOWN') NOT NULL,
    CONSTRAINT [PK_Joke] PRIMARY KEY CLUSTERED ([JokeId] ASC),
    CONSTRAINT [FK_Joke_JokeCategory] FOREIGN KEY ([JokeCategoryId]) REFERENCES [dbo].[JokeCategory] ([JokeCategoryId]) ON DELETE SET NULL ON UPDATE CASCADE
);

