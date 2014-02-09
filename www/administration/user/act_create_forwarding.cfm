
<cfparam name="form.frmleavecopy" type="numeric" default="0">


<cfif Len(ExtractEmailAdr(form.frmdestinationaddress)) IS 0>
	<cfoutput>#GetLangVal('adm_ph_forwarding_invalid_adr')#</cfoutput>
	
	<br><br><br>
	
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>


<cfinvoke component="/components/email/cmp_accounts" method="UpdateForwarding" returnvariable="a_bol_return">
	<cfinvokeargument name="source" value="#form.frmusername#">
	<cfinvokeargument name="destination" value="#form.frmdestinationaddress#">
	<cfinvokeargument name="leavecopy" value="#form.frmleavecopy#">
</cfinvoke>

<h4><cfoutput>#GetLangVal('adm_ph_forwarding_saved')#</cfoutput></h4>
<br>
<a href="<cfoutput>#ReturnRedirectURL()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>