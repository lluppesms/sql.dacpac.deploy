CREATE TABLE [dbo].[JokeCategory] (
    [JokeCategoryId]  INT            IDENTITY (1, 1) NOT NULL,
    [JokeCategoryTxt] NVARCHAR (500) NULL,
    [SortOrderNbr]    INT            CONSTRAINT [DF_JokeCategory_SortOrderNbr] DEFAULT ((50)) NOT NULL,
    [ActiveInd]       NVARCHAR (1)   CONSTRAINT [DF_JokeCategory_ActiveInd] DEFAULT (N'Y') NOT NULL,
    [CreateDateTime]  DATETIME       CONSTRAINT [DF_JokeCategory_CreateDateTime] DEFAULT (getdate()) NOT NULL,
    [CreateUserName]  NVARCHAR (255) CONSTRAINT [DF_JokeCategory_CreateUserName] DEFAULT (N'UNKNOWN') NOT NULL,
    [ChangeDateTime]  DATETIME       CONSTRAINT [DF_JokeCategory_ChangeDateTime] DEFAULT (getdate()) NOT NULL,
    [ChangeUserName]  NVARCHAR (255) CONSTRAINT [DF_JokeCategory_ChangeUserName] DEFAULT (N'UNKNOWN') NOT NULL,
    CONSTRAINT [PK_JokeCategory] PRIMARY KEY CLUSTERED ([JokeCategoryId] ASC)
);

