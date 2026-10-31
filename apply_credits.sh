#!/usr/bin/env bash
set -euo pipefail

readonly DECOMPILED_ROOT="decompiled_apk"
readonly SETTINGS_CREDIT="RDX-YT Settings • By Abdullah Naeem Rao"
readonly WELCOME_CREDIT="Welcome to RDX-YT • Developed by Abdullah Naeem Rao"
readonly DEVELOPER_CREDIT="Developed by Abdullah Naeem Rao"
readonly CREDIT_SMALI_SOURCE="branding-smali/com/rdx/yt/BrandCredits.smali"
readonly MAIN_ACTIVITY_SUFFIX="com/google/android/apps/youtube/app/watchwhile/MainActivity.smali"

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
    -e "s#(<string[^>]*name=\"revanced_settings_screen_00_about_title\"[^>]*>)[^<]*(</string>)#\\1${DEVELOPER_CREDIT}\\2#g" \
    -e "s#ReVanced([[:space:]]+Extended)?[[:space:]]+[Ss]ettings#${SETTINGS_CREDIT}#g" \
    -e "s#Settings([[:space:]]+for)?[[:space:]]+ReVanced([[:space:]]+Extended)?#${SETTINGS_CREDIT}#g" \
    -e 's#YouTube Premium#RDX-YT#g' \
    -e 's#ReVanced#RDX-YT#g' \
    "$strings_file"
done

if [[ ! -f "$CREDIT_SMALI_SOURCE" ]]; then
  echo "Missing startup credit bytecode: $CREDIT_SMALI_SOURCE" >&2
  exit 1
fi

mapfile -t MAIN_ACTIVITY_FILES < <(
  find "$DECOMPILED_ROOT" -type f -path "*/$MAIN_ACTIVITY_SUFFIX" | sort
)

if [[ "${#MAIN_ACTIVITY_FILES[@]}" -ne 1 ]]; then
  echo "Expected one YouTube MainActivity smali file, found ${#MAIN_ACTIVITY_FILES[@]}" >&2
  exit 1
fi

readonly MAIN_ACTIVITY_FILE="${MAIN_ACTIVITY_FILES[0]}"
readonly SMALI_ROOT="${MAIN_ACTIVITY_FILE%/$MAIN_ACTIVITY_SUFFIX}"
readonly CREDIT_SMALI_DESTINATION="$SMALI_ROOT/com/rdx/yt/BrandCredits.smali"

if [[ "$(grep --count '^\.method .* onCreate(Landroid/os/Bundle;)V$' "$MAIN_ACTIVITY_FILE")" -ne 1 ]]; then
  echo "Could not identify exactly one MainActivity.onCreate method." >&2
  exit 1
fi

sed --in-place \
  '/^\.method .* onCreate(Landroid\/os\/Bundle;)V$/a\    invoke-static {p0}, Lcom/rdx/yt/BrandCredits;->show(Landroid/content/Context;)V' \
  "$MAIN_ACTIVITY_FILE"

mkdir -p "$(dirname "$CREDIT_SMALI_DESTINATION")"
cp "$CREDIT_SMALI_SOURCE" "$CREDIT_SMALI_DESTINATION"

grep --quiet 'BrandCredits;->show(Landroid/content/Context;)V' "$MAIN_ACTIVITY_FILE"
grep --quiet 'Developed by Abdullah Naeem Rao' "$CREDIT_SMALI_DESTINATION"

echo "Injected persistent settings credit into ${#STRING_FILES[@]} localized string files."
echo "Injected an RDX-YT developer credit toast into YouTube MainActivity."
