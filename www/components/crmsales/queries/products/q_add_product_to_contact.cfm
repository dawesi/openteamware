<!--- //
	Module:            CRM / Product
	Description:       add product to contact (new record in productsassignedtocontact) and creates a history record
// --->

<cfquery name="q_add_product_to_contact">
INSERT INTO
	productsassignedtocontact
	(
	entrykey,
    dt_created,
    createdbyuserkey,

    contactkey,
    projectkey,
    quantity,
    retail_price,
    purchase_price,
    dt_added,
    comment,
    serialnumber
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.contactkey#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.projectkey#"/>,
   	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.quantity)#"/>,
    <cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.database_values.retail_price)#"/>,
    <cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.database_values.purchase_price)#"/>,
	<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.database_values.dt_added#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.comment#"/>,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.serialnumber#"/>
	)
;
</cfquery>

<!--- insert history record --->
<cfset a_struct_history_data = StructNew() />
<cfset a_struct_history_data.entrykey = CreateUUID() />
<cfset a_struct_history_data.dt_created = GetUTCTime(now()) />
<cfset a_struct_history_data.createdbyuserkey = arguments.securitycontext.myuserkey />
<cfset a_struct_history_data.contactkey = arguments.database_values.contactkey />
<cfset a_struct_history_data.productkey = arguments.database_values.projectkey />
<cfset a_struct_history_data.quantity = val(arguments.database_values.quantity) />
<cfset a_struct_history_data.purchase_price = val(arguments.database_values.purchase_price) />
<cfset a_struct_history_data.retail_price = val(arguments.database_values.retail_price) />

<cfset a_struct_history_data.comment = 'added new record to productsassignedtocontact table.' />
<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_db">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="table" value="productassignment_history">
	<cfinvokeargument name="primary_field" value="entrykey">
	<cfinvokeargument name="data" value="#a_struct_history_data#">
	<cfinvokeargument name="action" value="INSERT">
</cfinvoke>

<!--- update available quantity in productquantity table --->
<cfquery name="q_add_product_to_contact">
UPDATE
	productquantity
SET
    quantity = quantity - <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.quantity)#"/>
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>
AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.projectkey#"/>
;
</cfquery>


