<!--- // save signature // --->

<cfquery name="q_update" datasource="inboxccusers" dbtype="ODBC">
UPDATE pop3_data
SET signature = '#form.frmSignature#'
WHERE userid = #request.stSecurityContext.myuserid#
AND id = #val(form.frmaccountid)#;
</cfquery>

<!--- forward --->
<cflocation addtoken="No" url="index.cfm?action=Signatures&accountid=#val(form.frmAccountid)#">