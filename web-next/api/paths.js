import { BASE_URL } from "./common";

export function authHeader() {
	if (typeof window === "undefined") return {};
	const token = sessionStorage.getItem("token");
	return token ? { Authorization: `Bearer ${token}` } : {};
}

export const REGISTER_PATH = {
	url: `${BASE_URL}/user/add`,
	method: "POST",
	headers: {
		"Content-type": "application/json",
	},
};

export const LOGIN_PATH = {
	url: `${BASE_URL}/user/login`,
	method: "POST",
	headers: {
		"Content-type": "application/json",
	},
};

export const FETCH_USER_PATH = {
	url: `${BASE_URL}/user/me`,
	method: "GET",
};

export const FETCH_HOUSE_PATH = {
	url: `${BASE_URL}/house`,
	method: "GET",
};

export const FETCH_MY_HOUSES_PATH = {
	url: `${BASE_URL}/house/me`,
	method: "GET",
};

export const ADD_HOUSE_PATH = {
	url: `${BASE_URL}/house/add`,
	method: "POST",
};

export const RENT_HOUSE_PATH = {
	url: `${BASE_URL}/user/rent-house`,
	method: "POST",
};

export function favoritePath(houseId) {
	return {
		url: `${BASE_URL}/favorite/set/${houseId}`,
		method: "POST",
	};
}
