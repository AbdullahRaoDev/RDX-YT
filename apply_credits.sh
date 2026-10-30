#!/usr/bin/env bash
set -euo pipefail

readonly DECOMPILED_ROOT="decompiled_apk"
readonly SETTINGS_CREDIT="RDX-YT Settings • By Abdullah Naeem Rao"
readonly WELCOME_CREDIT="Welcome to RDX-YT • Developed by Abdullah Naeem Rao"

if [[ ! -d "$DECOMPILED_ROOT" ]]; then
  echo "Missing Apktool output directory: $DECOMPILED_ROOT" >&2
  exit 1
fi

mapfile -d '' STRING_FILES < <(
  find "$DECOMPILED_ROOT" \
    -type f \
    -path '*/res/values*/strings.xml' \
    -print0
)

if [[ "${#STRING_FILES[@]}" -eq 0 ]]; then
  echo "No res/values*/strings.xml files were found." >&2
  exit 1
fi

for strings_file in "${STRING_FILES[@]}"; do
  sed --in-place --regexp-extended \
    -e "s#(<string[^>]*>)[^<]*[Ww]elcome[^<]*ReVanced[^<]*(</string>)#\\1${WELCOME_CREDIT}\\2#g" \
    -e "s#(<string[^>]*name=\"[^\"]*revanced[^\"]*(welcome|version)[^\"]*\"[^>]*>)[^<]*(</string>)#\\1${WELCOME_CREDIT}\\3#gI" \
    -e "s#(<string[^>]*name=\"[^\"]*(welcome|version)[^\"]*revanced[^\"]*\"[^>]*>)[^<]*(</string>)#\\1${WELCOME_CREDIT}\\3#gI" \
    -e "s#(<string[^>]*name=\"[^\"]*(welcome|version)[^\"]*\"[^>]*>)[^<]*ReVanced[^<]*(</string>)#\\1${WELCOME_CREDIT}\\3#gI" \
    -e "s#ReVanced([[:space:]]+Extended)?[[:space:]]+[Ss]ettings#${SETTINGS_CREDIT}#g" \
    -e "s#Settings([[:space:]]+for)?[[:space:]]+ReVanced([[:space:]]+Extended)?#${SETTINGS_CREDIT}#g" \
    -e 's#YouTube Premium#RDX-YT#g' \
    -e 's#ReVanced#RDX-YT#g' \
    "$strings_file"
done

echo "Injected RDX-YT credits into ${#STRING_FILES[@]} localized string files."
