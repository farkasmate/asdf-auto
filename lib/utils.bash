#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/farkasmate/asdf-auto"
TOOL_NAME="auto"
TOOL_TEST="asdf help auto"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if auto is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$GH_REPO/archive/refs/tags/v${version}.tar.gz"

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

# auto functions
auto_command() {
	local dry_run=
	local tool_versions_path
	local plugins

	if [ $# -gt 0 ] && [ "$1" = "--dry-run" ]; then
		dry_run=1
	fi

	tool_versions_path=$(find_tool_versions)
	plugins=$(strip_tool_version_comments "$tool_versions_path" | cut -d ' ' -f 1)

	for plugin in $plugins; do
		local plugin_version
		local git_url
		local git_ref
		local config_file

		plugin_version=$(get_plugin_version "$plugin")
		git_url=$(cut -d '|' -f 1 <<<"$plugin_version")
		git_ref=$(cut -d '|' -f 2 <<<"$plugin_version")
		config_file=$(cut -d '|' -f 3 <<<"$plugin_version")

		if [ -n "$dry_run" ]; then
			print_dry_run "$plugin" "$git_url" "$git_ref" "$config_file"
			continue
		fi

		# add plugin: asdf plugin add <name> [<git-url>]
		bash -c "asdf plugin add $plugin $git_url"

		# update plugin: asdf plugin update {<name> [git-ref] | --all}
		bash -c "asdf plugin update $plugin $git_ref"
	done

	if [ -n "$dry_run" ]; then
		return 1
	fi

	# install tools
	bash -c "asdf install"
}

get_plugin_version() {
	local plugin_name=$1
	local search_path=$PWD

	while true; do
		if [ "$search_path" = "/" ]; then
			printf "||default\n"
			break
		fi

		local tool_versions_path
		tool_versions_path=$(get_version_in_dir "$plugin_name" "$search_path" "" | cut -d'|' -f2)

		if parse_plugin_version_comment "$plugin_name" "$tool_versions_path"; then
			break
		fi

		search_path=$(dirname "$search_path")
	done
}

parse_plugin_version_comment() {
	local plugin_name=$1
	local file_path=$2

	if [ -f "$file_path" ]; then
		local config_line
		local comment
		local git_url
		local git_ref

		config_line=$(grep "$plugin_name " "$tool_versions_path")
		if echo "$config_line" | grep -q ' # http'; then
			comment=${config_line/#$plugin_name [^#]*# /}
			git_url=$(echo "$comment" | grep -o "^http[^ ]*")
			git_ref=${comment/#$git_url/}
			printf "%s|%s|%s\n" "$git_url" "${git_ref/# /}" "$file_path"

			return 0
		fi
	fi

	return 1
}

print_dry_run() {
	local plugin_name=$1
	local git_url=$2
	local git_ref=$3
	local config_file=$4

	if [ -z "$git_url" ]; then
		git_url=$(asdf_plugin_repository_url)
	fi

	if [ -z "$git_ref" ]; then
		git_ref="latest"
	fi

	printf "Would install %s %s plugin from %s as configured by %s\n" "$git_ref" "$plugin_name" "$git_url" "$config_file"
}
