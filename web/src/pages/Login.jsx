import { Button, Card, Heading, TextField } from "@radix-ui/themes";
import React, { useState } from "react";
import { FaUser, FaLock, FaPhone } from "react-icons/fa6";
import { Link, useNavigate } from "react-router-dom";
import { isNotEmpty } from "../lib/validate";
import { toast } from "react-toastify";
import { LOGIN_PATH } from "../api/paths";

function Login() {
	const [userData, setUserData] = useState({contact: "", password: "" });
	//const { username, password } = userData
	function handleChangeData(e) {
		setUserData((prevData) => ({
			...prevData,
			[e.target?.id]: e.target?.value,
		}));
    }
    const navigate = useNavigate()
    const handleLogin = (e) => {
        e.preventDefault()
		if (isNotEmpty(userData)) {
			fetch(LOGIN_PATH.url, {
				...LOGIN_PATH,
				body: JSON.stringify(userData),
			}).then(async (response) => {
                if (response.status === 200) {
                    const data = await response.json()
                    sessionStorage.setItem("token", data?.token)
                    return navigate("/")
				}
			});
		} else {
			return toast.warn("Field are empty");
		}
	};

	return (
		<div className='flex justify-center items-center py-24'>
			<Card
				style={{ width: 400 }}
				className='p-5'>
				<Heading className='mb-3'>Login her</Heading>
				<form
                    action=''
                    onSubmit={handleLogin}
					method='post'>
					<TextField.Root className='mb-3'>
						<TextField.Slot>
							<FaPhone />
						</TextField.Slot>
						<TextField.Input
							id='contact'
							onChange={handleChangeData}
							size={"3"}
							placeholder='Username'
						/>
					</TextField.Root>
					<TextField.Root className='mb-3'>
						<TextField.Slot>
							<FaLock />
						</TextField.Slot>
						<TextField.Input
							type='password'
							id='password'
							onChange={handleChangeData}
							size={"3"}
							placeholder='Password'
						/>
					</TextField.Root>
					<Button
						variant={"solid"}
						size={"3"}
						className='w-full'>
						Login
					</Button>
				</form>
				<p>
					You have not account? <Link to={"/register"}>register</Link>
				</p>
			</Card>
		</div>
	);
}

export default Login;
