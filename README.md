# docker-bash

Minimal image with Bash and the GNU versions of `awk`, `sed`, `grep`, coreutils and `bc` on Alpine Linux, for scripts that need more than the BusyBox shell.

Images are built for `linux/amd64` and `linux/arm64`, run as a non-root user and ship with an SBOM, build provenance and a keyless signature.

## Images

Images are published to GitHub Container Registry as `ghcr.io/think-cube/bash`.

| Tag | Meaning | Changes? |
|---|---|---|
| `1.0.0` | Exact release | Never |
| `1.0`, `1`, `latest` | Newest matching release | With each release |
| `edge` | Newest build of `main` | With each merge and weekly rebuild |
| `edge-YYYYMMDD` | Weekly rebuild of `main` with current OS patches | Never |
| `sha-<commit>` | Build of one `main` commit | Never |

For production, pin by digest: `ghcr.io/think-cube/bash:1.0.0@sha256:...`.

## Usage

Start an interactive shell:

```bash
docker run --rm -it ghcr.io/think-cube/bash:1
```

Run a script from the current directory:

```bash
docker run --rm -v "$PWD:/work" ghcr.io/think-cube/bash:1 bash script.sh
```

Pipe data through it:

```bash
echo '2^10' | docker run --rm -i ghcr.io/think-cube/bash:1 bc
```

The image runs as `app` (UID/GID `10001`) in `/work`. If a script writes into a mounted directory, either make the directory writable by UID `10001` or run with your own IDs: `--user "$(id -u):$(id -g)"`.

## What is in the image

- Bash, the default command
- GNU `awk` (`gawk`), `sed`, `grep` (with `-P`), coreutils and `bc`
- Alpine Linux, in the version named on the `FROM` line of the `Dockerfile`

## Verify an image

Check the signature:

```bash
cosign verify ghcr.io/think-cube/bash:1.0.0 \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  --certificate-identity-regexp '^https://github\.com/Think-Cube/workflows/\.github/workflows/container-image\.yml@refs/tags/v.+$'
```

Read the SBOM and provenance:

```bash
docker buildx imagetools inspect ghcr.io/think-cube/bash:1.0.0 --format '{{ json .SBOM }}'
docker buildx imagetools inspect ghcr.io/think-cube/bash:1.0.0 --format '{{ json .Provenance }}'
```

## Build and test locally

```bash
docker build -t bash:local .
bash tests/smoke.sh bash:local
```

The smoke test checks that each tool is the GNU version and exercises features BusyBox lacks, such as associative arrays, `grep -P` and `date -d`.

## Support

Only the newest release receives fixes. `main` is rebuilt every week, and images with fixable critical vulnerabilities are not published. Report security issues through [GitHub private vulnerability reporting](https://github.com/Think-Cube/docker-bash/security/advisories/new).

## License

This project is licensed under the [MIT License](LICENSE).

## Contribution

Feel free to contribute by opening issues or pull requests. Your feedback and improvements are highly appreciated!
