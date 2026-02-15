# LubaUI MCP Server

An MCP (Model Context Protocol) server that makes the LubaUI design system actively queryable by AI assistants. Rather than reading Swift source files, your AI gets structured answers about tokens, components, and patterns through dedicated tools.

---

## Setup

### Using LubaUI in your own project (recommended)

One command — works from any project directory:

```bash
claude mcp add lubaui -- npx lubaui-mcp@latest
```

Using `@latest` ensures you always get the newest version. Without it, `npx` caches the first version it downloads.

That's it. Next time you start Claude Code, the LubaUI tools are available. Ask "What spacing should I use for card padding?" and Claude will query the server.

### Updating

If you installed without `@latest`, you can update manually:

```bash
npx lubaui-mcp@latest
```

Or re-add with auto-updates:

```bash
claude mcp remove lubaui
claude mcp add lubaui -- npx lubaui-mcp@latest
```

### Contributing to LubaUI

If you're working inside the LubaUI repo itself, the `.mcp.json` at the project root auto-discovers the server. Just install dependencies:

```bash
cd mcp-server && npm install
```

The server starts on demand when Claude Code opens the project.

---

## Tools

The server provides 10 tools organized by use case.

### Lookup Tools

#### `lookup_token`

Find a single design token by name or description.

```
"What spacing should I use for card padding?"
→ LubaSpacing.lg — 16pt — "Large — card padding, section spacing, standard gap"
```

**Parameters:**
- `query` (required) — Token name, API path, or description
- `category` (optional) — Filter: `spacing`, `radius`, `color`, `typography`, `motion`, `glass`

#### `lookup_component`

Get the full API for a single component.

```
"How do I use LubaButton?"
→ Parameters, styles, sizes, code example, related tokens
```

**Parameters:**
- `query` (required) — Component name (fuzzy: "Button", "LubaTextField", "toast")

#### `lookup_primitive`

Look up a single interaction primitive.

```
"How do I add swipe-to-delete?"
→ .lubaSwipeable() modifier, parameters, 6 presets, code example
```

**Parameters:**
- `query` (required) — Primitive name (fuzzy: "pressable", "swipeable", "glass")

### Batch Tools

For looking up multiple items at once — use these instead of calling the single-lookup tools repeatedly.

#### `lookup_components`

Look up multiple components in a single call. Returns full specs for each match.

```
queries: ["Button", "Card", "TextField", "Tabs", "Badge"]
→ 5 components with parameters, code examples, tokens, and notes
```

**Parameters:**
- `queries` (required) — Array of component names

#### `lookup_tokens`

Look up multiple tokens in a single call.

```
queries: ["spacing large", "radius medium", "press scale", "accent"]
→ All matching tokens with values, tiers, and descriptions
```

**Parameters:**
- `queries` (required) — Array of token queries
- `category` (optional) — Filter all queries by category

### Validation Tools

#### `validate_spacing`

Check if a spacing value is on the 4pt grid and maps to a named token.

```
"Is 14pt valid?"
→ No — 14pt is NOT on the 4pt grid.
  Nearest: LubaSpacing.md (12pt) and LubaSpacing.lg (16pt)
```

**Parameters:**
- `value` (required) — Spacing value in points

#### `validate_radius`

Check if a corner radius is on the LubaRadius scale.

```
"Is 10pt a valid radius?"
→ No — nearest: LubaRadius.sm (8pt) and LubaRadius.md (12pt)
```

**Parameters:**
- `value` (required) — Radius value in points

### Recommendation Tools

#### `suggest_tokens`

Describe what you're building and get token, component, and primitive recommendations — with full specs including parameters and code examples.

```
"I'm building a notification banner"
→ Spacing, colors, radius, typography recommendations
  + full specs for LubaToast, LubaAlert, lubaGlass
```

**Parameters:**
- `description` (required) — What you're building ("settings page", "profile card", "loading state")

Recognizes these patterns: `form`, `notification`, `banner`, `card`, `list`, `loading`, `navigation`, `profile`, `modal`, `settings`.

#### `get_color_palette`

Browse colors by category or search across the palette.

```
"Show me the surface colors"
→ background (#FAFAFA/#0D0D0D), surface (#FFFFFF/#171717),
  surfaceSecondary (#F5F5F5/#212121), surfaceTertiary (#EFEFEF/#2A2A2A)
```

**Parameters:**
- `query` (required) — Category name (`greyscale`, `surfaces`, `accent`, `text`, `semantic`, `border`, `glass`) or search term

### Migration Tool

#### `plan_migration`

Generate a mapping from an existing design system to LubaUI. Provide your source tokens and get a complete migration table.

```
source_system: "Custom DS with violet accent"
colors: [{ name: "DS.Colors.accent", value: "#A78BFA" }]
spacing: [{ name: "DS.Spacing.md", value: 16 }]
components: [{ name: "HeroCard", description: "large card with shadow" }]

→ Color mappings (exact/nearest with hex values)
  Spacing mappings (exact/nearest with delta)
  Component mappings (LubaCard, with full specs and code examples)
```

**Parameters:**
- `source_system` (required) — Name or description of your current design system
- `colors` (optional) — Array of `{ name, value (hex), usage? }`
- `spacing` (optional) — Array of `{ name, value (pt) }`
- `radii` (optional) — Array of `{ name, value (pt) }`
- `typography` (optional) — Array of `{ name, size (pt), weight? }`
- `components` (optional) — Array of `{ name, description }`

---

## Resources

Four read-only resources provide reference data at different levels of detail.

| URI | Size | Description |
|-----|------|-------------|
| `lubaui://reference/full` | ~52KB | Complete system — architecture, all tokens, all components with full specs, all primitives. **Read this once for full system adoption.** |
| `lubaui://components` | ~32KB | All components and primitives with full specs (parameters, examples, tokens, notes) |
| `lubaui://tokens/all` | ~18KB | Complete token catalog — spacing, radius, colors, typography, motion, glass |
| `lubaui://architecture` | ~2KB | Three-tier system rules, design philosophy, naming conventions |

**Recommended usage:** For design system adoption or migration, read `lubaui://reference/full` once — it has everything. Use the smaller resources when you only need a specific section.

---

## Architecture

```
mcp-server/
├── package.json
├── tsconfig.json
└── src/
    ├── index.ts              # Server entry, tool/resource registration
    ├── data/
    │   ├── tokens.json       # Spacing, radius, colors, typography, motion, glass
    │   ├── components.json   # 26 component APIs with parameters and examples
    │   └── primitives.json   # 7 primitives with modifiers and patterns
    ├── tools/
    │   ├── lookup.ts         # lookup_token, lookup_component, lookup_primitive, get_color_palette
    │   │                     # + batch: lookup_components, lookup_tokens
    │   ├── validate.ts       # validate_spacing, validate_radius
    │   ├── suggest.ts        # suggest_tokens (returns full component specs)
    │   └── migrate.ts        # plan_migration (token + component mapping)
    └── utils/
        ├── paths.ts          # Data directory resolution (source + dist)
        └── search.ts         # Scored fuzzy search (camelCase-aware)
```

**Data strategy:** Hand-authored JSON files transcribed from the Swift sources. The data files include usage guidance, cross-references, and design rationale that don't exist in source code. The token system changes infrequently, so static JSON is reliable and avoids runtime Swift parsing.

**Search:** Simple scored matching — exact (100) > starts-with (80) > contains (60) > camelCase part match (50). No external dependencies.

**Transport:** stdio via `@modelcontextprotocol/sdk`. Runs with `npx tsx` (no build step).

---

## Updating Data

When tokens or components change in the Swift sources, update the corresponding JSON file in `src/data/`:

- **Token changes** (new spacing value, color tweak) → edit `tokens.json`
- **New component or API change** → edit `components.json`
- **New primitive or modifier change** → edit `primitives.json`

The JSON structure is self-documenting. Match the existing patterns when adding entries.

---

## Development

```bash
# Install
cd mcp-server && npm install

# Test manually (sends JSON-RPC over stdin)
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0.0"}}}' | npx tsx src/index.ts

# List tools
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' | npx tsx src/index.ts

# Type check
npx tsc --noEmit

# Build for publishing
npx tsc
```
