import { Trade } from "@/lib/models/trade";

export const MIN_TRADES_PER_YEAR = 10;

/**
 * Estimate annual trade frequency from a sample of trades.
 *
 * Ensures realistic pacing for strategy-filtered simulations where the global
 * portfolio frequency would otherwise overstate the number of opportunities.
 */
export function estimateTradesPerYear(
  sampleTrades: Trade[],
  fallback: number
): number {
  if (sampleTrades.length < 2) {
    return Math.max(MIN_TRADES_PER_YEAR, fallback);
  }

  const sortedTrades = [...sampleTrades].sort(
    (a, b) => a.dateOpened.getTime() - b.dateOpened.getTime()
  );

  const firstDate = sortedTrades[0].dateOpened;
  const lastDate = sortedTrades[sortedTrades.length - 1].dateOpened;
  const daysElapsed =
    (lastDate.getTime() - firstDate.getTime()) / (1000 * 60 * 60 * 24);

  if (daysElapsed <= 0) {
    return Math.max(MIN_TRADES_PER_YEAR, fallback);
  }

  const yearsElapsed = daysElapsed / 365.25;
  if (yearsElapsed < 0.01) {
    return Math.max(MIN_TRADES_PER_YEAR, fallback);
  }

  const computed = Math.round(sampleTrades.length / yearsElapsed);
  return Math.max(MIN_TRADES_PER_YEAR, computed);
}
