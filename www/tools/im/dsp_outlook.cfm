<!--- //

	include an instant messenger box ...
	
	// --->
	
<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount is 0>
	<!--- no member of any workgroup ... --->
	<cfexit method="exittemplate">
</cfif>

<cfexit method="exittemplate">

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.excludestatus = 0>
<cfinvoke component="#application.components.cmp_im#" method="GetContactlist" returnvariable="stReturn">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td class="b_all" style="letter-spacing:2px;font-size:10px;text-transform:uppercase;">
	&nbsp;<b><img src="/images/icon/icon_star.gif" width="12" height="12" align="absmiddle" hspace="3" vspace="3" border="0"> Messenger</b>
	</td>
  </tr>
  <tr>
	<td>

		<table width="100%" border="0" cellpadding="4" cellspacing="0" style="margin-left:20px;">
		<tr>
			<td>
			
			<!--- get members who are online ... --->
			<cfset begin = GetTickCount()>
			<cfinvoke component="/components/im/cmp_im" method="GetOnlineWorkgroupMembers" returnvariable="stReturn">
				<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			</cfinvoke>
			<cfset end = GetTickCount() - begin>
			
			<cfset q_select_users = stReturn.q_select_users>
			
			<cfquery name="q_select_users_offline" dbtype="query">
			SELECT
				*
			FROM
				q_select_users
			WHERE
				JABBERSESSIONCONNECTED = 0
			;
			</cfquery>
			
			<cfquery name="q_select_users_online" dbtype="query">
			SELECT
				*
			FROM
				q_select_users
			WHERE
				JABBERSESSIONCONNECTED = 1
			;
			</cfquery>	
			
			<cfset q_select_users = q_select_users_online>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<cfoutput query="q_select_users">
			  <tr>
				<td>
				<cfif q_select_users.lastcontactminutes LTE 7>
					<cfset a_str_color = "green">
				<cfelseif q_select_users.lastcontactminutes LTE 30>
					<cfset a_str_color = "orange">
				<cfelse>
					<cfset a_str_color = "red">
				</cfif>
				<span style="background-color:#a_str_color#;height:6px;width:6px;"><img src="/images/space_1_1.gif" width="1" height="1"></span></td>
				<td>
				<a title="IM senden" href="javascript:SendInstantMessage('#jsstringformat(q_select_users.userkey)#');">#htmleditformat(q_select_users.fullname)#</a>
				</td>
				<td>
				<a href="/workgroups/default.cfm?action=showuser&entrykey=#urlencodedformat(q_select_users.userkey)#"><img src="/images/info.jpg" align="absmiddle" vspace="2" hspace="2" border="0"></a>
				</td>
				<td>
				<a href="/email/default.cfm?action=composemail&to=#urlencodedformat(q_select_users.username)#"><img alt="E-Mail senden" src="/images/icon/letter_yellow.gif" width="12" height="12" hspace="0" vspace="0" border="0" align="absmiddle"></a>
				</td>
			  </tr>
			</cfoutput>
			
			<cfif q_select_users_offline.recordcount GT 0>
			<tr>
				<td colspan="4" class="addinfotext">
				<cfoutput>#q_select_users_offline.recordcount#</cfoutput> offline
				</td>
			</tr>
			</cfif>
			
			 <!--- <tr>
				<td>&nbsp;</td>
				<td colspan="3">
				<a href="/workgroups/">weitere Mitglieder ...</a>
				</td>
			  </tr>--->
			</table>
		
		
			
			</td>
		</tr>
		</table>
<!---
<script type="text/javascript">
	var myimwindow;
	var leftpos = (screen.availWidth - 200)-40;
	resiz = (navigator.appName=="Netscape") ? 0 : 1;
	myimwindow = window.open("/im/newchatrequest.cfm?", "immessager","width=158,height=446,top=40,left="+leftpos+",directories=no,location=no,menubar=no,scroll=no,status=no,titlebar=no,toolbar=no,resizable="+resiz+"");
	myimwindow.focus();
</script>
--->


		
	</td>	
  </tr>
 </table>