# PoolVibe Amazon Shop — Product Research Prompt for Claude

## Context
PoolVibe is a pool owner app. We are building a curated "Shop" section on pool-vibe.com with Amazon affiliate links. We want to recommend only **enthusiast-trusted, pool-community-approved brands** — NO big box generics (no Clorox, no HTH, no Walmart house brands). Think what a dedicated pool owner, a pool professional, or a pool forum regular would actually recommend.

## Your Task
For each of the 8 categories below, research and return:

1. **Top 3–5 brands** that are genuinely trusted by pool owners and professionals (not just Amazon bestsellers — cross-reference pool forums, Reddit r/pools, YouTube pool channels, and pool professional communities)
2. **1–2 specific hero products per brand** with:
   - Exact product name
   - Amazon ASIN (10-character code, e.g. B08XYZ1234)
   - One-sentence reason it's trusted (voice: pool owner, not marketing copy)
   - Price tier: Budget / Mid / Premium
   - Any notable caveats (e.g. "only works for salt pools" or "requires weekly dosing")
3. **Brands to explicitly avoid** in this category — and why (generic, low quality, bad rep in pool community)
4. **Any category-specific buying advice** a first-time pool owner should know (1–2 sentences max)

## The 8 Categories

### 1. Chemicals & Testing
Focus: chlorine, shock, pH Up/Down, algaecide, clarifier, enzymes, test strips & liquid test kits, stabilizer (CYA), pool salt
Avoid: Clorox, HTH, any grocery/big box store house brands

### 2. Equipment & Maintenance
Focus: pumps & motors, cartridge/sand/DE filters, robotic & manual vacuums, pool covers & reels, heaters & heat pumps, salt chlorine generators, LED pool lights
Avoid: off-brand no-name equipment with no service network

### 3. Cleaning Supplies
Focus: telescoping poles, leaf rakes, wall brushes, tile & waterline cleaners, stain removers, pool brooms
Note: some overlap with Equipment — keep this focused on hand tools and surface cleaning

### 4. Pool Toys & Fun
Focus: quality floats & loungers (not cheap inflatables), water games, diving toys, premium inflatables that actually last a season
Avoid: anything that deflates after 2 weeks — prioritize durability

### 5. Poolside Furniture
Focus: weather-resistant outdoor loungers, chaise chairs, umbrellas, side tables, drink holders
Note: focus on brands that hold up to sun, chlorine splash, and humidity — outdoor furniture that lasts

### 6. Accessories
Focus: digital & analog thermometers, pool bags & totes, floating LED lights, outdoor/waterproof speakers, high-quality coolers, drink dispensers
Note: curate the "nice to have" items a pool owner would actually buy and love

### 7. Safety
Focus: pool alarms (surface, gate, wearable), safety fencing & gate latches, life rings & hooks, anti-entrapment drain covers, first aid
Note: this category is non-negotiable quality — do NOT recommend budget safety equipment. Only trusted, tested products.

### 8. Seasonal
Focus: winter covers (mesh & solid), pool closing kits, freeze protection (pipe insulation, expansion plugs), spring opening kits, leaf catchers/net covers for fall
Note: cover quality matters enormously — recommend brands with warranty and durability reputation

---

## Output Format
Return results as structured markdown. For each category:

```
## [Category Name]

### [Brand Name]
- **Why trusted:** [one sentence]
- **Avoid brands:** [list]
- **Buying tip:** [one sentence]

#### Hero Products
| Product Name | ASIN | Price Tier | Notes |
|---|---|---|---|
| [name] | [ASIN] | Budget/Mid/Premium | [caveat if any] |
```

---

## Quality Bar
- If you're not confident in an ASIN, flag it — we'll verify manually
- Prioritize products with 4.3+ stars and 500+ reviews on Amazon
- The final list should feel like recommendations from a trusted pool professional, not a generic affiliate site
- Fewer great picks > more mediocre ones. 3 excellent products per category beats 10 average ones.
