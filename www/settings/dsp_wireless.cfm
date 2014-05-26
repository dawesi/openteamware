<cf_disp_navigation mytextleft="Wireless">
<br>

<!--- die column "wireless status regelt die inkludierung eines mobile phones 

	0 ... keine angaben, noch nichts gemacht
	1 ... freigeschalten f&uuml;r eine bestimmte rufnummer
	-1 ... freischaltprozess aktiv, aber noch keine best&auml;tigung der nummer

--->
<cfquery name="q_select_status" datasource="inboxccusers">
SELECT
	wirelessstatus,mobilenr
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cfif q_select_status.wirelessstatus is 1>
	<cfoutput>#GetLangVal('prf_ph_wireless_already_confirmed')#</cfoutput> (<cfoutput>#q_select_status.mobilenr#</cfoutput>).
	<br><br>
	<a onClick="return confirm('<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>');" href="act_reset_mobile_nr.cfm"><cfoutput>#GetLangVal('prf_ph_wireless_confirm_again')#</cfoutput></a>
	<br><br>
	<a href="/tools/points/"><cfoutput>#GetLangVal('nav_ph_accountpoints')#</cfoutput></a>
	<br><br>
	<a href="/administration/?action=shop" target="_blank"><cfoutput>#GetLangVal('acc_ph_buy_points')#</cfoutput></a>
<cfelse>
	<script>
		function OpenAssistent()
		{
		window.open('/assistants/mobile/includemobile/index.cfm','newgroup','toolbar=no,location=no,directories=no,status=no,copyhistory=no,scrollbars=yes,resizable=yes,height=360,width=500');
		}
	</script> 
	
	<a href="javascript:OpenAssistent();"><cfoutput>#GetLangVal('prf_ph_wireless_start_assistant')#</cfoutput></a>
</cfif>


<!---
<br><br><br><br>
Aktuell eingesetztes Mobiltelefon: (unbekannt) [ <img src="/images/editicon.gif" align="absmiddle" vspace="4" hspace="4" border="0"> <cfoutput>#GetLangVal('cm_wd_edit')#</cfoutput> ]


<cfquery name="q_select_mobiles" datasource="#request.a_str_db_tools#">
SELECT
	*
FROM
	syncml_compatible_devices 
ORDER BY
	manufactor,device_name
;
</cfquery>


<select name="frmmobiledevice">
	<cfoutput query="q_select_mobiles">
		<option value="#q_select_mobiles.entrykey#">#q_select_mobiles.manufactor# - #q_select_mobiles.device_name#</option>
	</cfoutput>
</select>--->