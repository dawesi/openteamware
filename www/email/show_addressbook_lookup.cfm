<cfparam name="url.search" default="" type="string">
<!--- to / cc / bcc --->
<cfparam name="url.field" type="string" default="to">


<html>

<head>
<cfinclude template="/common/scripts/script_utils.cfm">
<cfinclude template="/style_sheet.cfm">

<title>Untitled Document</title>

<cfinclude template="../common/js/inc_js.cfm">

<script type="text/javascript">
	function RecalcHeight(t)
		{
		//alert(document.body.scrollHeight);
		//alert(document.body.clientHeight);
		
		//parent.AdjustLookupHeight(document.body.scrollHeight);
		
		//parent.iddivlookupcc.innerHTML = '<h1>hello</h1>';
		}
</script>
</head>



<body style="padding:0px;" class="mischeader" onLoad="SubmitData();">

<cfif len(url.search) IS 0>
	<script type="text/javascript">
		function SubmitData()
			{
			myArrayContacts = new Array(0);
			parent.mylookup_contacts = myArrayContacts;
			return true;
			}
	</script>
	<cfabort>
</cfif>

<cfif ListLen(url.search) GT 0>

	<!-- request last address --->
	<cfset url.search = ListGetAt(url.search, ListLen(url.search))>
</cfif>



<cfset a_str_search = url.search>

<cfif NOT StructKeyExists(session, 'q_select_addressbook_lookup')>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
</cfinvoke>

<cfset session.q_select_addressbook_lookup = stReturn.q_select_contacts>

</cfif>

<cfquery name="q_select" dbtype="query" maxrows="5">
SELECT
	firstname,surname,email_prim,company
FROM
	session.q_select_addressbook_lookup
WHERE

	(UPPER(firstname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(a_str_search)#%">)

	OR

	(UPPER(surname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(a_str_search)#%">)

	OR

	(UPPER(email_prim) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(a_str_search)#%">)

	OR

	(UPPER(company) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(a_str_search)#%">)
ORDER BY
	dt_lastcontact
;
</cfquery>


<cfif q_select.recordcount is 0>

Leider konnte kein Kontakt gefunden werden.

<cfelse>


<table width="100%"  border="0" cellspacing="0" cellpadding="2">
<cfoutput query="q_select">
  <tr id="idtrsearch#q_select.currentrow#" onMouseOver="hilite(this.id);" onMouseOut="restore(this.id);">
  	<td align="right">
		<cfif q_select.currentrow IS 1>
			STRG + 1
		<cfelse>
			+ #q_select.currentrow#
		</cfif>
	</td>
    <td>
		<a href="javascript:window.alert('#jsstringformat(q_select.email_prim)#', '#url.field#');" accesskey="1"><b>#highLight(q_select.surname, url.search)#</b>, #q_select.firstname# (#q_select.email_prim#)</a>
	</td>
	<td>&nbsp;
		
	</td>
  </tr>
</cfoutput>  
</table>


</cfif>

<!---<script type="text/javascript">
<cfwddx input="#q_select#" toplevelvariable="myRecordSet" action="wddx2js">
</script>--->
<cfwddx action="cfml2js" input="#q_select#" output=abc TOPLEVELVARIABLE='q_record_set'>

<script type="text/javascript">
	function SubmitData()
		{
		var myArrayContacts = new Array(<cfoutput>#q_select.recordcount#</cfoutput>);
		
		<cfoutput query="q_select">
		myArrayContacts[#(q_select.currentrow - 1)#] = new Array('#jsstringformat(highLight(q_select.surname, url.search))#', '#jsstringformat(q_select.firstname)#', '#jsstringformat(q_select.email_prim)#');
		</cfoutput>
		
		
		parent.mylookup_contacts = myArrayContacts;
		parent.loadACData();
		}
</script>

<!---<select name="frmselect" style="width:100%;">

<cfoutput query="q_select">

<option value="#q_select.firstname#">#q_select.firstname# #q_select.surname#</option>

</cfoutput>

</select>--->

</body>

</html>

