_: let
  kopicat_base = {
    red = "#ff657a";
    maroon = "#F29BA7";
    peach = "#ff9b5e";
    yellow = "#eccc81";
    green = "#a8be81";
    teal = "#9cd1bb";
    sky = "#A6C9E5";
    sapphire = "#86AACC";
    blue = "#5d81ab";
    lavender = "#66729C";
    mauve = "#b18eab";
  };

  kopicat_light =
    kopicat_base
    // {
      text = "#202027";
      subtext1 = "#263168";
      subtext0 = "#4c4f69";
      overlay2 = "#737994";
      overlay1 = "#838ba7";
      base = "#fcfcfa";
      mantle = "#EAEDF3";
      crust = "#DCE0E8";
      pink = "#EA7A95";
      mauve = "#986794";
      red = "#EC5E66";
      peach = "#FF8459";
      yellow = "#CAA75E";
      green = "#87A35E";
    };

  kopicat_dark =
    kopicat_base
    // {
      text = "#fcfcfa";
      surface2 = "#535763";
      surface1 = "#3a3d4b";
      surface0 = "#30303b";
      base = "#202027";
      mantle = "#1c1d22";
      crust = "#171719";
    };

  # https://github.com/tanmaymanojgandhi/circadia — "Warm Parchment" (light).
  # Spec tokens map to: bg_canvas->base, bg_surface->surface0 (sidebars),
  # bg_element->surface1 (active line/selection), border->surface2,
  # text_primary/muted/faint->text/subtext1/overlay1, accent->rosewater+blue
  # (cursor/focus + functions), keyword->mauve, type->yellow, string->green,
  # number->peach, comment->overlay0/overlay2 (Comment slot in old/new
  # catppuccin). Keys marked `synth` are not in the spec and are interpolated
  # in OKLCH within the neighbouring hues.
  circadia_light = {
    rosewater = "#09489a"; # spec accent (focus/links; cursor bg)
    flamingo = "#8d2e4b"; # synth
    pink = "#842162"; # synth
    mauve = "#631c84"; # spec keyword
    red = "#9b1111"; # synth
    maroon = "#7e2735"; # synth
    peach = "#8a2d00"; # spec number
    yellow = "#7f3500"; # spec type
    green = "#085802"; # spec string
    teal = "#005c41"; # synth
    sky = "#556b82"; # synth, muted: operators read as secondary text
    sapphire = "#005391"; # synth
    blue = "#09489a"; # spec accent/function
    lavender = "#5a4886"; # synth
    text = "#28323a"; # spec text_primary
    subtext1 = "#46535f"; # spec text_muted
    subtext0 = "#545f6a"; # synth
    overlay2 = "#574f46"; # spec comment
    overlay1 = "#5f6d7a"; # spec text_faint (line numbers/guides)
    overlay0 = "#574f46"; # spec comment
    surface2 = "#d4c8b2"; # spec border
    surface1 = "#e2d8c3"; # spec bg_element
    surface0 = "#ece4d4"; # spec bg_surface
    base = "#f4eee1"; # spec bg_canvas
    mantle = "#eee9de"; # synth
    crust = "#eae4d8"; # synth
  };

  # Circadia "Warm Ember & Obsidian" (dark). Same mapping as circadia_light;
  # accents stay warm (hue 10-30) except keyword (320) and function/sky (230).
  circadia_dark = {
    rosewater = "#e89a49"; # spec accent (focus/links; cursor bg)
    flamingo = "#eaa0aa"; # synth
    pink = "#f09dc4"; # synth
    mauve = "#e59de8"; # spec keyword
    red = "#f68678"; # synth
    maroon = "#dc8a90"; # synth
    peach = "#f6a84d"; # spec number
    yellow = "#f1be85"; # spec type
    green = "#a7db76"; # spec string
    teal = "#75cca7"; # synth
    sky = "#98b6c6"; # synth, muted: operators read as secondary text
    sapphire = "#88c0e1"; # synth
    blue = "#89c8e4"; # spec function
    lavender = "#c0b2dc"; # synth, bg hue (290) family
    text = "#eae3d8"; # spec text_primary
    subtext1 = "#b7aca0"; # spec text_muted
    subtext0 = "#a7a195"; # synth
    overlay2 = "#b3aba0"; # spec comment
    overlay1 = "#92887d"; # spec text_faint (line numbers/guides)
    overlay0 = "#b3aba0"; # spec comment
    surface2 = "#343041"; # spec border
    surface1 = "#252330"; # spec bg_element
    surface0 = "#1c1a24"; # spec bg_surface
    base = "#15141b"; # spec bg_canvas
    mantle = "#0f0f14"; # synth
    crust = "#0b0a10"; # synth
  };

  solarized_light = {
    rosewater = "#fdf7e8";
    flamingo = "#cb4b16";
    pink = "#d33682";
    mauve = "#6c71c4";
    red = "#dc322f";
    maroon = "#c03260";
    peach = "#cb4b1f";
    yellow = "#b58900";
    green = "#859900";
    teal = "#2aa198";
    sky = "#2398d2";
    sapphire = "#0077b3";
    blue = "#268bd2";
    lavender = "#7b88d3";
    text = "#657b83";
    subtext1 = "#586e75";
    subtext0 = "#073642";
    overlay2 = "#002b36";
    overlay1 = "#839496";
    overlay0 = "#93a1a1";
    surface2 = "#eee8d5";
    surface1 = "#ebecef";
    surface0 = "#ccd0da";
    base = "#fdf6e3";
    mantle = "#f7f1dc";
    crust = "#f5ecd7";
  };

  ayu_inspired = {
    rosewater = "#F5B8AB";
    flamingo = "#F29D9D";
    pink = "#AD6FF7";
    mauve = "#FF8F40";
    red = "#E66767";
    maroon = "#EB788B";
    peach = "#FAB770";
    yellow = "#FACA64";
    green = "#70CF67";
    teal = "#4CD4BD";
    sky = "#61BDFF";
    sapphire = "#4BA8FA";
    blue = "#00BFFF";
    lavender = "#00BBCC";
    text = "#C1C9E6";
    subtext1 = "#A3AAC2";
    subtext0 = "#8E94AB";
    overlay2 = "#7D8296";
    overlay1 = "#676B80";
    overlay0 = "#464957";
    surface2 = "#3A3D4A";
    surface1 = "#2F313D";
    surface0 = "#1D1E29";
    base = "#0b0b12";
    mantle = "#11111a";
    crust = "#191926";
  };
in {
  colorschemes.catppuccin = {
    enable = true;
    autoLoad = true;
    settings = {
      background = {
        light = "latte";
        dark = "mocha";
      };
      no_italic = false;
      no_bold = false;
      no_underline = false;
      term_colors = true;
      transparent_background = true;
      dim_inactive = {enabled = false;};
      float = {
        transparent = true;
        solid = true;
      };
      styles = {
        comments = ["italic"];
        conditionals = ["italic"];
        properties = [];
        functions = [];
        keywords = [];
        operators = [];
        loops = [];
        booleans = [];
        numbers = [];
        types = [];
        strings = [];
        variables = [];
      };
      lsp_styles = {
        virtual_text = {
          errors = ["italic"];
          hints = ["italic"];
          warnings = ["italic"];
          information = ["italic"];
        };
        underlines = {
          errors = ["undercurl"];
          hints = ["undercurl"];
          warnings = ["undercurl"];
          information = ["undercurl"];
        };
        inlay_hints = {background = true;};
      };
      highlight_overrides = {
        latte.__raw = ''
          function(C)
            return {
              FlashLabel = { fg = C.base, bg = C.red, style = { "bold" } },
            }
          end
        '';
      };
      custom_highlights.__raw = ''
        function(colors)
          return {
            ["@lsp.typemod.variable.mutable.rust"] = { style = { "underline" } },
            ["@lsp.typemod.selfKeyword.mutable.rust"] = {
              style = { "underline" },
            },
            ["@variable.builtin"] = { fg = colors.maroon, style = { "italic" } },

            CmpItemMenu = { link = "@comment" },

            CurSearch = { bg = colors.sky },
            IncSearch = { bg = colors.sky },
            CursorLineNr = { fg = colors.blue, style = { "bold" } },
            DashboardFooter = { fg = colors.overlay0 },
            TreesitterContextBottom = { style = {} },
            ["@markup.italic"] = { fg = colors.blue, style = { "italic" } },
            ["@markup.strong"] = { fg = colors.blue, style = { "bold" } },
            Headline = { style = { "bold" } },
            Headline1 = { fg = colors.blue, style = { "bold" } },
            Headline2 = { fg = colors.pink, style = { "bold" } },
            Headline3 = { fg = colors.lavender, style = { "bold" } },
            Headline4 = { fg = colors.green, style = { "bold" } },
            Headline5 = { fg = colors.peach, style = { "bold" } },
            Headline6 = { fg = colors.flamingo, style = { "bold" } },
            rainbow1 = { fg = colors.blue, style = { "bold" } },
            rainbow2 = { fg = colors.pink, style = { "bold" } },
            rainbow3 = { fg = colors.lavender, style = { "bold" } },
            rainbow4 = { fg = colors.green, style = { "bold" } },
            rainbow5 = { fg = colors.peach, style = { "bold" } },
            rainbow6 = { fg = colors.flamingo, style = { "bold" } },

            HydraRed = { fg = colors.red },
            HydraBlue = { fg = colors.blue },
            HydraAmaranth = { fg = colors.mauve },
            HydraPink = { fg = colors.pink },
            HydraTeal = { fg = colors.teal },
          }
        end
      '';
      auto_integrations = true;
      integrations = {
        alpha = true;
        aerial = true;
        barbecue = {
          dim_dirname = true;
          bold_basename = true;
        };
        treesitter = true;
        headlines = true;
        flash = true;
        gitsigns = true;
        notify = true;
        semantic_tokens = true;
        lsp_trouble = true;
        markdown = true;
        noice = true;
        telescope = {
          enabled = true;
          style = "nvchad";
        };
        illuminate = true;
        nvimtree = false;
        mason = true;
        neotree = true;
        mini = true;
        which_key = true;
        hop = true;
        cmp = true;
        lsp_saga = true;
        octo = true;
        navic = {enabled = true;};
        window_picker = true;
        blink_cmp = true;
        snacks = {enabled = true;};
        fzf = true;
        neotest = true;
        colorful_winsep = {enabled = true;};
      };
    };
  };
}
