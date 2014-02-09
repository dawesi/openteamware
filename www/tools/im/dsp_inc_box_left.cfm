<!--- //

	include an instant messenger box ...
	
	// --->
	
<cfif NOT CheckSimpleLoggedIn()>
	<cfexit method="exittemplate">
</cfif>

<cfif request.stSecurityContext.myuserid neq 2>
	<cfexit method="exittemplate">
</cfif>

<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount is 0>
	<!--- no member of any workgroup ... --->
	<cfexit method="exittemplate">
</cfif>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.excludestatus = 0>
<cfinvoke component="#application.components.cmp_im#" method="GetContactlist" returnvariable="stReturn">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<!---<cfdump var="#stReturn#">--->
<cfset q_select_contact_list = stReturn.q_select_contact_list>

	
<tr class="NavLeftTableHeader">
	<td class="NavLeftTableHeaderFont"><a href="/im/" class="NavLeftTableHeaderLink"><img border="0" src="/images/nav/button_vor.gif" width="5" height="10" vspace="2" hspace="2" align="absmiddle"> Messenger</a></td>
</tr>
<tr>
	<td>
	
	</td>
</tr>

<!---<cfexit method="exittemplate">--->
<tr>

	<td>
	

	<cfif q_select_contact_list.recordcount IS 0>
		<div align="center" class="addinfotext">Niemand online.</div>
	</cfif>
	<!--- get members who are online ... --->
	<!---<cfset begin = GetTickCount()>
	<cfinvoke component="/components/im/cmp_im" method="GetOnlineWorkgroupMembers" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	</cfinvoke>
	<cfset end = GetTickCount() - begin>
	
	<cfquery name="q_select_users" dbtype="query">
	SELECT
		*
	FROM
		stReturn.q_select_users
	WHERE
		jabbersessionconnected = 1
	;
	</cfquery>
	
	<cfquery name="q_select_users_offline" dbtype="query">
	SELECT
		COUNT(userkey) AS count_offline_users
	FROM
		stReturn.q_select_users
	WHERE
		jabbersessionconnected = 0
	;
	</cfquery>--->	
	
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<cfoutput query="q_select_contact_list">
	  <tr>
	  	<td>
		<!---<cfif q_select_users.lastcontactminutes LTE 7>
			<cfset a_str_color = "green">
		<cfelseif stReturn.q_select_users.lastcontactminutes LTE 30>
			<cfset a_str_color = "orange">
		<cfelse>
			<cfset a_str_color = "red">
		</cfif>--->
		<span style="background-color:green;height:6px;width:6px;"><img src="/images/space_1_1.gif" width="1" height="1"></span></td>
		<td>
		<a title="IM senden" href="javascript:SendInstantMessage('#jsstringformat(q_select_contact_list.jid)#');">#htmleditformat(q_select_contact_list.nick)#</a>
		</td>
		<!---<td>
		<a href="/workgroups/default.cfm?action=showuser&entrykey=#urlencodedformat(q_select_users.userkey)#"><img src="/images/info.jpg" align="absmiddle" vspace="2" hspace="2" border="0"></a>
		</td>
		<td>
		<a href="/email/default.cfm?action=composemail&to=#urlencodedformat(q_select_users.username)#"><img alt="E-Mail senden" src="/images/icon/letter_yellow.gif" width="12" height="12" hspace="0" vspace="0" border="0" align="absmiddle"></a>
		</td>--->
	  </tr>
	</cfoutput>
	  <!---<tr>
	  	<td>&nbsp;</td>
		<td colspan="3" class="addinfotext">
		<cfoutput>#q_select_users_offline.count_offline_users#</cfoutput> offline [ anzeigen ]
		</td>
	  </tr>--->
	</table>


	
	</td>
</tr>

<!---
<script type="text/javascript">
	var myimwindow;
	var leftpos = (screen.availWidth - 200)-40;
	resiz = (navigator.appName=="Netscape") ? 0 : 1;
	myimwindow = window.open("/im/newchatrequest.cfm?", "immessager","width=158,height=446,top=40,left="+leftpos+",directories=no,location=no,menubar=no,scroll=no,status=no,titlebar=no,toolbar=no,resizable="+resiz+"");
	myimwindow.focus();
</script>
--->