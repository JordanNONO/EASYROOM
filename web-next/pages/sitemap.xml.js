import { BASE_URL } from "../api/common";
import { blogPosts } from "../lib/blogPosts";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000";

function Sitemap() {
	return null;
}

export async function getServerSideProps({ res }) {
	let houses = [];
	try {
		const response = await fetch(`${BASE_URL}/house?city=Limoges`);
		if (response.ok) {
			houses = await response.json();
		}
	} catch (error) {
		houses = [];
	}

	const urls = [
		`${SITE_URL}/`,
		`${SITE_URL}/blog`,
		`${SITE_URL}/faq`,
		...houses.map((house) => `${SITE_URL}/house/${house.id}`),
		...blogPosts.map((post) => `${SITE_URL}/blog/${post.slug}`),
	];

	const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls
	.map(
		(url) => `  <url>
    <loc>${url}</loc>
  </url>`,
	)
	.join("\n")}
</urlset>`;

	res.setHeader("Content-Type", "text/xml");
	res.write(xml);
	res.end();

	return { props: {} };
}

export default Sitemap;
