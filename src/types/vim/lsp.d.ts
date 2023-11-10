declare namespace vim {
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
  }
}
