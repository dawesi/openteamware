<!--- check if the autologin key exists --->


<cfif IsDefined("url.frmattr_FRMIBLOGINKEY")>
	<!--- loop url variables and create form variables ... this way we
		can login the user ... --->
	
	<cfif request.stSecurityContext.myuserid is 2>
	

	
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="test">
	<CFLOOP COLLECTION = "#URL#" ITEM = "VARIABLE">
	#Variable# <br />
	</CFLOOP>
	</cfmail>
	
	
	<cfabort>
	</cfif>
	
	

</cfif>