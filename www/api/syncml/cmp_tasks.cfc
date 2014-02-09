<cfcomponent output='false'>
	<cfset sServiceKey = "52230718-D5B0-0538-D2D90BB6450697D1">
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfsetting requesttimeout="20000">
	
	<cffunction access="remote" name="CreateTask" output="false" returntype="boolean" hint="create a new task">
		<cfargument name="entrykey" type="string" required="true" hint="entrykey">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="title" type="string" required="true" hint="title">
		<cfargument name="notice" type="string" default="" required="true" hint="further text">
		<cfargument name="priority" type="numeric" default="2" hint="priority (default = 2); 1 = low; 3 = high">
		<cfargument name="percentdone" type="numeric" default="0" required="false" hint="">
		<cfargument name="status" type="numeric" default="1" hint="0 = done; 1 = not started yet (default); 2 = in progres; 3 = deferred">
		<cfargument name="projectkeys" type="string" default="" hint="n/a, leave empty">
		<cfargument name="actualwork" type="numeric" default="0" hint="minutes of actual work">
		<cfargument name="totalwork" type="numeric" default="0" hint="minutes of total work">
		<cfargument name="categories" type="string" default="" hint="categories">
		<cfargument name="due" type="date" required="false" hint="due (date in ts ... format)">
		<cfargument name="linked_contacts" type="string" default="" hint="n/a">
		<cfargument name="linked_files" type="string" default="" hint="n/a">
		<cfargument name="assignedtouserkeys" type="string" default="" required="false" hint="assigned to other users (leave empty by default)">
		<!---<cfargument name="private" type="numeric" default="0" required="false" hint="private">--->
		<cfargument name="dt_start" type="date" required="no" hint="start date of task">
		
		<cfset arguments.private = 0>
		<cfset arguments.userkey = arguments.securitycontext.myuserkey>
		
		<cfinvoke component="#application.components.cmp_tasks#" method="CreateTask" argumentcollection="#arguments#" returnvariable="a_bol_return"/>
		
		<cfreturn a_bol_return/>
		
	</cffunction>
	
	<cffunction access="remote" name="DeleteTask" output="false" returntype="boolean" hint="delete a task item">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings ... --->
		<cfargument name="usersettings" type="struct" required="true">
		<!--- delete outlook sync information too? --->
		<cfargument name="clearoutlooksyncmetadata" type="boolean" required="false" default="true" hint="clear out various meta data tables">
		
		<cfinvoke component="#application.components.cmp_tasks#" method="DeleteTask" argumentcollection="#arguments#" returnvariable="a_bol_return"/>
		
		<cfreturn a_bol_return/>
	</cffunction>		
	
	<cffunction access="remote" name="GetTask" output="false" returntype="struct" hint="return the task">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" default="" required="true" hint="entrykey">
		<!--- the security context ... check if this user has the right to access this object ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings (utc diff ... ) --->
		<cfargument name="usersettings" type="struct" required="true">	
		
		<cfinvoke component="#application.components.cmp_tasks#" method="GetTask" argumentcollection="#arguments#" returnvariable="stReturn"/>
		
		<cfreturn stReturn/>		
		
	</cffunction>		
	
	<cffunction access="remote" name="GetTasks" output="false" returntype="struct" hint="load tasks">
		<!--- security-context ...--->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- filteroptions ... --->
		<cfargument name="filter" type="struct" required="false" default="#StructNew()#" hint="filter">
		<!--- search for something ... --->
		<cfargument name="search" type="string" default="" required="false" hint="search for something">
		<!--- order by xy ... --->
		<cfargument name="orderby" type="string" default="dt_lastmodified" required="false" hint="order by fieldname">
		<!--- desc? --->
		<cfargument name="orderbydesc" type="boolean" required="false" default="false">
		<!--- load notice (body)? --->
		<cfargument name="loadnotice" type="boolean" required="false" default="true" hint="load notices as well">
		<!--- get category list? --->
		<cfargument name="createcategorylist" type="boolean" required="false" default="true" hint="create and return a list of distinct categories">

		<cfinvoke component="#application.components.cmp_tasks#" method="GetTasks" argumentcollection="#arguments#" returnvariable="stReturn"/>
		
		<cfreturn stReturn/>		
	</cffunction>		
	
	<cffunction access="remote" name="UpdateTask" output="false" returntype="boolean" hint="Update a task item">
		<!--- entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of task">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="yes">
		<!--- new values ... --->
		<!--- a structure full of items to edit ... --->	
		<cfargument name="newvalues" type="struct" required="true" hint="structure holding the new desired new values (field names same as in CreateTask)">		
		
		<cfinvoke component="#application.components.cmp_tasks#" method="UpdateTask" argumentcollection="#arguments#" returnvariable="a_bol_return"/>
		
		<cfreturn a_bol_return/>
	</cffunction>			
	
</cfcomponent>		