ORDER BY

<cfif Len(arguments.orderby) IS 0>
	addressbook.company,
	addressbook.surname,
	addressbook.firstname
<cfelse>

	<cfif ListLen(arguments.orderby) GT 0>
	
		<cfloop list="#arguments.orderby#" index="a_str_order_by" delimiters=",">
		addressbook.<cfoutput>#a_str_order_by#</cfoutput>
			<cfif ListLast(arguments.orderby) NEQ a_str_order_by>,</cfif>
		</cfloop>
		
	<cfelse>
		addressbook.<cfoutput>#arguments.orderby#</cfoutput>
	</cfif>
	
</cfif>