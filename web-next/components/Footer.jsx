import Link from "next/link";
import Logo from "./Logo";

function Footer() {
	return (
		<footer className='border-t border-line bg-paper-raised'>
			<div className='mx-auto max-w-6xl px-6 py-10 flex flex-col sm:flex-row justify-between gap-8'>
				<div>
					<Logo className='mb-3' />
					<p className='text-sm text-ink-soft max-w-xs'>
						EasyRoom aide les étudiants à trouver un logement à Limoges :
						annonces, résidences CROUS et distance aux transports, au même
						endroit.
					</p>
				</div>
				<div className='flex gap-12 text-sm'>
					<div className='flex flex-col gap-2'>
						<span className='font-semibold text-ink mb-1'>Explorer</span>
						<Link href='/#logements' className='hover:text-brass'>
							Logements
						</Link>
						<Link href='/#crous' className='hover:text-brass'>
							Résidences CROUS
						</Link>
						<Link href='/blog' className='hover:text-brass'>
							Blog
						</Link>
						<Link href='/faq' className='hover:text-brass'>
							FAQ
						</Link>
					</div>
					<div className='flex flex-col gap-2'>
						<span className='font-semibold text-ink mb-1'>Compte</span>
						<Link href='/register' className='hover:text-brass'>
							Publier une annonce
						</Link>
						<Link href='/login' className='hover:text-brass'>
							Se connecter
						</Link>
					</div>
					<div className='flex flex-col gap-2'>
						<span className='font-semibold text-ink mb-1'>Légal</span>
						<Link href='/mentions-legales' className='hover:text-brass'>
							Mentions légales
						</Link>
					</div>
				</div>
			</div>
			<div className='border-t border-line py-4 text-center text-xs text-ink-soft'>
				© {new Date().getFullYear()} EasyRoom — Limoges
			</div>
		</footer>
	);
}

export default Footer;
