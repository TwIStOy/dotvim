declare module "ht.utils.base64" {
  /**
   * Encode a string to base64.
   */
  export function encode(str: string): string;

  export function encode_bytes(bytes: any[], length?: number): string;
}  
