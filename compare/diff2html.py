#!/usr/bin/env python

# *****************************************
# * FILE: diff2html.py                    *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

import sys
import os
import string
import re
import time
import stat

if ( __name__ == "__main__" ) :

	# EXTERNAL CSS 
	external_css = ""

	# PROCESSES COMMAND-LINE OPTIONS
	cmd_line = string.join(sys.argv)
	print sys.argv
    argv = tuple(sys.argv)

    #CHECKING IF BOTH FILES EXISTS
    file1 = argv[1]
    file2 = argv[2]
    print file1
    print file2
    if not os.access(file1, os.F_OK):
    	print "File %s doesn't exist or is not readable, aborting." % file1
    	sys.exist(1)
    if not os.access(file2, os.F_OK):
    	print "File %s doesn't exist or is not readable, aborting." % file2
    	sys.exist(1)

    # RUNNING DIFF
    diff_stdout = os.popen("diff %s" % string.join(argv[1:]), "r")
    diff_output = diff_stdout.readlines()
    diff_stdout.close()
    print diff_output
    print diff_stdout

    # MAPS TO STORE THE REPORTED DIFFERENCES
    changed = {}
    deleted = {}
    added = {}

    # MAGIC REGULAR EXPRESSION
    diff_re = re.compile(
        r"^(?P<f1_start>\d+)(,(?P<f1_end>\d+))?"+ \
         "(?P<diff>[acd])"+ \
         "(?P<f2_start>\d+)(,(?P<f2_end>\d+))?")
    print diff_re

    # PARSING THE OUTPUT FROM DIFF
    for diff_line in diff_output:
        diffs = diff_re.match(string.strip(diff_line))
        # If the line doesn't match, it's useless for us
        if not ( diffs  == None ) :
            # Retrieving informations about the differences : 
            # starting and ending lines (may be the same)
            f1_start = int(diffs.group("f1_start"))
            if ( diffs.group("f1_end") == None ) :
                f1_end = f1_start
            else :
                f1_end = int(diffs.group("f1_end"))
            f2_start = int(diffs.group("f2_start"))
            if ( diffs.group("f2_end") == None ) :
                f2_end = f2_start
            else :
                f2_end = int(diffs.group("f2_end"))
            f1_nb = (f1_end - f1_start) + 1
            f2_nb = (f2_end - f2_start) + 1
            # Is it a changed (modified) line ?
            if ( diffs.group("diff") == "c" ) :
                # We have to handle the way "diff" reports lines merged
                # or splitted
                if ( f2_nb < f1_nb ) :
                    # Lines merged : missing lines are marqued "deleted"
                    for lf1 in range(f1_start, f1_start+f2_nb) :
                        changed[lf1] = 0
                    for lf1 in range(f1_start+f2_nb, f1_end+1) :
                        deleted[lf1] = 0
                elif ( f1_nb < f2_nb ) :
                    # Lines splitted : extra lines are marqued "added"
                    for lf1 in range(f1_start, f1_end+1) :
                        changed[lf1] = 0
                    for lf2 in range(f2_start+f1_nb, f2_end+1) :
                        added[lf2] = 0
                else :
                    # Lines simply modified !
                    for lf1 in range(f1_start, f1_end+1) :
                        changed[lf1] = 0
            # Is it an added line ?
            elif ( diffs.group("diff") == "a" ) :
                for lf2 in range(f2_start, f2_end+1):
                    added[lf2] = 0
            else :
            # OK, so it's a deleted line
                for lf1 in range(f1_start, f1_end+1) :
                    deleted[lf1] = 0

    # Storing the two compared files, to produce the HTML output
    f1 = open(file1, "r")
    f1_lines = f1.readlines()
    f1.close()
    f2 = open(file2, "r")
    f2_lines = f2.readlines()
    f2.close()
    
    # Finding some infos about the files
    f1_stat = os.stat(file1)
    f2_stat = os.stat(file2)

    # Printing the HTML header, and various known informations
    
    # Preparing the links to changes
    if ( len(changed) == 0 ) :
        changed_lnks = "None"
    else :
        changed_lnks = ""
        keys = changed.keys()
        keys.sort()
        for key in keys :
            changed_lnks += "<a href=\"#F1_%d\">%d</a>, " % (key, key)
        changed_lnks = changed_lnks[:-2]
    
    if ( len(added) == 0 ) :
        added_lnks = "None"
    else :
        added_lnks = ""
        keys = added.keys()
        keys.sort()
        for key in keys :
            added_lnks += "<a href=\"#F2_%d\">%d</a>, " % (key, key)
        added_lnks = added_lnks[:-2]

    if ( len(deleted) == 0 ) :
        deleted_lnks = "None"
    else :
        deleted_lnks = ""
        keys = deleted.keys()
        keys.sort()
        for key in keys :
            deleted_lnks += "<a href=\"#F1_%d\">%d</a>, " % (key, key)
        deleted_lnks = deleted_lnks[:-2]

    print """
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
 "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<head>
    <title>Differences between %s and %s</title>""" % (file1, file2)
    if ( external_css == "" ) :
        print "    <style>%s</style>" % default_css
    else :
        print "    <link rel=\"stylesheet\" href=\"%s\" type=\"text/css\">" % \
        external_css

    print """
</head>
<body>
<table>
<tr><td width="50%%">
<table>
    <tr>
        <td class="modified">Modified lines:&nbsp;</td>
        <td class="modified">%s</td>
    </tr>
    <tr>
        <td class="added">Added line:&nbsp;</td>
        <td class="added">%s</td>
    </tr>
    <tr>
        <td class="removed">Removed line:&nbsp;</td>
        <td class="removed">%s</td>
    </tr>
</table>
</td>
<td width="50%%">
<i>Generated by <a href="http://diff2html.tuxfamily.org"><b>diff2html</b></a><br/>
&copy; Yves Bailly, MandrakeSoft S.A. 2001<br/>
<b>diff2html</b> is licensed under the <a 
href="http://www.gnu.org/copyleft/gpl.html">GNU GPL</a>.</i>
</td></tr>
</table>
<hr/>
<table>
    <tr>
        <th>&nbsp;</th>
        <th width="45%%"><strong><big>%s</big></strong></th>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        <th width="45%%"><strong><big>%s</big></strong></th>
    </tr>
    <tr>
        <td width="16">&nbsp;</td>
        <td>
        %d lines<br/>
        %d bytes<br/>
        Last modified : %s<br/>
        <hr/>
        </td>
        <td width="16">&nbsp;</td>
        <td width="16">&nbsp;</td>
        <td>
        %d lines<br/>
        %d bytes<br/>
        Last modified : %s<br/>
        <hr/>
        </td>
    </tr>
""" % (changed_lnks, added_lnks, deleted_lnks,
       file1, file2,
       len(f1_lines), f1_stat[stat.ST_SIZE], 
       time.asctime(time.gmtime(f1_stat[stat.ST_MTIME])),
       len(f2_lines), f2_stat[stat.ST_SIZE], 
       time.asctime(time.gmtime(f2_stat[stat.ST_MTIME])))
    
    # Running through the differences...
    nl1 = nl2 = 0
    while not ( (nl1 >= len(f1_lines)) and (nl2 >= len(f2_lines)) ) :
        if ( added.has_key(nl2+1) ) :
            f2_lines[nl2]
      # This is an added line
            print """
    <tr>
        <td class="linenum">&nbsp;</td>
        <td class="added">&nbsp;</td>
        <td width="16">&nbsp;</td>
        <td class="linenum"><a name="F2_%d">%d</a></td>
        <td class="added">%s</td>
    </tr>
""" % (nl2+1, nl2+1, str2html(f2_lines[nl2]))
            nl2 += 1
        elif ( deleted.has_key(nl1+1) ) :
      # This is a deleted line
            print """
    <tr>
        <td class="linenum"><a name="F1_%d">%d</a></td>
        <td class="removed">%s</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">&nbsp;</td>
        <td class="removed">&nbsp;</td>
    </tr>
""" % (nl1+1, nl1+1, str2html(f1_lines[nl1]))
            nl1 += 1
        elif ( changed.has_key(nl1+1) ) :
      # This is a changed (modified) line
            print """
    <tr>
        <td class="linenum"><a name="F1_%d">%d</a></td>
        <td class="modified">%s</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">%d</td>
        <td class="modified">%s</td>
    </tr>
""" % (nl1+1, nl1+1, str2html(f1_lines[nl1]), 
       nl2+1, str2html(f2_lines[nl2]))
            nl1 += 1
            nl2 += 1
        else :
      # These lines have nothing special
            if ( not only_changes ) :
                print """
    <tr>
        <td class="linenum">%d</td>
        <td class="normal">%s</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">%d</td>
        <td class="normal">%s</td>
    </tr>
""" % (nl1+1, str2html(f1_lines[nl1]),
       nl2+1, str2html(f2_lines[nl2]))
            nl1 += 1
            nl2 += 1
            
    # And finally, the end of the HTML
    print """
</table>
<hr/>
<i>Generated by <b>diff2html</b> on %s<br/>
Command-line:</i> <tt>%s</tt>

</body>
</html>
""" % (time.asctime(time.gmtime(time.time())), cmd_line)