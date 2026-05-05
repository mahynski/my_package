"""
Pytest example template.

TODO: Replace this with real tests for your package. The trivial test
below exists only to keep the test suite green on a fresh template
checkout — coverage numbers it produces are not meaningful.
"""

import my_package


def test_version_is_set():
    """Sanity check: the package exposes a non-empty version string."""
    assert isinstance(my_package.__version__, str)
    assert my_package.__version__
