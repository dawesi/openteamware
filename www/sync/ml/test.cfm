<cfset a_str_sql = 'where "urn:schemas:contacts:givenName"=''&apos;&apos; Apo'' and "urn:schemas:contacts:sn"=''Andreas'' and "urn:schemas:contacts:middlename" is null  and "urn:schemas:contacts:email1" is null </D:sql>'>

<cfdump var="#a_str_sql#">


<pre>surname: |<cfoutput>#GetWebDAVSqlWhereAttribute(a_str_sql, 'urn:schemas:contacts:givenName')#</cfoutput>|</pre>
<pre>firstname: |<cfoutput>#GetWebDAVSqlWhereAttribute(a_str_sql, 'urn:schemas:contacts:sn')#</cfoutput>|</pre>
<pre>email: |<cfoutput>#GetWebDAVSqlWhereAttribute(a_str_sql, 'urn:schemas:contacts:email1')#</cfoutput>|</pre>

<cfset a_str_sql = 'where ("urn:schemas:calendar:dtstart"=CAST("2005-08-26T11:00:00.000Z" as ''dateTime'') and "urn:schemas:calendar:dtend"=CAST("2005-08-26T12:00:00.000Z" as ''dateTime'') and "urn:schemas:calendar:location" is null ) AND not ("http://schemas.microsoft.com/mapi/id/{00062002-0000-0000-C000-000000000046}/0x8231" != cast("0" as int) and ("urn:schemas:calendar:instancetype" != 1 and "urn:schemas:calendar:instancetype" != 0))</D:sql>'>

<cfdump var="#a_str_sql#">

<pre>start: |<cfoutput>#GetWebDAVSqlWhereAttribute(a_str_sql, 'urn:schemas:calendar:dtstart')#</cfoutput>|</pre>