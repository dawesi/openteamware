/* 
	Clean Form Validation was written from scratch by Marc Grabanski
	http://marcgrabanski.com
*/

var cleanValidator = {
	init: function (settings) {
		this.settings = settings;
		this.form = document.getElementById(this.settings["formId"]);
		formInputs = this.form.getElementsByTagName("input");
		

		this.form.onsubmit = function () {
			error = cleanValidator.validate();
			if(error.length < 1) {
				return true;
			} else {
				cleanValidator.printError(error);
				return false;
			}
		};
	},
	validate: function () {
		error = '';
		validationTypes = new Array("isRequired", "isEmail", "isNumeric");
		for(n=0; n<validationTypes.length; n++) {
			var x = this.settings[validationTypes[n]];
			if(x != null) {
				for(i=0; i<x.length; i++) 
				{
					inputField = document.getElementById(x[i]);
					inputField_display = document.getElementById(x[i] + '_display');
					switch (validationTypes[n]) {
						case "isRequired" :
						valid = !isRequired(inputField.value);
						errorMsg = "is a required field.";
						break;
						case "isEmail" :
						valid = isEmail(inputField.value);
						errorMsg = "is an invalid email address.";
						break;
						case "isNumeric" :
						valid = isNumeric(inputField.value);
						errorMsg = "can only be a number.";
						break;
					}
					if(!valid) {
						error += x[i]+" "+errorMsg+"\n";
						inputField.style.background = '#FFFF99';
						
						if (inputField_display) {
							inputField_display.style.background = '#FFFF99';
							
						}
					}
				}
			}
		}
		return error;
	},
	printError: function (error) {
		OpenErrorMessagePopup('5202', '');
	}
};

// returns true if the string is not empty
function isRequired(str){
	return (str == null) || (str.length == 0);
}
// returns true if the string is a valid email
function isEmail(str){
	if(isRequired(str)) return false;
	var re = /^[^\s()<>@,;:\/]+@\w[\w\.-]+\.[a-z]{2,}$/i
	return re.test(str);
}
// returns true if the string only contains characters 0-9 and is not null
function isNumeric(str){
	if(isRequired(str)) return false;
	var re = /[\D]/g
	if (re.test(str)) return false;
	return true;
}