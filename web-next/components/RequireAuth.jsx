import { useEffect } from "react";
import { useRouter } from "next/router";
import { useAuthStatus } from "../hooks/useAuthStatus";
import LoadingPage from "./LoadingPage";

function RequireAuth({ children }) {
	const router = useRouter();
	const { loggedIn, checkingStatus } = useAuthStatus();

	useEffect(() => {
		if (!checkingStatus && !loggedIn) {
			router.replace("/login");
		}
	}, [checkingStatus, loggedIn, router]);

	if (checkingStatus || !loggedIn) {
		return <LoadingPage />;
	}

	return children;
}

export default RequireAuth;
