import { glob } from 'astro/loaders'
import { defineCollection, z } from 'astro:content'

const seoSchema = z.object({
	title: z.string().min(3).max(120).optional(),
	description: z.string().min(3).max(160).optional(),
	image: z
		.object({
			src: z.string(),
			alt: z.string().optional()
		})
		.optional(),
	pageType: z.enum(['website', 'article']).default('website')
})

const blog = defineCollection({
	loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
	schema: z.object({
		title: z.string(),
		excerpt: z.string().optional(),
		publishDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		isFeatured: z.boolean().default(false),
		tags: z.array(z.string()).default([]),
		repo: z.string().optional(),
		seo: seoSchema.optional()
	})
})

const pages = defineCollection({
	loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/pages' }),
	schema: z.object({
		title: z.string(),
		action: z.object({
			text: z.string(),
			href: z.string()
		}).optional(),
		seo: seoSchema.optional()
	})
})

const projects = defineCollection({
	loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects' }),
	schema: z.object({
		title: z.string(),
		description: z.string().optional(),
		publishDate: z.coerce.date(),
		isFeatured: z.boolean().default(false),
		repo: z.string().optional(),
		blog: z.string().optional(),
		seo: seoSchema.optional()
	})
})

export const collections = { blog, pages, projects }
