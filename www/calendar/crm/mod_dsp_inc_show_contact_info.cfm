
<cfparam name="attributes.viewmode" type="string" default="short">
<cfparam name="attributes.query" type="query">

<cfif StructKeyExists(url, 'printmode') AND url.printmode IS TRUE>
	<cfset attributes.viewmode = 'full'>
</cfif>

<cfswitch expression="#attributes.viewmode#">
	<cfcase value="short">
		<cfoutput>
		[<a href="../addressbook/?action=ShowItem&entrykey=#attributes.query.entrykey#"><cfif Len(attributes.query.company) GT 0>[#attributes.query.company#]</cfif> #attributes.query.surname#, #attributes.query.firstname#</a> (#attributes.query.b_zipcode# #attributes.query.b_city#]&nbsp;
		</cfoutput>
	</cfcase>
	<cfcase value="middle">
		<cfoutput>
		[<a href="../addressbook/?action=ShowItem&entrykey=#attributes.query.entrykey#"><cfif Len(attributes.query.company) GT 0>[#attributes.query.company#]</cfif> #attributes.query.surname#, #attributes.query.firstname#</a> (#attributes.query.b_zipcode# #attributes.query.b_city# T: #attributes.query.b_telephone# M: #attributes.query.b_mobile#)]&nbsp;
		</cfoutput>
	</cfcase>
	<cfcase value="full">
		<cfoutput>
		<div class="b_all" style="padding:2px; ">
		<a href="../addressbook/?action=ShowItem&entrykey=#attributes.query.entrykey#"><b><cfif Len(attributes.query.company) GT 0>[#attributes.query.company#]</cfif> #attributes.query.surname#, #attributes.query.firstname#</b></a>
		<br>
		#attributes.query.b_zipcode# #attributes.query.b_city#; #attributes.query.b_street# #attributes.query.b_country#
		<br>
		T: #attributes.query.b_telephone# F: #attributes.query.b_fax# M: #attributes.query.b_mobile#; E: #attributes.query.email_prim#<br>
		B: #attributes.query.notice#
		</div>
		</cfoutput>
	</cfcase>
</cfswitch>