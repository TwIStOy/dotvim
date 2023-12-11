import { MdAtxHeading } from "./atx-heading";
import { MdNodeFactory } from "./node-factory";
import { MdSection } from "./section";
import { MdThematicBreak } from "./thematic-break";

let factory = MdNodeFactory.getInstance();

factory.register("atx_heading", (node, source, inherit) => {
  return new MdAtxHeading(node, source, inherit);
});
factory.register("thematic_break", (node, source, inherit) => {
  return new MdThematicBreak(node, source, inherit);
});
factory.register("section", (node, source, inherit) => {
  return new MdSection(node, source, inherit);
});
