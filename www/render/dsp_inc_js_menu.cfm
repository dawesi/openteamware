

<!--- menu script ... needed in every header --->

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	
    <td style="color: gray;
    font-weight: bold;
    font-size: 10px;
    text-transform: uppercase;padding:4px;">	
		Start | Neu | E-Mail |
	<!--- test 
	<script type="text/javascript">
 		try	{
			document.write(parent.framebottom.GetCachedTopMenuString());
			}
			catch(e) {
				WriteTopMenu();
				}
			
	</script>
	
	--->
	
	</td>
	
	<cfif StructKeyExists(request, 'stSecurityContext')>
		
		<!---
		<td align="right" style="white-space: nowrap;color:silver;padding-right:14px;">
			<span id="id_span_nav_right">			
				<!---<a href="#" class="nav_top_link_default" style="font-weight:bold; "><cfoutput>#request.stSecurityContext.myusername#</cfoutput></a>
				&nbsp;|&nbsp;
				--->
				
				<!---
				&nbsp;|&nbsp;<a class="nav_top_link_default" href="/logout.cfm" target="_top"><img vspace="0" hspace="0" border="0" src="/images/menu/img_logout_16x16.gif" align="absmiddle"> <cfoutput>#GetLangVal('cm_wd_logout')#</cfoutput></a>&nbsp;&nbsp;
				--->
			</span>
		</td>
		--->
		<td style="display:none; ">
			<!--- dummy iframe for smartload --->
			<iframe src="/tools/smartload/history/" name="id_iframe_smartload_history" width="0" marginwidth="0" height="0" marginheight="0" scrolling="auto" frameborder="0" id="id_iframe_smartload_history"></iframe>
		</td>
	</cfif>
  </tr>
</table>

<!--- div tags for the various services --->
<div id="id_div_menu_sub_items" class="div_menu_top_popup" style="display:none;padding:0px;position:absolute;left:5000px;width:100%;" onMouseMove="MainMenuMO();" onMouseOver="MainMenuMO();" onMouseOut="StartCloseMainMenuTimer();">
	<!--- menu content goes here --->
</div>