# Recipe API Research

Checked on: 2026-03-11

## Goal

Find public APIs or public data sources suitable for a recipe-themed portfolio project with:

- broad enough feature coverage
- manageable usage terms
- low risk of violating provider rules if implemented correctly

This note is a practical summary of the official docs and terms that were reviewed. It is not legal advice.

## Recommended Stack

### Best low-risk portfolio stack if a paid plan is acceptable

Use:

- TheMealDB with a paid/supporter key for core recipe discovery
- USDA FoodData Central for nutrition data
- Open Food Facts as an optional add-on for barcode and product lookup

This combination gives good coverage while keeping licensing and operational constraints easier to manage than Spoonacular or Edamam.

### Best no-paid-plan portfolio stack

Use:

- Wikibooks Cookbook content accessed through the MediaWiki API behind your own normalization layer
- USDA FoodData Central for nutrition data
- Open Food Facts as an optional add-on for barcode and product lookup
- DummyJSON Recipes only for prototyping or seeded demo content
- Instacart Recipe Page API only if you already own the recipe content and want shopping handoff links

This avoids recurring recipe API fees, but it shifts more work to your own backend, parsing, and data quality controls.

## Candidate Summary

### 1. TheMealDB

Best for:

- core recipe search and detail pages
- browse by category, area, and ingredient
- random recipe features
- lightweight MVP or portfolio demos

Useful features:

- search meals by name
- lookup meal details by id
- filter by ingredient, category, and area
- random meal endpoint
- meal images and metadata

Important terms:

- API data can be used through the official endpoints.
- Free usage is intended for development projects.
- Free users may not publish apps to an app store unless they become paid subscribers.
- Premium/supporter access is positioned for production-style usage.

Practical verdict:

- Good default choice for a portfolio app.
- Safest path for any public release is to use a paid/supporter key.
- Dataset breadth is limited compared with larger commercial recipe APIs, but still enough for a portfolio.

Notes:

- TheMealDB home page currently states a relatively small dataset size, which is fine for a portfolio but not ideal for a large consumer app.

Official sources:

- https://www.themealdb.com/
- https://www.themealdb.com/api.php
- https://www.themealdb.com/terms_of_use.php

### 2. USDA FoodData Central

Best for:

- ingredient nutrition
- macro and micronutrient lookup
- nutrition panels
- supplementing recipe APIs that lack robust nutrition data

Useful features:

- food search
- food details lookup
- nutrient breakdown
- branded and foundation foods

Important terms:

- Data is released as public domain / CC0.
- API access requires a key.
- Default rate limit is documented at 1,000 requests per hour per IP.

Practical verdict:

- Very safe supplement for a public portfolio project.
- Not a full recipe API, so it works best as a nutrition companion rather than the primary recipe source.

Official source:

- https://fdc.nal.usda.gov/api-guide

### 3. Open Food Facts

Best for:

- barcode scanning
- pantry or grocery features
- allergen and product lookup
- branded food search

Useful features:

- open food product database
- product nutrition and ingredient data
- barcode-based lookup
- image and labeling metadata

Important terms:

- Data reuse is allowed under ODbL.
- Attribution is required.
- Share-alike obligations may apply if the database is combined into another database.
- API consumers should send a custom User-Agent.

Practical verdict:

- Strong optional add-on for product and grocery features.
- Best used as a separate live lookup service.
- Avoid merging Open Food Facts data into a closed proprietary database unless you are prepared to comply with ODbL obligations.

Official sources:

- https://openfoodfacts.github.io/openfoodfacts-server/api/
- https://support.openfoodfacts.org/help/en-gb/12-api-data-reuse/94-are-there-conditions-to-use-the-api

### 4. Spoonacular

Best for:

- feature-rich demo apps
- meal planning
- shopping list workflows
- pantry or "what can I cook" features
- advanced recipe utilities

Useful features:

- recipe search
- ingredient search
- meal planning
- shopping lists
- recipe nutrition
- ingredient substitutions
- price breakdown
- pantry/fridge discovery flows

Important terms:

- Attribution to the original recipe source is required.
- The free plan requires a backlink.
- The terms prohibit using the API to create an app or site meant to provide the same experience as Spoonacular.
- Storage and caching are restricted; long-term bulk copying is not allowed.

Practical verdict:

- Best single API if breadth matters more than licensing simplicity.
- Suitable for a focused portfolio tool, not a generic Spoonacular-style clone.
- Safe usage depends heavily on live fetching, attribution, and respecting storage restrictions.

Official sources:

- https://spoonacular.com/food-api
- https://spoonacular.com/food-api/pricing
- https://spoonacular.com/food-api/terms

### 5. Edamam

Best for:

- nutrition-centric apps
- diet and health filtering
- allergy-aware search experiences

Useful features:

- recipe search
- nutrition analysis
- diet and health filters
- meal-planning oriented features

Important terms:

- Usage terms are stricter than the other options above.
- Free usage language is limited to personal or not-for-profit use.
- Attribution to Edamam and source providers is required.
- Archiving, copying, and general data storage are restricted without permission.
- Current public recipe access appears more paid-first than the simpler alternatives.

Practical verdict:

- Not the best default option for a broad public portfolio project.
- More suitable when the project is specifically about nutrition or diet intelligence and can comply with strict attribution and storage rules.

Official sources:

- https://developer.edamam.com/edamam-recipe-api
- https://developer.edamam.com/edamam-docs-recipe-api
- https://developer.edamam.com/signup
- https://developer.edamam.com/attribution

## Free/Public Alternatives to Paid Plans

These are the most practical replacements if the goal is to avoid recurring paid recipe API plans.

### A. DummyJSON Recipes

Best for:

- UI prototyping
- seeded demo content
- testing pagination, search, tags, and detail screens

Useful features:

- list recipes
- get recipe by id
- search recipes
- browse recipe tags
- filter by meal type

Important terms and constraints:

- The docs describe the recipes endpoint as sample data useful for testing and prototyping.
- The public repository is open-source under the MIT License.
- It is not a large or authoritative live recipe dataset.

Practical verdict:

- Good replacement while building UI and app flows that would otherwise rely on Spoonacular or Edamam.
- Weak replacement if the published app needs broad, real-world recipe coverage.

Official sources:

- https://dummyjson.com/
- https://dummyjson.com/docs/recipes
- https://github.com/Ovi/DummyJSON

### B. Wikibooks Cookbook via MediaWiki API

Best for:

- real public recipe content without a paid vendor API
- searchable recipe catalogs backed by your own server
- portfolio projects that want to demonstrate ingestion and normalization

Useful features:

- MediaWiki REST API for content access
- MediaWiki Action API category listing via `categorymembers`
- thousands of recipe pages in the Wikibooks recipes category

Important terms and constraints:

- This is not a dedicated recipe API, so parsing and normalization are your responsibility.
- The Wikibooks `Category:Recipes` page currently shows 3,741 total pages.
- Wikibooks text is available under the Creative Commons Attribution-ShareAlike License, so attribution is required and derived-content obligations should be reviewed before redistribution.

Practical verdict:

- Strongest no-fee path if you need real public recipe content and can afford a backend integration layer.
- Better suited to a server-backed app than a thin client that expects clean recipe JSON out of the box.

Official sources:

- https://www.mediawiki.org/wiki/API:REST_API/en
- https://www.mediawiki.org/wiki/API:Categorymembers
- https://en.wikibooks.org/wiki/Cookbook
- https://en.wikibooks.org/wiki/Category:Recipes

### C. Open Recipes dataset

Best for:

- seeding your own recipe database
- search indexing demos
- schema.org-based import pipelines

Useful features:

- JSON database snapshots
- schema.org Recipe-compatible structure
- open dataset you can host yourself

Important terms and constraints:

- The repository was archived on 2018-02-08 and is now read-only.
- The dataset is licensed under Creative Commons Attribution 3.0.
- The project describes itself as an open database of recipe bookmarks, so completeness and freshness vary.

Practical verdict:

- Useful as a static seed dataset if you want full control and no dependency on a hosted recipe vendor.
- Not a strong drop-in replacement for a modern live recipe API.

Official sources:

- https://github.com/fictive-kin/openrecipes

### D. Instacart Recipe Page API

Best for:

- shopping handoff flows
- shoppable ingredient lists
- add-to-cart style experiences layered on top of your own recipe source

Useful features:

- generate hosted recipe pages with ingredients and instructions
- return shareable URLs for app or website handoff
- support pantry-style and measurement-rich ingredient presentation

Important terms and constraints:

- This is not a recipe search corpus and does not replace a recipe catalog API.
- You provide the recipe title, image, ingredients, and instructions; Instacart hosts the shopping page.
- The docs use a development API key for testing and a production API key for the live environment.

Practical verdict:

- Good replacement for the shopping-oriented portion of Spoonacular-style functionality.
- Not a replacement for TheMealDB, Spoonacular, or Edamam as a recipe discovery source.

Official sources:

- https://docs.instacart.com/developer_platform_api/guide/concepts/recipe/
- https://docs.instacart.com/developer_platform_api/get_started/recipe/
- https://docs.instacart.com/developer_platform_api/get_started/api-keys/
- https://docs.instacart.com/developer_platform_api/guide/terms_and_policies/developer_terms/

## Final Recommendation

### If the goal is safest public portfolio usage

Use:

- TheMealDB with a paid/supporter key for public release
- USDA FoodData Central for nutrition
- Open Food Facts only as an optional separate lookup service

Why:

- broad enough feature set for a portfolio
- easier compliance than Spoonacular and Edamam
- fewer restrictions on storage and product design when implemented carefully

### If the goal is no paid plan at all

Use:

- Wikibooks Cookbook via the MediaWiki API with your own backend normalization layer
- USDA FoodData Central for nutrition
- Open Food Facts only as a separate live lookup service
- DummyJSON Recipes only for development seeds, previews, or offline demos

Optional:

- Add Instacart Recipe Page API only if you want users to shop ingredients from your own recipes

Why:

- avoids recurring recipe API subscription costs
- keeps the nutrition and grocery pieces on public data sources
- the main trade-off is higher implementation complexity and less standardized recipe data

### If the goal is maximum features from one API

Use Spoonacular only if:

- the app is a focused feature demo rather than a general recipe portal clone
- recipe source attribution is visible
- response storage is kept within their rules

## Suggested Portfolio Features

A solid portfolio app can combine these without unusual licensing risk:

- recipe search by name
- browse by category and cuisine
- filter by ingredient
- random meal discovery
- recipe detail screen
- favorites and collections stored locally
- shopping list stored locally
- nutrition breakdown using USDA data
- barcode or grocery lookup using Open Food Facts

## Compliance Checklist

- Use only official APIs and official endpoints.
- Show attribution where the provider requires it.
- Store only your own user data plus third-party identifiers when possible.
- Avoid building a bulk local mirror of third-party recipe content unless the terms explicitly allow it.
- For DummyJSON, treat it as sample or prototype data rather than an authoritative live recipe catalog.
- For Wikibooks/Wikimedia content, keep attribution visible and review CC BY-SA obligations before republishing transformed recipe content.
- For Open Recipes, expect stale archived data and plan to own the cleaning and hosting pipeline yourself.
- For Instacart Recipe Page, treat it as a shopping destination layered on top of your recipe source, not as your primary recipe database.
- For Open Food Facts, send a custom User-Agent.
- For Spoonacular and Edamam, be conservative about caching and raw response retention.
- For TheMealDB, use paid/supporter access before any app store release.
