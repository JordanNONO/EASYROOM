import { Button, Card, Heading, TextField } from "@radix-ui/themes";
import React, { useState } from "react";
import {FaUser,FaLock} from "react-icons/fa6"
import { Link } from "react-router-dom";

function Login() {
    const [userData, setUserData] = useState({ username: "", password: "" });
    const { username, password } = userData
    function handleChangeData(e) {
        setUserData((prevData) => (({
            ...prevData,
            [e.target?.id]:e.target?.value
        })))
    }
	const handleLogin = () => {
		// Handle login logic here
		console.log("Logging in with:", username, password);
	};

    return (
			<div className='flex justify-center items-center py-24'>
				<Card
					style={{ width: 400 }}
					className='p-5'>
					<Heading className='mb-3'>Login her</Heading>
					<form
						action=''
						method='post'>
						<TextField.Root className='mb-3'>
							<TextField.Slot>
								<FaUser />
							</TextField.Slot>
							<TextField.Input
								id='username'
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
                            type="password"
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
