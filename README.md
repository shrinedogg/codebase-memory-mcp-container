# codebase-memory-mcp container

Multi-arch (`linux/amd64`, `linux/arm64`) container image for
[DeusData/codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp),
built from source on Debian bookworm.

Published at [`shrinedogg/codebase-memory-mcp`](https://hub.docker.com/r/shrinedogg/codebase-memory-mcp).

## Usage

The image's entrypoint is the `codebase-memory-mcp` binary, which runs an MCP
server over stdio by default.

```bash
docker run --rm -i shrinedogg/codebase-memory-mcp:latest
```

To index a codebase, mount it into the container:

```bash
docker run --rm -i -v /path/to/your/repo:/repo shrinedogg/codebase-memory-mcp:latest
```

MCP client configuration example:

```json
{
  "mcpServers": {
    "codebase-memory": {
      "command": "docker",
      "args": ["run", "--rm", "-i",
               "-v", "/path/to/your/repo:/repo",
               "shrinedogg/codebase-memory-mcp:latest"]
    }
  }
}
```

## Build

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg CBM_VERSION=0.10.7 \
  -t shrinedogg/codebase-memory-mcp:latest \
  -t shrinedogg/codebase-memory-mcp:0.10.7 \
  --push .
```

Tags track upstream releases; `latest` points at the most recent build.
