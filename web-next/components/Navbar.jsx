import { Avatar, Button, DropdownMenu } from "@radix-ui/themes";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import Link from "next/link";
import { useRouter } from "next/router";
import { RENT_HOUSE_PATH, authHeader } from "../api/paths";
import { toast } from "react-toastify";
import { logout } from "../redux/features/user";
import Logo from "./Logo";

function Navbar() {
	const router = useRouter();
	const dispatch = useDispatch();
	const user = useSelector((state) => state.UserReduce.userData);
	const [hasToken, setHasToken] = useState(false);

	useEffect(() => {
		setHasToken(!!sessionStorage.getItem("token"));
	}, []);

	function rentHouse() {
		fetch(RENT_HOUSE_PATH.url, {
			method: RENT_HOUSE_PATH.method,
			headers: authHeader(),
		})
			.then(async (r) => {
				if (r.status === 200) {
					toast.success("C'est noté, ta maison est maintenant en location !");
					window.location.reload();
				} else {
					toast.error("Impossible de mettre la maison en location.");
				}
			})
			.catch(() => {
				toast.error("Erreur réseau, réessaie.");
			});
	}
	function handleLogout() {
		dispatch(logout());
		toast.success("À bientôt !");
		router.push("/");
	}
	return (
		<nav className='sticky top-0 z-20 bg-paper/95 backdrop-blur border-b border-line'>
			<div className='mx-auto max-w-6xl flex justify-between items-center px-6 py-4'>
				<Link href={"/"}>
					<Logo />
				</Link>
				<div className='hidden md:flex items-center gap-8 text-sm font-medium text-ink-soft'>
					<Link href={"/#logements"} className='hover:text-brass transition-colors'>
						Logements
					</Link>
					<Link href={"/#crous"} className='hover:text-brass transition-colors'>
						Résidences CROUS
					</Link>
					<Link href={"/blog"} className='hover:text-brass transition-colors'>
						Blog
					</Link>
					<Link href={"/faq"} className='hover:text-brass transition-colors'>
						FAQ
					</Link>
				</div>
				<div className='flex items-center gap-3'>
					{!hasToken ? (
						<>
							<Link className='text-sm font-medium text-ink hover:text-brass transition-colors' href={"/login"}>
								Se connecter
							</Link>
							<Button variant={"solid"} onClick={() => router.push("/register")}>
								Publier une annonce
							</Button>
						</>
					) : (
						<>
							<DropdownMenu.Root>
								<DropdownMenu.Trigger>
									<button type='button' className='cursor-pointer' aria-label='Ouvrir le menu du compte'>
										<Avatar
											fallback={((user?.name?.[0] ?? "") + (user?.lastname?.[0] ?? "")) || "?"}
										/>
									</button>
								</DropdownMenu.Trigger>
								<DropdownMenu.Content>
									{user?.ren_house === 0 ? (
										<DropdownMenu.Item onClick={rentHouse}>Mettre en location</DropdownMenu.Item>
									) : (
										<DropdownMenu.Item onClick={() => router.push("/dashboard")}>
											Tableau de bord
										</DropdownMenu.Item>
									)}
									<DropdownMenu.Separator />
									<DropdownMenu.Item color='red' onClick={handleLogout}>
										Déconnexion
									</DropdownMenu.Item>
								</DropdownMenu.Content>
							</DropdownMenu.Root>
						</>
					)}
				</div>
			</div>
		</nav>
	);
}

export default Navbar;
