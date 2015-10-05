## Compare 

Core judge uses diff to compare the outputs with the option to show the differences by an html file designed on Bootstrap 3 with some additional styles.

Diff is a linux command used for compare two files. In this case, core judge use diff to compare the output of source code with output expected. 

### Usage

```sh
$ ./compare /full_path/file1 /full_path/file2 --diff2html(optional)
```
* diff2html generate an HTML file with the differences(optional).

#### Status Codes
* 0 - Files are equal.
* 1 - Files are different.
* 2 - Some file don't exist.
* 3 - Unexpected error.

