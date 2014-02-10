<!--- //
	Module:            CRM / Product
	Description:       update productsassignedtocontact (its quantity, date and comment) and creates a history record
// --->



<!--- insert history record --->

<cfset a_str_comment = "productsassignedtocontact record has been updated - quantity was increased." />
<cfif a_int_old_quantity EQ -1>
    	<cfset variables.productsassignedtocontactentrykey = arguments.database_values.entrykey />
    	<cfinclude template="q_select_productsassignedtocontact.cfm" />
    	<cfset a_int_old_quantity = q_select_productsassignedtocontact.quantity />
    	<cfset a_str_comment = "productsassignedtocontact record has been updated - quantity was set" />
</cfif>
<cfset a_delta_quantity = arguments.database_values.quantity - a_int_old_quantity />  <!--- how many product have been assigned --->


<cfset a_struct_history_data = StructNew() />
<cfset a_struct_history_data.entrykey = CreateUUID() />
<cfset a_struct_history_data.dt_created = GetUTCTime(now()) />
<cfset a_struct_history_data.createdbyuserkey = arguments.securitycontext.myuserkey />
<cfset a_struct_history_data.contactkey = arguments.database_values.contactkey />
<cfset a_struct_history_data.productkey = arguments.database_values.projectkey />
<cfset a_struct_history_data.purchase_price = arguments.database_values.purchase_price />
<cfset a_struct_history_data.retail_price = arguments.database_values.retail_price />
<cfset a_struct_history_data.quantity = a_delta_quantity />
<cfset a_struct_history_data.comment = a_str_comment />


<cfquery name="q_update_product_of_contact" datasource="#request.a_str_db_crm#">
UPDATE
	productsassignedtocontact
SET	
    quantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.quantity)#"/>,
    dt_added = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.database_values.dt_added#"/>,
    comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.comment#"/>,
	retail_price = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.retail_price#"/>,
	purchase_price = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.purchase_price#"/>
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.entrykey#"/>
;
</cfquery>


<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_db">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="database" value="#request.a_str_db_crm#">
	<cfinvokeargument name="table" value="productassignment_history">
	<cfinvokeargument name="primary_field" value="entrykey">
	<cfinvokeargument name="data" value="#a_struct_history_data#">
	<cfinvokeargument name="action" value="INSERT">
</cfinvoke>

<cfquery name="q_update_product_of_contact_available" datasource="#request.a_str_db_crm#">
UPDATE
	productquantity
SET	
    quantity = quantity - <cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_delta_quantity)#"/>
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>
AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.projectkey#"/>
;
</cfquery>


