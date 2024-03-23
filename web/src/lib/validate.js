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
