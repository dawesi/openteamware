<!--- save meeting members ... --->

<cfparam name="form.frmcbentrykey" type="string" default="">

<cfdump var="#form#">

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset q_select_contacts = stReturn_contacts.q_select_contacts>

<!--- update data ... --->


<!--- renew output window ... --->



<!--- close window ... --->

<html>
	<head>
	<script type="text/javascript">
		function SetNewValues()
		{
		opener.RemoveAllAssignedContacts();
		opener.RemoveAllAssignedContacts();
		
		<cfloop list="#form.FRMCBENTRYKEY#" index="sEntrykey">
		
			<!--- load name ... --->
			<cfquery name="q_select_contact_name" dbtype="query">
			SELECT
				firstname,surname,b_zipcode
			FROM
				q_select_contacts
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
			;
			</cfquery>
			
			<cfset a_str_name = q_select_contact_name.surname & ', ' & q_select_contact_name.firstname>
			
			opener.SetAssignedContact('<cfoutput>#jsstringformat(a_str_name)#</cfoutput>','<cfoutput>#jsstringformat(sEntrykey)#</cfoutput>');
		</cfloop>
		}
		</script>
	</head>
<body onLoad="SetNewValues();window.close();">

</body>
</html>