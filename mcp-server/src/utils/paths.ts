import { existsSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Resolve data directory — works from both src/ (dev) and dist/ (published)
function resolveDataDir(): string {
  // From src/utils/ → src/data/
  const fromSrc = join(__dirname, "..", "data");
  if (existsSync(fromSrc)) return fromSrc;

  // From dist/utils/ → src/data/ (npm published layout)
  const fromDist = join(__dirname, "..", "..", "src", "data");
  if (existsSync(fromDist)) return fromDist;

  throw new Error("Could not locate data directory");
}

export const dataDir = resolveDataDir();
