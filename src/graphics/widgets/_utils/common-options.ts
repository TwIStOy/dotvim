import { AllOptional } from "@core/type_traits";
import { AnyColor } from "./color";
import { ifNil } from "@core/vim";

export interface BorderOptions {
  /**
   * @description The border radius of the container.
   */
  radius?: number;
  /**
   * @description The border width of the container.
   */
  width: number;
  /**
   * @description The border color of the container.
   */
  color?: AnyColor;
}

export interface PaddingOptions {
  /**
   * @description The padding top of the container.
   */
  top: number;
  /**
   * @description The padding right of the container.
   */
  right: number;
  /**
   * @description The padding bottom of the container.
   */
  bottom: number;
  /**
   * @description The padding left of the container.
   */
  left: number;
}

export class Padding {
  static zero: PaddingOptions = {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
  };

  static all(value: number): PaddingOptions {
    return {
      top: value,
      right: value,
      bottom: value,
      left: value,
    };
  }

  static vertical(value: number): PaddingOptions {
    return {
      top: value,
      right: 0,
      bottom: value,
      left: 0,
    };
  }

  static horizontal(value: number): PaddingOptions {
    return {
      top: 0,
      right: value,
      bottom: 0,
      left: value,
    };
  }

  static from(value: AllOptional<PaddingOptions>): PaddingOptions {
    return {
      top: ifNil(value.top, 0),
      right: ifNil(value.right, 0),
      bottom: ifNil(value.bottom, 0),
      left: ifNil(value.left, 0),
    };
  }
}

export interface MarginOptions {
  /**
   * @description The margin top of the container.
   */
  top: number;
  /**
   * @description The margin right of the container.
   */
  right: number;
  /**
   * @description The margin bottom of the container.
   */
  bottom: number;
  /**
   * @description The margin left of the container.
   */
  left: number;
}

export class Margin {
  static zero: MarginOptions = {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
  };

  static all(value: number): MarginOptions {
    return {
      top: value,
      right: value,
      bottom: value,
      left: value,
    };
  }
}
