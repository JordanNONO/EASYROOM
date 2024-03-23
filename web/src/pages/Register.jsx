import { Button, Card, Flex, Heading, TextField } from "@radix-ui/themes";
import React, { useState } from "react";
import { FaUser, FaLock } from "react-icons/fa6";
import { Link, useNavigate } from "react-router-dom";
import { isNotEmpty } from "../lib/validate";
import { toast } from "react-toastify";
import { REGISTER_PATH } from "../api/paths";

function Register() {
	const [userData, setUserData] = useState({ contact: "",name:"",lastname:"", password: "" });
	//const { name,lastname,contact, password } = userData;
	function handleChangeData(e) {
		setUserData((prevData) => ({
			...prevData,
			[e.target?.id]: e.target?.value,
		}));
    }
    const navigate = useNavigate()
    const handleRegister = (e) => {
        e.preventDefault()
        if (isNotEmpty(userData)) {
            fetch(REGISTER_PATH.url, {
                method: REGISTER_PATH.method,
                headers: REGISTER_PATH.headers,
                body:JSON.stringify(userData)
            }).then(async(response) => {
                if (response.status === 201) {
                    toast.success("You are wellcome")
                    return navigate("/login")
                } else {
                    toast.error(await response.text)
                }
            })
        } else {
            return toast.warn("Field are empty")
        }
	};

	return (
		<div className='flex justify-center items-center py-24'>
			<Card
				style={{ width: 450 }}
				className='p-5'>
				<Heading className='mb-3'>Create your account</Heading>
				<form
					action=''
					method='post' onSubmit={handleRegister}>
					<TextField.Root className='mb-3'>
						<TextField.Slot>
							<FaUser />
						</TextField.Slot>
						<TextField.Input
							type='tel'
							id='contact'
							onChange={handleChangeData}
							size={"3"}
							placeholder='Contact'
						/>
					</TextField.Root>
					<Flex gap={"2"}>
						<TextField.Root className='mb-3'>
							<TextField.Slot>
								<FaUser />
							</TextField.Slot>
							<TextField.Input
								type='text'
								id='name'
								onChange={handleChangeData}
								size={"3"}
								placeholder='Name'
							/>
						</TextField.Root>
						<TextField.Root className='mb-3'>
							<TextField.Slot>
								<FaUser />
							</TextField.Slot>
							<TextField.Input
								type='text'
								id='lastname'
								onChange={handleChangeData}
								size={"3"}
								placeholder='lastname'
							/>
						</TextField.Root>
					</Flex>
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
						Register
					</Button>
				</form>
				<p>
					Have you account? <Link to={"/login"}>login her</Link>
				</p>
			</Card>
		</div>
	);
}

export default Register;
