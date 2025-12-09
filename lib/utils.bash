#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/seaweedfs/seaweedfs"
TOOL_NAME="seaweedfs"
TOOL_TEST="weed version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if seaweedfs is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3-
}

list_all_versions() {
	# Change this function if seaweedfs has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$(release_url "$version")"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

detect_platform() {
  local version="$1"
  local platform=""

	case "$OSTYPE" in
		darwin*) platform="darwin" ;;
		linux*) platform="linux" ;;
		*) fail "Unsupported platform" ;;
	esac
  echo "$platform"
}

detect_architecture() {
  local version="$1"
  local architecture=""

	case "$(uname -m)" in
		x86_64) architecture="amd64" ;;
		aarch64 | arm64) architecture="arm64" ;;
		*) fail "Unsupported architecture" ;;
	esac
  echo "$architecture"
}


release_url() {
  local version="$1"
  local platform architecture  archive_file download_base_url

  platform="$(detect_platform "$version")"
  architecture="$(detect_architecture "$version")"

	archive_format="tar.gz"
	archive_file="${platform}_${architecture}.${archive_format}"
	download_base_url="${GH_REPO}/releases/download"

  echo "${download_base_url}/${version}/${archive_file}"
}
