import { useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { useRouter } from "next/router";
import { Heading, Button } from "@radix-ui/themes";
import { IoHeart, IoHeartOutline, IoArrowBack } from "react-icons/io5";
import { toast } from "react-toastify";
import Seo from "../../components/Seo";
import { BASE_URL } from "../../api/common";
import { favoritePath, authHeader } from "../../api/paths";

export async function getStaticPaths() {
	try {
		const response = await fetch(`${BASE_URL}/house?city=Limoges`);
		const houses = response.ok ? await response.json() : [];
		return {
			paths: houses.map((house) => ({ params: { id: String(house.id) } })),
			fallback: "blocking",
		};
	} catch (error) {
		return { paths: [], fallback: "blocking" };
	}
}

export async function getStaticProps({ params }) {
	try {
		const response = await fetch(`${BASE_URL}/house/${params.id}`);
		if (!response.ok) {
			return { notFound: true };
		}
		const house = await response.json();
		return { props: { house }, revalidate: 600 };
	} catch (error) {
		return { notFound: true };
	}
}

function HouseDetail({ house }) {
	const router = useRouter();
	const [favorite, setFavorite] = useState(!!house.favorite);
	const [pending, setPending] = useState(false);
	const ownerName = house.User?.name ?? house["User.name"] ?? null;
	const firstImage = house.images?.[0]?.image;
	const mapUrl =
		house.latitude && house.longitude
			? `https://www.openstreetmap.org/?mlat=${house.latitude}&mlon=${house.longitude}#map=16/${house.latitude}/${house.longitude}`
			: null;

	const description = house.description
		? house.description.slice(0, 155)
		: `Logement à ${house.location}`;

	const jsonLd = {
		"@context": "https://schema.org",
		"@type": "Apartment",
		name: house.label,
		description: house.description,
		image: house.images?.map((image) => image.image) ?? [],
		address: {
			"@type": "PostalAddress",
			streetAddress: house.location,
			addressLocality: house.city ?? "Limoges",
			addressCountry: "FR",
		},
		numberOfRooms: house.nbre_bedroom,
		offers: {
			"@type": "Offer",
			price: house.price,
			priceCurrency: "EUR",
			availability: house.is_rent
				? "https://schema.org/SoldOut"
				: "https://schema.org/InStock",
		},
	};

	function toggleFavorite() {
		if (typeof window === "undefined" || !sessionStorage.getItem("token")) {
			toast.info("Connecte-toi pour ajouter des favoris.");
			router.push("/login");
			return;
		}
		if (pending) return;
		setPending(true);
		const { url, method } = favoritePath(house.id);
		fetch(url, { method, headers: authHeader() })
			.then((r) => {
				if (!r.ok) throw new Error("request failed");
				setFavorite((current) => !current);
			})
			.catch(() => toast.error("Impossible de mettre à jour les favoris."))
			.finally(() => setPending(false));
	}

	return (
		<div className='max-w-5xl mx-auto px-6 py-10'>
			<Seo
				title={`${house.label} — ${house.location} | EasyRoom`}
				description={description}
				canonicalPath={`/house/${house.id}`}
				ogImage={firstImage}
				jsonLd={jsonLd}
			/>
			<Link
				href='/#logements'
				className='inline-flex items-center gap-2 text-sm text-ink-soft hover:text-brass mb-6'>
				<IoArrowBack /> Retour aux logements
			</Link>

			<div className='grid grid-cols-1 md:grid-cols-2 gap-3 mb-8 rounded-2xl overflow-hidden'>
				{house.images?.length > 0 ? (
					house.images.map((image) => (
						<Image
							key={image.id}
							src={image.image}
							alt={house.label}
							width={600}
							height={400}
							className='w-full h-auto object-cover'
						/>
					))
				) : (
					<div className='w-full h-[300px] bg-paper-raised flex items-center justify-center text-ink-soft'>
						Pas de photo
					</div>
				)}
			</div>

			<div className='grid grid-cols-1 md:grid-cols-3 gap-10'>
				<div className='md:col-span-2'>
					<div className='flex items-start justify-between gap-4 mb-1'>
						<Heading className='font-display !text-3xl'>{house.label}</Heading>
						<button
							type='button'
							aria-label={favorite ? "Retirer des favoris" : "Ajouter aux favoris"}
							aria-pressed={favorite}
							disabled={pending}
							onClick={toggleFavorite}
							className='shrink-0 rounded-full border border-line p-2 hover:scale-110 transition-transform disabled:opacity-60'>
							{favorite ? (
								<IoHeart size={20} className='text-brass' />
							) : (
								<IoHeartOutline size={20} className='text-ink-soft' />
							)}
						</button>
					</div>
					<p className='text-ink-soft mb-6'>{house.location}</p>

					<p className='mb-6 leading-relaxed'>{house.description}</p>

					<ul className='mb-6 flex flex-wrap gap-3 text-sm'>
						<li className='bg-paper-raised rounded-full px-3 py-1'>
							{house.nbre_bedroom} chambre{house.nbre_bedroom > 1 ? "s" : ""}
						</li>
						<li className='bg-paper-raised rounded-full px-3 py-1'>
							{house.has_bathroom ? "Salle de bain incluse" : "Sans salle de bain"}
						</li>
						<li className='bg-paper-raised rounded-full px-3 py-1'>
							{house.has_kitchen ? "Cuisine incluse" : "Sans cuisine"}
						</li>
					</ul>

					{house.options?.length > 0 ? (
						<ul className='mb-6 flex flex-wrap gap-2'>
							{house.options.map((option) => (
								<li
									key={option.id}
									className='text-sm border border-line rounded-full px-3 py-1'>
									{option.label}
								</li>
							))}
						</ul>
					) : null}

					{ownerName ? (
						<p className='text-sm text-ink-soft'>Proposé par {ownerName}</p>
					) : null}
				</div>

				<aside className='md:col-span-1'>
					<div className='sticky top-24 rounded-2xl border border-line bg-white p-6 shadow-sm'>
						<Heading size={"6"} className='font-display !text-ink mb-1'>
							{house.price} €
						</Heading>
						<p className='text-ink-soft text-sm mb-5'>par mois</p>

						{house.nearest_stop ? (
							<p className='text-sm text-ink-soft mb-5 bg-brass-light text-brass rounded-lg px-3 py-2'>
								{house.nearest_stop.name} à {Math.round(house.nearest_stop.distanceMeters)} m
							</p>
						) : null}

						{mapUrl ? (
							<a href={mapUrl} target='_blank' rel='noreferrer' className='block'>
								<Button variant='outline' className='w-full cursor-pointer mb-3'>
									Voir sur la carte
								</Button>
							</a>
						) : null}
						<Button className='w-full cursor-pointer' onClick={toggleFavorite} disabled={pending}>
							{favorite ? "Retirer des favoris" : "Ajouter aux favoris"}
						</Button>
					</div>
				</aside>
			</div>
		</div>
	);
}

export default HouseDetail;
