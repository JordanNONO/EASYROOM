import { useEffect, useState, useRef } from "react";
import { FETCH_HOUSE_PATH } from "../api/paths";

export function useAuthStatus() {
	const [loggedIn, setLoggedIn] = useState(false);
	const [checkingStatus, setCheckingStatus] = useState(true);
	const isMounted = useRef(true);
	useEffect(() => {
		if (isMounted) {
			//const auth = sessionStorage.getItem("token");
			fetch(FETCH_HOUSE_PATH.url, {
				...FETCH_HOUSE_PATH,
			}).then(async (r) => {
				if (r.status === 200) {
					//const auth = sessionStorage.getItem("token");
					//if (auth) {
					setLoggedIn(true);
					//}
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
