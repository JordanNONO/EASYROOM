import { Heading } from "@radix-ui/themes";
import Seo from "../components/Seo";

const QUESTIONS = [
	{
		q: "EasyRoom, c'est quoi exactement ?",
		a: "Un site pour trouver un logement à Limoges : des annonces publiées par des particuliers, et les résidences étudiantes du CROUS, avec la distance au transport en commun le plus proche pour chaque logement.",
	},
	{
		q: "C'est gratuit ?",
		a: "Oui. Chercher un logement et publier une annonce sont gratuits pour l'instant.",
	},
	{
		q: "Comment je publie une annonce ?",
		a: "Crée un compte, puis rends-toi sur ton tableau de bord pour ajouter ton logement avec ses photos et ses informations.",
	},
	{
		q: "Les résidences CROUS, ce sont des annonces EasyRoom ?",
		a: "Non — ce sont des informations publiques sur les résidences étudiantes gérées par le CROUS de Limoges, affichées ici pour te faire gagner du temps. Pour candidater, passe par le site du CROUS.",
	},
	{
		q: "D'où viennent les distances aux transports ?",
		a: "Des données ouvertes officielles de Limoges Métropole, mises à jour régulièrement.",
	},
];

function Faq() {
	return (
		<div className='mx-auto max-w-3xl px-6 py-16'>
			<Seo
				title='FAQ | EasyRoom'
				description='Questions fréquentes sur la recherche de logement étudiant à Limoges avec EasyRoom.'
				canonicalPath='/faq'
			/>
			<Heading className='font-display !text-3xl mb-8'>Questions fréquentes</Heading>
			<div className='flex flex-col gap-6'>
				{QUESTIONS.map(({ q, a }) => (
					<div key={q} className='border-b border-line pb-6'>
						<Heading size={"4"} className='!text-ink mb-2'>
							{q}
						</Heading>
						<p className='text-ink-soft'>{a}</p>
					</div>
				))}
			</div>
		</div>
	);
}

export default Faq;
