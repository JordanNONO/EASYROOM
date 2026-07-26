import { Heading } from "@radix-ui/themes";
import { IoSearchOutline, IoChatbubbleOutline, IoKeyOutline } from "react-icons/io5";

const STEPS = [
	{
		icon: IoSearchOutline,
		title: "Cherche",
		text: "Parcours les annonces de particuliers et les résidences CROUS à Limoges, avec la distance au transport le plus proche pour chacune.",
	},
	{
		icon: IoChatbubbleOutline,
		title: "Contacte",
		text: "Mets un logement en favori, contacte le propriétaire ou candidate directement auprès du CROUS pour les résidences étudiantes.",
	},
	{
		icon: IoKeyOutline,
		title: "Emménage",
		text: "Signe ton bail l'esprit tranquille : notre check-list (état des lieux, garant, assurance, APL) t'accompagne jusqu'aux clés.",
	},
];

function HowItWorks() {
	return (
		<section className='mx-auto max-w-6xl px-6 py-16'>
			<Heading className='font-display !text-3xl mb-10 text-center'>
				Comment ça marche
			</Heading>
			<div className='grid grid-cols-1 md:grid-cols-3 gap-8'>
				{STEPS.map(({ icon: Icon, title, text }, index) => (
					<div key={title} className='relative text-center px-4'>
						<div className='mx-auto mb-4 w-14 h-14 rounded-full bg-brass-light flex items-center justify-center'>
							<Icon size={24} className='text-brass' />
						</div>
						<span className='block text-xs font-semibold text-brass mb-1'>
							Étape {index + 1}
						</span>
						<Heading size={"4"} className='!text-ink mb-2'>
							{title}
						</Heading>
						<p className='text-ink-soft text-sm leading-relaxed'>{text}</p>
					</div>
				))}
			</div>
		</section>
	);
}

export default HowItWorks;
