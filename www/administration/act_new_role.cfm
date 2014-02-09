

<cfdump var="#form#">


<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="CreateWorkgroupRole" returnvariable="a_struct_create_role_return">
	<cfinvokeargument name="workgroupkey" value="#form.frmworkgroupkey#">
	<cfinvokeargument name="rolename" value="#form.frmname#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="standardtype" value="0">
</cfinvoke>