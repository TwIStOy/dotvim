import { MdNodeFactory } from "./node-factory";
import {
  MdAtxHeading,
  MdCodeFenceBlock,
  MdSection,
  MdThematicBreak,
} from "./nodes";

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
factory.register("code_fence_content", (node, source, inherit) => {
  return new MdCodeFenceBlock(node, source, inherit);
});
