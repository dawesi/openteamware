<!--- //

	calendar reaction file ... generate this file in order to provide SHORT urls 
	
	
	// --->

<!--- id of entry (f.e. E76DAA79-2E9D-46D7-A9E622E1060E9585) --->	
<cfparam name="url.id" default="">

<!--- status --->
<cfparam name="url.status" default="0">

<!--- action (status/vcal/addevent/writeback) --->
<cfparam name="url.action" default="status">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfswitch expression="#url.action#">
	<cfcase value="status">
	<cflocation addtoken="no" url="calendar/meeting/react.cfm?id=#url.id#&status=#url.status#">
	</cfcase>
	
	<cfcase value="addevent">
	<cflocation addtoken="no" url="calendar/meeting/addevent.cfm?id=#url.id#">
	</cfcase>
	
	<cfcase value="writeback">
	<cflocation url="calendar/meeting/writeback.cfm?id=#url.id#" addtoken="no">
	</cfcase>

</cfswitch>

</body>
</html>
