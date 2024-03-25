import { useEffect, useState, useRef } from "react";
import { FETCH_USER_PATH } from "../api/paths";
import { useDispatch } from "react-redux";
import { setUserData } from "../redux/features/user";

export function useAuthStatus() {
	const [loggedIn, setLoggedIn] = useState(false);
	const [checkingStatus, setCheckingStatus] = useState(true);
	const isMounted = useRef(true);
	const dispatch = useDispatch();
	useEffect(() => {
		if (isMounted) {
			//const auth = sessionStorage.getItem("token");
			fetch(FETCH_USER_PATH.url, {
				...FETCH_USER_PATH,
			}).then(async (r) => {
				if (r.status === 200) {
					//const auth = sessionStorage.getItem("token");
					//if (auth) {
					setLoggedIn(true);
					//}
					const data = await r.json();
					dispatch(setUserData(data));
					setCheckingStatus(false);
				} else {
					setCheckingStatus(false);
				}
			});
		}

		return () => {
			isMounted.current = false;
		};
	}, [isMounted]);

	return { loggedIn, checkingStatus };
}
