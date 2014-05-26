
<cfset a_cmp_user = application.components.cmp_user> 
<cfset a_cmp_customize = application.components.cmp_customize />
<cfset a_cmp_load_userdata = CreateObject('component', '/components/management/users/cmp_load_userdata')>
<cfset a_cmp_content = application.components.cmp_content>

<!--- create language comp --->
<cfset a_cmp_translation = application.components.cmp_lang />

<cfloop query="q_select_article_watchers">

<cfset stUserSettings = a_cmp_user.GetUsersettings(userkey = q_select_article_watchers.userkey)>
<cfset a_struct_userdata = a_cmp_load_userdata.LoadUserData(entrykey = q_select_article_watchers.userkey)>
<cfset q_select_user = a_struct_userdata.query>
<cfset iLangNo = a_struct_userdata.query.defaultlanguage>

<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleData(usersettings = stUserSettings, entryname = 'mail').FeedbackMailSender>
<cfset a_str_base_url = a_cmp_customize.GetCustomStyleData(usersettings = stUserSettings, entryname = 'main').BaseURL>
<cfset a_str_product_name = a_cmp_customize.GetCustomStyleData(usersettings = stUserSettings, entryname = 'main').Productname>

<cfmail from="#a_str_sender_address#" to="#a_cmp_user.getusernamebyentrykey(q_select_article_watchers.userkey)#" subject="Neuer Beitrag im Forum">
A new posting has been added - please click here:
https://#a_str_base_url#/forum/index.cfm?action=ShowThread&entrykey=#arguments.threadkey#
</cfmail>

<!---No more alerts for this thread.--->

</cfloop>