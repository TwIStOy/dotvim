/**
 * Unique array elements.
 *
 * @param arr Array to unique.
 * @returns A new array with unique elements.
 */
export function uniqueArray<T>(arr: T[]): T[] {
  return Array.from(new Set(arr));
}
