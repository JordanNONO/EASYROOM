import Head from "next/head";

const SITE_NAME = "EasyRoom";
const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:3000";

function Seo({
	title,
	description,
	canonicalPath = "/",
	ogImage,
	jsonLd,
	noindex = false,
}) {
	const canonicalUrl = `${SITE_URL}${canonicalPath}`;

	return (
		<Head>
			<title>{title}</title>
			{description ? <meta name='description' content={description} /> : null}
			<link rel='canonical' href={canonicalUrl} />
			{noindex ? (
				<meta name='robots' content='noindex, nofollow' />
			) : (
				<meta name='robots' content='index, follow' />
			)}
			<meta property='og:type' content='website' />
			<meta property='og:site_name' content={SITE_NAME} />
			<meta property='og:title' content={title} />
			{description ? (
				<meta property='og:description' content={description} />
			) : null}
			<meta property='og:url' content={canonicalUrl} />
			{ogImage ? <meta property='og:image' content={ogImage} /> : null}
			<meta
				name='twitter:card'
				content={ogImage ? "summary_large_image" : "summary"}
			/>
			{jsonLd ? (
				<script
					type='application/ld+json'
					dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
				/>
			) : null}
		</Head>
	);
}

export default Seo;
