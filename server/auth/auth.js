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

  // Décode le JWT s'il est présent et valide, sans jamais rejeter la requête.
  // Nécessaire pour les routes de lecture publiques (annonces) que Google ou
  // un site Next.js en SSG/ISR doivent pouvoir appeler sans token.
  optionalAuth: () => {
    return (req, res, next) => {
      passport.authenticate("jwt", { session: false }, (err, user) => {
        req.user = user || undefined;
        next();
      })(req, res, next);
    };
  },
};
