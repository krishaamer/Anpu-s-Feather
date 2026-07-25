#!/usr/bin/env bash

set -euo pipefail

APP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -z "${DEVELOPER_DIR:-}" ]]; then
  if [[ -x /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild ]]; then
    DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
  else
    DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer
  fi
fi
export DEVELOPER_DIR

TEAM_ID="${APPLE_TEAM_ID:-QDKYG4BFAD}"
BUNDLE_ID="${IOS_BUNDLE_ID:-co.haam.anpusfeather}"
SCHEME_NAME="${IOS_SCHEME_NAME:-AnpusFeather}"
API_KEY_ID="${ASC_API_KEY_ID:-45TX469F25}"
API_ISSUER_ID="${ASC_API_ISSUER_ID:-69a6de7b-ed28-47e3-e053-5b8c7c11a4d1}"
# Prefer AuthKey_*.p8 (App Store Connect API key naming); fall back to ApiKey_*.p8
if [[ -z "${ASC_API_KEY_PATH:-}" ]]; then
  if [[ -f "$HOME/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8" ]]; then
    API_KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_${API_KEY_ID}.p8"
  else
    API_KEY_PATH="$HOME/.appstoreconnect/private_keys/ApiKey_${API_KEY_ID}.p8"
  fi
else
  API_KEY_PATH="$ASC_API_KEY_PATH"
fi
EXPORT_OPTIONS="$APP_ROOT/scripts/ExportOptions-TestFlight.plist"
MARKETING_VERSION="${MARKETING_VERSION:-2.0}"
BUILD_NUMBER="${BUILD_NUMBER:-$(date -u +%Y%m%d%H%M)}"
UPLOAD_TO_TESTFLIGHT="${UPLOAD_TO_TESTFLIGHT:-1}"
PROJECT="$APP_ROOT/AnpusFeather.xcodeproj"

require_file() {
  if [[ ! -f "$1" ]]; then
    echo "Required file not found: $1" >&2
    exit 1
  fi
}

upload_ipa() {
  local ipa_path="$1"
  require_file "$ipa_path"
  require_file "$API_KEY_PATH"

  echo "Validating $(basename "$ipa_path") with App Store Connect..."
  xcrun altool --validate-app "$ipa_path" \
    --type ios \
    --api-key "$API_KEY_ID" \
    --api-issuer "$API_ISSUER_ID" \
    --api-key-subject user \
    --p8-file-path "$API_KEY_PATH"

  echo "Uploading $(basename "$ipa_path") to TestFlight..."
  xcrun altool --upload-package "$ipa_path" \
    --type ios \
    --api-key "$API_KEY_ID" \
    --api-issuer "$API_ISSUER_ID" \
    --api-key-subject user \
    --p8-file-path "$API_KEY_PATH" \
    --wait
}

if [[ -n "${IPA_PATH:-}" ]]; then
  upload_ipa "$IPA_PATH"
  exit 0
fi

require_file "$EXPORT_OPTIONS"
require_file "$PROJECT/project.pbxproj"
require_file "$API_KEY_PATH"

if [[ ! -x "$DEVELOPER_DIR/usr/bin/xcodebuild" ]]; then
  echo "Xcode was not found at $DEVELOPER_DIR." >&2
  exit 1
fi

if [[ ! "$BUILD_NUMBER" =~ ^[0-9]+([.][0-9]+){0,2}$ ]]; then
  echo "BUILD_NUMBER must contain one to three dot-separated integers." >&2
  exit 1
fi

BUILD_ROOT="$APP_ROOT/build/ios-testflight-${BUILD_NUMBER}"
ARCHIVE_PATH="$BUILD_ROOT/AnpusFeather.xcarchive"
EXPORT_PATH="$BUILD_ROOT/export"
INFO_PLIST="$APP_ROOT/AnpusFeather/Info.plist"

mkdir -p "$BUILD_ROOT" "$EXPORT_PATH"

echo "Stamping Anpu's Feather $MARKETING_VERSION ($BUILD_NUMBER)..."
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $MARKETING_VERSION" "$INFO_PLIST"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "$INFO_PLIST"

echo "Archiving with local Xcode ($DEVELOPER_DIR)..."
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME_NAME" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates \
  DEVELOPMENT_TEAM="$TEAM_ID" \
  CODE_SIGN_STYLE=Automatic \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID" \
  MARKETING_VERSION="$MARKETING_VERSION" \
  CURRENT_PROJECT_VERSION="$BUILD_NUMBER" \
  ASSETCATALOG_COMPILER_APPICON_NAME=AppIcon \
  archive 2>&1 | tee "$BUILD_ROOT/archive.log"

echo "Exporting the App Store IPA..."
xcodebuild \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  2>&1 | tee "$BUILD_ROOT/export.log"

IPA_PATH="$(find "$EXPORT_PATH" -maxdepth 1 -type f -name '*.ipa' -print -quit)"
if [[ -z "$IPA_PATH" ]]; then
  echo "The archive succeeded, but no IPA was exported to $EXPORT_PATH." >&2
  exit 1
fi

echo "IPA ready: $IPA_PATH"

if [[ "$UPLOAD_TO_TESTFLIGHT" == "1" ]]; then
  upload_ipa "$IPA_PATH"
else
  echo "Upload skipped because UPLOAD_TO_TESTFLIGHT=$UPLOAD_TO_TESTFLIGHT."
fi
