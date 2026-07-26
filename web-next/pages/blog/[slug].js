import Link from "next/link";
import { Heading } from "@radix-ui/themes";
import { IoArrowBack } from "react-icons/io5";
import Seo from "../../components/Seo";
import { blogPosts, getBlogPost } from "../../lib/blogPosts";

export async function getStaticPaths() {
	return {
		paths: blogPosts.map((post) => ({ params: { slug: post.slug } })),
		fallback: false,
	};
}

export async function getStaticProps({ params }) {
	const post = getBlogPost(params.slug);
	if (!post) return { notFound: true };
	return { props: { post } };
}

function BlogPost({ post }) {
	const jsonLd = {
		"@context": "https://schema.org",
		"@type": "BlogPosting",
		headline: post.title,
		description: post.excerpt,
		datePublished: post.publishedAt,
	};

	return (
		<article className='mx-auto max-w-3xl px-6 py-16'>
			<Seo
				title={`${post.title} | Blog EasyRoom`}
				description={post.excerpt}
				canonicalPath={`/blog/${post.slug}`}
				jsonLd={jsonLd}
			/>
			<Link
				href='/blog'
				className='inline-flex items-center gap-2 text-sm text-ink-soft hover:text-brass mb-6'>
				<IoArrowBack /> Retour au blog
			</Link>
			<time className='text-xs uppercase tracking-wide text-brass font-semibold'>
				{new Date(post.publishedAt).toLocaleDateString("fr-FR", {
					day: "numeric",
					month: "long",
					year: "numeric",
				})}
			</time>
			<Heading className='font-display !text-3xl mt-2 mb-8'>{post.title}</Heading>
			<div className='flex flex-col gap-8'>
				{post.sections.map((section) => (
					<section key={section.heading}>
						<Heading size={"4"} className='!text-ink mb-3'>
							{section.heading}
						</Heading>
						{section.paragraphs.map((paragraph, index) => (
							<p key={index} className='text-ink-soft leading-relaxed mb-3'>
								{paragraph}
							</p>
						))}
					</section>
				))}
			</div>
		</article>
	);
}

export default BlogPost;
