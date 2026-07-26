import { createSlice } from "@reduxjs/toolkit";

const initialState = {
	isAuth: typeof window !== "undefined" && !!sessionStorage.getItem("token"),
	userData: {},
};

export const UserState = createSlice({
	name: "userState",
	initialState,
	reducers: {
		setUserStatus: (state, action) => {
			state.isAuth = action.payload;
		},
		setUserData: (state, action) => {
			state.userData = action.payload;
		},
		logout(state, _) {
			if (typeof window !== "undefined") {
				sessionStorage.removeItem("token");
				sessionStorage.clear();
			}
			state.userData = {};
			if (typeof window !== "undefined") {
				window.location.reload();
			}
		},
	},
});

export const { setUserStatus, setUserData, logout } = UserState.actions;

export default UserState.reducer;
