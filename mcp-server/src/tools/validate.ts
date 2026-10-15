import { tokensData } from "./lookup.js";

type ScaleEntry = { name: string; api: string; value: number };
// Lookup and validation must share the same catalog, including half-grid tokens.
const spacingScale: ScaleEntry[] = tokensData.spacing.tokens;
const radiusScale: ScaleEntry[] = tokensData.radius.tokens;

function findNearest(value: number, scale: typeof spacingScale) {
  let closest = scale[0];
  let closestDist = Math.abs(value - closest.value);

  for (const entry of scale) {
    const dist = Math.abs(value - entry.value);
    if (dist < closestDist) {
      closest = entry;
      closestDist = dist;
    }
  }

  // Also find the bracketing tokens
  const below = [...scale].reverse().find((s) => s.value <= value);
  const above = scale.find((s) => s.value >= value);

  return { closest, below, above };
}

export function validateSpacing(value: number) {
  const exactMatch = spacingScale.find((s) => s.value === value);

  if (exactMatch) {
    return {
      valid: true,
      onGrid: value % 4 === 0,
      token: exactMatch,
      message: `${value}pt is ${exactMatch.api} (${exactMatch.name})`,
    };
  }

  const onGrid = value % 4 === 0;
  const { closest, below, above } = findNearest(value, spacingScale);

  return {
    valid: false,
    onGrid,
    value,
    suggestion: closest,
    nearest: {
      below: below ?? null,
      above: above ?? null,
    },
    message: onGrid
      ? `${value}pt is on the 4pt grid but not a named token. Nearest: ${closest.api} (${closest.value}pt). Use LubaSpacing.custom(${value / 4}) for grid-aligned custom values.`
      : `${value}pt is NOT on the 4pt grid. Nearest named tokens: ${below ? `${below.api} (${below.value}pt)` : "none"} and ${above ? `${above.api} (${above.value}pt)` : "none"}.`,
  };
}

export function validateRadius(value: number) {
  const exactMatch = radiusScale.find((r) => r.value === value);

  if (exactMatch) {
    return {
      valid: true,
      token: exactMatch,
      message: `${value}pt is ${exactMatch.api} (${exactMatch.name})`,
    };
  }

  const { closest, below, above } = findNearest(
    value,
    radiusScale.filter((r) => r.value !== 9999) // Exclude full for nearest calculation
  );

  return {
    valid: false,
    value,
    suggestion: closest,
    nearest: {
      below: below ?? null,
      above: above ?? null,
    },
    message: `${value}pt is not on the LubaRadius scale. Nearest: ${closest.api} (${closest.value}pt). Valid radii: ${radiusScale.map((r) => `${r.name}(${r.value})`).join(", ")}.`,
  };
}
