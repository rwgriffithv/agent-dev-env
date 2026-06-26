#!/usr/bin/env bash
#
# scripts/clean-emacs.sh
#
# Remove Emacs temporary files.
#
set -euo pipefail

find . -name "*~" -exec rm {} \;
