import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import {
  lookupToken,
  lookupComponent,
  lookupPrimitive,
  lookupComponents,
  lookupTokens,
  getColorPalette,
  tokensData,
  componentsData,
  primitivesData,
} from "./tools/lookup.js";
import { validateSpacing, validateRadius } from "./tools/validate.js";
import { suggestTokens } from "./tools/suggest.js";
import { planMigration } from "./tools/migrate.js";

const server = new McpServer({
  name: "lubaui",
  version: "1.0.0",
});

// --- Tools ---

server.tool(
  "lookup_token",
  "Look up a single LubaUI design token by name or description. For multiple tokens, use lookup_tokens (batch) instead. For the full system, read the lubaui://reference/full resource.",
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
  "Look up a single LubaUI component by name. For multiple components, use lookup_components (batch) instead. For the full system, read the lubaui://reference/full resource.",
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
  "Suggest LubaUI tokens, components, and primitives for a UI you're building. Returns full component/primitive specs with parameters and code examples. For complete system knowledge, read the lubaui://reference/full resource instead.",
  {
    description: z.string().describe("Description of what you're building (e.g. 'notification banner', 'settings page', 'profile card')"),
  },
  async ({ description }) => {
    const result = suggestTokens(description);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

// --- Batch Tools ---

server.tool(
  "lookup_components",
  "Look up multiple LubaUI components in a single call. Returns full specs (parameters, code examples, tokens, notes) for each match. Use this instead of calling lookup_component repeatedly.",
  {
    queries: z.array(z.string()).describe("Array of component names (e.g. ['Button', 'Card', 'TextField', 'Tabs'])"),
  },
  async ({ queries }) => {
    const result = lookupComponents(queries);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

server.tool(
  "lookup_tokens",
  "Look up multiple LubaUI design tokens in a single call. Returns token name, API, value, tier, and usage guidance for each match. Use this instead of calling lookup_token repeatedly.",
  {
    queries: z.array(z.string()).describe("Array of token queries (e.g. ['spacing large', 'radius medium', 'press scale'])"),
    category: z
      .enum(["spacing", "radius", "color", "typography", "motion", "glass"])
      .optional()
      .describe("Filter all queries by token category"),
  },
  async ({ queries, category }) => {
    const result = lookupTokens(queries, category);
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  }
);

// --- Migration Tool ---

server.tool(
  "plan_migration",
  "Generate a mapping from an existing design system to LubaUI. Provide source tokens (colors with hex values, spacing/radius with pt values, typography with sizes, components with descriptions) and get a complete migration table showing exact/nearest LubaUI equivalents with code examples.",
  {
    source_system: z
      .string()
      .describe("Name or description of the source design system (e.g. 'Custom DS with violet accent and dark-only theme')"),
    colors: z
      .array(
        z.object({
          name: z.string().describe("Source color token name (e.g. 'DS.Colors.accent')"),
          value: z.string().describe("Hex color value (e.g. '#A78BFA')"),
          usage: z.string().optional().describe("How this color is used (e.g. 'primary accent')"),
        })
      )
      .optional()
      .describe("Source color tokens to map"),
    spacing: z
      .array(
        z.object({
          name: z.string().describe("Source spacing token name"),
          value: z.number().describe("Value in points"),
        })
      )
      .optional()
      .describe("Source spacing tokens to map"),
    radii: z
      .array(
        z.object({
          name: z.string().describe("Source radius token name"),
          value: z.number().describe("Value in points"),
        })
      )
      .optional()
      .describe("Source radius tokens to map"),
    typography: z
      .array(
        z.object({
          name: z.string().describe("Source typography token name"),
          size: z.number().describe("Font size in points"),
          weight: z.string().optional().describe("Font weight (e.g. 'bold', 'semibold')"),
        })
      )
      .optional()
      .describe("Source typography tokens to map"),
    components: z
      .array(
        z.object({
          name: z.string().describe("Source component name (e.g. 'HeroCard')"),
          description: z
            .string()
            .describe("What the component does (e.g. 'large card with shadow for featured content')"),
        })
      )
      .optional()
      .describe("Source components to find LubaUI equivalents for"),
  },
  async ({ source_system, colors, spacing, radii, typography, components }) => {
    const result = planMigration(source_system, {
      colors,
      spacing,
      radii,
      typography,
      components,
    });
    return {
      content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
    };
  }
);

// --- Resources ---

server.resource(
  "reference-full",
  "lubaui://reference/full",
  {
    description:
      "Complete LubaUI design system reference — architecture, all tokens, all 25 components with full specs, and all 7 primitives. Read this once to understand the entire system without making individual lookup calls.",
  },
  async () => {
    const fullReference = {
      system: "LubaUI Design System",
      version: "1.0.0",
      philosophy:
        "Composability over inheritance. Behaviors are extracted into primitives (modifiers) so any view can gain interactive powers without subclassing. Every magic number has a name, a token, and documented rationale.",
      platforms: "iOS 16+, macOS 13+, watchOS 9+, tvOS 16+, visionOS 1.0+",

      architecture: {
        tokenSystem: {
          tier1: {
            name: "Primitives (LubaPrimitives)",
            rule: "Raw hex values and numbers. NEVER reference directly in component code.",
          },
          tier2: {
            name: "Semantic Tokens",
            rule: "Human-readable, context-aware names. USE THESE in components.",
            modules: [
              "LubaColors",
              "LubaSpacing",
              "LubaRadius",
              "LubaTypography",
              "LubaMotion",
              "LubaAnimations",
            ],
          },
          tier3: {
            name: "Component Tokens",
            rule: "Per-component configuration enums. Reference tier 2 tokens internally.",
          },
        },
        colorSystem: {
          approach: "Greyscale-first with organic sage green accent",
          adaptive: "All colors use LubaColors.adaptive(light:dark:) for automatic light/dark mode",
          surfaceHierarchy: "background → surface → surfaceSecondary → surfaceTertiary",
          accentColor: "Sage green (#5F7360 light / #9AB897 dark) — WCAG AA compliant",
        },
        motionSystems: {
          LubaMotion: "Raw constants (scale values, animation parameters) — use with .scaleEffect(), .opacity()",
          LubaAnimations: "Applied Animation objects — use with withAnimation(), .animation(), .transition()",
        },
        configuration: {
          environment: "@Environment(\\.lubaConfig) for runtime settings, @Environment(\\.lubaTheme) for theming",
          presets: [".minimal", ".accessible", ".debug"],
        },
      },

      tokens: tokensData,

      components: componentsData.map((c: { name: string; description: string; parameters: unknown; example: string; tokens: string[]; notes: string }) => ({
        name: c.name,
        description: c.description,
        parameters: c.parameters,
        example: c.example,
        tokens: c.tokens,
        notes: c.notes,
      })),

      primitives: primitivesData.map((p: { name: string; modifier: string; description: string; parameters: unknown; example: string; tokens: string[]; composability: string; [key: string]: unknown }) => {
        const entry: Record<string, unknown> = {
          name: p.name,
          modifier: p.modifier,
          description: p.description,
          parameters: p.parameters,
          example: p.example,
          tokens: p.tokens,
          composability: p.composability,
        };
        if ("presets" in p) entry.presets = p.presets;
        if ("variants" in p) entry.variants = p.variants;
        if ("builtInStyles" in p) entry.builtInStyles = p.builtInStyles;
        if ("hapticStyles" in p) entry.hapticStyles = p.hapticStyles;
        return entry;
      }),

      summary: {
        totalComponents: componentsData.length,
        totalPrimitives: primitivesData.length,
        componentNames: componentsData.map((c: { name: string }) => c.name),
        primitiveNames: primitivesData.map((p: { name: string }) => p.name),
      },
    };

    return {
      contents: [
        {
          uri: "lubaui://reference/full",
          mimeType: "application/json",
          text: JSON.stringify(fullReference, null, 2),
        },
      ],
    };
  }
);

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
