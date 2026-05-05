#!/usr/bin/env bash
# Personalize this template for your project.
#
# Replaces every place the original author's identity is baked in
# (package name, GitHub username, author name, email, ORCID, codecov token)
# and renames the package directory. Run once, after cloning.
#
# Usage:
#   scripts/personalize.sh \
#     --name my_awesome_package \
#     --username my-github-handle \
#     --author "Jane Doe" \
#     --email jane@example.com \
#     [--orcid 0000-0001-2345-6789]
#
# Flags --name, --username, --author, --email are required. --orcid is
# optional; if omitted, the orcid line is removed from CITATION.cff.
#
# After running, manually:
#   1. Replace LICENSE.md with your chosen license and update the `license`
#      field in pyproject.toml to its SPDX expression.
#   2. Replace docs/_static/logo*.png with your own art (or remove
#      `html_logo` from docs/conf.py).
#   3. Once codecov is enabled for the new repo, replace the placeholder
#      token (the script leaves it as REPLACE_WITH_CODECOV_TOKEN).
#   4. Once Zenodo mints a DOI, fill in CITATION.cff and the badge in
#      README.md / docs/index.rst.
#   5. Update pyproject.toml's `description` and the package docstring
#      in <new-name>/__init__.py.
#
# When you're satisfied, delete this script: `rm -r scripts/`.

set -euo pipefail

# ---- defaults (these are the strings to replace) -------------------------
OLD_NAME="my_package"
OLD_USERNAME="mahynski"
OLD_AUTHOR="Nathan A. Mahynski"
OLD_EMAIL="nathan.mahynski@gmail.com"
OLD_ORCID="0000-0002-0008-8749"
OLD_CODECOV_TOKEN="YSLBQ33C7F"

NEW_NAME=""
NEW_USERNAME=""
NEW_AUTHOR=""
NEW_EMAIL=""
NEW_ORCID=""

# ---- arg parse -----------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NEW_NAME="$2"; shift 2 ;;
    --username) NEW_USERNAME="$2"; shift 2 ;;
    --author) NEW_AUTHOR="$2"; shift 2 ;;
    --email) NEW_EMAIL="$2"; shift 2 ;;
    --orcid) NEW_ORCID="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

for var in NEW_NAME NEW_USERNAME NEW_AUTHOR NEW_EMAIL; do
  if [[ -z "${!var}" ]]; then
    echo "Missing required flag for ${var#NEW_} (lowercased). See --help." >&2
    exit 2
  fi
done

# CITATION.cff stores given/family names as separate fields. Split the new
# author on the last space: "Jane Doe" -> given="Jane", family="Doe".
# "Jane A. Doe" -> given="Jane A.", family="Doe".
NEW_FAMILY="${NEW_AUTHOR##* }"
NEW_GIVEN="${NEW_AUTHOR% *}"
OLD_FAMILY="Mahynski"
OLD_GIVEN="Nathan"

# ---- platform-aware sed -i ----------------------------------------------
if [[ "$(uname)" == "Darwin" ]]; then
  sedi=(sed -i '')
else
  sedi=(sed -i)
fi

# ---- collect target files (plain text, exclude .git, _build, this script) -
mapfile -t files < <(find . -type f \
  -not -path "./.git/*" \
  -not -path "./docs/_build/*" \
  -not -path "./scripts/personalize.sh" \
  \( -name "*.py" -o -name "*.md" -o -name "*.rst" -o -name "*.toml" \
     -o -name "*.cfg" -o -name "*.yml" -o -name "*.yaml" -o -name "*.in" \
     -o -name "*.cff" -o -name "*.sh" -o -name "Makefile*" \
     -o -name "CODEOWNERS" \))

# ---- rewrite -------------------------------------------------------------
# Use | as sed delimiter for fields that may contain / (none here, but
# author/email are safer that way too).
for f in "${files[@]}"; do
  "${sedi[@]}" \
    -e "s|${OLD_AUTHOR}|${NEW_AUTHOR}|g" \
    -e "s|${OLD_EMAIL}|${NEW_EMAIL}|g" \
    -e "s|${OLD_CODECOV_TOKEN}|REPLACE_WITH_CODECOV_TOKEN|g" \
    -e "s/${OLD_NAME}/${NEW_NAME}/g" \
    -e "s/${OLD_USERNAME}/${NEW_USERNAME}/g" \
    "$f"
done

# CITATION.cff name fields (given/family stored separately).
"${sedi[@]}" \
  -e "s/family-names: ${OLD_FAMILY}/family-names: ${NEW_FAMILY}/" \
  -e "s/given-names: ${OLD_GIVEN}/given-names: ${NEW_GIVEN}/" \
  CITATION.cff

# ORCID: rewrite if provided, otherwise drop the orcid line from CITATION.cff.
if [[ -n "$NEW_ORCID" ]]; then
  "${sedi[@]}" -e "s|${OLD_ORCID}|${NEW_ORCID}|g" CITATION.cff
else
  "${sedi[@]}" -e "/orcid:.*${OLD_ORCID}/d" CITATION.cff
fi

# ---- rename package directory -------------------------------------------
if [[ -d "$OLD_NAME" && "$OLD_NAME" != "$NEW_NAME" ]]; then
  if git ls-files --error-unmatch "$OLD_NAME" >/dev/null 2>&1; then
    git mv "$OLD_NAME" "$NEW_NAME"
  else
    mv "$OLD_NAME" "$NEW_NAME"
  fi
fi

cat <<EOF

Personalization complete. Manual follow-ups:

  1. LICENSE.md — replace placeholder with your chosen license; set the
     'license' field in pyproject.toml to its SPDX expression.
  2. docs/_static/logo.png and logo_transparent.png — replace with your
     own art, or remove html_logo from docs/conf.py.
  3. Codecov badge token — search for REPLACE_WITH_CODECOV_TOKEN in
     README.md and docs/index.rst; replace with the token from your
     codecov.io project.
  4. CITATION.cff and DOI badge — populate after Zenodo mints a DOI.
  5. pyproject.toml 'description' and ${NEW_NAME}/__init__.py docstring —
     replace template placeholders.

Review the diff:           git diff
Then delete this script:   rm -r scripts/
EOF
