<cfsetting enablecfoutputonly="Yes">
<cfparam name="attributes.status" default="">
<cfset astatus = "">
<cfswitch expression="#attributes.status#">
  <cfcase value="0">
  <cfset astatus = "erledigt">
  </cfcase>
  <cfcase value="1">
  <cfset astatus = "nicht begonnen">
  </cfcase>
  <cfcase value="2">
  <cfset astatus = "in Bearbeitung">
  </cfcase>
  <cfcase value="3">
  <cfset astatus = "zurückgestellt">
  </cfcase>
  <cfcase value="4">
  <cfset astatus = "wartet">
  </cfcase>
</cfswitch>
<cfoutput>#astatus#</cfoutput> 
<cfsetting enablecfoutputonly="No">
