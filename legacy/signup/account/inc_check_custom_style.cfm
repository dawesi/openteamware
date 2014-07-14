<cfset a_cmp_customize = application.components.cmp_customize />
<cfset a_struct_administration = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'administration')>
<cfset a_str_default_partner_key = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'main').DefaultPartnerKey>
<cfset a_str_email_feedback = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'mail').FeedbackMailSender>
