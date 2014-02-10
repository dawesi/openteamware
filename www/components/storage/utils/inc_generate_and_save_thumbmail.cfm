<cftry>
<cfset a_str_thumbnail_filename = request.a_str_storage_datapath & request.a_str_dir_separator & 'thumbnails' & request.a_str_dir_separator & a_str_uuid & '.jpg'>
			
<cfset myImage = CreateObject("Component",'/components/tools/cmp_image') />

<!--- open the image to resize --->
<cfset myImage.readImage(path = arguments.location, givenfileext = ListLast(arguments.contenttype, '/')) />


			<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="thumbnails ..." type="html">
			<cfdump var="#arguments#">
			<cfdump var="#a_str_thumbnail_filename#">
			</cfmail>--->


<!--- resize the image to a specific width and height --->
<cfset myImage.scalePixels(160, 140) />
<!--- output the image in JPG format --->
<cfset myImage.writeImage(a_str_thumbnail_filename, "jpg", 90) />

<cfcatch type="any">
	<!--- maybe invalid image and so on --->
	
	<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch" type="html">
		<cfdump var="#cfcatch#">
	</cfmail>--->
</cfcatch>
</cftry>			