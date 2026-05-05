"""
Configuration file for the Sphinx documentation builder.

For the full list of built-in configuration values, see the documentation:
https://www.sphinx-doc.org/en/master/usage/configuration.html
"""

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "my_package"
# Hardcoded for reproducible builds. Bump the year manually (or replace with
# a "{start}–{current}" range) when appropriate.
copyright = "2026, Nathan A. Mahynski"
author = "Nathan A. Mahynski"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.viewcode",
    "sphinx.ext.napoleon",
    "sphinx.ext.mathjax",
    "sphinx_search.extension",
    "nbsphinx",
    "sphinx_gallery.load_style",
]
# To enable BibTeX citations, add "sphinxcontrib.bibtex" above, install
# `sphinxcontrib-bibtex` (e.g. add it to the docs extra), and set
# `bibtex_bibfiles = ["refs.bib"]` with at least one *.bib file under docs/.

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
# `_static/logo.png` is used by the Sphinx theme; `_static/logo_transparent.png`
# is what README.md embeds. Keep both in sync (or trim to one) when replacing.
html_logo = "_static/logo.png"
html_context = {
    "display_github": True,  # Integrate GitHub
    "github_user": "mahynski",  # Username
    "github_repo": "my_package",  # Repo name
    "github_version": "main",  # Version
    "conf_py_path": "docs/",  # Path in the checkout to the docs root
}
html_theme = "sphinx_book_theme"  #'sphinx_rtd_theme'
html_static_path = ["_static"]
pygments_style = "sphinx"
# Notebooks must be pre-executed locally; RTD just renders saved output.
nbsphinx_execute = "never"
# Examples for setting thumbnails for jupyter notebook tiles
# nbsphinx_kernel_name = 'my_package-kernel'
# nbsphinx_thumbnails = {
#    "jupyter/api/pipelines": "_static/default.png",
#    "jupyter/api/sharing_models": "_static/default.png",
# }
