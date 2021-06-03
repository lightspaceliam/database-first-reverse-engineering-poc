# Database First Reverse Engineering

The purpose of this POC is to demonstrate how to reverse engineer an existing Microsoft SQL database, utilizing the dotnet cli commands to calculate and create C# entities that reflect the database schema. These entities can later be utilized to query against the database with Entity Framework. 

Whilst this is a simple demonstration including only two tables, you will quicky see how: 
- Accurately each table and column is calculated, including constraints
- The benefits if this was implemented at scale across a much larger schema

After following the Steps and executing the dotnet cli command ```dotnet ef dbcontext scaffold {…}``` you will notice three C# classes are generated:
- Supplier (entity)
- Product (entity)
- DbFirstReverseEngineeringContext inherits from DbContext (Fluent API)

And keep in mind all this is configurable. Just research the cli flags and chop and change to meet your requirements.

If you or your team where tasked with migrating to Entity Framework and later managing future database schema migrations with a Code First approach, you can appreciate how this toolset could vastly reduce the time to accurately accomplish this unit of work.

Yet another added bonus, Visual Studio 2019^ Community edition (the free one!) even has a database schema comparison tool. So, you can compare the legacy/existing schema with the new one, you can now create and manage with Code First Migrations before committing to cutting over with confidence. 

## Instalation Requirements
- [.NET Core 5.0.6](https://dotnet.microsoft.com/download)
- [SQL Server 2019^ developer](https://www.microsoft.com/en-au/sql-server/sql-server-downloads)
- [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15) or [SQL Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
- [Visual Studio or VS Code with appropriate extensions: (SQL Server (mssql))](https://visualstudio.microsoft.com/downloads/)

## Assumptions  

- You can connect to localhost to get to SQL Server
- SQL Server Network Configuration TCP/IP is enabled
- You have the above installed

If not update the connection string in the dotnet cli command.
## Steps

1. Clone the repository 
```
git clone https://github.com/lightspaceliam/database-first-reverse-engineering-poc.git
```
2. With CMD, navigate to: cd {your-directory}/database-first-reverse-engineering-poc/Entities
3. If entities/classes Supplier, Product & DbFirstReverseEngineeringContext exist, delete
4. Run TSQL script: ./Entities/Scripts/DbCreate.sql
5. Run TSQL script: ./Entities/Scripts/CreateTablesAndSeedData.sql
6. run dotnet cli command:
```
dotnet ef dbcontext scaffold "Server=localhost;Database=DbFirstReverseEngineering;Integrated Security=True;MultipleActiveResultSets=True" Microsoft.EntityFrameworkCore.SqlServer --data-annotations --use-database-names
```
If you are creating a project from scratch and have opted to use the dotnet cli commands, ensure you have included the following packages:
```
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="5.0.6" />
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="5.0.6" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="5.0.6" />
```
## Commands 

**Default Scaffold**
```
dotnet ef dbcontext scaffold "Data Source=localhost;Initial Catalog=ReverseEngineeredDb" Microsoft.EntityFrameworkCore.SqlServer
```

**Specifying tables**
```
dotnet ef dbcontext scaffold {connectionString & Provider...} --table Artist --table Album
```

**Preserving names**

.NET may update the table names and or pluralize. I would recommend keeping the existing table names for now to assist with comparing schemas and later changing them to suit your requirements via Code First Migrations.
```
dotnet ef dbcontext scaffold {connectionString & Provider...} --use-database-names
```

**Fluent API or Data Annotations**

Entity types are configured using the Fluent API by default. Specify (.NET Core CLI) to instead use data annotations when possible.
```
dotnet ef dbcontext scaffold {connectionString & Provider...} --data-annotations
```

**DbContext name**

The scaffolded DbContext class name will be the name of the database suffixed with Context by default. To specify a different one, use
```
dotnet ef dbcontext scaffold {connectionString & Provider...} --context
```

You can also use the ```--force``` flag to update existing entities however, you will lose any customisations made. I highly recommend studying the Limitations & Customizing the Model references before making uninformed decisions in the references below. 

**What I used**
I specified:

- ```--data-annotations``` because I prefer to keep the Fluent API as small as possible. I don't want to search through a million constraints related to other tables when I’m only interested on Supplier or Product in this context
- ```--use-database-names``` because that its Db 1st. 
```
dotnet ef dbcontext scaffold "Server=localhost;Database=DbFirstReverseEngineering;Integrated Security=True;MultipleActiveResultSets=True" Microsoft.EntityFrameworkCore.SqlServer --data-annotations --use-database-names
```
## References
- [Reverse Engineering](https://docs.microsoft.com/en-us/ef/core/managing-schemas/scaffolding?tabs=dotnet-core-cli)
- [Limitations](https://docs.microsoft.com/en-us/ef/core/managing-schemas/scaffolding?tabs=dotnet-core-cli#limitations)
- [Updating the model](https://docs.microsoft.com/en-us/ef/core/managing-schemas/scaffolding?tabs=dotnet-core-cli#updating-the-model)
