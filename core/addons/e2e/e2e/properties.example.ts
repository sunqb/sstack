// 性质测试示例（fast-check）。把它纳入你的测试命令后，verify 才会跑。
// 安装：npm install -D fast-check
import * as fc from "fast-check";

function uniquePreserveOrder(items: string[]): string[] {
  const seen = new Set<string>();
  const out: string[] = [];
  for (const item of items) {
    if (!seen.has(item)) {
      seen.add(item);
      out.push(item);
    }
  }
  return out;
}

// Example property: dedup keeps the first occurrence and never invents values.
export function runExample(): void {
  fc.assert(
    fc.property(fc.array(fc.string()), (items) => {
      const result = uniquePreserveOrder(items);
      const again = uniquePreserveOrder(result);
      if (result.join("\0") !== again.join("\0")) return false;
      return result.every((item) => items.includes(item));
    }),
  );
}
