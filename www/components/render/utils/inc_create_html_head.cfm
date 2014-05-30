<!--- //

	Module:		Render
	Function:	GenerateHTMLHeaderContent
	Description:Create Html Header
	

// ---><cfoutput><!DOCTYPE HTML>

<html>
	<head>
		
		<!--- call CSS include ... --->
		<link rel="stylesheet" media="all" type="text/css" href="/assets/css/bootstrap.css">
		<link rel="stylesheet" media="all" type="text/css" href="/assets/css/default.css">
		<link rel="stylesheet" media="print" type="text/css" href="/assets/css/print.css">	
		

		<!--- call js include ... important to do first because of init.js (has to be called first of all)  --->
		
		#CallJavaScriptsInclude(currentaction = arguments.currentaction)#
		<script src="/assets/js/bootstrap.min.js"></script>
				
		<!--- custom html header --->
		#GenerateCustomHTMLHeader()#
	
		<title>#htmleditformat(arguments.pagetitle)#</title>
		
		<link rel="shortcut icon" href="/images/si/group_add.png" type="image/png" />
		
	</head>
			
</cfoutput>

