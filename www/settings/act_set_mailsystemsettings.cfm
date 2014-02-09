<!---

	call the perl script of mail.openTeamWare to create filters and so on
	
	--->
<cfparam name="attributes.username" default="#request.stSecurityContext.myusername#" type="string">
	
<cfhttp url="http://mail.openTeamWare.com/cgi-bin/generateprocmailconfig.pl?username=#urlencodedformat(trim(attributes.username))#" method="get" resolveurl="no"></cfhttp>