export type Image = {
	src: string
	alt?: string
	caption?: string
}

export type Link = {
	text: string
	href: string
}

export type Hero = {
	title?: string
	text?: string
	image?: Image
	actions?: Link[]
}

export type SiteConfig = {
	website: string
	logo?: Image
	title: string
	subtitle?: string
	description: string
	image?: Image
	headerNavLinks?: Link[]
	footerNavLinks?: Link[]
	socialLinks?: Link[]
	hero?: Hero
	postsPerPage?: number
	projectsPerPage?: number
}

const siteConfig: SiteConfig = {
	website: 'https://mun.sh',
	title: 'Andrew Munro',
	subtitle: '@andrewmunro | mun.sh',
	description: "The personal website of Andrew Munro",
	image: {
		src: '/hero.jpg',
		alt: "Andrew Munro"
	},
	headerNavLinks: [
		{
			text: 'Home',
			href: '/'
		},
		{
			text: 'Projects',
			href: '/projects'
		},
		{
			text: 'Blog',
			href: '/blog'
		},
		{
			text: 'Tags',
			href: '/tags'
		}
	],
	footerNavLinks: [
		{
			text: 'Bio',
			href: '/bio'
		},
		{
			text: 'CV',
			href: '/cv'
		},
		{
			text: 'Contact',
			href: '/contact'
		},
		{
			text: 'RSS',
			href: '/rss.xml'
		}
	],
	socialLinks: [
		{
			text: 'Github',
			href: 'https://github.com/andrewmunro'
		},
		{
			text: 'LinkedIn',
			href: 'https://www.linkedin.com/in/andrew-munro-1a426787/'
		},
		{
			text: 'Bluesky',
			href: 'https://bsky.app/profile/synergies.bsky.social'
		}
	],
	hero: {
		title: '',
		text: `<p><b>I am</b> a software engineer, architect, technologist and tinkerer.</p>
			<p><b>I live</b> and work in <a href="https://maps.app.goo.gl/XLTrke6nzbkbTMsD6">Leeds, UK</a>.</p>
			<p><b>I co-founded</b> <a href="https://milkshake.io">Milkshake Games</a>, creators of <a href="https://golfparty.io">⛳ golfparty.io</a>.</p>
			<p><b>I love</b> to make multiplayer web games and currently working on <a href="https://ecs.milkshake.io">my own engine</a>.</p>
			<p><b>I share</b> life with my beautiful wife and our <a href="/cat">cat</a>.</p>
			`,
		image: {
			src: '/hero.jpg',
			alt: 'Andrew Munro'
		},
		actions: [
			// {
			// 	text: 'Get in Touch',
			// 	href: 'mailto:andrew@mun.sh'
			// }
		]
	},
	postsPerPage: 8,
	projectsPerPage: 8
}

export default siteConfig
