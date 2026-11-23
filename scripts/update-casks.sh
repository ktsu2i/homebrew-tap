#!/usr/bin/env bash
# Casks/*.rb を、それぞれの GitHub リポジトリ (ktsu2i/<cask 名>) の最新 release に更新する。
# maltmill は Formula 専用のため、cask はこのスクリプトで更新する。
#
# 前提:
# - cask の url は "#{version}" を埋め込んだ GitHub release asset の URL である。
# - version と sha256 はそれぞれ 1 行で書かれている (単一アーキテクチャ / universal の cask)。
# - gh CLI が使える (GH_TOKEN または gh auth login)。
set -euo pipefail
shopt -s nullglob

for cask in Casks/*.rb; do
  name="$(basename "$cask" .rb)"
  repo="ktsu2i/${name}"

  tag="$(gh release view --repo "$repo" --json tagName --jq .tagName)"
  latest="${tag#v}"
  if [[ ! "$latest" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "${name}: skip unexpected tag ${tag}" >&2
    continue
  fi

  current="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")"
  if [[ "$current" == "$latest" ]]; then
    echo "${name}: ${current} is up to date"
    continue
  fi

  url_template="$(sed -n 's/^  url "\(.*\)"$/\1/p' "$cask")"
  url="${url_template//'#{version}'/$latest}"

  tmp="$(mktemp -d)"
  curl -fsSL --retry 3 -o "${tmp}/asset" "$url"
  sha256="$(shasum -a 256 "${tmp}/asset" | cut -d ' ' -f 1)"
  rm -rf "$tmp"

  sed -i.bak \
    -e "s/^  version \".*\"$/  version \"${latest}\"/" \
    -e "s/^  sha256 \".*\"$/  sha256 \"${sha256}\"/" \
    "$cask"
  rm "${cask}.bak"
  echo "${name}: ${current} -> ${latest}"
done
