# SQL Server Deploy Example

## Introduction

This repository will demonstrate how to deploy an Azure SQL Server instance using pipelines with Bicep files, and then deploy and/or update a database schema using a SQL Server Database Project, which creates a DACPAC file that is then published to Azure with a YML pipeline.

## Usage

Follow these steps to publish and update a database schema to an existing Azure SQL Server using Azure DevOps pipelines:

1. Create a SQL database on your local server or desktop.

1. Create a new `SQL Server Database Project` in Visual Studio with the SQL Server Data Tools installed.
  
    > If the intended deploy target is Azure SQL, go into the project properties and set the Target Platform to "Microsoft Azure SQL Database".

1. Import the database schema into the project by right-clicking on the project and select `Import...` and then `Database...` and select the database you wish to import, which will populate the project with the schema objects.

1. If an initial set of data is desired in the database, add a post deployment script to the project by right clicking on the `dbo` folder and selecting `Add` and then `Script...` and then selecting Post-Deployment script.  Name the script something like `Post-Deployment.sql` and add the desired SQL commands to populate the database with data.

    > Note: The script will be run **EVERY TIME** the database is created or updated, so be sure the script is [**idempotent**](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/applying?tabs=dotnet-core-cli#idempotent-sql-scripts) and will not create multiple versions of the initial data.

1. Check the updated project code into the repository and then run one of the pipelines to build the DACPAC file and deploy the database to the target server.

    > Note: the folder, solution, and project name are hard-coded into the pipelines, so if those are changed, the pipelines will need to be updated.

1. If you are NOT using a local user/password, you must find the service principal name that is running your pipeline and execute these commands in the Azure SQL Database to grant that service principal access to the database:

    ``` sql
    CREATE USER yourSP FROM EXTERNAL PROVIDER
    ALTER ROLE db_owner ADD MEMBER yourSP
    ```

    > If you don't you do this, you will probably see this error:

    ``` bash
    ##[error]Unable to connect to target server 'xxxdacpacdemo.database.windows.net'. Please verify the connection information such as the server name, login credentials, and firewall rules for the target server.
    ##[error]Login failed for user '<token-identified principal>'.
    ##[error]The Azure SQL DACPAC task failed. SqlPackage.exe exited with code 1.Check out how to troubleshoot failures at https://aka.ms/sqlazuredeployreadme#troubleshooting-
    ```

    > For more info, see: [https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure#provision-microsoft-entra-admin-sql-database](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure#provision-microsoft-entra-admin-sql-database)

1. When changes are made to the database, use the Schema Compare tool to compare the source database to the database project and then update the project with the changes, check in the code, and run one of the pipelines again to publish your changes.

    > Note: If publishing to Azure SQL, the Schema Compare options should be set to ignore Database Roles and Users, as those do not transfer well to Azure SQL. Check the changes into the repository and run the pipeline again to deploy the changes to the target server.

## Pipeline Setup

See the [.azdo/pipeline/readme.md](.azdo/pipelines/readme.md) file for details on what each pipeline does and how to set up the Azure DevOps environment to make the pipelines function correctly.

## Additional Notes

- This project is mostly focused on database **SCHEMA** changes, not on changing to the actual **DATA** in a database (except for the initial data populate). However, there is an example of running scripts as part of the post-deployment.

- In addition, this project has [a pipeline that runs a script](.azdo/pipelines/run-sql-pipeline.yml). The scripts allowed are defined in the YML code and the user may choose which one at runtime.
- One of the custom scripts in this example does an Azure DB Copy, which must run in the Master database, so there is custom logic in the run SQL pipeline template for that.

- For some helpful queries about permissions in an Azure SQL database, see [permissions_queries.md](permissions_queries.md).

## References

- [Blog: Continuous Delivery for Azure SQL DB](https://devblogs.microsoft.com/azure-sql/continuous-delivery-for-azure-sql-db-using-azure-devops-multi-stage-pipelines/)
- [Example Pipeline from the previous article](https://github.com/arvindshmicrosoft/azure-sql-devops/blob/add-pipeline/azure-pipelines/deploy-sqlproj.yml)

- [Blog: DevOps for Azure SQL](https://devblogs.microsoft.com/azure-sql/devops-for-azure-sql/)

- [Blog: Deploying DACPACs to Azure SQL via Azure DevOps Pipelines](https://techcommunity.microsoft.com/t5/healthcare-and-life-sciences/deploying-dapacs-to-azure-sql-via-azure-devops-pipelines/ba-p/4227385)

- [MS Learn: Azure SQL database deployment](https://learn.microsoft.com/en-us/azure/devops/pipelines/targets/azure-sqldb?view=azure-devops&tabs=yaml)

- [Visual Studio: SQL Server Data Tools](https://visualstudio.microsoft.com/vs/features/ssdt/)

- [YML Task: SqlAzureDacpacDeployment@1](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/sql-azure-dacpac-deployment-v1?view=azure-pipelines)

<!-- Other References

- [SO: Connect with MI in a Pipeline Question](https://stackoverflow.com/questions/55637169/invoke-sqlcmd-with-aad-authentication)

- [SO: Connect with MI in a Pipeline Question](https://markallison.co.uk/blog/connect-mi-with-managedidentity/)

- [Blog: Automatically Deploy your Database with Dacpac Packages](https://programmingwithwolfgang.com/deploy-dacpac-linux-azure-devops/)

- [Deploying DB changes using SSDT via Azure DevOps](https://medium.com/synsoft-global/deploying-db-changes-using-ssdt-via-azure-devops-3907f326e80d) 

- [Blog: Unleashing the Power of Managed Identity: Running SQL Scripts in Azure DevOps Pipeline](https://dev.to/shekhartarare/unleashing-the-power-of-managed-identity-running-sql-scripts-in-azure-devops-pipeline-311f)

-->
