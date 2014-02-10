<!---

	load cached ids
	
	--->
	
<cfsetting requesttimeout="20000">
	
<!--- restore workgroup information ... --->
<cfwddx action="wddx2cfml" input="#Trim(q_select_cached_ids_available.data1)#" output="stWGInfo">

<!--- restore categories ... --->
<cfwddx action="wddx2cfml" input="#Trim(q_select_cached_ids_available.data2)#" output="a_struct_categories">