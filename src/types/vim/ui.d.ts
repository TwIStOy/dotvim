declare namespace vim {
  export namespace ui {
    export function input(
      opts: {
        /**
         * Text of prompt
         */
        prompt?: string;
        /**
         * Default reply to the input
         */
        default?: string;
        /**
         * Specifies type of completion support for input.
         */
        completion?: string;
        /**
         * Highlight
         */
        highlight?: () => void;
      },
      on_confirm: (input?: string) => void
    ): void;
  }
}
