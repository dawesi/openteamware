<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfset a_bol_history_go_back = false>
<cfset a_str_history_url = ''>

<!--- the random number given by the smartload javascript

	if this number already exists, the user has clicked on the back button --->
<cfparam name="url.r" type="string" default="">

<!--- the target page --->
<cfparam name="url.target" type="string" default="">

<cfif NOT StructKeyExists(session, 'a_arr_smartload_urls')>
	<cfset session.a_arr_smartload_urls = ArrayNew(1)>
</cfif>

<cfset a_struct_history = StructNew()>
<cfset a_struct_history.url = url.target>
<cfset a_struct_history.r = url.r>

<cfloop from="1" to="#ArrayLen(session.a_arr_smartload_urls)#" index="ii">
	<cfif CompareNoCase(session.a_arr_smartload_urls[ii].r, url.r) IS 0>
		<cfset a_bol_history_go_back = true>
		<cfset a_str_history_url = session.a_arr_smartload_urls[ii].url>
		
		<cfset a_str_history_url = ReplaceNoCase(a_str_history_url, 'smartload=1', 'smartload=0')>
	</cfif>
</cfloop>

<cfset tmp = ArrayPrepend(session.a_arr_smartload_urls, a_struct_history)>

<html>
	<head>
			<script type="text/javascript">
				function SayHello()
					{
					//alert('123');
					<cfif a_bol_history_go_back>
					//alert('go back in history');
					parent.window.location.href = '<cfoutput>#jsstringformat(a_str_history_url)#</cfoutput>';
					</cfif>
					}
			</script>
			<title></title>
	</head>
<body onLoad="SayHello();">
	
	
</body>
</html>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="123" type="html">
	<cfdump var="#url#">
	<cfdump var="#session.a_arr_smartload_urls#">
</cfmail>--->