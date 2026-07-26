function Stat({ value, label }) {
	return (
		<div className='text-center'>
			<div className='font-display text-3xl text-brass'>{value}</div>
			<div className='text-xs uppercase tracking-wide text-ink-soft mt-1'>{label}</div>
		</div>
	);
}

function TrustBar({ houseCount, crousCount }) {
	return (
		<section className='bg-white border-b border-line'>
			<div className='mx-auto max-w-6xl px-6 py-8 flex flex-col sm:flex-row items-center justify-around gap-8'>
				<Stat value={houseCount} label='Logements à Limoges' />
				<Stat value={crousCount} label='Résidences CROUS référencées' />
				<Stat value='100%' label='Données transport officielles' />
			</div>
		</section>
	);
}

export default TrustBar;
