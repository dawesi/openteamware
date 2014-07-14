<!--- try to display the image of the device ... --->

<cfparam name="url.device" type="string" default="">

<cfset a_str_file = '/mnt/www-source/www.openTeamWare.com/images/mobilesync/devices/' & url.device & '.jpg'>

<cflog text="display image: #a_str_file# #FileExists(a_str_file)#" type="Information" log="Application" file="ib_syncml">

<cfif FileExists(a_str_file)>
	<cfcontent deletefile="no" file="#a_str_file#" type="image/jpeg">
<cfelse>
	<cfcontent deletefile="no" file="#request.a_str_img_1_1_pixel_location#" type="image/gif">
</cfif>