const passport = require("passport");
module.exports = {
  ensureAuthenticated: function (req, res, next) {
    if (req.isAuthenticated()) {
      return next();
    }
    // req.flash("error_msg", "Not Authorized");
    let path = "/user/login";
    //path += req.headers.referer ? `?next=${req.headers.referer}` : "";
    return res.redirect(path);
  },

  protect: () => {
    return passport.authenticate("jwt", { session: false });
  },
};
