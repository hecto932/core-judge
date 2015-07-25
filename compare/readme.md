1st line: a stands for added, d for deleted and c for changed. Line numbers of the original file appear before these letters and those of the modified file appear after the letter.

2nd line: line with < are from file 1 and are different from file 2.

3rd line is a divider.

4th line: line with > are from file 2 and are different from file 1.

(If you ever see = it means the lines are the same in both files)

And your problem might be whitespaces or other non-human readable characters: those trigger a difference too.

There are some options to manipulate output.

Example:

rinzwind@discworld:~$ more 1 
test
test2
test3
rinzwind@discworld:~$ more 2
test
test2  
test3
contexted format:

rinzwind@discworld:~$ diff -c  1 2
*** 1   2011-08-13 17:05:40.433966684 +0200
--- 2   2011-08-13 17:11:24.369966629 +0200
***************
*** 1,3 ****
  test
! test2
  test3
--- 1,3 ----
  test
! test2  
  test3
A "!" represents a change between lines that correspond in the two files. A "+" represents the addition of a line, while a blank space represents an unchanged line. At the beginning of the patch is the file information, including the full path and a time stamp. At the beginning of each hunk are the line numbers that apply for the corresponding change in the files. A number range appearing between sets of three asterisks applies to the original file, while sets of three dashes apply to the new file. The hunk ranges specify the starting and ending line numbers in the respective file.

Expanding on Lekensteyn's comment about unified format:

rinzwind@discworld:~$ diff -u  1 2
--- 1   2011-08-13 17:05:40.433966684 +0200
+++ 2   2011-08-13 17:11:24.369966629 +0200
@@ -1,3 +1,3 @@
 test
-test2
+test2  
 test3
The format starts with the same two-line header as the context format, except that the original file is preceded by "---" and the new file is preceded by "+++". Following this are one or more change hunks that contain the line differences in the file. The unchanged, contextual lines are preceded by a space character, addition lines are preceded by a plus sign, and deletion lines are preceded by a minus sign.

Some useful options:

-b Ignore changes in the amount of white space.

-w Ignore all white space.

-B Ignore all blank lines.

-y output in 2 colums.