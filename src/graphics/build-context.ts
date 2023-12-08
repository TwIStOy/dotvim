import { randv4 } from "@core/utils/uuid";
import { CairoRender } from "./cairo-render";
import { RenderBox } from "./base";

export class BuildContext {
  public renderer: CairoRender;
  public key: string;

  constructor(width: number, height: number) {
    this.renderer = new CairoRender(width, height);
    this.key = randv4();
  }

  getInitialRenderBox(): RenderBox {
    return {
      contextKey: this.key,
      position: {
        x: 0,
        y: 0,
      },
      width: this.renderer.width,
      height: this.renderer.height,
    };
  }

  intoPngBytes(): number[] {
    return this.renderer.toPngBytes();
  }
}
