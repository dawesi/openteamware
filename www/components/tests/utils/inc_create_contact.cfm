<cfscript>	
	function CheckEntryExistsAndReturnValue(e)
		{
		
		if (NOT IsDefined('a_struct_data'))		
			{
			return '';
			}
		
		
		if (StructKeyExists(a_struct_data, e))
			{
			return a_struct_data[e];
			}
				else return '';
		}

</cfscript>

<cflog text="#StructKeyList(a_struct_data)# #StructKeyExists(a_struct_data, 'firstname')#" type="Information" log="Application" file="ib_import">

<cflog text="inserting contact ... company: #CheckEntryExistsAndReturnValue('company')#" type="Information" log="Application" file="ib_import">


<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="entrykey" value="#sEntrykey#">
	
	<cfinvokeargument name="firstname" value="#CheckEntryExistsAndReturnValue('firstname')#">
	<cfinvokeargument name="surname" value="#CheckEntryExistsAndReturnValue('surname')#">
	<cfinvokeargument name="company" value="#CheckEntryExistsAndReturnValue('company')#">
	<cfinvokeargument name="department" value="#CheckEntryExistsAndReturnValue('department')#">
	<cfinvokeargument name="position" value="#CheckEntryExistsAndReturnValue('position')#">
	<cfinvokeargument name="title" value="#CheckEntryExistsAndReturnValue('title')#">
	<cfinvokeargument name="sex" value="#val(CheckEntryExistsAndReturnValue('sex'))#">
	<cfinvokeargument name="email_prim" value="#CheckEntryExistsAndReturnValue('email_prim')#">
	<cfinvokeargument name="email_adr" value="#CheckEntryExistsAndReturnValue('email_adr')#">
	<cfinvokeargument name="birthday" value="#CheckEntryExistsAndReturnValue('birthday')#">
	<cfinvokeargument name="categories" value="#CheckEntryExistsAndReturnValue('categories')#">
	<cfinvokeargument name="b_street" value="#CheckEntryExistsAndReturnValue('b_street')#">
	<cfinvokeargument name="b_city" value="#CheckEntryExistsAndReturnValue('b_city')#">
	<cfinvokeargument name="b_zipcode" value="#CheckEntryExistsAndReturnValue('b_zipcode')#">
	<cfinvokeargument name="b_country" value="#CheckEntryExistsAndReturnValue('b_country')#">
	<cfinvokeargument name="b_telephone" value="#CheckEntryExistsAndReturnValue('b_telephone')#">
	<cfinvokeargument name="b_fax" value="#CheckEntryExistsAndReturnValue('b_fax')#">
	<cfinvokeargument name="b_mobile" value="#CheckEntryExistsAndReturnValue('b_mobile')#">
	<cfinvokeargument name="b_url" value="#CheckEntryExistsAndReturnValue('b_url')#">
	<cfinvokeargument name="p_street" value="#CheckEntryExistsAndReturnValue('p_street')#">
	<cfinvokeargument name="p_city" value="#CheckEntryExistsAndReturnValue('p_city')#">
	<cfinvokeargument name="p_zipcode" value="#CheckEntryExistsAndReturnValue('p_zipcode')#">
	<cfinvokeargument name="p_country" value="#CheckEntryExistsAndReturnValue('p_country')#">
	<cfinvokeargument name="p_telephone" value="#CheckEntryExistsAndReturnValue('p_telephone')#">		
	

	<cfinvokeargument name="p_fax" value="#CheckEntryExistsAndReturnValue('p_fax')#">
	<cfinvokeargument name="p_mobile" value="#CheckEntryExistsAndReturnValue('p_mobile')#">
	<cfinvokeargument name="p_url" value="#CheckEntryExistsAndReturnValue('p_url')#">
	<cfinvokeargument name="notice" value="#CheckEntryExistsAndReturnValue('notice')#">
	<cfinvokeargument name="archiveentry" value="#val(CheckEntryExistsAndReturnValue('archiveentry'))#">			
	<cfinvokeargument name="contacttype" value="#val(CheckEntryExistsAndReturnValue('contacttype'))#">				
	<cfinvokeargument name="parentcontactkey" value="#CheckEntryExistsAndReturnValue('parentcontactkey')#">				
	<cfinvokeargument name="sender" value="ws_import">				
</cfinvoke>

<cfset stReturn.a_bol_return_addressbook = a_bol_return>
<cfset stReturn.sEntrykey = sEntrykey>

