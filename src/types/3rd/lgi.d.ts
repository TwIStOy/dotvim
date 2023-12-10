declare module "lgi" {
  namespace cairo {
    type ImageType = "argb32" | "rgb24";

    class Surface {
      write_to_png(filename: string): void;
      flush(): void;
    }

    export namespace enums {
      export namespace CAIRO_STATUS_ {
        export const success: any;
      }
    }

    class Pattern {}
    class TextExtents {
      x_bearing: number;
      y_bearing: number;
      width: number;
      height: number;
      x_advance: number;
      y_advance: number;
    }
    class FontExtents {
      ascent: number;
      descent: number;
      height: number;
      max_x_advance: number;
      max_y_advance: number;
    }

    function ImageSurface(
      this: void,
      type: number,
      width: number,
      height: number
    ): Surface;

    type LineCap = "butt" | "round" | "square";
    type LineJoin = "miter" | "round" | "bevel";
    type Operator =
      | "clear"
      | "source"
      | "over"
      | "in"
      | "out"
      | "atop"
      | "dest"
      | "dest_over"
      | "dest_in"
      | "dest_out"
      | "dest_atop"
      | "xor"
      | "add"
      | "saturate"
      | "multiply"
      | "screen"
      | "overlay"
      | "darken"
      | "lighten"
      | "color_dodge"
      | "color_burn"
      | "hard_light"
      | "soft_light"
      | "difference"
      | "exclusion"
      | "hsl_hue"
      | "hsl_saturation"
      | "hsl_color"
      | "hsl_luminosity";

    function Context(surface: Surface): Context;
    class Context {
      save(): void;
      restore(): void;

      set_source_rgb(r: number, g: number, b: number): void;
      set_source_rgba(r: number, g: number, b: number, a: number): void;

      new_sub_path(): void;
      move_to(x: number, y: number): void;



      source(source: Surface, x?: number, y?: number): void;
      operator(): Operator;
      operator(op: Operator): void;

      font_face(name: string, slant: string, weight: string): void;
      font_size(size: number): void;

      line_width(): number;
      set_line_width(value: number): void;

      miter_limit(): number;
      miter_limit(value: number): void;
      line_cap(): LineCap;
      line_cap(value: LineCap): void;
      line_join(): LineJoin;
      line_join(value: LineJoin): void;

      get_matrix(): Matrix;
      set_matrix(m: Matrix): void;
      transform(m: Matrix): this;
      translate(x: number, y: number): this;
      scale(x: number, y: number): this;
      rotate(rads: number): this;

      new_path(): void;
      line_to(x: number, y: number): void;
      curve_to(
        x1: number,
        y1: number,
        x2: number,
        y2: number,
        x3: number,
        y3: number
      ): void;
      quad_curve_to(x1: number, y1: number, x2: number, y2: number): void;
      arc(
        xc: number,
        yc: number,
        radius: number,
        angle1: number,
        angle2: number
      ): void;
      arc_negative(
        xc: number,
        yc: number,
        radius: number,
        angle1: number,
        angle2: number
      ): void;
      rel_move_to(x: number, y: number): void;
      rel_line_to(x: number, y: number): void;
      rel_curve_to(
        x1: number,
        y1: number,
        x2: number,
        y2: number,
        x3: number,
        y3: number
      ): void;
      rel_quad_curve_to(x1: number, y1: number, x2: number, y2: number): void;
      close_path(): void;
      path_extents(): [number, number, number, number];
      mask(pattern: Pattern): void;
      mask_surface(surface: Surface, x: number, y: number): void;
      elliptic_arc(
        cx: number,
        cy: number,
        rx: number,
        ry: number,
        rotation: number,
        a1: number,
        a2: number
      ): void;
      elliptic_arc_negative(
        cx: number,
        cy: number,
        rx: number,
        ry: number,
        rotation: number,
        a1: number,
        a2: number
      ): void;

      rectangle(x: number, y: number, width: number, height: number): void;
      rounded_rectangle(
        x: number,
        y: number,
        width: number,
        height: number,
        radius: number
      ): void;

      fill(): void;
      fill_preserve(): void;
      stroke(): void;
      stroke_preserve(): void;

      paint(): void;
      paint_with_alpha(alpha: number): void;

      reset_clip(): void;
      clip(): void;
      clip_preserve(): void;
      clip_extends(): [number, number, number, number];

      show_text(text: string): void;
      text_path(text: string): void;
      text_extents(text: string): TextExtents;
      font_extents(): FontExtents;
    }

    class Matrix {}

    /** @noSelf */
    function matrix(
      a?: number,
      b?: number,
      c?: number,
      d?: number,
      e?: number,
      f?: number
    ): Matrix;
  }

  namespace Pango {
    const SCALE: number;

    class Layout {
      set_markup(text: string, length: number): void;
      /**
       * Sets the single paragraph mode of layout.
       *
       * If setting is TRUE, do not treat newlines and similar characters as
       * paragraph separators; instead, keep all text in a single paragraph, and
       * display a glyph for paragraph separator characters. Used when you want
       * to allow editing of newlines on a single text line.
       *
       * The default value is `FALSE`.
       */
      set_single_paragraph_mode(setting: boolean): void;
      /**
       * Sets the width to which the lines of the `PangoLayout` should wrap
       * or ellipsized.
       *
       * The default value is -1: no width set.
       */
      set_width(width: number): void;
      get_pixel_size(): LuaMultiReturn<[number, number]>;
    }
  }

  namespace PangoCairo {
    function create_layout(cr: cairo.Context): Pango.Layout;

    function show_layout(cr: cairo.Context, layout: Pango.Layout): void;
  }
}
