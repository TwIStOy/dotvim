export interface MarkupLine {
  text: string;
}

export interface MarkupParagraph {
  lines: MarkupLine[];
}

export type TranslateResult = MarkupLine | MarkupParagraph;
