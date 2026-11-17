#!/usr/bin/env bash
set -euo pipefail

image=${1:?usage: smoke.sh <image>}

run() {
  docker run --rm -i "$image" "$@"
}

# Capture output first, so grep -q never cuts a docker run short.
expect() {
  local pattern=$1 out
  shift
  out=$(run "$@")
  printf '%s\n' "${out%%$'\n'*}"
  grep -q "$pattern" <<< "$out"
}

test "$(run id -u < /dev/null)" != "0"
expect 'GNU bash, version 5' bash --version
expect 'GNU Awk' gawk --version
expect 'GNU sed' sed --version
expect 'GNU grep' grep --version
expect 'GNU coreutils' ls --version

# The default command is bash, not the BusyBox shell.
test "$(echo 'echo "$BASH_VERSION"' | run)" != ""

# Features scripts rely on that BusyBox does not provide.
test "$(echo '2^10' | run bc)" = "1024"
test "$(run bash -c 'declare -A m=([a]=1); echo "${m[a]}"')" = "1"
test "$(run bash -c 'echo foo | grep -oP "f\Ko+"')" = "oo"
test "$(run date -u -d @0 +%Y)" = "1970"
test "$(run bash -c 'echo a-b | sed -E "s/(a)-(b)/\2\1/"')" = "ba"
