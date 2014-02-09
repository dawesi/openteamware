<!--- //
	
	load an image attachment that has been already saved to the harddisk
	
	the filename is saved in the "src" parameter
	
	the file is deleted after being delivered
	
	<io>
		<in>
			<param name="src" type="string" required=true default="">
			the source parameter
			
			the file is saved in the request.a_str_temp_directory directory
			</param>
			
			<param name="contenttype" type="string" required=true default="">
			the content - type
			</param>
			
			<param name="thumbnail" type="numeric" required=true default="1">
			generate a thumbnail?
			</param>						
			
		</in>
	</io>
	
	// --->
	
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.src" type="string" default="">
<cfparam name="url.contenttype" type="string" default="">
<cfparam name="url.thumbnail" type="numeric" default="1">

<cfif len(url.contenttype) is 0>
	<cfset a_str_contenttype = "binary/unknown">
<cfelse>
	<cfset a_str_contenttype = url.contenttype>
</cfif>

<cfset a_str_contenttype = ReplaceNoCase(a_str_contenttype, 'pjpeg', 'jpeg') />
<cfset a_str_contenttype = ReplaceNoCase(a_str_contenttype, 'x-', '') />

<!--- the filename of the original --->
<cfset sFilename = request.a_str_temp_directory & "/" &url.src />

<cfif NOT FileExists(sFilename)>
	<h4>Files does not exist.</h4>
</cfif>

<!--- thumbnail or not? --->
<cfif Val( url.thumbnail ) IS 0>
	<cfcontent deletefile="false" file="#sFilename#" type="#a_str_contenttype#">
</cfif>

<!--- filename of thumbnail --->
<cfset a_str_thumbnail_filename = request.a_str_temp_directory & createuuid() />

<cftry>
<cfset myImage = CreateObject("Component",'/components/tools/cmp_image') />
<cfset myImage.readImage(path = sFilename, givenfileext = ListLast(a_str_contenttype, '/')) />

<!--- resize the image to a specific width and height --->
<cfset myImage.scalePixels(160, 140) />
<!--- output the image in JPG format --->
<cfset myImage.writeImage(a_str_thumbnail_filename, "jpg", 90) />


<cfif FileExists(a_str_thumbnail_filename)>
	<cfcontent type="#a_str_contenttype#" file="#a_str_thumbnail_filename#" deletefile="false">
</cfif>

<cfcatch type="any">
	<!--- ignore all exceptions --->
	
</cfcatch>
</cftry>