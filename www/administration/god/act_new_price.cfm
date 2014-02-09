
<cfdump var="#form#">

<cfinclude template="queries/q_insert_price.cfm">

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">