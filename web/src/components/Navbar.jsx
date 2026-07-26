import { Avatar, Button, DropdownMenu } from '@radix-ui/themes';
import React from 'react'
import { useDispatch, useSelector } from 'react-redux';
import { Link, useNavigate } from 'react-router-dom'
import { RENT_HOUSE_PATH, authHeader } from '../api/paths';
import { toast } from 'react-toastify';
import { logout } from '../redux/features/user';

function Navbar() {
    const navigate = useNavigate()
    const dispatch = useDispatch()
    const user = useSelector((state)=>state.UserReduce.userData)
    function rentHouse() {
        fetch(RENT_HOUSE_PATH.url, {
					method: RENT_HOUSE_PATH.method,
					headers: authHeader(),
				})
					.then(async (r) => {
						if (r.status === 200) {
							toast.success("Eh bien....");
							window.location.reload();
						} else {
							toast.error("Unable to rent the house");
						}
					})
					.catch(() => {
						toast.error("Network error, please try again");
					});
    }
    function handleLogout() {
        dispatch(logout())
    }
  return (
		<nav>
			<div className='flex justify-between items-center p-5'>
				<Link
					to={"/"}
					className='text-2xl font-bold uppercase text-blue-700'>
					Easyroom
				</Link>
				<div className='flex items-center gap-5 text-lg'>
					<Link to={""}>Home</Link>
					<Link to={""}>Location</Link>
					<Link to={""}>Rental</Link>
					<Link to={""}>Faq</Link>
				</div>
				<div className='flex items-center gap-2'>
					{!sessionStorage.getItem("token") ? (
						<>
							<Link
								className='text-blue'
								to={"/login"}>
								Login
							</Link>
							<span>/</span>
							<Button
								variant={"solid"}
								onClick={() => navigate("/register")}>
								Register
							</Button>
						</>
					) : (
						<>
						<DropdownMenu.Root>
							<DropdownMenu.Trigger>
								<div>
								<Avatar
									
									fallback={((user?.name?.[0] ?? "") + (user?.lastname?.[0] ?? "")) || "?"}
								/>
								
								</div>
							</DropdownMenu.Trigger>
							<DropdownMenu.Content>
							{user?.ren_house === 0 ? (
								<Button
									color={"gold"}
									onClick={rentHouse}>
									Rent house
								</Button>
							) : (
								<Button
									color={"gold"}
									onClick={() => navigate("/dashboard")}>
									Dashboard
								</Button>
							)}
							<DropdownMenu.Separator />
							
							<Button
								variant={"solid"}
								color={"red"}
								onClick={handleLogout}>
								Déconnexion
							</Button>
							</DropdownMenu.Content>
						</DropdownMenu.Root>
							
						</>
					)}
				</div>
			</div>
		</nav>
	);
}

export default Navbar