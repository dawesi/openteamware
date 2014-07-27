<!--- die verschiedenen termine inkludieren --->

<cfset ATermine = StructNew()>

<cfset aTerminInfo = ArrayNew(1)>
<cfset aTerminInfo[1] = "test">
<cfset StructInsert(Atermine, "Titel", aTerminInfo)>
<cfset StructCount(ATermine)>

<cfoutput>#tmp#</cfoutput>