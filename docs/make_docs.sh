#!/usr/bin/env bash
# Build the Sphinx HTML docs locally. Mirrors the RTD pre_build / build flow.
set -euo pipefail

# Generate API reference pages from my_package/. Output goes alongside conf.py
# in docs/, where they're picked up by the `modules` toctree in index.rst.
sphinx-apidoc -o ./ ../my_package/

# Clean and rebuild HTML. Equivalent to `make clean html` but doesn't depend
# on the Makefile being named correctly.
rm -rf _build/html _build/doctrees
sphinx-build -b html -d _build/doctrees . _build/html
