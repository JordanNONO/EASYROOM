require("dotenv").config();

const http = require("http");
const express = require("express");
const app = express();
const session = require("express-session");
const cookieParser = require("cookie-parser");
const passport = require("passport");
const { localAuth, jwtAuth } = require("./auth/index");
const cors = require("cors");
const { swaggerUi, specs } = require("./swagger");

const SESSION_SECRET = process.env.SESSION_SECRET;
if (!SESSION_SECRET) {
	console.warn(
		"SESSION_SECRET n'est pas défini : utilisation d'un secret temporaire non sécurisé pour le développement. Définis SESSION_SECRET dans .env pour la production.",
	);
}
const SESSION_MAX_AGE_MS = 60 * 60 * 1000; // 1 heure

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static("uploads"));
app.use(
	cors({
		origin: process.env.CORS_ORIGIN ? process.env.CORS_ORIGIN.split(",") : true,
		credentials: true,
	}),
);
app.use(
	session({
		secret: SESSION_SECRET || require("crypto").randomBytes(32).toString("hex"),
		resave: false,
		saveUninitialized: false,
		cookie: {
			maxAge: SESSION_MAX_AGE_MS,
			secure: process.env.NODE_ENV === "production",
			httpOnly: true,
		},
	}),
);

app.use(async function(req, res, next) {
	try {
		res.locals.user = req.user || null;
		next();
	} catch (error) {
		next(error);
	}
});
app.use(passport.initialize());
app.use(passport.session());
jwtAuth(passport);
localAuth(passport);

app.use("/", require("./routes/index"));

app.use("/api/v1/user", require("./routes/api/user"));
app.use("/api/v1/chat", require("./routes/api/chat"));
app.use("/api/v1/house", require("./routes/api/house"));
app.use("/api/v1/favorite", require("./routes/api/favorite"));
app.use("/api/v1/reservation", require("./routes/api/reservation"));
app.use("/api/v1/campus", require("./routes/api/campus"));
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(specs));

// Doit rester le dernier middleware pour capter les erreurs des routes ci-dessus.
app.use((err, req, res, next) => {
	console.error(err);
	res.status(err.status || 500).json({ error: "Internal Server Error" });
});

const PORT = process.env.PORT || 4500;
http.createServer(app).listen(PORT, () => {
	console.log(`server run on port ${PORT}`);
});
