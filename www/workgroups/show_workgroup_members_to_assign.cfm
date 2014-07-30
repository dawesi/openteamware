<cfinclude template="../login/check_logged_in.cfm">

<!--- //

	a task has to be assigend to a member ...
	
	show all members of the current workgroup
	and return with a standard javascript function

	// --->

<cfparam name="url.workgroupkey" type="string" default="">

<html>
<head>
<cfinclude template="../style_sheet.cfm">
<title>Select ...</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginwidth="0" marginheight="0" >

<cfif Len(url.workgroupkey) is 0>
	You haven't selected a workgroup!
	<cfabort>
</cfif>

<script type="text/javascript">
	function setwgusername(username)
		{
		window.opener.setworkgroupusername(username);
		window.close();
		}
</script>

<cfinvoke component="/components/workgroups/tools" method="IsMemberOfWorkgroup" returnvariable="a_bol_is_member">
	<cfinvokeargument name="userid" value="#request.stSecurityContext.myuserid#">
	<cfinvokeargument name="workgroupkey" value="#url.workgroupkey#">
</cfinvoke>

<cfif a_bol_is_member is false>
	<cfabort>
</cfif>

<cfquery debug="yes" name="q_select_workgroup_members">
SELECT
	workgroup_members.username,users.surname,users.firstname
FROM
	workgroup_members
JOIN
	users ON (users.userid = workgroup_members.userid)
WHERE (workgroup = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.workgroup_id#">)
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td colspan="2"><b>Mitglieder dieser Arbeitsgruppe</b></td>
  </tr>
  <cfoutput query="q_select_workgroup_members">
  <tr>
    <td>#q_select_workgroup_members.firstname# #q_select_workgroup_members.surname#</td>
    <td><a class="simplelink" href="javascript:setwgusername('#jsstringformat(q_select_workgroup_members.username)#');">#q_select_workgroup_members.username#</a></td>
  </tr>
  </cfoutput>
</table>



</body>
</html>
