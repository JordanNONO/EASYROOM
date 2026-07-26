import { Heading } from "@radix-ui/themes";
import Seo from "../components/Seo";

function MentionsLegales() {
	return (
		<div className='mx-auto max-w-3xl px-6 py-16'>
			<Seo title='Mentions légales | EasyRoom' canonicalPath='/mentions-legales' noindex />
			<Heading className='font-display !text-3xl mb-8'>Mentions légales</Heading>
			<div className='flex flex-col gap-6 text-ink-soft'>
				<p className='rounded-lg bg-brass-light text-brass px-4 py-3 text-sm'>
					Page à compléter avant la mise en ligne publique du site (obligatoire en France pour tout site accessible au public).
				</p>
				<section>
					<Heading size={"4"} className='!text-ink mb-2'>
						Éditeur du site
					</Heading>
					<p>[Nom / raison sociale] — [adresse] — [email de contact]</p>
				</section>
				<section>
					<Heading size={"4"} className='!text-ink mb-2'>
						Hébergement
					</Heading>
					<p>Site : Vercel Inc. — API : [hébergeur du backend, ex. Render]</p>
				</section>
				<section>
					<Heading size={"4"} className='!text-ink mb-2'>
						Directeur de la publication
					</Heading>
					<p>[Nom]</p>
				</section>
			</div>
		</div>
	);
}

export default MentionsLegales;
