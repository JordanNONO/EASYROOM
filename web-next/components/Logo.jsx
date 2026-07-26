function Logo({ className = "" }) {
	return (
		<span className={`inline-flex items-center gap-2 ${className}`}>
			<svg viewBox='0 0 100 100' className='w-7 h-7 shrink-0' fill='none' aria-hidden='true'>
				<path d='M50 8 L84 38 L82 38 L18 38 L16 38 Z' fill='#17233A' />
				<rect x='30' y='34' width='40' height='8' fill='#17233A' />
				<rect x='24' y='42' width='52' height='46' rx='3' fill='#17233A' />
				<rect x='43' y='61' width='14' height='27' rx='2' fill='#A9722F' />
			</svg>
			<span className='font-display text-xl leading-none'>
				<span className='text-ink'>easy</span>
				<span className='text-brass font-semibold'>room</span>
			</span>
		</span>
	);
}

export default Logo;
