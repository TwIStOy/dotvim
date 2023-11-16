import { ifNil } from "@core/vim";
import { executeOpration } from "./api";

const allMarkdownFiles = `
query {
  vault {
    allMarkdownFiles {
      path
      basename
      cachedMetadata {
        tags {
          tag
        }
        frontmatter {
          key
          value
        }
        links {
          link
          linkPath {
            path
          }
        }
      }
    }
  }
}
`;

interface Tag {
  tag: string;
}

interface FrontmatterKV {
  key: string;
  value: any;
}

interface LinkItem {
  link: string;
  linkPath: {
    path: string;
  };
}

interface CachedMetadata {
  tags: Tag[];
  frontmatter: FrontmatterKV[];
  links: LinkItem[];
}

interface MarkdownFile {
  path: string;
  basename: string;
  cachedMetadata: CachedMetadata;
}

interface AllMarkdownFilesResponse {
  data: {
    vault: {
      allMarkdownFiles: MarkdownFile[];
    };
  };
}

export class ObsidianMdFile {
  private _file: MarkdownFile;
  private _collection: ObsidianMdFilesCollection;

  constructor(file: MarkdownFile, collection: ObsidianMdFilesCollection) {
    this._file = file;
    this._collection = collection;
  }

  get aliases(): string[] {
    let result = this._file.cachedMetadata.frontmatter.find(
      (kv) => kv.key === "aliases"
    )?.value;
    if (result == null) {
      return [];
    }
    if (typeof result === "string") {
      return [result];
    }
    return result;
  }

  get id(): string {
    return this._idOpt ?? "";
  }

  get _idOpt(): string | null {
    return (
      this._file.cachedMetadata.frontmatter.find((kv) => kv.key === "id")
        ?.value ?? null
    );
  }

  get title(): string {
    return ifNil(this.aliases[0] ?? null, this._idOpt, this._file.basename);
  }

  get links() {
    return this._file.cachedMetadata.links.map((link) => ({
      link: link.link,
      path: link.linkPath.path,
    }));
  }

  get backlinks(): ObsidianMdFile[] {
    return this._collection.backlinks.get(this._file.path) ?? [];
  }

  get tags(): string[] {
    return [
      ...this._file.cachedMetadata.tags.map((tag) => tag.tag),
      ...(
        (this._file.cachedMetadata.frontmatter.find((kv) => kv.key === "tags")
          ?.value as string[]) ?? []
      ).map((tag) => `#${tag}`),
    ];
  }
}

export class ObsidianMdFilesCollection {
  private _files: ObsidianMdFile[];
  public backlinks: Map<string, ObsidianMdFile[]> = new Map();

  constructor(files: MarkdownFile[]) {
    this._files = files.map((file) => new ObsidianMdFile(file, this));
    this._files.forEach((file) => {
      file.links.forEach((link) => {
        if (!this.backlinks.has(link.path)) {
          this.backlinks.set(link.path, []);
        }
        this.backlinks.get(link.path)!.push(file);
      });
    });
  }
}

export function getAllMarkdownFiles(): ObsidianMdFilesCollection {
  const response = executeOpration<AllMarkdownFilesResponse>(allMarkdownFiles);
  let files = response?.data.vault.allMarkdownFiles ?? [];
  return new ObsidianMdFilesCollection(files);
}
