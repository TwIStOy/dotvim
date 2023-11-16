declare interface TelescopeEntry<T> {
  value: T;
  display: string | ((entry: TelescopeEntry<T>) => string);
  ordinal: string;
}
