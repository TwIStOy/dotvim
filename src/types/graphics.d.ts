declare namespace graphics {
  interface Renderer {}

  interface BuildContext {
    renderer: Renderer;

    /**
     * @description Render the widget.
     */
    build(widget: Widget): void;

    /**
     * @description Generate a PNG image from the current renderer.
     */
    intoPngBytes(): number[];
  }

  interface BuildingInjections {
    maxHeight: number;
    maxWidth: number;
    minHeight: number;
    minWidth: number;
  }

  interface Widget {
    _injection: BuildingInjections | null;

    /*
     * Children widgets.
     */
    children: Widget[];

    /**
     * Set the injection for the `BuildContext`.
     */
    prepareBuild(injection: BuildingInjections): void;

    /**
     * @description Render the widget.
     */
    build(context: BuildContext): void;

    /**
     * @description Check if the widget can be rendered.
     */
    canRender(): boolean;
  }
}
