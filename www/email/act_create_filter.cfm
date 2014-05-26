<!--- //

	Module:		E-Mail
	Description:Create a new filter
	

// --->
<cfparam name="form.frmantispamfilter" type="numeric" default="0">
<cfparam name="form.frmstoponsuccess" type="numeric" default="0">


<cfswitch expression="#form.frmfilteraction#">
	<cfcase value="1">
	<!--- move to folder --->
	<cfset a_str_filterparam = form.frmdestinationfolder>
	<cfset a_str_filterparam = ReplaceNoCase(a_str_filterparam, "INBOX.", "", "ONE")>
	</cfcase>
	<cfcase value="2">
	<!--- forward by email --->
	<cfset a_str_filterparam = form.frmdestinationemailaddress>
	</cfcase>
	<cfdefaultcase>
	<cfset a_str_filterparam = "">
	</cfdefaultcase>
</cfswitch>

<!--- create the filter --->
<cfinvoke component="/components/email/cmp_filter" method="CreateFilter" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
	<cfinvokeargument name="filtername" value="#form.frmfiltername#">
	<cfinvokeargument name="filteraction" value="#form.frmfilteraction#">
	<cfinvokeargument name="filterparam" value="#a_str_filterparam#">
	<cfinvokeargument name="comparisonfield" value="#form.frmcomparisonfield#">
	<cfinvokeargument name="comparison" value="#form.frmcomparison#">
	<cfinvokeargument name="comparisonparam" value="#form.frmcomparisonparam#">
	<cfinvokeargument name="antispamfilter" value="#form.frmantispamfilter#">
	<cfinvokeargument name="stoponsuccess" value="#form.frmstoponsuccess#">
</cfinvoke>


<cfinvoke component="/components/email/cmp_filter" method="CreateProcmailconfig" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>

<cflocation addtoken="no" url="index.cfm?action=filter">


