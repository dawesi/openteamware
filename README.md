openteamware: CFML CRM
======================

CFML Open Source CRM (ColdFusion, Railo, mysql)

Features

- Manage your contacts & accounts
- Activity & Project management - what's going on on which account (follow ups, sales projects, tasks)



Requirements

- ColdFusion 8+ or Railo 3+
- mysql 5+

Setup Guide


Setup instructions
==================

- Install mysql server (latest version)
- Create a database called otwcrm and an user which can perform CRUD operations on this database
- Import the OTW schema (located in the DB folder) to create all necessary tables

- CFML Server, either Adobe ColdFusion (commercial) or Railo (Open Source)

Instructions for Railo (recommended)
- Either add a new host to an existing setup or grab a copy of the latest stable version at http://www.getrailo.org/index.cfm/download/ (Railo is offering bundles with tomcat)
- Install the Application server and extract the source code (Everything in the folder _www) in the desired host directory or the default wwwroot.
- Open the railo manager (http://localhost:[ port you have selected at setup]/railo-context/admin/web.cfm and go to the tab "datasources" on the left. Create one datasource called otwocrm and connect to the database created above.
- You're ready to go - open http://localhost:[ port you have selected at setup] and log in with the default user
- The default user has the username/password: user / password (Change it in the settings)
