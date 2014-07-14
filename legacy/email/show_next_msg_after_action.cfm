<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.md5_querystring" type="string" default="">
<cfparam name="url.mailbox" type="string" default="">
<cfparam name="url.id" type="numeric" default="0">

<cfmodule template="utils/inc_check_next_msg.cfm"
	md5_querystring = #url.md5_querystring#
	mailbox = #url.mailbox#
	id = #url.id#>