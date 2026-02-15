import { readFileSync } from "fs";
import { join } from "path";
import { search, type SearchableItem } from "../utils/search.js";
import { dataDir } from "../utils/paths.js";

// Load data once at module level
const tokensData = JSON.parse(
  readFileSync(join(dataDir, "tokens.json"), "utf-8")
);
const componentsData: ComponentEntry[] = JSON.parse(
  readFileSync(join(dataDir, "components.json"), "utf-8")
);
const primitivesData: PrimitiveEntry[] = JSON.parse(
  readFileSync(join(dataDir, "primitives.json"), "utf-8")
);

interface ComponentEntry {
  name: string;
  description: string;
  parameters: Array<{
    name: string;
    type: string;
    required?: boolean;
    default?: string;
    options?: string[];
    description: string;
  }>;
  example: string;
  tokens: string[];
  notes: string;
}

interface PrimitiveEntry {
  name: string;
  modifier: string;
  description: string;
  parameters: Array<{
    name: string;
    type: string;
    required?: boolean;
    default?: string;
    options?: string[];
    description: string;
  }>;
  example: string;
  tokens: string[];
  composability: string;
  [key: string]: unknown;
}

// Flatten all tokens into a searchable list
interface FlatToken extends SearchableItem {
  api: string;
  value?: number | string;
  tier?: number;
  description: string;
  category: string;
  subcategory?: string;
  light?: string;
  dark?: string;
  primitive?: string;
  aliasOf?: string;
}

function flattenTokens(): FlatToken[] {
  const flat: FlatToken[] = [];

  // Spacing
  for (const t of tokensData.spacing.tokens) {
    flat.push({ ...t, category: "spacing", aliases: [t.api] });
  }

  // Radius
  for (const t of tokensData.radius.tokens) {
    flat.push({ ...t, category: "radius", aliases: [t.api] });
  }

  // Colors (all subcategories)
  for (const sub of [
    "greyscale",
    "surfaces",
    "accent",
    "text",
    "semantic",
    "border",
    "glass",
  ]) {
    const colors = tokensData.colors[sub];
    if (colors) {
      for (const c of colors) {
        flat.push({
          ...c,
          category: "color",
          subcategory: sub,
          aliases: [c.api],
        });
      }
    }
  }

  // Typography
  for (const t of tokensData.typography.tokens) {
    flat.push({
      ...t,
      category: "typography",
      aliases: [t.api],
      value: `${t.size}pt ${t.weight}`,
    });
  }

  // Motion constants
  for (const sub of ["pressScales", "animations", "other"]) {
    const items = tokensData.motion.constants[sub];
    if (items) {
      for (const m of items) {
        flat.push({ ...m, category: "motion", subcategory: sub, aliases: [m.api] });
      }
    }
  }

  // Applied animations
  for (const a of tokensData.motion.appliedAnimations) {
    flat.push({ ...a, category: "motion", subcategory: "applied", aliases: [a.api] });
  }

  // Glass
  for (const s of tokensData.glass.styles) {
    flat.push({ ...s, category: "glass", aliases: [s.api] });
  }
  for (const t of tokensData.glass.tokens) {
    flat.push({ ...t, category: "glass", aliases: [t.api], description: t.name });
  }

  return flat;
}

const flatTokens = flattenTokens();

// --- Tool implementations ---

export function lookupToken(query: string, category?: string) {
  const results = search(flatTokens, query, { category, maxResults: 8 });

  if (results.length === 0) {
    return { found: false, message: `No tokens matching "${query}"${category ? ` in category "${category}"` : ""}` };
  }

  return {
    found: true,
    count: results.length,
    tokens: results.map((t) => ({
      name: t.name,
      api: t.api,
      value: t.value,
      tier: t.tier,
      category: t.category,
      subcategory: t.subcategory,
      description: t.description,
      ...(t.light && { light: t.light }),
      ...(t.dark && { dark: t.dark }),
      ...(t.primitive && { primitive: t.primitive }),
      ...(t.aliasOf && { aliasOf: t.aliasOf }),
    })),
  };
}

export function lookupComponent(query: string) {
  const searchable: (ComponentEntry & SearchableItem)[] = componentsData.map(
    (c) => ({
      ...c,
      aliases: [c.name.replace("Luba", "")],
    })
  );

  const results = search(searchable, query, { maxResults: 3 });

  if (results.length === 0) {
    return {
      found: false,
      message: `No component matching "${query}". Available: ${componentsData.map((c) => c.name).join(", ")}`,
    };
  }

  return {
    found: true,
    components: results.map((c) => ({
      name: c.name,
      description: c.description,
      parameters: c.parameters,
      example: c.example,
      tokens: c.tokens,
      notes: c.notes,
    })),
  };
}

export function lookupPrimitive(query: string) {
  const searchable: (PrimitiveEntry & SearchableItem)[] = primitivesData.map(
    (p) => ({
      ...p,
      aliases: [p.name.replace("luba", ""), p.modifier],
    })
  );

  const results = search(searchable, query, { maxResults: 3 });

  if (results.length === 0) {
    return {
      found: false,
      message: `No primitive matching "${query}". Available: ${primitivesData.map((p) => p.name).join(", ")}`,
    };
  }

  return {
    found: true,
    primitives: results.map((p) => {
      const result: Record<string, unknown> = {
        name: p.name,
        modifier: p.modifier,
        description: p.description,
        parameters: p.parameters,
        example: p.example,
        tokens: p.tokens,
        composability: p.composability,
      };
      if ("presets" in p) result.presets = p.presets;
      if ("variants" in p) result.variants = p.variants;
      if ("builtInStyles" in p) result.builtInStyles = p.builtInStyles;
      if ("hapticStyles" in p) result.hapticStyles = p.hapticStyles;
      return result;
    }),
  };
}

export function getColorPalette(query: string) {
  const categories = [
    "greyscale",
    "surfaces",
    "accent",
    "text",
    "semantic",
    "border",
    "glass",
  ];

  // Check if query matches a category directly
  const directMatch = categories.find(
    (c) => c.toLowerCase() === query.toLowerCase() ||
      c.toLowerCase().startsWith(query.toLowerCase())
  );

  if (directMatch) {
    const colors = tokensData.colors[directMatch];
    return {
      category: directMatch,
      description: tokensData.colors.description,
      colors: colors,
    };
  }

  // Otherwise search across all colors
  const allColors: FlatToken[] = flatTokens.filter(
    (t) => t.category === "color"
  );
  const results = search(allColors, query, { maxResults: 10 });

  if (results.length === 0) {
    return {
      found: false,
      message: `No colors matching "${query}". Categories: ${categories.join(", ")}`,
    };
  }

  return {
    found: true,
    colors: results.map((c) => ({
      name: c.name,
      api: c.api,
      light: c.light,
      dark: c.dark,
      description: c.description,
      subcategory: c.subcategory,
      ...(c.aliasOf && { aliasOf: c.aliasOf }),
    })),
  };
}

// Export data for resources
export { tokensData, componentsData, primitivesData };
