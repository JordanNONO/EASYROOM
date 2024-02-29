const jwt = require("jsonwebtoken");
/**
 *
 * @param {Function} callback
 * @param {*} _req
 * @param {*} res
 * @param {*} next
 * @returns
 */
function decodeAndCheckJWT(_req, res, _next, callback) {
	try {
		// Decode the token
		const decoded = jwt.decode(_req.query.token, "hsi#@°#§@xjhsk");
		if (decoded?.exp) {
			// Get expiration time from the decoded token
			const expirationTime = decoded.exp * 1000; // Convert to milliseconds

			// Get current time in milliseconds
			const currentTime = new Date().getTime();

			// Check if the token is expired
			if (currentTime > expirationTime) {
				return res.status(500).send("Token has expired");
			} else {
				return callback(decoded);
			}
		} else {
			return res.status(500).send("Token does not contain expiration time");
		}
	} catch (err) {
		return res.status(500).send("Invalid token");
	}
}

module.exports = decodeAndCheckJWT;
