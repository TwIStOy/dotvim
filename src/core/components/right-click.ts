import { ClickableComponent } from "./clickable";

export interface RightClickOpt {
  shortCut?: string;
  path?: string;
}

export class RightClickMenuItemComponent implements ClickableComponent {
  onClick() {
    throw new Error("Method not implemented.");
  }
}
