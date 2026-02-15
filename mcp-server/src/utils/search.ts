export interface SearchableItem {
  name: string;
  aliases?: string[];
  category?: string;
  description?: string;
  [key: string]: unknown;
}

interface ScoredResult<T> {
  item: T;
  score: number;
}

function splitCamelCase(str: string): string[] {
  return str
    .replace(/([a-z])([A-Z])/g, "$1 $2")
    .replace(/([A-Z]+)([A-Z][a-z])/g, "$1 $2")
    .toLowerCase()
    .split(/[\s._-]+/)
    .filter(Boolean);
}

function scoreMatch(query: string, target: string): number {
  const q = query.toLowerCase();
  const t = target.toLowerCase();

  if (t === q) return 100;
  if (t.startsWith(q)) return 80;
  if (t.includes(q)) return 60;

  // camelCase part match
  const targetParts = splitCamelCase(target);
  const queryParts = splitCamelCase(query);

  const matchedParts = queryParts.filter((qp) =>
    targetParts.some((tp) => tp.startsWith(qp) || tp.includes(qp))
  );

  if (matchedParts.length > 0) {
    return 50 * (matchedParts.length / queryParts.length);
  }

  return 0;
}

export function search<T extends SearchableItem>(
  items: T[],
  query: string,
  options?: { category?: string; maxResults?: number }
): T[] {
  const maxResults = options?.maxResults ?? 10;

  let candidates = items;
  if (options?.category) {
    const cat = options.category.toLowerCase();
    candidates = items.filter(
      (item) => item.category?.toLowerCase() === cat
    );
  }

  const scored: ScoredResult<T>[] = [];

  for (const item of candidates) {
    let bestScore = scoreMatch(query, item.name);

    if (item.aliases) {
      for (const alias of item.aliases) {
        bestScore = Math.max(bestScore, scoreMatch(query, alias));
      }
    }

    if (item.description) {
      const descScore = scoreMatch(query, item.description) * 0.5;
      bestScore = Math.max(bestScore, descScore);
    }

    if (bestScore > 0) {
      scored.push({ item, score: bestScore });
    }
  }

  scored.sort((a, b) => b.score - a.score);
  return scored.slice(0, maxResults).map((s) => s.item);
}
