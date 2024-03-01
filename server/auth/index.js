const LocalStrategy = require("passport-local").Strategy;
const bcrypt = require("bcryptjs");
const JwtStrategy = require("passport-jwt").Strategy,
	ExtractJwt = require("passport-jwt").ExtractJwt;
const db = require("../models");

function localAuth(passport) {
	passport.use(
		new LocalStrategy(
			{ usernameField: "username" },
			(username, password, done) => {
				// Match user
				db.User.findOne({
					where: {
						name: username,
					},
					raw: true,
				}).then(async (user) => {
					//const getAdmin = await db.Role.findOne({ where: { name: "Admin" } });
					console.log(user);
					if (!user) {
						console.log("No User Found");

						return done(null, false, {
							message: "Nom d'utilisateur ou mot de passe incorrect",
						});
					}

					// Match password
					bcrypt.compare(password, user.password, async (err, isMatch) => {
						if (err) throw err;

						if (isMatch) {
							return done(null, user);
						} else {
							//console.log("Incorrect");

							return done(null, false, {
								message: "Nom d'utilisateur ou mot de passe incorrect",
							});
						}
					});
				});
			},
		),
	);

	passport.serializeUser(function (user, cb) {
		process.nextTick(function () {
			return cb(null, {
				id: user.id,
				username: user.username,
				role: user.role,
			});
		});
	});

	passport.deserializeUser(function (user, cb) {
		const { id } = user;
		//User.findByPk(id);
		db.User.findByPk(id, { include: ["Role"], raw: true })
			.then((user) => {
				process.nextTick(function () {
					return cb(null, user);
				});
			})
			.catch((err) => cb(err));
	});
}

function jwtAuth(passport) {
	const opts = {};
	opts.jwtFromRequest = ExtractJwt.fromAuthHeaderAsBearerToken();
	opts.secretOrKey = process.env.SECRET ?? "285dfeQs@@#";
	passport.use(
		new JwtStrategy(opts, function (jwt_payload, done) {
			db.User.findOne({ where: { id: jwt_payload.id }, raw: true }).then(
				async (user, err) => {
					if (err) {
						console.log(err);

						return done(err, false);
					}
					if (user) {
						process.nextTick(async () => {
							return done(null, user);
						});
					} else {
						return done(null, false);
						// or you could create a new account
					}
				},
			);
		}),
	);
}
module.exports = {
	jwtAuth,
	localAuth,
};
