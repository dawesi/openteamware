<!--- //

	Service:	Address Book
	Action:		ShowDlgAddFilterCriteria
	Description:Add a filter criteria ...
	
	Header:		

// --->

<cfparam name="url.area" type="string" default="">
<cfparam name="url.datatype" type="string" default="0">
<cfparam name="url.viewkey" type="string" default="">
<cfparam name="url.fieldname" type="string" default="">

<cfswitch expression="#url.fieldname#">
	<cfcase value="category">
	
		<!--- first step: the master category list --->
		<cfset a_str_categories = getlangval("cm_ph_categories_masterlist") />
		
		
			
		<!--- 2nd step: load workgroup defined categories --->			
		<!--- 3rd step: load user defined categories --->
		<cfset a_str_own_categories = GetUserPrefPerson('common', 'personalcategories', '', '', false) />
			
		<cfif Len(a_str_own_categories) GT 0>
			
			<!--- replace build-in master list --->
			<cfset a_str_categories = a_str_own_categories />
		</cfif>
		
		<cfset a_str_categories = ListSort(a_str_categories, 'textnocase') />
		
		<ul class="ul_nopoints">
					
		<cfloop list="#a_str_categories#" delimiters="," index="a_str_key">
			<cfoutput>
			<cfset a_str_href = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'filtercategory', a_str_key) />
			<li><img src="/images/si/tag_blue.png" class="si_img" /><a href="##" onclick="AddFilterCriteria('categories', '#url.area#', '#jsstringformat(url.viewkey)#', '#JsStringFormat(a_str_key)#');">#trim(shortenstring(a_str_key, 20))#</a></li>
			</cfoutput>
		</cfloop>
		
		</ul>

	</cfcase>
	<cfcase value="workgroup">
	
		<ul class="ul_nopoints">
		<li>
			<a href="#" onclick="ReloadPageWithNewParameter('filterworkgroupkey=private');"><img src="/images/si/user.png" class="si_img" /><cfoutput>#GetLangVal('adrb_ph_filter_private_only')#</cfoutput></a>
		</li>
		<cfoutput query="request.stSecurityContext.q_select_workgroup_permissions">

		<li style="padding-left:#(request.stSecurityContext.q_select_workgroup_permissions.workgrouplevel * 10)#">
			<img src="/images/si/group.png" class="si_img" /><a href="##" onclick="AddFilterCriteria('workgroup', '#url.area#', '#jsstringformat(url.viewkey)#', '#JsStringFormat(request.stSecurityContext.q_select_workgroup_permissions.workgroup_key)#');">#htmleditformat(shortenstring(request.stSecurityContext.q_select_workgroup_permissions.workgroup_name, 17))#</a>
		</li>
		</cfoutput>
		</ul>
	
	</cfcase>
	<cfcase value="custodian">
	
		<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
		</cfinvoke>		

		<ul class="ul_nopoints">
		<cfoutput query="q_select_users">

		<li>
			<img src="/images/si/user.png" class="si_img" /><a href="##" onclick="AddFilterCriteria('custodian', '#url.area#', '#jsstringformat(url.viewkey)#', '#JsStringFormat(q_select_users.entrykey)#');"> #application.components.cmp_user.GetFullNameByentrykey(entrykey = q_select_users.entrykey)# (#q_select_users.username#)</a>
		</li>
		</cfoutput>
		</ul>

	</cfcase>
	<cfcase value="criteria">
		
		<cfset a_str_tree_id = 'id_tree_' & CreateUUIDJS() />
		<cfset a_str_form_id = 'id_form_' & CreateUUIDJS() />
	
		<form action="" name="<cfoutput>#a_str_form_id#</cfoutput>" id="<cfoutput>#a_str_form_id#</cfoutput>">
			<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCriteriaTree" returnvariable="sReturn">
				<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
				<cfinvokeargument name="options" value="allowedit">
				<cfinvokeargument name="form_input_name" value="frm_criteria_ids">
				<cfinvokeargument name="url_tags_to_add" value="">
				<cfinvokeargument name="tree_id" value="#a_str_tree_id#">
			</cfinvoke>

			<cfoutput>#sReturn#</cfoutput>

		<cfoutput>
		<input type="button" onclick="AddFilterCriteria('criteria', '0', '#jsstringformat(url.viewkey)#', CollectCheckedSelectBoxesValues('<cfoutput>#a_str_tree_id#</cfoutput>'));" value="#GetLangVal('cm_ph_btn_action_apply')#" class="btn" />
		</cfoutput>
		</form>
	
	</cfcase>
</cfswitch>

