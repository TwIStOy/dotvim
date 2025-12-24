import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Update version, stage changes and commit",
  args: {
    message: tool.schema.string().describe("Commit message"),
  },
  async execute(args) {
    const result = await Bun.$`python3 ./git-add-and-commit.py -y ${args.message}`.text()
    return result.trim()
  },
})
