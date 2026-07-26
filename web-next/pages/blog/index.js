import Link from "next/link";
import { Heading } from "@radix-ui/themes";
import Seo from "../../components/Seo";
import { blogPosts } from "../../lib/blogPosts";

export async function getStaticProps() {
	return { props: {} };
}

function BlogIndex() {
	const jsonLd = {
		"@context": "https://schema.org",
		"@type": "Blog",
		name: "Le blog EasyRoom",
		blogPost: blogPosts.map((post) => ({
			"@type": "BlogPosting",
			headline: post.title,
			datePublished: post.publishedAt,
		})),
	};

	return (
		<div className='mx-auto max-w-4xl px-6 py-16'>
			<Seo
				title='Blog logement étudiant à Limoges | EasyRoom'
				description='Conseils pour trouver un logement étudiant à Limoges : CROUS, quartiers, transports, check-list avant de signer.'
				canonicalPath='/blog'
				jsonLd={jsonLd}
			/>
			<Heading className='font-display !text-3xl mb-2'>Le blog</Heading>
			<p className='text-ink-soft mb-10'>
				Des conseils concrets pour trouver et bien choisir ton logement
				étudiant à Limoges.
			</p>
			<div className='flex flex-col gap-8'>
				{blogPosts.map((post) => (
					<Link
						key={post.slug}
						href={`/blog/${post.slug}`}
						className='block rounded-2xl border border-line bg-white p-6 hover:shadow-md transition-shadow'>
						<time className='text-xs uppercase tracking-wide text-brass font-semibold'>
							{new Date(post.publishedAt).toLocaleDateString("fr-FR", {
								day: "numeric",
								month: "long",
								year: "numeric",
							})}
						</time>
						<Heading size={"4"} className='!text-ink mt-2 mb-2'>
							{post.title}
						</Heading>
						<p className='text-ink-soft'>{post.excerpt}</p>
					</Link>
				))}
			</div>
		</div>
	);
}

export default BlogIndex;
