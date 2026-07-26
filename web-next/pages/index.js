import { useState } from "react";
import Link from "next/link";
import { Heading } from "@radix-ui/themes";
import Heroes from "../components/Heroes";
import SearchBar from "../components/SearchBar";
import HouseCard from "../components/HouseCard";
import TrustBar from "../components/TrustBar";
import HowItWorks from "../components/HowItWorks";
import Seo from "../components/Seo";
import { BASE_URL } from "../api/common";
import { blogPosts } from "../lib/blogPosts";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000";

export async function getStaticProps() {
	let houses = [];
	let crousResidences = [];
	try {
		const [housesRes, crousRes] = await Promise.all([
			fetch(`${BASE_URL}/house?city=Limoges`),
			fetch(`${BASE_URL}/campus/crous?city=Limoges`),
		]);
		houses = housesRes.ok ? await housesRes.json() : [];
		crousResidences = crousRes.ok ? await crousRes.json() : [];
	} catch (error) {
		houses = [];
		crousResidences = [];
	}

	return {
		props: { houses, crousResidences },
		revalidate: 600,
	};
}

function Home({ houses: initialHouses, crousResidences }) {
	const [houses, setHouses] = useState(initialHouses);
	const [activeQuery, setActiveQuery] = useState(null);

	const jsonLd = {
		"@context": "https://schema.org",
		"@type": "ItemList",
		itemListElement: initialHouses.map((house, index) => ({
			"@type": "ListItem",
			position: index + 1,
			url: `${SITE_URL}/house/${house.id}`,
			name: house.label,
		})),
	};

	function handleSearchResults(results, query) {
		setActiveQuery(query);
		setHouses(results ?? []);
	}

	function clearSearch() {
		setActiveQuery(null);
		setHouses(initialHouses);
	}

	return (
		<div>
			<Seo
				title='Logements à Limoges | EasyRoom'
				description='Trouvez votre logement étudiant à Limoges : appartements, colocations et résidences CROUS proches des transports.'
				canonicalPath='/'
				jsonLd={jsonLd}
			/>
			<Heroes />
			<SearchBar onResults={handleSearchResults} />
			<div className='pt-10'>
				<TrustBar houseCount={initialHouses.length} crousCount={crousResidences.length} />
			</div>
			<section id='logements' className='mx-auto max-w-6xl px-6 pt-16 pb-16 scroll-mt-20'>
				<Heading className='font-display !text-3xl mb-2'>
					{activeQuery ? `Résultats pour "${activeQuery}"` : "Logements disponibles à Limoges"}
				</Heading>
				<p className='text-ink-soft mb-8'>
					{activeQuery ? (
						<button onClick={clearSearch} className='underline hover:text-brass'>
							Réinitialiser la recherche
						</button>
					) : (
						<>
							{houses.length} logement{houses.length > 1 ? "s" : ""} publié
							{houses.length > 1 ? "s" : ""} par des particuliers, à jour.
						</>
					)}
				</p>
				{houses.length === 0 ? (
					<p className='rounded-xl border border-dashed border-line p-8 text-center text-ink-soft'>
						{activeQuery
							? "Aucun logement ne correspond à cette recherche."
							: "Aucun logement disponible pour le moment — reviens bientôt, ou sois le premier à en publier un."}
					</p>
				) : (
					<div className='grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 items-start'>
						{houses.map((house) => (
							<HouseCard key={house.id} house={house} />
						))}
					</div>
				)}
			</section>
			<HowItWorks />
			<section id='crous' className='bg-paper-raised border-y border-line'>
				<div className='mx-auto max-w-6xl px-6 py-16 scroll-mt-20'>
					<Heading className='font-display !text-3xl mb-2'>
						Résidences CROUS à Limoges
					</Heading>
					<p className='text-ink-soft mb-8 max-w-2xl'>
						Les résidences étudiantes gérées par le CROUS, en plus des
						annonces de particuliers ci-dessus.
					</p>
					{crousResidences.length === 0 ? (
						<p className='text-ink-soft'>Aucune résidence trouvée.</p>
					) : (
						<div className='grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4'>
							{crousResidences.map((residence) => (
								<div
									key={residence.id}
									className='p-5 bg-white border border-line rounded-xl'>
									<Heading size={"3"} className='!text-ink mb-1'>
										{residence.title}
									</Heading>
									<p className='text-ink-soft text-sm'>{residence.address}</p>
								</div>
							))}
						</div>
					)}
				</div>
			</section>
			<section className='mx-auto max-w-6xl px-6 py-16'>
				<div className='flex items-center justify-between mb-8'>
					<Heading className='font-display !text-3xl'>Depuis le blog</Heading>
					<Link href='/blog' className='text-brass font-medium text-sm hover:underline'>
						Tout voir →
					</Link>
				</div>
				<div className='grid grid-cols-1 sm:grid-cols-3 gap-6'>
					{blogPosts.slice(0, 3).map((post) => (
						<Link
							key={post.slug}
							href={`/blog/${post.slug}`}
							className='block rounded-2xl border border-line bg-white p-5 hover:shadow-md transition-shadow'>
							<Heading size={"3"} className='!text-ink mb-2'>
								{post.title}
							</Heading>
							<p className='text-ink-soft text-sm'>{post.excerpt}</p>
						</Link>
					))}
				</div>
			</section>
		</div>
	);
}

export default Home;
