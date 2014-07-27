<!--- select font type --->
<cfif arguments.use_fixed_font>
	<cfset a_str_font_family = 'Fixedsys, Courier, mono;'>
<cfelse>
	<cfset a_str_font_family = 'Times New Roman, Times, serif'>
</cfif>

<cfscript>
/**
 * Similar to xmlFormat() but replaces all characters not on the &quot;good&quot; list as opposed to characters specifically on the &quot;bad&quot; list.
 * 
 * @param inString 	 String to format. (Required)
 * @return Returns a string. 
 * @author Samuel Neff (sam@serndesign.com) 
 * @version 1, January 12, 2004 
 */
function xmlFormatEx(inString) {
   
   //var goodChars = "!@##$^*()0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`~[]{};:,./?\| -_=+#chr(13)##chr(10)##chr(9)#";
   var goodChars = "!@$*()0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~[]{};:,./?\| -_=+#chr(13)##chr(10)##chr(9)#";
   var i = 1;
   var c = "";     
   var s = "";
   
   for (i=1; i LTE len(inString); i=i+1) {
      
      c = mid(inString, i, 1);
      
      if (find(c, goodChars)) {
         s = s & c;
      } else {
         s = s & "&##" & asc(c) & ";";
      }
   }
   
   return s;
}
</cfscript>

<cfsavecontent variable="sReturn">
<cfoutput>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<!--- title = subject --->
		<title>#xmlformat(CheckZeroString(Trim(arguments.subject)))#</title>
		<style type="text/css">
			body {background-color:white;font-family:#a_str_font_family#}
			.td_right {text-align:right;}
		</style>
	</head>
<body>
<p>
	<em>
		<strong>Wichtige Informationen:</strong>
		Diese Nachricht wurde digital signiert und die eingesetzte A1 Signatur entspricht einer fortgeschrittenen Signatur. Rechtliche Hinweise &amp; eine Anleitung zur Überprüfung der Echtheit finden Sie am Ende der Nachricht.
	</em>
</p>
<hr/>
<table>
	<tr>
		<td class="td_right">
			Betreff:
		</td>
		<td>
			<strong>#xmlFormatEx(Trim(arguments.subject))#</strong>
		</td>
	</tr>
	<tr>
		<td class="td_right">
			Von:
		</td>
		<td>
			#xmlFormatEx(arguments.from)#
		</td>
	</tr>	
	<tr>
		<td class="td_right">
			An:
		</td>
		<td>
			#xmlFormatEx(arguments.to)#
		</td>
	</tr>
	<tr>
		<td class="td_right">
			Systemzeit:
		</td>
		<td>
			#xmlFormatEx(DateFormat(Now(), 'dd.mm.yy') & ' ' & TimeFormat(Now(), 'HH:mm'))#
		</td>
	</tr>
</table>
<hr/>

<!--- output body ... PRE if fixed font, variable with BR if otherwise --->
<cfif arguments.use_fixed_font>
	<pre>
<cfelse>
	<p>
</cfif>

<cfloop list="#arguments.text_body#" delimiters="#chr(10)#" index="a_str_line">
#xmlFormatEx(a_str_line)#<cfif NOT arguments.use_fixed_font><br/></cfif>
</cfloop>
	
<cfif arguments.use_fixed_font>
	</pre>
<cfelse>
	</p>
</cfif>
	
<!--- loop over "attachments" --->
<cfif ArrayLen(arguments.attachments) GT 0>
<table>
	<tr>
		<td>
			Attachments
		</td>
	</tr>
	<cfloop from="1" to="#ArrayLen(arguments.attachments)#" index="ii">
	<tr>
		<td>
			<img src="http://192.168.0.1/att_#ii#.jpg"/>
		</td>
	</tr>
	</cfloop>
</table>
</cfif>

<hr/>
<p><strong>Um die Authentizität (Echtheit) der Nachricht zu überprüfen, öffnen Sie einfach den beigefügten Anhang "Ueberpruefung.html".</strong></p>
<p><strong>Die Signatur dieser Nachricht (Verwaltungssignatur) ist der sicheren Signatur / eigenhändigen Unterschrift im Behördenverkehr gleichgestellt (§25 Abs 1 E-GovG iVm §4 Abs 1 SignaturG)</strong></p>
<p>Erstellt mit openTeamWare Mobile Sign (www.openTeamWare.com) unter Verwendung der A1 Signatur (www.a1.net/signatur/)</p>
<p>Interne ID: #xmlFormatEx(arguments.jobkey)#</p>
</body>
</html>
</cfoutput>
</cfsavecontent>