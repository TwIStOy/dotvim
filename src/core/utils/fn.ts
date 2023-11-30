export function callOnce<R>(fn: () => R): () => R {
  let called = false;
  let result: R;
  return () => {
    if (!called) {
      called = true;
      result = fn();
    }
    return result;
  };
}
