
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.resourceskeys" type="string" default="">

<cfset a_str_workgroup_keys = ValueList(request.stSecurityContext.q_select_workgroup_permissions.workgroup_key)>

<cfinvoke component="/components/tools/cmp_resources" method="GetResources" returnvariable="q_select_resources">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	<cfinvokeargument name="workgroupkeys" value="#a_str_workgroup_keys#">
</cfinvoke>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<form action="save_useresources.cfm" method="post">

<cfdump var="#q_select_resources#">

</form>
</body>
</html>
