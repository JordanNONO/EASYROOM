import { useEffect, useState } from "react";
import { Heading } from "@radix-ui/themes";
import { FaBuilding } from "react-icons/fa6";
import AddHouseForm from "../components/AddHouseForm";
import RequireAuth from "../components/RequireAuth";
import Seo from "../components/Seo";
import { FETCH_MY_HOUSES_PATH, authHeader } from "../api/paths";

function Dashboard() {
	const [myHouses, setMyHouses] = useState([]);
	const [loading, setLoading] = useState(true);

	useEffect(() => {
		fetch(FETCH_MY_HOUSES_PATH.url, { headers: authHeader() })
			.then((r) => (r.ok ? r.json() : []))
			.then(setMyHouses)
			.catch(() => setMyHouses([]))
			.finally(() => setLoading(false));
	}, []);

	return (
		<RequireAuth>
			<Seo
				title='Tableau de bord | EasyRoom'
				description='Gérez vos annonces EasyRoom.'
				canonicalPath='/dashboard'
				noindex
			/>
			<div className='mx-auto max-w-4xl px-6 py-12'>
				<Heading className='font-display !text-3xl mb-8'>Tableau de bord</Heading>

				<div className='flex items-center gap-4 rounded-2xl border border-line bg-white p-5 mb-10 w-fit'>
					<div className='bg-brass-light rounded-xl p-3'>
						<FaBuilding size={24} className='text-brass' />
					</div>
					<div>
						<div className='font-display text-3xl text-ink'>
							{loading ? "…" : myHouses.length}
						</div>
						<div className='text-xs uppercase tracking-wide text-ink-soft'>
							Annonce{myHouses.length > 1 ? "s" : ""} publiée{myHouses.length > 1 ? "s" : ""}
						</div>
					</div>
				</div>

				{myHouses.length > 0 ? (
					<div className='mb-12'>
						<Heading size={"4"} className='!text-ink mb-4'>
							Mes annonces
						</Heading>
						<div className='flex flex-col gap-3'>
							{myHouses.map((house) => (
								<div
									key={house.id}
									className='flex items-center justify-between rounded-xl border border-line bg-white p-4'>
									<div>
										<div className='font-medium text-ink'>{house.label}</div>
										<div className='text-sm text-ink-soft'>{house.location}</div>
									</div>
									<div className='font-display text-ink'>{house.price} €</div>
								</div>
							))}
						</div>
					</div>
				) : null}

				<Heading size={"4"} className='!text-ink mb-4'>
					Publier une nouvelle annonce
				</Heading>
				<AddHouseForm />
			</div>
		</RequireAuth>
	);
}

export default Dashboard;
