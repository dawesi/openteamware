
<cfif StructKeyExists(variables, 'stReturn')>
<cfdump var="#stReturn.Q_SELECT_ASSIGNED_CONTACTS#">
</cfif>
<!---
<div id="iddivworkgroups" style="display:none;width:100%;height:80px;" class="b_all">
	<iframe id="idiframeworkgroups" name="idiframeworkgroups" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%" src="/tools/security/permissions/iframe/?servicekey=<cfoutput>#urlencodedformat(request.sCurrentServiceKey)#</cfoutput>&sectionkey=&entrykey=<cfoutput>#urlencodedformat(EditOrCreateContact.query.entrykey)#</cfoutput>"></iframe>
</div>
--->