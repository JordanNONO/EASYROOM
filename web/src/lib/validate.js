/**
 *
 * @param {object} object
 * @returns
 */
export function isNotEmpty(object) {
	if (Object.keys(object).filter((k) => object[k] === "").length === 0)
		return true;
	return false;
}
export const formDataToFormData = (formData) => {
	const form = new FormData();
	for (const key in formData) {
	  if (Array.isArray(formData[key])) {
		formData[key].forEach((item) => {
		  form.append(key, item);
		});
	  } else {
		form.append(key, formData[key]);
	  }
	}
	console.log(form)
	return form;
  };