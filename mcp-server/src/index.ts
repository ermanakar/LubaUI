import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import {
  lookupToken,
  lookupComponent,
  lookupPrimitive,
  getColorPalette,
  tokensData,
  componentsData,
  primitivesData,
} from "./tools/lookup.js";
import { validateSpacing, validateRadius } from "./tools/validate.js";
import { suggestTokens } from "./tools/suggest.js";

const server = new McpServer({
  name: "lubaui",
  version: "1.0.0",
});

// --- Tools ---

server.tool(
  "lookup_token",
  "Look up a LubaUI design token by name or description. Returns token name, API, value, tier, and usage guidance.",
  {
    query: z.string().describe("Token name, API path, or description (e.g. 'spacing large', 'lg', 'card padding')"),
    category: z
      .enum(["spacing", "radius", "color", "typography", "motion", "glass"])
      .optional()
      .describe("Filter by token category"),
  },
  async ({ query, category }) => {
    const result = lookupToken(query, category);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

server.tool(
  "lookup_component",
  "Look up a LubaUI component by name. Returns init parameters, styles, code example, and related tokens.",
  {
    query: z.string().describe("Component name (e.g. 'Button', 'LubaTextField', 'toast')"),
  },
  async ({ query }) => {
    const result = lookupComponent(query);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

server.tool(
  "lookup_primitive",
  "Look up a LubaUI interaction primitive by name. Returns modifier signature, parameters, presets, and code example.",
  {
    query: z.string().describe("Primitive name (e.g. 'pressable', 'swipeable', 'glass', 'expandable')"),
  },
  async ({ query }) => {
    const result = lookupPrimitive(query);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

server.tool(
  "validate_spacing",
  "Check if a spacing value is on the LubaUI 4pt grid and maps to a named token. Suggests nearest tokens if not.",
  {
    value: z.number().describe("Spacing value in points to validate"),
  },
  async ({ value }) => {
    const result = validateSpacing(value);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

server.tool(
  "validate_radius",
  "Check if a corner radius value is on the LubaUI radius scale. Suggests nearest token if not.",
  {
    value: z.number().describe("Radius value in points to validate"),
  },
  async ({ value }) => {
    const result = validateRadius(value);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

server.tool(
  "get_color_palette",
  "Get LubaUI colors by category or search. Returns light/dark hex values and usage context.",
  {
    query: z.string().describe("Color category (greyscale, surfaces, accent, text, semantic, border, glass) or search term (e.g. 'error', 'background')"),
  },
  async ({ query }) => {
    const result = getColorPalette(query);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

server.tool(
  "suggest_tokens",
  "Suggest LubaUI tokens, components, and primitives for a UI you're building. Describe what you're building and get recommendations.",
  {
    description: z.string().describe("Description of what you're building (e.g. 'notification banner', 'settings page', 'profile card')"),
  },
  async ({ description }) => {
    const result = suggestTokens(description);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

// --- Resources ---

server.resource(
  "tokens-all",
  "lubaui://tokens/all",
  { description: "Complete LubaUI token catalog — spacing, radius, colors, typography, motion, and glass tokens" },
  async () => {
    return {
      contents: [
        {
          uri: "lubaui://tokens/all",
          mimeType: "application/json",
          text: JSON.stringify(tokensData, null, 2),
        },
      ],
    };
  }
);

server.resource(
  "architecture",
  "lubaui://architecture",
  { description: "LubaUI design system architecture — three-tier token system, design philosophy, and conventions" },
  async () => {
    const architecture = {
      philosophy: "Composability over inheritance. Behaviors are extracted into primitives so any view can gain interactive powers through modifiers, not subclassing. Every magic number has a name, a token, and documented rationale.",
      tokenSystem: {
        tier1: {
          name: "Primitives (LubaPrimitives)",
          rule: "Raw hex values and numbers. The DNA. NEVER reference directly in component code.",
          examples: ["LubaPrimitives.grey900Light → Color(hex: 0x1A1A1A)", "LubaPrimitives.space4 → 4"],
        },
        tier2: {
          name: "Semantic Tokens",
          rule: "Human-readable, context-aware names. USE THESE in components.",
          modules: ["LubaColors", "LubaSpacing", "LubaRadius", "LubaTypography", "LubaMotion", "LubaAnimations"],
          examples: ["LubaColors.textPrimary → adaptive grey900", "LubaSpacing.lg → 16pt", "LubaMotion.pressScale → 0.97"],
        },
        tier3: {
          name: "Component Tokens",
          rule: "Per-component configuration enums. Reference tier 2 tokens internally.",
          modules: ["LubaCardTokens", "LubaFieldTokens", "LubaButtonSize", "LubaToastTokens", "LubaTabsTokens", "etc."],
        },
      },
      colorSystem: {
        approach: "Greyscale-first with organic sage green accent",
        adaptive: "All colors use LubaColors.adaptive(light:dark:) for automatic light/dark mode",
        surfaceHierarchy: "background → surface → surfaceSecondary → surfaceTertiary",
        accentColor: "Sage green (#5F7360 light / #9AB897 dark) — WCAG AA compliant",
      },
      spacingGrid: "4pt base grid. Named tokens: xs(4), sm(8), md(12), lg(16), xl(24), xxl(32), xxxl(48), huge(64)",
      radiusScale: "none(0), xs(4), sm(8), md(12), lg(16), xl(24), full(9999)",
      typography: "SF Rounded by default. Config-aware via LubaConfig.shared.useRoundedFont",
      motionSystems: {
        LubaMotion: "Raw constants (scale values, animation parameters) — use with .scaleEffect(), .opacity()",
        LubaAnimations: "Applied Animation objects — use with withAnimation(), .animation(), .transition()",
      },
      platforms: "iOS 16+, macOS 13+, watchOS 9+, tvOS 16+, visionOS 1.0+",
      configuration: {
        environment: "@Environment(\\.lubaConfig) for runtime settings, @Environment(\\.lubaTheme) for theming",
        presets: [".minimal", ".accessible", ".debug"],
      },
    };

    return {
      contents: [
        {
          uri: "lubaui://architecture",
          mimeType: "application/json",
          text: JSON.stringify(architecture, null, 2),
        },
      ],
    };
  }
);

server.resource(
  "components",
  "lubaui://components",
  { description: "LubaUI component directory — all 25 components with descriptions" },
  async () => {
    const summary = componentsData.map((c: { name: string; description: string }) => ({
      name: c.name,
      description: c.description,
    }));

    const primitivesSummary = primitivesData.map((p: { name: string; modifier: string; description: string }) => ({
      name: p.name,
      modifier: p.modifier,
      description: p.description,
    }));

    return {
      contents: [
        {
          uri: "lubaui://components",
          mimeType: "application/json",
          text: JSON.stringify(
            {
              components: summary,
              primitives: primitivesSummary,
              total: { components: summary.length, primitives: primitivesSummary.length },
            },
            null,
            2
          ),
        },
      ],
    };
  }
);

// --- Start ---

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
