<!DOCTYPE html>

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

	<link rel="stylesheet" media="all" type="text/css" href="/assets/css/bootstrap.min.css">
	<link rel="stylesheet" media="all" type="text/css" href="/assets/css/default.css">

	<title><cfoutput>#htmleditformat(request.appsettings.description)# #GetLangVal('lg_ph_title')#</cfoutput></title>

	<cfinclude template="/common/js/inc_js.cfm">

	<style type="text/css" media="all">
		body {
			background-color:#f2f2f2 !important;
		}
	</style>
</head>

<cfif StructKeyExists(client, 'LastLoginUsername') and Len(Client.LastLoginUsername) GT 0>
  <cfset a_str_js_onload = "onload=""document.formlogin.frmpassword.focus();""">
  <cfelse>
  <cfset a_str_js_onload = "onload=""document.formlogin.frmusername.focus();""">
</cfif>

<body <cfoutput>#a_str_js_onload#</cfoutput>>

<cfset a_struct_medium_logo = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'medium_logo') />
<cfset a_str_product_name = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'main').productname />

<form action="act_login.cfm" method="post" onsubmit="$('#id_login_img').append(a_str_loading_status_img_login);$('#frmlogin').hide();" name="formlogin" style="margin:0px;">
<input type="hidden" name="frmdomain" value="<cfoutput>#request.appsettings.properties.defaultdomain#</cfoutput>">

<!--- set forwarding target ... --->
<cfif (len(url.url) gt 0) AND (CompareNoCase(url.url, "/index.cfm") neq 0) AND (CompareNoCase(url.url, '/crm/') NEQ 0)>
	<input type="Hidden" name="url" value="<cfoutput>#urlencodedformat(url.url)#</cfoutput>" />
</cfif>


<div>
<div class="panel panel-default" style="margin-top:120px;width:600px;margin-left: auto; margin-right: auto;border:1px solid #3276b1">
  <div class="panel-heading" style="background-color:#3276b1;color:white;text-transform:uppercase;padding:18px">
    <h3 class="panel-title">
		<cfoutput>#htmleditformat(request.appsettings.description)# #GetLangVal('lg_ph_title')#</cfoutput>
	</h3>
  </div>
<div class="panel-body">


		<table class="table table_details table_edit_form" style="margin-left:20px">
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
		                		<a href="index.cfm?url=<cfoutput>#urlencodedformat(url.url)#</cfoutput>&resetloginusername=1"><cfoutput>#GetLangVal("lg_changeuser")#</cfoutput> ...</a>
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
							<input type="submit" value="<cfoutput>#GetLangVal( 'cm_wd_login' )#</cfoutput>" class="btn btn-success" />
						</td>
					</tr>
				</table>


  </div>
	<div class="panel-footer">
		&copy; 2014 otw - Find us on <a href="https://github.com/funkymusic/openteamware">github</a>
	</div>
</div>
</div>
</form>

<script type="text/javascript">
	$('input').blur();
</script>

</body>

</html>