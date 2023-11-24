declare namespace vim {
  export namespace diagnostic {
    export function open_float(
      this: void,
      opts?: AnyTable
    ): LuaMultiReturn<[number, number]> | LuaMultiReturn<[null, null]>;

    export namespace severity {
      export const ERROR: number;
      export const WARN: number;
      export const INFO: number;
      export const HINT: number;
    }

    export function goto_prev(opts?: {
      namespace?: number;
      cursor_position?: [number, number];
      wrap?: boolean;
      severity?: number;
      float?: boolean | AnyTable;
      win_id?: number;
    }): void;

    export function goto_next(opts?: {
      namespace?: number;
      cursor_position?: [number, number];
      wrap?: boolean;
      severity?: number;
      float?: boolean | AnyTable;
      win_id?: number;
    }): void;
  }

  export namespace lsp {
    export interface client {
      /**
       * The id allocated to the client.
       */
      id: number;
      /**
       * If a name is specified on creation, that will be used. Otherwise it is
       * just the client id. This is used for logs and messages.
       */
      name: string;
      /**
       * The encoding used for communicating with the server.
       */
      offset_encoding: string;
    }
    /**
     * Get active clients.
     */
    export function get_clients(filter?: {
      /**
       * Only return clients with the given id
       */
      id?: number;
      /**
       * Only return clients attached to this buffer
       */
      bufnr?: number;
      /**
       * Only return clients with the given name
       */
      name?: string;
      /**
       * Only return clients supporting the given method
       */
      method?: string;
    }): client[];

    export namespace buf {
      type LspOnListHandler = (options: {
        items: LuaTable[];
        title: string;
        context: LuaTable | null;
      }) => void;

      /**
       * Jumps to the declaration of the symbol under the cursor.
       */
      export function declaration(
        this: void,
        options?: {
          reuse_win?: boolean;
          on_list?: LspOnListHandler;
        }
      ): void;

      /**
       * Jumps to the definition of the symbol under the cursor.
       */
      export function definition(
        this: void,
        options?: {
          reuse_win?: boolean;
          on_list?: LspOnListHandler;
        }
      ): void;

      export function rename(
        this: void,
        new_name?: string,
        options?: {
          filter?: (client: client) => boolean;
          name?: string;
        }
      ): void;

      export function hover(this: void): void;
    }
  }
}
