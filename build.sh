#!/usr/bin/env sh

BASE_STYLE_VERSION="0.3.0"

SCRIPT_DIR="$( cd "$(dirname "$0")" && pwd )"
TEMPLATES_DIR="${SCRIPT_DIR}/template"
BUILD_DIR="${SCRIPT_DIR}/dist"
TMP_DIR="${SCRIPT_DIR}/tmp"
STYLE_TARGET_DIR="${BUILD_DIR}/style/"
STYLE_JAR_URL="https://github.com/clarin-eric/base_style/releases/download/${BASE_STYLE_VERSION}/base-style-${BASE_STYLE_VERSION}-css-with-bootstrap.jar"
TMP_STYLE_JAR="${TMP_DIR}/style.jar"

HEADER_FILE="header.inc"
FOOTER_FILE="footer.inc"

set -e

mkdir -p "$BUILD_DIR"
mkdir -p "$TMP_DIR"

main() {
	if [ "clean" = "$1" ]; then
		clean
	else
		if ! [ -e "${STYLE_TARGET_DIR}" ]; then
			get_style
		fi
		
		copy_custom_style
	
		(cd "$TEMPLATES_DIR" && apply_templates)
	fi
	
	clean_tmp
	echo "Done"
}

get_style() {
	if ! [ -e "${TMP_STYLE_JAR}" ]; then
		echo "Retrieving style files..."
		curl -s -L "${STYLE_JAR_URL}" > "$TMP_STYLE_JAR"
	fi
	echo "Unpacking style..."
	mkdir -p "${STYLE_TARGET_DIR}"
	(cd "${STYLE_TARGET_DIR}" && unzip "${TMP_STYLE_JAR}") > /dev/null
}

copy_custom_style() {
	echo "Merging custom style content..."
	rsync -a "${SCRIPT_DIR}/style"/* "${STYLE_TARGET_DIR}"
}

apply_templates() {
	for f in `ls *.html`; do
		echo $f
		cat "$HEADER_FILE" "$f" "$FOOTER_FILE" > "${BUILD_DIR}/"$(basename "$f")
	done
}

clean() {
	clean_tmp
	clean_build
}

clean_tmp() {
	if [ -d "${TMP_DIR}" ]; then
		echo "Cleaning up tmp..."
		rm -rf "${TMP_DIR}"
	fi
}

clean_build() {
	if [ -d "${BUILD_DIR}" ]; then
		echo "Cleaning up build dir..."
		rm -rf "${BUILD_DIR}"/*
	fi
}

main $@