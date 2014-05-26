
<cfinclude template="../login/check_logged_in.cfm">


<cfparam name="url.entrykey" type="string" default="">

<cfinclude template="queries/q_delete_view.cfm">

<cflocation addtoken="no" url="index.cfm?action=saveview">