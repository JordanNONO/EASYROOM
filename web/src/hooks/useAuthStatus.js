import { useEffect, useState, useRef } from "react";
import { FETCH_USER_PATH, authHeader } from "../api/paths";
import { useDispatch } from "react-redux";
import { setUserData } from "../redux/features/user";

export function useAuthStatus() {
	const [loggedIn, setLoggedIn] = useState(false);
	const [checkingStatus, setCheckingStatus] = useState(true);
	const isMounted = useRef(true);
	const dispatch = useDispatch();
	useEffect(() => {
		isMounted.current = true;

		fetch(FETCH_USER_PATH.url, {
			method: FETCH_USER_PATH.method,
			headers: authHeader(),
		})
			.then(async (r) => {
				if (!isMounted.current) return;
				if (r.status === 200) {
					const data = await r.json();
					dispatch(setUserData(data));
					setLoggedIn(true);
				}
				setCheckingStatus(false);
			})
			.catch(() => {
				if (isMounted.current) setCheckingStatus(false);
			});

		return () => {
			isMounted.current = false;
		};
	}, [dispatch]);

	return { loggedIn, checkingStatus };
}
