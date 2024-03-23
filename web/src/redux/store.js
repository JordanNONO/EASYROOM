import { configureStore } from "@reduxjs/toolkit";
import UserState from "./features/user";

export const store = configureStore({
	reducer: {
		UserReduce: UserState,
	},
});
