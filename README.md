PyPi Package Template
===

1. Choose a name and replace all "my_package" names, strings, etc. in this repo with your desired package name (e.g., "my_awesome_new_package").  The command below makes this simple; run this after cloning the repo locally.

~~~bash
for file in $(find . -type f -not -path "./.git/*"); do sed -i "s/my_package/my_awesome_new_package/g" $file; done
~~~

2. Get coding!

Documentation
===

Documentation is stored in the `docs/` folder and is currently set up to use [sphinx](https://www.sphinx-doc.org/en/master/).

First build the `requirements.txt` needed to build the documentation.

~~~bash
$ cd docs
$ pip install Sphinx
$ pip install pip-tools
$ pip-compile requirements.in
~~~

Adjust the `docs/conf.py` as desired. Then run `docs/make_docs.sh` to setup the documentation initially.  You can manually add and adjust later.

~~~bash
$ bash make_docs.sh
~~~

Go to [https://about.readthedocs.com/](https://about.readthedocs.com/) to link your repo to build and host the documentation automatically!
