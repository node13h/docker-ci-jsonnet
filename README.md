# Jsonnet tools for CI jobs

## Tools included

- [Jsonnet (Go implementation)](https://github.com/google/go-jsonnet)
- [Jsonnet Bundler](https://github.com/jsonnet-bundler/jsonnet-bundler)
- jq
- yq
- Bash
- Make
- Git

See [DEVELOPING.md](DEVELOPING.md) for local development setup
instructions.
## Tags

Image is tagged with an immutable version number (see [VERSION](VERSION)) on
each release. Additionally there are few mutable tags which get overwritten
as long as version part of the tag (`X.Y.Z` for full or `X.Y` for minor) remains
unchanged for each tool between releases of the image):

- `jsonnet-go-X.Y.Z`,
- `jsonnet-go-X.Y`,
- `jb-X.Y.Z`,
- `jb-X.Y`,
- `latest`.

Example:

```
$ docker run -it --rm docker.io/alikov/ci-jsonnet:jsonnet-go-0.20 jsonnet --version
Jsonnet commandline interpreter (Go implementation) v0.20.0
```

