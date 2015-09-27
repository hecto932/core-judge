#!/usr/bin/env python

# *****************************************
# * FILE: diff2html.py                    *
# * AUTOR: Hector Jose Flores Colmenarez  *
# * EMAIL: hecto932@gmail.com             *           
# *****************************************

#LIBRARIES 
import sys
import os
import string
import re
import time
import stat

def str2html(s) :
    s1 = string.replace(string.rstrip(s), "&", "&amp;")
    if ( len(s1) == 0 ) : return ( s1 ) ;
    s1 = string.replace(s1, "<", "&lt;")
    s1 = string.replace(s1, ">", "&gt;")
    i = 0
    s2 = ""
    while ( s1[i] == " " ) :
        s2 += "&nbsp;"
        i += 1
    s2 += s1[i:]
    return ( s2 )

# MAIN
if ( __name__ == "__main__" ) :

    # PROCESS COMAND-LINE OPTIONS
    cmd_line = string.join(sys.argv)
    
    for ind_opt in range(len(sys.argv)) :
        if ( sys.argv[ind_opt] == "--help" ) :
            print_usage()
            sys.exit(0)
    
    external_css = ""
    ind_css = -1
    ind_chg = -1
    only_changes = 0
    argv = tuple(sys.argv)
    for ind_opt in range(len(argv)) :
        if ( argv[ind_opt] == "--style-sheet" ) :
            ind_css = in_opt
            external_css = argv[ind_css+1]
        if ( argv[ind_opt] == "--only-changes" ) :
            ind_chg = ind_opt
            only_changes = 1

    argv = list(argv)
    if ( ind_css >= 0 ) :
        del argv[ind_css:ind_css+2]
    if ( ind_chg >= 0 ) :
        del argv[ind_chg:ind_chg+1]

    # VERIFY IF BOTH FILES EXISTS
    file1 = argv[-2]
    file2 = argv[-1]
    if not os.access(file1, os.F_OK) :
        print "File %s does not exist or is not readable, aborting." % file1
        sys.exit(1)
    if not os.access(file2, os.F_OK) :
        print "File %s does not exist or is not readable, aborting." % file2
        sys.exit(1)

    # INVOKES "DIFF"
    diff_stdout = os.popen("diff %s" % string.join(argv[1:]), "r")
    diff_output = diff_stdout.readlines()
    diff_stdout.close()
    # REPORTED DIFFERENCES
    changed = {}
    deleted = {}
    added = {}
    # MAGIC REGULAR EXPRESSION
    diff_re = re.compile(
        r"^(?P<f1_start>\d+)(,(?P<f1_end>\d+))?"+ \
         "(?P<diff>[acd])"+ \
         "(?P<f2_start>\d+)(,(?P<f2_end>\d+))?")
    for diff_line in diff_output:
        diffs = diff_re.match(string.strip(diff_line))
        # If the line doesn't match, it's useless for us
        if not ( diffs  == None ) :
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
            if ( diffs.group("diff") == "c" ) :
                if ( f2_nb < f1_nb ) :
                    for lf1 in range(f1_start, f1_start+f2_nb) :
                        changed[lf1] = 0
                    for lf1 in range(f1_start+f2_nb, f1_end+1) :
                        deleted[lf1] = 0
                elif ( f1_nb < f2_nb ) :
                    for lf1 in range(f1_start, f1_end+1) :
                        changed[lf1] = 0
                    for lf2 in range(f2_start+f1_nb, f2_end+1) :
                        added[lf2] = 0
                else :
                    for lf1 in range(f1_start, f1_end+1) :
                        changed[lf1] = 0
            elif ( diffs.group("diff") == "a" ) :
                for lf2 in range(f2_start, f2_end+1):
                    added[lf2] = 0
            else :
                for lf1 in range(f1_start, f1_end+1) :
                    deleted[lf1] = 0

    f1 = open(file1, "r")
    f1_lines = f1.readlines()
    f1.close()
    f2 = open(file2, "r")
    f2_lines = f2.readlines()
    f2.close()
    
    f1_stat = os.stat(file1)
    f2_stat = os.stat(file2)

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
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="utf-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Differences between %s and %s</title>
                <link href="bootstrap.min.css" rel="stylesheet"/>
                <link rel="stylesheet" href="styles.css"/>
    """ % (file1, file2)
    print """
        </head>
        <body>
            <div class="row header-green">
                <div class="col-md-12">
                    <h1 class="title">diff2html</h1>
                </div>
            </div>
            <table>
                <tr>
                    <td width="100%%">
                        <table class="table table-bordered table-responsive">
                            <tr>
                                <td class="color-modified">Modified lines:&nbsp;</td>
                                <td class="color-modified">%s</td>
                            </tr>
                            <tr>
                                <td class="color-added">Added line:&nbsp;</td>
                                <td class="color-added">%s</td>
                            </tr>
                            <tr>
                                <td class="color-delete">Removed line:&nbsp;</td>
                                <td class="color-delete">%s</td>
                            </tr>
                        </table>
                    </td>
                    
                </tr>
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
    
    nl1 = nl2 = 0
    while not ( (nl1 >= len(f1_lines)) and (nl2 >= len(f2_lines)) ) :
        if ( added.has_key(nl2+1) ) :
            f2_lines[nl2]
      # This is an added line
            print """
    <tr>
        <td class="linenum">&nbsp;</td>
        <td class="color-added">&nbsp;</td>
        <td width="16">&nbsp;</td>
        <td class="linenum"><a name="F2_%d">%d</a></td>
        <td class="color-added">%s</td>
    </tr>
""" % (nl2+1, nl2+1, str2html(f2_lines[nl2]))
            nl2 += 1
        elif ( deleted.has_key(nl1+1) ) :
            print """
    <tr>
        <td class="linenum"><a name="F1_%d">%d</a></td>
        <td class="color-delete">%s</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">&nbsp;</td>
        <td class="color-delete">&nbsp;</td>
    </tr>
""" % (nl1+1, nl1+1, str2html(f1_lines[nl1]))
            nl1 += 1
        elif ( changed.has_key(nl1+1) ) :
            print """
    <tr>
        <td class="linenum"><a name="F1_%d">%d</a></td>
        <td class="color-modified">%s</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">%d</td>
        <td class="color-modified">%s</td>
    </tr>
""" % (nl1+1, nl1+1, str2html(f1_lines[nl1]), 
       nl2+1, str2html(f2_lines[nl2]))
            nl1 += 1
            nl2 += 1
        else :
            if ( not only_changes ) :
                print """
    <tr>
        <td class="linenum">%d</td>
        <td class="color-ok">%s</td>
        <td width="16">&nbsp;</td>
        <td class="linenum">%d</td>
        <td class="color-ok">%s</td>
    </tr>
""" % (nl1+1, str2html(f1_lines[nl1]),
       nl2+1, str2html(f2_lines[nl2]))
            nl1 += 1
            nl2 += 1
            
    print """
        </table>
        <hr/>
        <p class="log-file">
            <b>Generated by diff2html on %s</b>
            <br/>
            Command-line: <time>%s<time>
        </p>
        <footer>
            Develop by <a href="http://github.com/hecto932">Hector Flores</a>
        </footer>
    </body>
</html>
""" % (time.asctime(time.gmtime(time.time())), cmd_line)