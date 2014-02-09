<!--- //



	common function for an alert box

	

	// --->
	
<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="attributes.message" type="string" default="&nbsp;">

<cfparam name="attributes.backlink" type="boolean" default="true">

<cfparam name="attributes.width" type="numeric" default="500">

<cfparam name="attributes.caption" type="string" default="Fehler">

<cfif Len(attributes.caption) IS 0>
	<cfset attributes.caption = GetLangVal('cm_wd_information')>
</cfif>

<fieldset class="default_fieldset">
	<legend><cfoutput>#htmleditformat(attributes.caption)#</cfoutput></legend>
	<div>
		<img src="/images/img_attention.png" width="29" height="30" hspace="8" vspace="8" border="0" align="left">

		<cfoutput>#trim(attributes.message)#</cfoutput>
		
		<cfif attributes.backlink>
			<br />
			<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
		</cfif>		
	</div>
</fieldset>

<cfexit method="exittemplate">

<table class="b_all" width="<cfoutput>#attributes.width#</cfoutput>" border="0" cellpadding="4" cellspacing="0">

	<tr class="mischeader">

		<td colspan="2" class="bb contrasttext">

		<b><cfoutput>#attributes.caption#</cfoutput></b>

		</td>

	</tr>	

	<tr>

		<td valign="middle" width="40">

			<img src="/images/img_attention.png" width="29" height="30" hspace="4" vspace="4" border="0">

		</td>

		<td style="line-height:20px;" class="bl">

			<cfoutput>#trim(attributes.message)#</cfoutput>

		</td>

	</tr>

	<cfif attributes.backlink>

	<tr>

		<td>&nbsp;</td>

		<td class="bl">

		<a href="javascript:history.go(-1);" class="simplelink">zur&uuml;ck</a>

		</td>

	</tr>

	</cfif>

</table>