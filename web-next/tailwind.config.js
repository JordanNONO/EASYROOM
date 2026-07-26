/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ["./pages/**/*.{js,jsx}", "./components/**/*.{js,jsx}"],
	theme: {
		extend: {
			colors: {
				ink: { DEFAULT: "#17233A", soft: "#3C4A63" },
				paper: { DEFAULT: "#FAF7F1", raised: "#F1ECE0" },
				brass: { DEFAULT: "#A9722F", bright: "#C98A3E", light: "#F1E3CE" },
				moss: { DEFAULT: "#3F5A4C" },
				line: { DEFAULT: "#DCD3C3" },
			},
			fontFamily: {
				display: ["var(--font-display)", "Georgia", "serif"],
				sans: ["var(--font-body)", "system-ui", "sans-serif"],
			},
		},
	},
	plugins: [],
};
