<cfdump var="#cgi.QUERY_STRING#">

<!--- entrykey of recipient --->
<cfparam name="url.r" type="string" default="">

<!--- url is build the following way ...

	?r=[recipientkey]&[target_url]
	
	--->
