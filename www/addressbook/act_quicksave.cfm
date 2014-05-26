<!--- eintraege einfueen --->

<cfset ARecordsInserted = 0>



<cfloop index="ii" from="1" to="50">



	<cfif IsDefined("check_"&#ii#) is true>	

		<!--- adresse gefunden ... --->

		<cfset ARecordsInserted = ARecordsInserted + 1>

		

		<cfset AEmail = urldecode(Evaluate("email_"&#ii#))>
		<cfset AFirstname = Evaluate("frmfirstname_"&ii)>
		<cfset ASurname = Evaluate("frmSurname_"&ii)>
		<cfset ACompany = Evaluate("frmCompany_"&ii)>		

		<!--- einfuegen ---->

		<cfset QuickAddRequest.firstname = AFirstname>
		<cfset QuickAddRequest.surname = ASurname>
		<cfset QuickAddRequest.email_prim = AEmail>
		<cfset QuickAddRequest.company = ACompany>



		<!--- query --->
		<!--- create item ... --->
		userid,groupname,firstname,surname,email_prim,company
		
		<cfset sEntrykey = CreateUUID()>
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
			<cfinvokeargument name="entrykey" value="#sEntrykey#">
			<cfinvokeargument name="firstname" value="#QuickAddRequest.firstname#">
			<cfinvokeargument name="surname" value="#QuickAddRequest.surname#">
			<cfinvokeargument name="company" value="#QuickAddRequest.company#">
			<cfinvokeargument name="email_prim" value="#QuickAddRequest.email_prim#">
		</cfinvoke>		

		<!--- // activate remote edit? --->

		<cfif IsDefined("form.frmRemoteEdit_"&ii)>
		
				<cfinvoke component="#application.components.cmp_addressbook#" method="ActivateRemoteEdit" returnvariable="stReturn">
					<cfinvokeargument name="entrykey" value="#sEntrykey#">
					<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
					<cfinvokeargument name="usersettings" value="#request.stUserSettings#">		
				</cfinvoke>

		</cfif>

	</cfif>



</cfloop>



<!--- umleiten ... ---->

<cfif ARecordsInserted is 1>

	<!--- den neuen record anzeigen ... --->

	<cflocation addtoken="No" url="index.cfm?action=ShowItem&entrykey=#urlencodedformat(sEntrykey)#">

<cfelse>

	<!--- mehr als ein record eingefuegt ... zur uebersicht --->

	<cflocation url="index.cfm" addtoken="No">

</cfif>