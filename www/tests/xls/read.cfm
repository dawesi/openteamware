
<cfset theFile = ExpandPath( './otw20.xls' ) />

<cfspreadsheet headerrow="1" action="read" src="#theFile#" query="spreadsheetData"></cfspreadsheet>

<cfdump var="#spreadsheetData#">