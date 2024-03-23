import { BASE_URL } from "./common";

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
	headers: {
		Authorization: `Bearer ${sessionStorage.getItem("token")}`,
	},
};

export const FETCH_HOUSE_PATH = {
	url: `${BASE_URL}/house`,
	method: "GET",
	headers: {
		Authorization: `Bearer ${sessionStorage.getItem("token")}`,
	},
};

export const ADD_HOUSE_PATH = {
	url: `${BASE_URL}/house/add`,
	method: "POST",
	headers: {
		Authorization: `Bearer ${sessionStorage.getItem("token")}`,
	},
};

export const RENT_HOUSE_PATH = {
	url: `${BASE_URL}/rent-house`,
	method: "POST",
	headers: {
		Authorization: `Bearer ${sessionStorage.getItem("token")}`,
	},
};
