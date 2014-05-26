<!--- check if we've sent this alert already three times this day --->

<cfset a_str_page = DateFormat(Now(), 'yyyymmdd')&'_'&securitycontext.myuserkey>

<cfmodule template="/common/person/howoftenseen.cfm"
	userid = 0
	section="automails.alert.notenoughpoints"
	page="#a_str_page#">
	
<cfif PersonTimesSeen GT 3>
	<cfexit method="exittemplate">
</cfif>

<!--- lookup username ... --->

<cfset a_str_username = application.components.cmp_user.GetUsernamebyentrykey(securitycontext.myuserkey)>

<cftry>
<cfmail from="feedback@openTeamWare.com" bcc="#request.appsettings.properties.NotifyEmail#" to="#a_str_username#" subject="Bitte laden Sie Ihr Punktekonto auf">
Leider konnte ein SMS/Fax/iLetter Versandauftrag nicht ausgefuehrt werden, da
Ihr Punktekonto einen zu niedrigen Stand aufweist.

Bitte klicken Sie hier um im openTeamWare Shop Punkte nachzukaufen:

https://www.openTeamWare.com/administration/index.cfm?action=shop

Einen schoenen Tag wuenscht

das openTeamWare.com Team (feedback@openTeamWare.com)</cfmail>

<cfcatch type="any">
	
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="error on points alert sent" type="html">
		<cfdump var="#cfcatch#">
		<cfdump var="#arguments#">
	</cfmail>

</cfcatch></cftry>