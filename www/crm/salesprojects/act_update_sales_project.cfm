<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="form.frmresponsibleuserkey" type="string" default="">

<cfset stUpdate = StructNew()>

<cfset stUpdate.title = form.frmtitle>
<cfset stUpdate.comment = form.frmcomment>
<cfset stUpdate.probability = form.frmprobability>
<cfset stUpdate.sales = form.frmsales>
<cfset stUpdate.stage = form.frmstage>
<cfset stUpdate.responsibleuserkey = form.frmresponsibleuserkey>
<cfset stUpdate.lead_source = form.frmleadsource>
<cfset stUpdate.dt_closing = form.frmclosingdate>
<cfset stUpdate.projecttype = form.frmproject_type>
<!--- more to come ... --->


<cfinvoke component="#request.a_str_component_crm_sales#" method="UpdateSalesProject" returnvariable="ab">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="newvalues" value="#stUpdate#">
</cfinvoke>

<cflocation addtoken="no" url="/crm/index.cfm?Action=ShowSalesProject&entrykey=#urlencodedformat(form.frmentrykey)#">