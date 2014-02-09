<!--- die verschiedenen termine inkludieren --->

<cfset ATermine = StructNew()>

<cfset aTerminInfo = ArrayNew(1)>
<cfset aTerminInfo[1] = "test">
<cfset tmp = StructInsert(Atermine, "Titel", aTerminInfo)>
<cfset tmp = StructCount(ATermine)>

<cfoutput>#tmp#</cfoutput>