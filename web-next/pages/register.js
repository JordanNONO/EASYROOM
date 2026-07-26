import { Button, Card, Flex, Heading, TextField } from "@radix-ui/themes";
import { useState } from "react";
import { FaUser, FaLock } from "react-icons/fa6";
import Link from "next/link";
import { useRouter } from "next/router";
import { toast } from "react-toastify";
import { isNotEmpty } from "../lib/validate";
import { REGISTER_PATH } from "../api/paths";
import Seo from "../components/Seo";
import Logo from "../components/Logo";

function Register() {
	const [userData, setUserData] = useState({
		contact: "",
		name: "",
		lastname: "",
		password: "",
	});
	const [submitting, setSubmitting] = useState(false);
	const router = useRouter();

	function handleChangeData(e) {
		setUserData((prevData) => ({
			...prevData,
			[e.target?.id]: e.target?.value,
		}));
	}

	const handleRegister = (e) => {
		e.preventDefault();
		if (!isNotEmpty(userData)) {
			toast.warn("Merci de remplir tous les champs.");
			return;
		}
		setSubmitting(true);
		fetch(REGISTER_PATH.url, {
			method: REGISTER_PATH.method,
			headers: REGISTER_PATH.headers,
			body: JSON.stringify(userData),
		})
			.then(async (response) => {
				if (response.status === 201) {
					toast.success("Bienvenue sur EasyRoom !");
					return router.push("/login");
				}
				toast.error(await response.text());
			})
			.catch(() => toast.error("Erreur réseau, réessaie."))
			.finally(() => setSubmitting(false));
	};

	return (
		<div className='flex flex-col justify-center items-center py-24 px-6'>
			<Seo
				title='Créer un compte | EasyRoom'
				description='Crée ton compte EasyRoom pour publier une annonce ou sauvegarder tes favoris.'
				canonicalPath='/register'
				noindex
			/>
			<Link href='/' className='mb-8'>
				<Logo />
			</Link>
			<Card style={{ width: 450 }} className='p-6 shadow-sm'>
				<Heading className='font-display mb-1 !text-2xl'>Créer un compte</Heading>
				<p className='text-ink-soft text-sm mb-5'>
					Pour publier une annonce ou sauvegarder tes favoris.
				</p>
				<form onSubmit={handleRegister}>
					<TextField.Root className='mb-3'>
						<TextField.Slot>
							<FaUser />
						</TextField.Slot>
						<TextField.Input
							type='tel'
							id='contact'
							aria-label='Contact'
							onChange={handleChangeData}
							size={"3"}
							placeholder='Numéro de téléphone'
						/>
					</TextField.Root>
					<Flex gap={"2"}>
						<TextField.Root className='mb-3 flex-1'>
							<TextField.Slot>
								<FaUser />
							</TextField.Slot>
							<TextField.Input
								type='text'
								id='name'
								aria-label='Prénom'
								onChange={handleChangeData}
								size={"3"}
								placeholder='Prénom'
							/>
						</TextField.Root>
						<TextField.Root className='mb-3 flex-1'>
							<TextField.Slot>
								<FaUser />
							</TextField.Slot>
							<TextField.Input
								type='text'
								id='lastname'
								aria-label='Nom'
								onChange={handleChangeData}
								size={"3"}
								placeholder='Nom'
							/>
						</TextField.Root>
					</Flex>
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
						{submitting ? "Création..." : "Créer mon compte"}
					</Button>
				</form>
				<p className='text-sm text-ink-soft mt-4'>
					Déjà un compte ?{" "}
					<Link href={"/login"} className='text-brass font-medium'>
						Connecte-toi
					</Link>
				</p>
			</Card>
		</div>
	);
}

export default Register;
