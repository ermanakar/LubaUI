# LubaUI MCP Server

An MCP (Model Context Protocol) server that makes the LubaUI design system actively queryable by AI assistants. Rather than reading Swift source files, your AI gets structured answers about tokens, components, and patterns through dedicated tools.

---

## Setup

### Using LubaUI in your own project (recommended)

One command — works from any project directory:

```bash
claude mcp add lubaui -- npx lubaui-mcp
```

That's it. Next time you start Claude Code, the LubaUI tools are available. Ask "What spacing should I use for card padding?" and Claude will query the server.

### Contributing to LubaUI

If you're working inside the LubaUI repo itself, the `.mcp.json` at the project root auto-discovers the server. Just install dependencies:

```bash
cd mcp-server && npm install
```

The server starts on demand when Claude Code opens the project.

---

## Tools

The server provides 7 tools that solve real problems during development.

### `lookup_token`

Find any design token by name or description.

```
"What spacing should I use for card padding?"
→ LubaSpacing.lg — 16pt — "Large — card padding, section spacing, standard gap"

"What's the accent color hex?"
→ LubaColors.accent — light: #5F7360, dark: #9AB897
```

**Parameters:**
- `query` (required) — Token name, API path, or description
- `category` (optional) — Filter: `spacing`, `radius`, `color`, `typography`, `motion`, `glass`

### `lookup_component`

Get the full API for any of the 25 components.

```
"How do I use LubaButton?"
→ Parameters, styles (.primary/.secondary/.ghost/.destructive/.subtle/.glass),
  sizes, code example, related tokens
```

**Parameters:**
- `query` (required) — Component name (fuzzy: "Button", "LubaTextField", "toast")

### `lookup_primitive`

Look up any of the 7 interaction primitives.

```
"How do I add swipe-to-delete?"
→ .lubaSwipeable() modifier, parameters, 6 presets (.delete, .archive, .pin, etc.),
  code example, composability notes
```

**Parameters:**
- `query` (required) — Primitive name (fuzzy: "pressable", "swipeable", "glass")

### `validate_spacing`

Check if a spacing value is on the 4pt grid and maps to a named token.

```
"Is 14pt valid?"
→ No — 14pt is NOT on the 4pt grid.
  Nearest: LubaSpacing.md (12pt) and LubaSpacing.lg (16pt)

"Is 16pt valid?"
→ Yes — 16pt is LubaSpacing.lg
```

**Parameters:**
- `value` (required) — Spacing value in points

### `validate_radius`

Check if a corner radius is on the LubaRadius scale.

```
"Is 10pt a valid radius?"
→ No — nearest: LubaRadius.sm (8pt) and LubaRadius.md (12pt)
  Valid radii: none(0), xs(4), sm(8), md(12), lg(16), xl(24), full(9999)
```

**Parameters:**
- `value` (required) — Radius value in points

### `get_color_palette`

Browse colors by category or search across the palette.

```
"Show me the surface colors"
→ background (#FAFAFA/#0D0D0D), surface (#FFFFFF/#171717),
  surfaceSecondary (#F5F5F5/#212121), surfaceTertiary (#EFEFEF/#2A2A2A)

"What colors are available for errors?"
→ error (#B54A4A/#E07A7A), errorSubtle (#FAEFEF/#251A1A)
```

**Parameters:**
- `query` (required) — Category name (`greyscale`, `surfaces`, `accent`, `text`, `semantic`, `border`, `glass`) or search term

### `suggest_tokens`

Describe what you're building and get token, component, and primitive recommendations.

```
"I'm building a notification banner"
→ Spacing: LubaSpacing.md (12pt) internal, LubaSpacing.lg (16pt) horizontal
  Colors: LubaColors.success/warning/error for status
  Radius: LubaRadius.md (12pt)
  Typography: LubaTypography.subheadline for message
  Components: LubaToast, LubaAlert
  Primitives: lubaGlass for frosted effect
```

**Parameters:**
- `description` (required) — What you're building ("settings page", "profile card", "loading state")

Recognizes these patterns: `form`, `notification`, `banner`, `card`, `list`, `loading`, `navigation`, `profile`, `modal`, `settings`.

---

## Resources

Three read-only resources provide full reference data.

| URI | Description |
|-----|-------------|
| `lubaui://tokens/all` | Complete token catalog — spacing, radius, colors, typography, motion, glass |
| `lubaui://architecture` | Three-tier system rules, design philosophy, naming conventions |
| `lubaui://components` | Component and primitive directory with descriptions |

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
    │   ├── components.json   # 25 component APIs with parameters and examples
    │   └── primitives.json   # 7 primitives with modifiers and patterns
    ├── tools/
    │   ├── lookup.ts         # lookup_token, lookup_component, lookup_primitive, get_color_palette
    │   ├── validate.ts       # validate_spacing, validate_radius
    │   └── suggest.ts        # suggest_tokens
    └── utils/
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
```
