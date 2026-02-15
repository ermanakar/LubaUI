import { readFileSync } from "fs";
import { join } from "path";
import { search, type SearchableItem } from "../utils/search.js";
import { dataDir } from "../utils/paths.js";

const componentsData = JSON.parse(
  readFileSync(join(dataDir, "components.json"), "utf-8")
) as Array<{ name: string; description: string; [key: string]: unknown }>;

const primitivesData = JSON.parse(
  readFileSync(join(dataDir, "primitives.json"), "utf-8")
) as Array<{ name: string; description: string; [key: string]: unknown }>;

// Keyword mappings for common UI patterns
const patternSuggestions: Record<
  string,
  {
    spacing: string[];
    colors: string[];
    radius: string[];
    typography: string[];
    components: string[];
    primitives: string[];
  }
> = {
  form: {
    spacing: ["LubaSpacing.sm (8pt) between fields", "LubaSpacing.lg (16pt) section gaps"],
    colors: ["LubaColors.surface for field background", "LubaColors.border for field borders", "LubaColors.error for validation"],
    radius: ["LubaRadius.md (12pt) for fields"],
    typography: ["LubaTypography.body for field text", "LubaTypography.caption for helper text", "LubaTypography.button for submit"],
    components: ["LubaTextField", "LubaTextArea", "LubaCheckbox", "LubaRadio", "LubaToggle", "LubaButton"],
    primitives: [],
  },
  notification: {
    spacing: ["LubaSpacing.md (12pt) internal padding", "LubaSpacing.lg (16pt) horizontal padding"],
    colors: ["LubaColors.success/warning/error for status", "LubaColors.surface for background"],
    radius: ["LubaRadius.md (12pt) for toast/alert"],
    typography: ["LubaTypography.subheadline for message", "LubaTypography.buttonSmall for action"],
    components: ["LubaToast", "LubaAlert"],
    primitives: ["lubaGlass for frosted effect"],
  },
  banner: {
    spacing: ["LubaSpacing.md (12pt) vertical padding", "LubaSpacing.lg (16pt) horizontal padding"],
    colors: ["LubaColors.success/warning/error for status", "LubaColors.surface for background"],
    radius: ["LubaRadius.md (12pt)"],
    typography: ["LubaTypography.headline for title", "LubaTypography.body for message"],
    components: ["LubaAlert"],
    primitives: ["lubaGlass for frosted effect"],
  },
  card: {
    spacing: ["LubaSpacing.lg (16pt) card padding", "LubaSpacing.sm (8pt) content gaps"],
    colors: ["LubaColors.surface for background", "LubaColors.textPrimary for title", "LubaColors.textSecondary for description"],
    radius: ["LubaRadius.md (12pt) card corners"],
    typography: ["LubaTypography.headline for title", "LubaTypography.body for content", "LubaTypography.caption for metadata"],
    components: ["LubaCard"],
    primitives: ["lubaPressable for tappable cards", "lubaExpandable for expandable cards", "lubaGlass for glass cards"],
  },
  list: {
    spacing: ["LubaSpacing.sm (8pt) between items", "LubaSpacing.lg (16pt) row padding"],
    colors: ["LubaColors.surface for row background", "LubaColors.border for separators"],
    radius: ["LubaRadius.md (12pt) for row cards"],
    typography: ["LubaTypography.body for primary text", "LubaTypography.bodySmall for secondary"],
    components: ["LubaCard", "LubaDivider", "LubaAvatar"],
    primitives: ["lubaSwipeable for swipe actions", "lubaPressable for tap actions"],
  },
  loading: {
    spacing: ["LubaSpacing.md (12pt) around loading indicators"],
    colors: ["LubaColors.accent for active indicators", "LubaColors.gray200 for tracks"],
    radius: ["LubaRadius.xs (4pt) for skeleton elements"],
    typography: ["LubaTypography.caption for loading labels"],
    components: ["LubaSpinner", "LubaProgressBar", "LubaCircularProgress", "LubaSkeleton"],
    primitives: ["lubaShimmerable for shimmer effect"],
  },
  navigation: {
    spacing: ["LubaSpacing.lg (16pt) tab padding", "LubaSpacing.xs (4pt) icon-label gap"],
    colors: ["LubaColors.accent for selected", "LubaColors.textSecondary for unselected"],
    radius: ["LubaRadius.sm (8pt) for tab indicators"],
    typography: ["LubaTypography.footnote for tab labels"],
    components: ["LubaTabs", "LubaSearchBar"],
    primitives: ["lubaGlass for glass tab bar"],
  },
  profile: {
    spacing: ["LubaSpacing.lg (16pt) between elements", "LubaSpacing.xl (24pt) section gaps"],
    colors: ["LubaColors.surface for card", "LubaColors.textPrimary for name", "LubaColors.textSecondary for details"],
    radius: ["LubaRadius.full (9999) for avatar"],
    typography: ["LubaTypography.title2 for name", "LubaTypography.body for details", "LubaTypography.caption for metadata"],
    components: ["LubaAvatar", "LubaCard", "LubaBadge", "LubaButton"],
    primitives: [],
  },
  modal: {
    spacing: ["LubaSpacing.lg (16pt) header/content padding", "LubaSpacing.xl (24pt) between sections"],
    colors: ["LubaColors.surface for background", "LubaColors.textPrimary for title"],
    radius: ["LubaRadius.lg (16pt) for sheet corners"],
    typography: ["LubaTypography.title3 for sheet title", "LubaTypography.body for content"],
    components: ["LubaSheet", "LubaButton"],
    primitives: ["lubaGlass for glass header"],
  },
  settings: {
    spacing: ["LubaSpacing.lg (16pt) row padding", "LubaSpacing.sm (8pt) label-control gap"],
    colors: ["LubaColors.surface for rows", "LubaColors.textPrimary for labels"],
    radius: ["LubaRadius.md (12pt) for grouped sections"],
    typography: ["LubaTypography.body for labels", "LubaTypography.bodySmall for descriptions"],
    components: ["LubaToggle", "LubaSlider", "LubaStepper", "LubaCard", "LubaDivider"],
    primitives: ["lubaExpandable for expandable settings"],
  },
};

export function suggestTokens(description: string) {
  const lower = description.toLowerCase();

  // Find matching patterns
  const matchedPatterns: string[] = [];
  for (const pattern of Object.keys(patternSuggestions)) {
    if (lower.includes(pattern)) {
      matchedPatterns.push(pattern);
    }
  }

  // Also search components and primitives for relevance
  const componentSearchable = componentsData.map((c) => ({
    ...c,
    aliases: [c.name.replace("Luba", "")],
  })) as (typeof componentsData[0] & SearchableItem)[];

  const primitiveSearchable = primitivesData.map((p) => ({
    ...p,
    aliases: [p.name.replace("luba", "")],
  })) as (typeof primitivesData[0] & SearchableItem)[];

  const relevantComponents = search(componentSearchable, description, {
    maxResults: 5,
  });
  const relevantPrimitives = search(primitiveSearchable, description, {
    maxResults: 3,
  });

  // Helper: resolve component names to full specs
  function resolveComponents(names: Iterable<string>) {
    const results: typeof componentsData = [];
    const seen = new Set<string>();
    for (const name of names) {
      const match = componentsData.find(
        (c) => c.name === name || c.name === `Luba${name}` || c.name.toLowerCase() === name.toLowerCase()
      );
      if (match && !seen.has(match.name)) {
        seen.add(match.name);
        results.push(match);
      }
    }
    return results.map((c) => ({
      name: c.name,
      description: c.description,
      parameters: c.parameters,
      example: c.example,
      tokens: c.tokens,
      notes: c.notes,
    }));
  }

  // Helper: resolve primitive names to full specs
  function resolvePrimitives(names: Iterable<string>) {
    const results: typeof primitivesData = [];
    const seen = new Set<string>();
    for (const name of names) {
      // Match against name, stripped prefix, or partial match (e.g. "lubaGlass for frosted effect" → "lubaGlass")
      const normalizedName = name.split(" ")[0].toLowerCase();
      const match = primitivesData.find(
        (p) =>
          p.name.toLowerCase() === normalizedName ||
          p.name.toLowerCase() === `luba${normalizedName}` ||
          p.name.replace("luba", "").toLowerCase() === normalizedName
      );
      if (match && !seen.has(match.name)) {
        seen.add(match.name);
        results.push(match);
      }
    }
    return results.map((p) => ({
      name: p.name,
      modifier: p.modifier,
      description: p.description,
      parameters: p.parameters,
      example: p.example,
      tokens: p.tokens,
      composability: p.composability,
      ...("presets" in p ? { presets: p.presets } : {}),
      ...("variants" in p ? { variants: p.variants } : {}),
    }));
  }

  if (matchedPatterns.length > 0) {
    // Merge suggestions from all matched patterns
    const merged = {
      spacing: new Set<string>(),
      colors: new Set<string>(),
      radius: new Set<string>(),
      typography: new Set<string>(),
      components: new Set<string>(),
      primitives: new Set<string>(),
    };

    for (const p of matchedPatterns) {
      const s = patternSuggestions[p];
      s.spacing.forEach((v) => merged.spacing.add(v));
      s.colors.forEach((v) => merged.colors.add(v));
      s.radius.forEach((v) => merged.radius.add(v));
      s.typography.forEach((v) => merged.typography.add(v));
      s.components.forEach((v) => merged.components.add(v));
      s.primitives.forEach((v) => merged.primitives.add(v));
    }

    return {
      matchedPatterns,
      suggestions: {
        spacing: [...merged.spacing],
        colors: [...merged.colors],
        radius: [...merged.radius],
        typography: [...merged.typography],
      },
      recommendedComponents: resolveComponents(merged.components),
      recommendedPrimitives: resolvePrimitives(merged.primitives),
    };
  }

  // Fallback: return search-based suggestions with full specs
  return {
    matchedPatterns: [],
    note: "No exact pattern match. Showing relevant components and primitives based on your description.",
    recommendedComponents: relevantComponents.map((c) => ({
      name: c.name,
      description: (c as Record<string, unknown>).description as string,
      parameters: (c as Record<string, unknown>).parameters,
      example: (c as Record<string, unknown>).example,
      tokens: (c as Record<string, unknown>).tokens,
      notes: (c as Record<string, unknown>).notes,
    })),
    recommendedPrimitives: relevantPrimitives.map((p) => ({
      name: p.name,
      modifier: (p as Record<string, unknown>).modifier,
      description: (p as Record<string, unknown>).description as string,
      parameters: (p as Record<string, unknown>).parameters,
      example: (p as Record<string, unknown>).example,
      tokens: (p as Record<string, unknown>).tokens,
      composability: (p as Record<string, unknown>).composability,
    })),
    generalGuidance: {
      spacing: "Use LubaSpacing tokens (xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48, huge=64). All on the 4pt grid.",
      colors: "Use LubaColors semantic tokens. textPrimary for main text, textSecondary for descriptions, accent for interactive, surface for backgrounds.",
      radius: "Use LubaRadius tokens (none=0, xs=4, sm=8, md=12, lg=16, xl=24, full=9999). md is the most common for components.",
      typography: "Use LubaTypography tokens. headline for titles, body for content, caption for metadata, button for actions.",
    },
  };
}
