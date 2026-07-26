import { Button, Card, Heading, TextField } from "@radix-ui/themes";
import { useState } from "react";
import { FaLock, FaPhone } from "react-icons/fa6";
import Link from "next/link";
import { useRouter } from "next/router";
import { toast } from "react-toastify";
import { isNotEmpty } from "../lib/validate";
import { LOGIN_PATH } from "../api/paths";
import Seo from "../components/Seo";
import Logo from "../components/Logo";

function Login() {
	const [userData, setUserData] = useState({ contact: "", password: "" });
	const [submitting, setSubmitting] = useState(false);
	const router = useRouter();

	function handleChangeData(e) {
		setUserData((prevData) => ({
			...prevData,
			[e.target?.id]: e.target?.value,
		}));
	}

	const handleLogin = (e) => {
		e.preventDefault();
		if (!isNotEmpty(userData)) {
			toast.warn("Merci de remplir tous les champs.");
			return;
		}
		setSubmitting(true);
		fetch(LOGIN_PATH.url, {
			method: LOGIN_PATH.method,
			headers: LOGIN_PATH.headers,
			body: JSON.stringify(userData),
		})
			.then(async (response) => {
				if (response.status === 200) {
					const data = await response.json();
					sessionStorage.setItem("token", data?.token);
					toast.success("Connexion réussie !");
					return router.push("/dashboard");
				}
				toast.error("Identifiant ou mot de passe incorrect.");
			})
			.catch(() => toast.error("Erreur réseau, réessaie."))
			.finally(() => setSubmitting(false));
	};

	return (
		<div className='flex flex-col justify-center items-center py-24 px-6'>
			<Seo
				title='Connexion | EasyRoom'
				description='Connecte-toi à ton compte EasyRoom.'
				canonicalPath='/login'
				noindex
			/>
			<Link href='/' className='mb-8'>
				<Logo />
			</Link>
			<Card style={{ width: 400 }} className='p-6 shadow-sm'>
				<Heading className='font-display mb-1 !text-2xl'>Content de te revoir</Heading>
				<p className='text-ink-soft text-sm mb-5'>Connecte-toi pour continuer.</p>
				<form onSubmit={handleLogin}>
					<TextField.Root className='mb-3'>
						<TextField.Slot>
							<FaPhone />
						</TextField.Slot>
						<TextField.Input
							id='contact'
							aria-label='Identifiant'
							onChange={handleChangeData}
							size={"3"}
							placeholder='Numéro / identifiant'
						/>
					</TextField.Root>
					<TextField.Root className='mb-5'>
						<TextField.Slot>
							<FaLock />
						</TextField.Slot>
						<TextField.Input
							type='password'
							id='password'
							aria-label='Mot de passe'
							onChange={handleChangeData}
							size={"3"}
							placeholder='Mot de passe'
						/>
					</TextField.Root>
					<Button variant={"solid"} size={"3"} className='w-full cursor-pointer' disabled={submitting}>
						{submitting ? "Connexion..." : "Se connecter"}
					</Button>
				</form>
				<p className='text-sm text-ink-soft mt-4'>
					Pas encore de compte ?{" "}
					<Link href={"/register"} className='text-brass font-medium'>
						Inscris-toi
					</Link>
				</p>
			</Card>
		</div>
	);
}

export default Login;
