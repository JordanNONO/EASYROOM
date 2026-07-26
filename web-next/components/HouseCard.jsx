import { useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { useRouter } from "next/router";
import { Heading } from "@radix-ui/themes";
import { IoHeart, IoHeartOutline, IoBedOutline, IoWaterOutline, IoRestaurantOutline } from "react-icons/io5";
import { toast } from "react-toastify";
import { favoritePath, authHeader } from "../api/paths";

function HouseCard({ house }) {
	const router = useRouter();
	const [favorite, setFavorite] = useState(!!house.favorite);
	const [pending, setPending] = useState(false);
	const firstImage = house.images?.[0]?.image;
	const stopLabel = house.nearest_stop
		? `${house.nearest_stop.name} · ${Math.round(house.nearest_stop.distanceMeters)} m`
		: null;

	function toggleFavorite(event) {
		event.preventDefault();
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
		<div className='group flex flex-col gap-3 rounded-2xl border border-line bg-white p-3 shadow-sm hover:shadow-md transition-shadow'>
			<div className='relative'>
				<Link href={`/house/${house.id}`} className='block overflow-hidden rounded-xl'>
					{firstImage ? (
						<Image
							className='w-full h-[180px] object-cover group-hover:scale-105 transition-transform duration-300'
							src={firstImage}
							alt={house.label}
							width={480}
							height={320}
						/>
					) : (
						<div className='w-full h-[180px] bg-paper-raised flex items-center justify-center text-ink-soft text-sm'>
							Pas de photo
						</div>
					)}
				</Link>
				<button
					type='button'
					aria-label={favorite ? "Retirer des favoris" : "Ajouter aux favoris"}
					aria-pressed={favorite}
					onClick={toggleFavorite}
					disabled={pending}
					className='absolute top-2 right-2 inline-flex rounded-full bg-white/90 p-2 shadow-sm hover:scale-110 transition-transform disabled:opacity-60'>
					{favorite ? (
						<IoHeart size={20} className='text-brass' />
					) : (
						<IoHeartOutline size={20} className='text-ink-soft' />
					)}
				</button>
			</div>
			<Link href={`/house/${house.id}`}>
				<Heading size={"3"} className='!text-ink'>
					{house.label}
				</Heading>
			</Link>
			<p className='text-ink-soft text-sm -mt-2'>{house.location}</p>
			<div className='flex items-center gap-3 text-ink-soft text-xs -mt-1'>
				<span className='inline-flex items-center gap-1'>
					<IoBedOutline size={14} /> {house.nbre_bedroom}
				</span>
				{house.has_bathroom ? (
					<span className='inline-flex items-center gap-1'>
						<IoWaterOutline size={14} /> Sdb
					</span>
				) : null}
				{house.has_kitchen ? (
					<span className='inline-flex items-center gap-1'>
						<IoRestaurantOutline size={14} /> Cuisine
					</span>
				) : null}
			</div>
			{stopLabel ? (
				<span className='inline-flex items-center gap-1 w-fit text-xs bg-brass-light text-brass rounded-full px-2 py-1'>
					{stopLabel}
				</span>
			) : null}
			<Heading size={"3"} className='!text-ink !font-display'>
				{house.price} € <span className='text-sm font-normal text-ink-soft'>/ mois</span>
			</Heading>
		</div>
	);
}

export default HouseCard;
