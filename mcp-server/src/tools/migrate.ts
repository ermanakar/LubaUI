import { readFileSync } from "fs";
import { join } from "path";
import { dataDir } from "../utils/paths.js";

const tokensData = JSON.parse(
  readFileSync(join(dataDir, "tokens.json"), "utf-8")
);
const componentsData: Array<{
  name: string;
  description: string;
  parameters: unknown;
  example: string;
  tokens: string[];
  notes: string;
}> = JSON.parse(readFileSync(join(dataDir, "components.json"), "utf-8"));
const primitivesData: Array<{
  name: string;
  modifier: string;
  description: string;
  parameters: unknown;
  example: string;
  tokens: string[];
  composability: string;
  [key: string]: unknown;
}> = JSON.parse(readFileSync(join(dataDir, "primitives.json"), "utf-8"));

// --- Scales for value-based matching ---

const spacingScale = [
  { name: "xs", api: "LubaSpacing.xs", value: 4 },
  { name: "sm", api: "LubaSpacing.sm", value: 8 },
  { name: "md", api: "LubaSpacing.md", value: 12 },
  { name: "lg", api: "LubaSpacing.lg", value: 16 },
  { name: "xl", api: "LubaSpacing.xl", value: 24 },
  { name: "xxl", api: "LubaSpacing.xxl", value: 32 },
  { name: "xxxl", api: "LubaSpacing.xxxl", value: 48 },
  { name: "huge", api: "LubaSpacing.huge", value: 64 },
];

const radiusScale = [
  { name: "none", api: "LubaRadius.none", value: 0 },
  { name: "xs", api: "LubaRadius.xs", value: 4 },
  { name: "sm", api: "LubaRadius.sm", value: 8 },
  { name: "md", api: "LubaRadius.md", value: 12 },
  { name: "lg", api: "LubaRadius.lg", value: 16 },
  { name: "xl", api: "LubaRadius.xl", value: 24 },
  { name: "full", api: "LubaRadius.full", value: 9999 },
];

// All LubaUI colors with hex values for matching
const allColors: Array<{
  name: string;
  api: string;
  light?: string;
  dark?: string;
  description: string;
}> = [];
for (const sub of [
  "greyscale",
  "surfaces",
  "accent",
  "text",
  "semantic",
  "border",
]) {
  const colors = tokensData.colors[sub];
  if (colors) {
    for (const c of colors) {
      allColors.push(c);
    }
  }
}

const typographyTokens: Array<{
  name: string;
  api: string;
  size: number;
  weight: string;
  description: string;
}> = tokensData.typography.tokens;

// --- Matching helpers ---

function findNearestScale(
  value: number,
  scale: Array<{ name: string; api: string; value: number }>
) {
  // Exclude full/9999 from nearest for radius
  const candidates = scale.filter((s) => s.value < 9999);
  let closest = candidates[0];
  let closestDist = Math.abs(value - closest.value);
  for (const entry of candidates) {
    const dist = Math.abs(value - entry.value);
    if (dist < closestDist) {
      closest = entry;
      closestDist = dist;
    }
  }
  const exact = scale.find((s) => s.value === value);
  return { exact: exact ?? null, nearest: closest, distance: closestDist };
}

function hexToRgb(hex: string): [number, number, number] | null {
  const clean = hex.replace(/^#/, "");
  if (clean.length !== 6) return null;
  const n = parseInt(clean, 16);
  return [(n >> 16) & 0xff, (n >> 8) & 0xff, n & 0xff];
}

function colorDistance(
  a: [number, number, number],
  b: [number, number, number]
): number {
  // Weighted Euclidean (human perception)
  const dr = a[0] - b[0];
  const dg = a[1] - b[1];
  const db = a[2] - b[2];
  return Math.sqrt(2 * dr * dr + 4 * dg * dg + 3 * db * db);
}

function findNearestColor(hex: string, mode: "light" | "dark" = "light") {
  const sourceRgb = hexToRgb(hex);
  if (!sourceRgb)
    return { exact: null, nearest: null, distance: Infinity, candidates: [] };

  const results: Array<{
    color: (typeof allColors)[0];
    distance: number;
  }> = [];

  for (const c of allColors) {
    const targetHex = mode === "light" ? c.light : c.dark;
    if (!targetHex) continue;
    const targetRgb = hexToRgb(targetHex);
    if (!targetRgb) continue;
    results.push({ color: c, distance: colorDistance(sourceRgb, targetRgb) });
  }

  results.sort((a, b) => a.distance - b.distance);
  const top = results.slice(0, 3);
  const exact = top.length > 0 && top[0].distance === 0 ? top[0].color : null;

  return {
    exact,
    nearest: top.length > 0 ? top[0].color : null,
    distance: top.length > 0 ? top[0].distance : Infinity,
    candidates: top.map((r) => ({
      api: r.color.api,
      light: r.color.light,
      dark: r.color.dark,
      distance: Math.round(r.distance),
      description: r.color.description,
    })),
  };
}

function findNearestTypography(size: number, weight?: string) {
  // First try exact size match
  const exactSize = typographyTokens.filter((t) => t.size === size);
  if (exactSize.length > 0) {
    // If weight specified, try to match that too
    if (weight) {
      const exactBoth = exactSize.find(
        (t) => t.weight.toLowerCase() === weight.toLowerCase()
      );
      if (exactBoth)
        return {
          exact: exactBoth,
          nearest: exactBoth,
          alternatives: exactSize,
        };
    }
    return {
      exact: exactSize[0],
      nearest: exactSize[0],
      alternatives: exactSize,
    };
  }

  // Find nearest by size
  let closest = typographyTokens[0];
  let closestDist = Math.abs(size - closest.size);
  for (const t of typographyTokens) {
    const dist = Math.abs(size - t.size);
    if (dist < closestDist) {
      closest = t;
      closestDist = dist;
    }
  }

  return { exact: null, nearest: closest, alternatives: [] as typeof typographyTokens };
}

// Component purpose matching via keywords
const componentKeywords: Record<string, string[]> = {
  LubaButton: ["button", "action", "submit", "cta", "tap"],
  LubaCard: [
    "card",
    "container",
    "panel",
    "box",
    "section",
    "hero",
    "tile",
  ],
  LubaTextField: ["input", "field", "text field", "text input", "url", "email"],
  LubaTextArea: ["textarea", "multiline", "text area", "comment", "notes"],
  LubaSearchBar: ["search", "search bar", "filter"],
  LubaCheckbox: ["checkbox", "check", "checkmark"],
  LubaRadio: ["radio", "option", "select one"],
  LubaToggle: ["toggle", "switch", "on off"],
  LubaSlider: ["slider", "range", "volume"],
  LubaStepper: ["stepper", "increment", "decrement", "quantity"],
  LubaRating: ["rating", "star", "stars", "review"],
  LubaTabs: ["tab", "tabs", "segment", "segmented", "picker"],
  LubaToast: ["toast", "snackbar", "notification", "flash"],
  LubaAlert: [
    "alert",
    "banner",
    "warning",
    "error message",
    "info",
    "notice",
  ],
  LubaProgress: [
    "progress",
    "progress bar",
    "loading bar",
    "circular progress",
    "ring",
  ],
  LubaSpinner: ["spinner", "loading", "activity indicator"],
  LubaSkeleton: ["skeleton", "placeholder", "shimmer", "loading placeholder"],
  LubaSheet: ["sheet", "bottom sheet", "modal", "drawer"],
  LubaAvatar: ["avatar", "profile image", "user image", "initials"],
  LubaBadge: [
    "badge",
    "label",
    "tag",
    "status",
    "verdict",
    "pill",
    "indicator",
  ],
  LubaDivider: ["divider", "separator", "line", "hr"],
  LubaIcon: ["icon", "symbol", "sf symbol"],
  LubaChip: ["chip", "tag", "filter chip", "hashtag"],
  LubaMenu: ["menu", "dropdown", "context menu", "popover menu"],
  LubaTooltip: ["tooltip", "hint", "help text", "info popup"],
  LubaLink: ["link", "hyperlink", "url link", "text link"],
};

const primitiveKeywords: Record<string, string[]> = {
  lubaPressable: [
    "pressable",
    "tappable",
    "tap",
    "press",
    "scale button",
    "bounce button",
    "button style",
  ],
  lubaExpandable: [
    "expandable",
    "collapsible",
    "expand",
    "collapse",
    "accordion",
    "disclosure",
  ],
  lubaSwipeable: ["swipeable", "swipe", "swipe to delete", "swipe action"],
  lubaShimmerable: ["shimmer", "loading effect", "shimmer effect"],
  lubaLongPressable: ["long press", "hold", "press and hold"],
  lubaGlass: [
    "glass",
    "frosted",
    "blur",
    "material",
    "translucent",
    "transparent",
    "vibrancy",
  ],
};

function matchComponent(description: string) {
  const lower = description.toLowerCase();
  const matches: Array<{
    name: string;
    score: number;
    matchedKeywords: string[];
  }> = [];

  for (const [name, keywords] of Object.entries(componentKeywords)) {
    const matched = keywords.filter((k) => lower.includes(k));
    if (matched.length > 0) {
      matches.push({ name, score: matched.length, matchedKeywords: matched });
    }
  }

  matches.sort((a, b) => b.score - a.score);
  const top = matches.slice(0, 3);

  return top.map((m) => {
    const comp = componentsData.find((c) => c.name === m.name);
    return {
      lubaComponent: m.name,
      confidence: m.score >= 2 ? "high" : "medium",
      matchedKeywords: m.matchedKeywords,
      ...(comp
        ? {
            description: comp.description,
            example: comp.example,
            parameters: comp.parameters,
            notes: comp.notes,
          }
        : {}),
    };
  });
}

function matchPrimitive(description: string) {
  const lower = description.toLowerCase();
  const matches: Array<{
    name: string;
    score: number;
    matchedKeywords: string[];
  }> = [];

  for (const [name, keywords] of Object.entries(primitiveKeywords)) {
    const matched = keywords.filter((k) => lower.includes(k));
    if (matched.length > 0) {
      matches.push({ name, score: matched.length, matchedKeywords: matched });
    }
  }

  matches.sort((a, b) => b.score - a.score);
  return matches.slice(0, 3).map((m) => {
    const prim = primitivesData.find((p) => p.name === m.name);
    return {
      lubaPrimitive: m.name,
      modifier: prim?.modifier,
      matchedKeywords: m.matchedKeywords,
      ...(prim
        ? {
            description: prim.description,
            example: prim.example,
          }
        : {}),
    };
  });
}

// --- Main migration function ---

interface MigrationInput {
  colors?: Array<{
    name: string;
    value: string;
    usage?: string;
  }>;
  spacing?: Array<{
    name: string;
    value: number;
  }>;
  radii?: Array<{
    name: string;
    value: number;
  }>;
  typography?: Array<{
    name: string;
    size: number;
    weight?: string;
  }>;
  components?: Array<{
    name: string;
    description: string;
  }>;
}

export function planMigration(sourceDescription: string, tokens?: MigrationInput) {
  const result: Record<string, unknown> = {
    sourceSystem: sourceDescription,
  };

  // --- Token mappings ---
  if (tokens?.colors && tokens.colors.length > 0) {
    result.colorMappings = tokens.colors.map((src) => {
      const match = findNearestColor(src.value, "light");
      return {
        source: { name: src.name, value: src.value, usage: src.usage },
        lubaUI: match.exact
          ? {
              api: match.exact.api,
              light: match.exact.light,
              dark: match.exact.dark,
              match: "exact",
            }
          : {
              api: match.nearest?.api,
              light: match.nearest?.light,
              dark: match.nearest?.dark,
              match: "nearest",
              distance: Math.round(match.distance),
              alternatives: match.candidates,
            },
      };
    });
  }

  if (tokens?.spacing && tokens.spacing.length > 0) {
    result.spacingMappings = tokens.spacing.map((src) => {
      const match = findNearestScale(src.value, spacingScale);
      return {
        source: { name: src.name, value: src.value },
        lubaUI: match.exact
          ? { api: match.exact.api, value: match.exact.value, match: "exact" }
          : {
              api: match.nearest.api,
              value: match.nearest.value,
              match: "nearest",
              delta: `${src.value - match.nearest.value}pt`,
              note:
                src.value % 4 === 0
                  ? `On 4pt grid. Use LubaSpacing.custom(${src.value / 4}) for exact value.`
                  : `Not on 4pt grid. Consider rounding to ${match.nearest.value}pt.`,
            },
      };
    });
  }

  if (tokens?.radii && tokens.radii.length > 0) {
    result.radiusMappings = tokens.radii.map((src) => {
      const match = findNearestScale(src.value, radiusScale);
      return {
        source: { name: src.name, value: src.value },
        lubaUI: match.exact
          ? { api: match.exact.api, value: match.exact.value, match: "exact" }
          : {
              api: match.nearest.api,
              value: match.nearest.value,
              match: "nearest",
              delta: `${src.value - match.nearest.value}pt`,
            },
      };
    });
  }

  if (tokens?.typography && tokens.typography.length > 0) {
    result.typographyMappings = tokens.typography.map((src) => {
      const match = findNearestTypography(src.size, src.weight);
      return {
        source: { name: src.name, size: src.size, weight: src.weight },
        lubaUI: match.exact
          ? {
              api: match.exact.api,
              size: match.exact.size,
              weight: match.exact.weight,
              match: "exact",
            }
          : {
              api: match.nearest.api,
              size: match.nearest.size,
              weight: match.nearest.weight,
              match: "nearest",
              note:
                match.alternatives.length > 0
                  ? `Multiple tokens at this size: ${match.alternatives.map((a) => a.api).join(", ")}`
                  : `Nearest size. Use LubaTypography.custom(size: ${src.size}, weight: .${src.weight ?? "regular"}) for exact match.`,
            },
      };
    });
  }

  // --- Component mappings ---
  if (tokens?.components && tokens.components.length > 0) {
    result.componentMappings = tokens.components.map((src) => {
      const compMatches = matchComponent(src.description);
      const primMatches = matchPrimitive(src.description);
      return {
        source: { name: src.name, description: src.description },
        lubaComponents: compMatches,
        lubaPrimitives: primMatches.length > 0 ? primMatches : undefined,
      };
    });
  }

  // --- Summary ---
  const mappingCounts = {
    colors: (result.colorMappings as unknown[])?.length ?? 0,
    spacing: (result.spacingMappings as unknown[])?.length ?? 0,
    radii: (result.radiusMappings as unknown[])?.length ?? 0,
    typography: (result.typographyMappings as unknown[])?.length ?? 0,
    components: (result.componentMappings as unknown[])?.length ?? 0,
  };

  const totalMappings = Object.values(mappingCounts).reduce((a, b) => a + b, 0);

  result.summary = {
    totalMappings,
    mappingCounts,
    tip: totalMappings === 0
      ? "Provide token arrays (colors, spacing, radii, typography, components) for detailed mappings. Or read lubaui://reference/full for the complete system reference."
      : "Review the mappings above. 'exact' matches are direct replacements. 'nearest' matches may need visual review.",
  };

  return result;
}
