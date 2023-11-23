import { Plugin } from "@core/model";
import { plugin as imageNvim } from "./image-nvim";


function newLibPlugin(name: string) {
  return new Plugin({
    shortUrl: name,
    lazy: {
      lazy: true,
    }
  });
}

export const plugins = [
  newLibPlugin("MunifTanjim/nui.nvim"),
  newLibPlugin("nvim-lua/popup.nvim"),
  newLibPlugin("nvim-lua/plenary.nvim"),
  newLibPlugin("nvim-tree/nvim-web-devicons"),
  imageNvim
] as const;
