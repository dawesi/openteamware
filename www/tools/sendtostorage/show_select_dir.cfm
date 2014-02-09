<cfparam name="url.username" type="string" default="">
<cfparam name="url.password" type="string" default="">

<cfinclude template="/common/scripts/script_utils.cfm">

<cfset a_cmp_check_login = CreateObject('component', '/components/management/users/cmp_check_login')>

<cfset a_struct_check_login = a_cmp_check_login.CheckLogin(username = url.username, password = url.password)>

<cfif a_struct_check_login.ok NEQ 'YES'>
	<h4>Access forbiden.</h4>
	<cfabort>
</cfif>

<cfset a_str_userkey = a_struct_check_login.entrykey>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>

<cfset variables.stSecurityContext = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>

<cfset variables.stUserSettings = a_struct_settings>

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetDirectoryStructure"   
	returnVariable = "a_struct_dirs"   
	securitycontext="#variables.stSecurityContext#"
	usersettings="#variables.stUserSettings#">
</cfinvoke>

	<cfset a_arr_dirs=ArrayNew(1)>
	<cfset a_struct_hint=Structnew()>
	
	<cfset sDirectorykey=a_struct_dirs.rootdirectorykey>
	<cfset a_struct_hint.directorykey = sDirectorykey>
	
	<cfset a_struct_hint.counter = 0>
	
	<cfset tmp=ArrayAppend(a_arr_dirs,a_struct_hint)>
	
<html>
<head>
<title>Untitled Document</title>
	<style type="text/css">
		body,a,td,div {font-family:Tahoma,Arial;font-size:12px;}
		a {color:black;text-decoration:none;}
		a:hover {color:#006699;font-weight:bold;}
		div.div_dir {background-color:white;}
	</style>
	<script type="text/javascript">
		function SelectDir(d)
			{
			location.href = 'selectdir://' + d;
			}
	</script>
</head>

<body style="margin:0px;padding:4px; ">



<cfloop  condition="arraylen(a_arr_dirs) gt 0 ">
	
	<cfset a_current_hint = a_arr_dirs[arraylen(a_arr_dirs)]>
	<cfset sDirectorykey = a_current_hint.directorykey>
	
	<cfif a_current_hint.counter lte 0>
		
			<cfset a_int_padding_left = arraylen(a_arr_dirs) * 30>
			
			<cfset a_str_dir = ''>
			
			<cfset q_select_path = application.components.cmp_storage.GeneratePathInformation(directorykey = sDirectorykey)>
						
			<cfloop query="q_select_path">
				<cfset a_str_dir = ListPrepend(a_str_dir, q_select_path.directoryname, '/')>
			</cfloop>
			
			<cfif Len(a_str_dir) GT 1>
				<cfset a_str_dir = a_str_dir & '/'>
			</cfif>
			
			<cfset a_str_dir = ReplaceNoCase(a_str_dir, '//', '/', 'ALL')>
			
			<cfoutput>
			
			<div class="div_dir" style="padding-left:#a_int_padding_left#px;padding-top:3px; ">
				<a href="javascript:SelectDir('#jsstringformat(a_str_dir)#');"><img align="absmiddle" vspace="4" hspace="4 "alt="folder" width="15" height="13" src="/storage/images/smallfolder.gif" border="0"> #htmleditformat(a_struct_dirs.directories[sDirectorykey].name)#</a>
			</div>
			

			</cfoutput>

		</cfif>
		<cfif ArrayLen(a_struct_dirs.directories[sDirectorykey].subdirectories) gt a_current_hint.counter >
			<cfset a_current_hint.counter = a_current_hint.counter + 1 >
			<cfset a_struct_hint = StructNew () >
			<cfset sDirectorykey = a_struct_dirs.directories[sDirectorykey].subdirectories[a_current_hint.counter]>
			<cfset a_struct_hint.directorykey = sDirectorykey>
			<cfset a_struct_hint.counter = 0 >
			<cfset tmp=ArrayAppend(a_arr_dirs,a_struct_hint)>
		<cfelse>
			<cfset tmp=ArrayDeleteAt (a_arr_dirs,ArrayLen(a_arr_dirs))>
		</cfif>
	</cfloop>

</body>
</html>