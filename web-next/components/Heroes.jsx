import Link from "next/link";
import { Button } from "@radix-ui/themes";
import HeroPhotos from "./HeroPhotos";

function Heroes() {
	return (
		<section className='bg-paper overflow-hidden'>
			<div className='mx-auto max-w-6xl grid grid-cols-1 lg:grid-cols-2 items-center gap-10 px-6 py-16 lg:py-20'>
				<div>
					<span className='inline-block mb-4 text-xs font-semibold uppercase tracking-wider text-brass bg-brass-light rounded-full px-3 py-1'>
						Limoges
					</span>
					<h1 className='font-display mb-5 text-4xl sm:text-5xl leading-tight text-ink'>
						Le logement étudiant à Limoges, sans le casse-tête
					</h1>
					<p className='mb-8 text-ink-soft text-lg'>
						Annonces réelles, résidences CROUS et distance aux transports en
						commun — tout au même endroit, pour trouver ta chambre ou ton
						appartement plus vite.
					</p>
					<div className='flex flex-wrap gap-4'>
						<a href='#logements'>
							<Button size={"4"} className='cursor-pointer'>
								Voir les logements
							</Button>
						</a>
						<Link href='/register'>
							<Button size={"4"} variant='outline' className='cursor-pointer'>
								Publier une annonce
							</Button>
						</Link>
					</div>
				</div>
				<HeroPhotos className='rounded-3xl h-64 sm:h-80 lg:h-[420px]' />
			</div>
		</section>
	);
}

export default Heroes;
