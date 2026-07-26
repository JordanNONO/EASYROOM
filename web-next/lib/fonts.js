import { Fraunces, Inter } from "next/font/google";

export const display = Fraunces({
	subsets: ["latin"],
	weight: ["400", "600"],
	style: ["normal", "italic"],
	variable: "--font-display",
	display: "swap",
});

export const body = Inter({
	subsets: ["latin"],
	weight: ["400", "500", "600", "700"],
	variable: "--font-body",
	display: "swap",
});
