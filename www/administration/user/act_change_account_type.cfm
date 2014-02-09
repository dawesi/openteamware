

<cfdump var="#form#">

<!--- update licence ... --->

<cfinvoke component="#request.a_str_component_licence#" method="UpdateUserProductKey" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="productkey" value="#form.frmproductkey#">
</cfinvoke>


<cflocation addtoken="no" url="../default.cfm?action=userproperties&entrykey=#form.frmuserkey##writeurltagsfromform()#">