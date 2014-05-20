openteamware: CFML CRM
======================

CFML Open Source CRM (ColdFusion, Railo, mysql)

Features

- Manage your contacts & accounts
- Activity & Project management - what's going on on which account (follow ups, sales projects, tasks)



Requirements

- Windows or Linux
- Java JDK (in case not already installed)
- Application Server: ColdFusion 8+ or Railo 3+
- Database: mysql 5+

otw has been heavily tested on Linux but should run on Windows as well.

Setup instructions
==================

- Install mysql server (http://dev.mysql.com/downloads/mysql/)
- Create a database called otwcrm and an user which can perform CRUD operations on this database
- Import the OTW schema (located in the DB folder) to create all necessary tables

- CFML Server, either Adobe ColdFusion (commercial) or Railo (Open Source)

Instructions for Railo (recommended)
- Either add a new host to an existing setup or grab a copy of the latest stable version at http://www.getrailo.org/index.cfm/download/ (Railo is offering bundles with tomcat)
- Install the Application server. During setup you can agree to all default settings as they can be changed later. In case you already know that you want to run the service on the standard http or https port select port 80 or 443 during the setup as web listener for tomcat
- Extract the source code (Everything in the folder _www) in the desired host directory or the default wwwroot.
- Open the railo manager (http://localhost:[ port you have selected at setup]/railo-context/admin/web.cfm and go to the tab "datasources" on the left. Create one datasource called otwocrm and connect to the database created above.
- You're ready to go - open http://localhost:[ port you have selected at setup] and log in with the default user
- The default user has the username/password: user / password (Change it in the settings)
