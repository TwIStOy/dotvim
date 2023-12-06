export interface ImageRenderBackend {
  /**
   * Returns whether the backend is supported.
   */
  supported(): boolean;
}
