import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  isAuth: !!sessionStorage.getItem('token'),
  userData: {},
};

export const UserState = createSlice({
  name: 'userState',
  initialState,
  reducers: {
    setUserStatus: (state, action) => {
      state.isAuth = action.payload;
    },
    setUserData: (state, action) => {
      state.userData = action.payload;
    },
    logout(state,_) {
      sessionStorage.removeItem('token');
      state.userData = {};
      sessionStorage.clear();
      return window.location.reload();
    },
  },
});

export const { setUserStatus, setUserData, logout } = UserState.actions;

export default UserState.reducer;
