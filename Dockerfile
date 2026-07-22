# syntax=docker/dockerfile:1

# ── Build stage ─────────────────────────────────────────────────────────────
# codebase-memory-mcp is pure C with vendored tree-sitter grammars — only
# gcc/g++ and make are required. Generated sources are committed to the repo,
# so no Node.js or Python codegen is needed for the standard variant.
FROM debian:bookworm-slim AS build

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY codebase-memory-mcp/ .

ARG CBM_VERSION=dev
RUN scripts/build.sh --version "${CBM_VERSION}" CC=gcc CXX=g++ \
 && strip build/c/codebase-memory-mcp

# ── Runtime stage ───────────────────────────────────────────────────────────
FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="codebase-memory-mcp" \
      org.opencontainers.image.description="Code intelligence engine for AI coding agents (MCP server)" \
      org.opencontainers.image.source="https://github.com/DeusData/codebase-memory-mcp" \
      org.opencontainers.image.licenses="MIT"

RUN apt-get update \
 && apt-get install -y --no-install-recommends zlib1g \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd --system cbm && useradd --system --gid cbm --create-home cbm

COPY --from=build /src/build/c/codebase-memory-mcp /usr/local/bin/codebase-memory-mcp

USER cbm
WORKDIR /home/cbm

# MCP server speaks JSON-RPC over stdio.
ENTRYPOINT ["/usr/local/bin/codebase-memory-mcp"]
