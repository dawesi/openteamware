<!--- //

	Module:		Session
	Function:	CreateInternalSessionVars
	Description:




	TODO hp: cleanup and remove old data ...

// --->

<cfset stReturn.myuserkey = q_select_user.entrykey />
<cfset stReturn.mycompanykey = q_select_user.companykey />
<cfset stReturn.myuserid = q_select_user.userid />

<!--- nun die verschiedenen Variablen setzen --->
<cfset stReturn.mysurname = q_select_user.surname />
<cfset stReturn.myfirstname = q_select_user.firstname />

<cfset stReturn.myplz = val(q_select_user.plz) />
<cfset stReturn.myusername = q_select_user.username />
<cfset stReturn.mydefaultlanguage = val(q_select_user.defaultlanguage) />

<!--- language --->
<cfset client.langno = val(q_select_user.defaultlanguage) />

<!--- timeout --->
<cfset stReturn.mytimeout = 20 />

<cfset client.mySessionTimeout = stReturn.mytimeout />

<!--- utc difference !! --->
<cfset stReturn.utcDiff = q_select_user.utcdiff />

<!--- day light saving time? --->
<cfif val(q_select_user.daylightsavinghours) NEQ 0>
	<!--- add daylightsaving hours --->
	<cfset stReturn.utcdiff = stReturn.utcdiff + q_select_user.daylightsavinghours />
</cfif>


<cfset stReturn.MYCITY = q_select_user.CITY />
<cfset stReturn.mystreet = q_select_user.address1 />
<cfset stReturn.mycountry = q_select_user.country />
<cfset stReturn.mysex = q_select_user.sex />
<cfset stReturn.myMobileTelNr = q_select_user.mobilenr />


