<cfparam name="form.frmcbworkgroups" type="string" default="">
<cfparam name="form.frmservicekey" type="string" default="">
<cfparam name="form.frmsectionkey" type="string" default="">
<cfparam name="form.frmentrykey" type="string" default="">
<cfparam name="form.frm_all_workgroup_keys" type="string" default="">

<cfparam name="form.frmentrykey" type="string" default="">


<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onLoad="ReloadAndClose();">

<!--- frm_all_workgroup_keys holds all displayed workgroup keys ... remove them from share (allow to re-create them) --->

<cfloop list="#form.frm_all_workgroup_keys#" delimiters="," index="a_str_workgroupkey">

	<cfinvoke component="#application.components.cmp_security#" method="RemoveWorkgroupShare" returnvariable="a_bol_return">
		<cfinvokeargument name="servicekey" value="#form.frmservicekey#">
		<cfinvokeargument name="workgroupkey" value="#a_str_workgroupkey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	</cfinvoke>

</cfloop>


<cfloop list="#form.frmcbworkgroups#" delimiters="," index="a_str_workgroupkey">
	
	<cfinvoke component="#application.components.cmp_security#" method="CreateWorkgroupShare" returnvariable="a_bol_return">
		<cfinvokeargument name="servicekey" value="#form.frmservicekey#">
		<cfinvokeargument name="workgroupkey" value="#a_str_workgroupkey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	</cfinvoke>
	
</cfloop>

<script type="text/javascript">
	function ReloadAndClose()
		{
		var obj1,obj2;
		
		obj1 = opener;
		
		if (obj1 !== null)
			{
			// window is still open
			obj2 = opener.idiframeworkgroups;
			
			if (obj2 !== null)
				{
				
				obj2.location.reload();			
				}
			}		
		
		window.close();
		}
</script>

</body>
</html>
