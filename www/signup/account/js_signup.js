function changecreateteam(value)
	{
	var obj1
	var a_str_style_display = '';
	
	if (value == true)
		{
		a_str_style_display = 'none';
		} else
			{
			a_str_style_display = '';
			}
	
	obj1 = findObj('id_tr_team_members');
	obj1.style.display = a_str_style_display;
	obj1 = findObj('id_tr_team_name');
	obj1.style.display = a_str_style_display;
	obj1 = findObj('id_tr_team_description');
	obj1.style.display = a_str_style_display;
	}

function SetOptionsCustomize(value)
	{
	var obj1;
	
	obj1 = findObj('id_td_options_customize');
	
	if (value == 'custom')
		{
		obj1.style.display = '';
		}
			else
				{
				obj1.style.display = 'none';
				}
	}
	
	function SetPromoKeywordVisible()
		{
		findObj('idpromocodekeyword').style.display = '';
		}	