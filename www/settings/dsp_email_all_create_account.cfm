<!--- checks durchf&uuml;hren --->



<cfset AConfirmCode = "">

	

	<cfloop index="ii" from="1" to="11" step="1">

		<cfset i = RandRange(97, 122)>

		<cfset AConfirmCode = AConfirmCode&#Chr(i)#>

	</cfloop>

	

<cfif IsDefined("form.frmDeleteMsgOnServer")>

	<cfset ADelMsgOnServer = 1>

<cfelse>

	<cfset ADelMsgOnServer = 0>

</cfif>



<cfquery name="q_insert" datasource="inboxccusers" dbtype="ODBC">

set nocount on ;

insert into pop3_data

(userid,emailadr,pop3server,pop3username,pop3password,deletemsgonserver,confirmed,confirmcode)

values

(#request.stSecurityContext.myuserid#,'#form.frmEmailadr#','#form.frmServer#','#form.frmUsername#','#form.frmPassword#',#ADelMsgOnServer#,-1,'#AConfirmCode#');

select @@identity as max_id;

</cfquery>



<!--- id holen --->

	

<!--- email mit der best&auml;tigung usw schicken --->

<cfmodule template="mod_send_email_confirm.cfm" id=#val(q_insert.max_id)# userid=#request.stSecurityContext.myuserid# username=#request.stSecurityContext.myuserid#>



<!--- weiterleiten --->

<cflocation addtoken="No" url="index.cfm?action=ExternalEmail">