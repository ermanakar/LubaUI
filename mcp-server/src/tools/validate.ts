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
