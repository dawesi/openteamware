<!--- //

	Module:		E-Mail
	Action:		autoanswer
	Description: 
	

// --->
<cfparam name="url.subaction" default="">

<!--- // autoresponder settings // --->
<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_ph_autoanswer')) />

<cfswitch expression="#url.subaction#">

  <cfcase value="edit">
  <!-- eintrag editieren --->
  <cfparam name="url.id" type="numeric" default="0">
 
  <cfquery name="q_select_msg" datasource="#request.a_str_db_users#">
  SELECT
  		awaymsg,emailadr,SendAwayMsg
  FROM
  		pop3_data
  WHERE
  	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
  	AND
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
  ;
  </cfquery>
  <form action="default.cfm" method="get">
    <input type="Hidden" name="action" value="AutoAnswer">
    <input type="Hidden" name="subaction" value="setautoanswer">
    <input type="Hidden" name="id" value="<cfoutput>#val(url.id)#</cfoutput>">
    <b><cfoutput>#GetLangVal('mail_ph_email_address')#</cfoutput>: <cfoutput>#q_select_msg.emailadr#</cfoutput></b> <br />
    <table>
      <tr> 
        <td colspan="2"> <textarea wrap="hard" name="AwayMsg" rows="7" cols="50"><cfoutput>#trim(q_select_msg.awaymsg)#</cfoutput></textarea> 
        </td>
      </tr>
      <tr> 
        <td> <cfoutput>#GetLangVal('cm_wd_status')#</cfoutput>: 
          <select name="SendAwayMsg">
            <option value="1" <cfoutput>#WriteSelectedElement(q_select_msg.SendAwayMsg, 1)#</cfoutput>> <cfoutput>#GetLangVal('mail_wd_autoresponse_active')#</cfoutput>
            <option value="0" <cfoutput>#WriteSelectedElement(q_select_msg.SendAwayMsg, 0)#</cfoutput>> <cfoutput>#GetLangVal('mail_wd_autoresponse_inactive')#</cfoutput> 
          </select> </td>
        <td align="right"><input type="Submit" name="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
      </tr>
    </table>
  </form>
  <br />
  </cfcase>
  <cfcase value="reset">
  <!--- zur�cksetzen auf nein und nix --->
  <cfquery name="q_update" datasource="inboxccusers" dbtype="ODBC">
  update pop3_data set AwayMsg = '', SendAwayMsg = 0 where (userid = 
  <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
  ) and (id = 
  <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
  ) 
  </cfquery>
  <p><img src="/images/info.jpg" hspace="2" vspace="2" border="0" align="absmiddle" alt=""> <cfoutput>#GetLangVal('mail_ph_autoresponse_item_updated')#</cfoutput></p>
  </cfcase>
  <cfcase value="setstatus">
  <!--- (de)aktivieren --->
  <cfparam name="url.id" default="0" type="numeric">
  <cfparam name="url.value" default="0" type="numeric">
  <cfquery name="q_update" datasource="inboxccusers" dbtype="ODBC">
  update pop3_data set SendAwayMsg = 
  <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(url.value)#">
  where (userid = 
  <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
  ) and (id = 
  <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
  ) 
  </cfquery>
  <p><img src="/images/info.jpg" hspace="2" vspace="2" border="0" align="absmiddle" alt=""> <cfoutput>#GetLangVal('mail_ph_autoresponse_item_updated')#</cfoutput></p>
  </cfcase>
  <cfcase value="setautoanswer">
  <!--- antwortverhalten setzen --->
  <cfparam name="url.awaymsg" type="string" default="">
  <cfparam name="url.id" default="0" type="numeric">
  <cfquery name="q_update" datasource="inboxccusers" dbtype="ODBC">
  update pop3_data set AwayMsg = 
  <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.AwayMsg#">
  , SendAwayMsg = #val(url.SendAwayMsg)# where (userid = 
  <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
  ) and (id = 
  <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
  ) 
  </cfquery>
  <p><img src="/images/info.jpg" hspace="2" vspace="2" border="0" align="absmiddle" alt=""> <cfoutput>#GetLangVal('mail_ph_autoresponse_item_updated')#</cfoutput></p>
  </cfcase>
</cfswitch>
<!--- auto-answer sind in pop3_data gespeichert --->
<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>
<table class="table_overview">
  <tr class="tbl_overview_header"> 
    <td>
		<cfoutput>#GetLangVal('mail_ph_email_address')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('mail_wd_autoresponder_activated')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
	</td>
  </tr>
  <cfoutput query="q_select"> 
    <tr> 
      <td style="font-weight:bold;">
			<img src="/images/si/email.png" class="si_img" /> #htmleditformat(q_select.emailadr)#
      </td>
      <td> 
	  
        <cfif Len(q_select.SendAwayMsg) IS 0>
          <cfset ASendAwayMsg = 0>
        <cfelse>
          <cfset ASendAwayMsg = q_select.SendAwayMsg>
        </cfif>
		
		<cfif ASendAwayMsg is 0>
          #GetLangVal('cm_wd_no')# [<a href="default.cfm?action=AutoAnswer&subaction=setstatus&id=#q_select.id#&value=1">#GetLangVal('mail_wd_autoresponder_activate')#</a>] 
          <cfelse>
          #GetLangVal('cm_wd_yes')# [<a href="default.cfm?action=AutoAnswer&subaction=setstatus&id=#q_select.id#&value=0">#GetLangVal('mail_wd_autoresponder_deactivate')#</a>] 
        </cfif> </td>
      <td valign="middle" class="bt">
	  
	  	[ <a href="default.cfm?action=AutoAnswer&subaction=reset&id=#q_select.id#">#GetLangVal('cm_wd_reset')#</a> ]
		
		[<a href="default.cfm?action=AutoAnswer&subaction=edit&id=#q_select.id#"><img src="/images/si/pencil.png" class="si_img" />#GetLangVal('cm_wd_edit')#</a> ]
		</td>
    </tr>
    <tr> 
      <td colspan="3" style="color:##004080;padding:5px;"> <cfset amsg = q_select.awaymsg> 
        <cfset amsg = replacenocase(amsg, chr(13), "<br />", "ALL")> #amsg# &nbsp; </td>
    </tr></tr>
  </cfoutput> 
</table>
<br />
<cfoutput>#GetLangVal('mail_ph_autoanswer_standardtext')#</cfoutput>


