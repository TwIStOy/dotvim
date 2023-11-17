declare namespace vim {
  export namespace keymap {
    /**
     * Adds a new mapping.
     */
    function set(
      mode: string | string[],
      lhs: string,
      rhs: string | (() => void),
      opts?: {
        replace_keycodes?: boolean;
        noremap?: boolean;
        buffer?: number | boolean;
        remap?: boolean;
        desc?: string;
      }
    ): void;
  }
}
