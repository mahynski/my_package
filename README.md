PyPi Package Template
===

1. Choose a name and replace all "my_package" names, strings, etc. in this repo with your desired package name.  The command below makes this simple.

~~~bash
$ for file in $(find . -type f -not -path "./.git/*"); do sed -i "s/my_package/my_awesome_new_package/g" $file; done # Replace "my_awesome_new_package" with your new package name
~~~

2. Get coding!
