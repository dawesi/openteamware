<!--- //
	Module:            CRM / Products
	Description:       removes the specified product from contact
// --->

<cfset variables.productsassignedtocontactentrykey = arguments.entrykey />
<cfinclude template="q_select_productsassignedtocontact.cfm" />

<cfquery name="q_delete_product">
DELETE FROM
    productsassignedtocontact
WHERE
    entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"/>
</cfquery>

<!--- insert history record --->

<cfset a_struct_history_data = StructNew() />
<cfset a_struct_history_data.entrykey = CreateUUID() />
<cfset a_struct_history_data.dt_created = GetUTCTime(now()) />
<cfset a_struct_history_data.createdbyuserkey = arguments.securitycontext.myuserkey />
<cfset a_struct_history_data.contactkey = q_select_productsassignedtocontact.contactkey />
<cfset a_struct_history_data.productkey = q_select_productsassignedtocontact.projectkey />
<cfset a_struct_history_data.quantity = -q_select_productsassignedtocontact.quantity />
<cfset a_struct_history_data.comment = "record deleted from productsassignedtocontact table." />
<cfset a_struct_history_data.retail_price = val(q_select_productsassignedtocontact.retail_price) />
<cfset a_struct_history_data.purchase_price = val(q_select_productsassignedtocontact.purchase_price) />

<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_db">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="table" value="productassignment_history">
	<cfinvokeargument name="primary_field" value="entrykey">
	<cfinvokeargument name="data" value="#a_struct_history_data#">
	<cfinvokeargument name="action" value="INSERT">
</cfinvoke>

