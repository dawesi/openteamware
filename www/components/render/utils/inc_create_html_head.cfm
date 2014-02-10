<!--- //

	Module:		Render
	Function:	GenerateHTMLHeaderContent
	Description:Create Html Header
	

// --->


<cfoutput>
<!DOCTYPE HTML>

<html>
	<head>
		
	
		<!--- call js include ... important to do first because of init.js (has to be called first of all)  --->
		#CallJavaScriptsInclude(currentaction = arguments.currentaction)#
		
		<!--- call CSS include ... --->
		#CallStyleSheetInclude()#
				
		<!--- custom html header --->
		#GenerateCustomHTMLHeader()#
	
		<title>#htmleditformat(arguments.pagetitle)#</title>
		
		<link rel="shortcut icon" href="/images/si/group_add.png" type="image/png" />
		
		<!--- <base href="http://www.stage.openTeamware.com:8080/start/default/"> --->
		
		<cfif StructKeyExists(request, 'stSecurityContext')>
		
			<cfif request.stSecurityContext.mycompanykey IS '299932A4-DB03-3450-03F0C1F65D836F5E'>
				<style type="text/css">
				.div_top_menu_outer {
				display:block;
				}
				</style>
			</cfif>
		</cfif>
	</head>
			
</cfoutput>

