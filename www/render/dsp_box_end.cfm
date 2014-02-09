<!--- //

	end of box

	// --->



	</td>

	</tr>

</table>




<!--- include now footer? --->

<cfif len(request.appsettings.include_footer) gt 0>
	<cfmodule template="/include/mod_include.cfm" pagename="#request.appsettings.include_footer#">
</cfif>

<cfif StructKeyExists(request, 'a_bol_using_own_header')>
	<div align="center">
	<a href="/content/homepage/"><img src="/images/homepage/img_inboxcc_logo_bottom.png" width="108" height="30" hspace="0" vspace="0" border="0"></a>
	</div>
</cfif>