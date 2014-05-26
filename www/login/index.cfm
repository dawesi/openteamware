<!--- //

	Module:		Framework
	Description:The login form
	
// --->

<cfif StructKeyExists(request, 'stSecurityContext')>
	<!--- forward to the startscreen --->
	<cflocation addtoken="no" url="/">
</cfif>

<cfif StructKeyExists(url, 'resetloginusername')>
  <cfset client.LastLoginUsername = "" />
</cfif>

<cfparam name="url.url" type="string" default="">
<cfparam name="url.loginfailed" type="boolean" default="false">

<cfif StructKeyExists(url, 'username') AND Len(url.username) GT 0>
	<cfset client.LastLoginUsername = url.username />
</cfif>


<html>
<head>

	<link rel="stylesheet" media="all" type="text/css" href="/assets/css/default.css">
	<link rel="stylesheet" media="print" type="text/css" href="/assets/css/print.css">		
	
	<title><cfoutput>#htmleditformat(request.appsettings.description)# #GetLangVal('lg_ph_title')#</cfoutput></title>

	<cfinclude template="/common/js/inc_js.cfm">
	
	<link rel="shortcut icon" href="/images/si/server_key.png" type="image/png" />
	
	<script type="text/javascript">
	var a_str_img = "/images/status/img_circle_loading.gif";
	image1 = new Image();
	image1.src = a_str_img;
	a_str_loading_status_img_login = '<img src="' + a_str_img + ' " />';
	</script>
	
	<style type="text/css" media="all">
	a {border-bottom:gray dashed 1px;}
	</style>
</head>

<cfif StructKeyExists(client, 'LastLoginUsername') and Len(Client.LastLoginUsername) GT 0>
  <cfset a_str_js_onload = "onload=""document.formlogin.frmpassword.focus();""">
  <cfelse>
  <cfset a_str_js_onload = "onload=""document.formlogin.frmusername.focus();""">
</cfif>

<body class="body_login" scroll=no <cfoutput>#a_str_js_onload#</cfoutput>>


<cfset a_struct_medium_logo = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'medium_logo') />

<cfset a_str_product_name = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'main').productname />


	

<form action="act_login.cfm" method="post" onsubmit="$('#id_login_img').append(a_str_loading_status_img_login);$('#frmlogin').hide();" name="formlogin" style="margin:0px;">
<input type="hidden" name="frmdomain" value="<cfoutput>#request.appsettings.properties.defaultdomain#</cfoutput>">

<!--- set forwarding target ... --->
<cfif (len(url.url) gt 0) AND (CompareNoCase(url.url, "/default.cfm") neq 0) AND (CompareNoCase(url.url, '/start/') NEQ 0)>
	<input type="Hidden" name="url" value="<cfoutput>#urlencodedformat(url.url)#</cfoutput>" />
</cfif>


<cfsavecontent variable="a_str_content">
	
	<div style="text-align:left;background-image:URL(/images/menu/img_key_login_bg.gif);background-position:right bottom;background-color:white;background-repeat:no-repeat;-moz-border-radius: 8px;">
		
		<table border="0" cellpadding="14" cellspacing="0" width="580">
		<tr>
			<td class="bb">

				<div style="float:right;width:auto;padding-top:12px">
				<a href="/rd/signup/?source=loginbox" style="font-weight:bold"><cfoutput>#GetLangVal('lg_ph_no_account_yet')#</cfoutput></a>
				</div>				

				<a href="/" class="nl"><img alt="<cfoutput>#GetLangVal('lg_ph_goto_homepage')#</cfoutput>" src="<cfoutput>#a_struct_medium_logo.path#</cfoutput>" width="<cfoutput>#a_struct_medium_logo.width#</cfoutput>" height="<cfoutput>#a_struct_medium_logo.height#</cfoutput>" hspace="12" vspace="12" border="0" align="absmiddle"></a>
			</td>
		</tr>
			<tr>
			<td valign="top">
			
			
				<div class="" style="margin-top:14px;">
				
								
				
				
				<table class="table_details table_edit_form" style="margin-left:20px">
					<tr>
						<td>
							<cfoutput>#GetLangVal('lg_ph_please_enter_your_data')#</cfoutput> 
						</td>
					</tr>
					 <cfif url.loginfailed>
					  	<tr>
							<td>
								<div class="status">
								<cfoutput>#GetLangVal('lg_ph_login_failed_please_try_again_or_subscribe')#</cfoutput>
								</div>
							</td>	
						</tr>
					 </cfif>
					<tr>
						<td>
							<div style="padding-bottom:8px;">
							<b><cfoutput>#GetLangVal("cm_wd_username")#</cfoutput></b>
							</div>
							
							<cfif StructKeyExists(client, 'LastLoginUsername') and Len(Client.LastLoginUsername) GT 0>
		                		<!--- // show last used username // --->
		                		<input type="hidden" name="frmUsername" value="<cfoutput>#htmleditformat(client.LastLoginUsername)#</cfoutput>" />
		               			<b><cfoutput>#htmleditformat(client.LastLoginUsername)#</cfoutput></b>
								<br /> 
		                		<a href="default.cfm?url=<cfoutput>#urlencodedformat(url.url)#</cfoutput>&resetloginusername=1"><cfoutput>#GetLangVal("lg_changeuser")#</cfoutput> ...</a>
		                	<cfelse>
								<input style="font-weight:bold;width:250px;" type="text" name="frmusername" size="35" maxlength="100" />
							</cfif>
							
						</td>
					</tr>
					
					<tr>
						<td>
							<div style="padding-bottom:8px;">
							<b><cfoutput>#GetLangVal("cm_wd_password")#</cfoutput></b>
							</div>
							
							<input style="font-weight:bold;width:250px;" type="password" size="35" maxlength="100" name="frmpassword" />
						</td>
					</tr>
					<tr>
						<td>
							<input type="submit" value="<cfoutput>#GetLangVal( 'cm_wd_login' )#</cfoutput>" class="btn" />
						</td>
					</tr>
				</table>
			
				</div>
				
							
			</td>
		</tr>
		<tr>
			<td class="bt">
				
				<cfif cgi.SERVER_PORT NEQ "443">
				  	<a href="https://<cfoutput>#cgi.HTTP_HOST##cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>"><cfoutput>#GetLangVal("start_ph_change_secure")#</cfoutput></a>
				  	/
				</cfif>
				
				<a href="mailto:<cfoutput>#ExtractEmailAdr( application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings( entryname = 'mail', style = '' ).FeedbackMailSender )#</cfoutput>?subject=Request%20Password"><cfoutput>#GetLangVal('lg_wd_data_forgotten')#</cfoutput></a>
				
				/
				
				<a href="/rd/about/" target="_blank"><cfoutput>#GetLangVal( 'cm_wd_about' )#</cfoutput></a>
			</td>
		</tr>
		</table>
	</div>
	
</cfsavecontent>



<table style="width:100%;height:70%;" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="middle" align="center">
		
		<div style="width:600px;">
		
			<cfoutput>#a_str_content#</cfoutput>
		</div>
		

		</td>

	</tr>

</table>

</form>

<script type="text/javascript">
	$('input').blur();
</script>

</body>

</html>