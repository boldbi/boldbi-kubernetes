# Consent to deploy client libraries

By giving consent to install client libraries to connect with Oracle, PostgreSQL, MySQL, MongoDB, InfluxDB, and Snowflake.Data, you can use the following libraries in your kubernetes pods. Bold BI uses these client libraries to connect with their respective SQL database variants. Read about the licenses of each library to give consent for usage. 

## mongo-csharp-driver
* MongoDB

[Apache License, Version 2.0](https://github.com/mongodb/mongo-csharp-driver/blob/master/License.txt)

## Snowflake.Data
* Snowflake.Data

[Apache License, Version 2.0](https://github.com/snowflakedb/snowflake-connector-net/blob/master/LICENSE)

## Oracle.ManagedDataAccess
* Oracle

[Oracle License](https://www.oracle.com/downloads/licenses/distribution-license.html)

## Npgsql 4.0.0
* PostgreSQL
* Amazon Redshift
* Google Cloud - PostgreSQL
* Amazon Aurora - PostgreSQL

[PostgreSQL License](https://github.com/npgsql/npgsql/blob/main/LICENSE)

## MySQLConnector 0.45.1
* MySQL
* MemSQL
* MariaDB
* Google Cloud – MySQL
* Amazon Aurora - MySQL
* CDATA

[MIT License](https://github.com/mysql-net/MySqlConnector/blob/master/LICENSE)

## InfluxData.Net
* InfluxDB

[MIT License](https://github.com/pootzko/InfluxData.Net/blob/master/LICENSE)

# Client library names as arguments for Bold BI deployment in Kubernetes

Find the names of client libraries, which needs to be passed as a comma separated string for an environment variable in **deployment.yaml** file.

| Library                   | Name          |
| -------------             | ------------- |
| mongo-csharp-driver       | mongodb       |
| Snowflake.Data            | snowflake     |
| Oracle.ManagedDataAccess  | oracle        |
| Npgsql 4.0.0              | npgsql        |
| MySQLConnector 0.45.1     | mysql         |
| InfluxData.Net            | influxdb      |
| Google.Cloud.BigQuery.V2  | google        |
| ClickHouse.Client         | clickhouse    |

If you want to use all client libraries in the Bold BI application, then pass the following string as value for `INSTALL_OPTIONAL_LIBS` environment variable. You need to add the names only for the libraries, which you are consenting to use with Bold BI application.

`mongodb,mysql,influxdb,snowflake,oracle,google,clickhouse`
