import { useEffect, useState } from "react";

const PHOTOS = [
	"/img/photo-1484154218962-a197022b5858.avif",
	"https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=1200&q=80&fit=crop",
	"https://images.unsplash.com/photo-1486304873000-235643847519?w=1200&q=80&fit=crop",
	"https://images.unsplash.com/photo-1707903074794-e35472388c44?w=1200&q=80&fit=crop",
];

function HeroPhotos({ className = "" }) {
	const [index, setIndex] = useState(0);

	useEffect(() => {
		const timer = setInterval(() => {
			setIndex((current) => (current + 1) % PHOTOS.length);
		}, 5000);
		return () => clearInterval(timer);
	}, []);

	return (
		<div className={`relative overflow-hidden ${className}`}>
			{PHOTOS.map((src, photoIndex) => (
				<div
					key={src}
					className='absolute inset-0 bg-cover bg-center transition-opacity duration-1000 ease-in-out'
					style={{
						backgroundImage: `url(${src})`,
						opacity: photoIndex === index ? 1 : 0,
					}}
				/>
			))}
			<div className='absolute inset-0 bg-gradient-to-br from-brass/10 to-ink/15' />
		</div>
	);
}

export default HeroPhotos;
