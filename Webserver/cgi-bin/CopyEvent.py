#!/usr/bin/python
import os
import cgi
import cgitb
import datetime
import mat4py   # used for .mat file
import ast


try: # Windows needs stdio set for binary mode.
    import msvcrt
    msvcrt.setmode (0, os.O_BINARY) # stdin  = 0
    msvcrt.setmode (1, os.O_BINARY) # stdout = 1
except ImportError:
    pass

# enable to see the server log
cgitb.enable()

# Obtain the date and time string for the file name
datestr = datetime.datetime.now().strftime("%Y%m%d%H%M")

# define local location for incoming files, if the directory doesn't exist, create directory
FileLocation = 'f:/webserver/RealtimeSHM/tmp_copy/'
matfiledir = 'F:/webserver/RealtimeSHM/SignatureFile/signature.csv'

if not os.path.exists(FileLocation):
    os.makedirs(FileLocation)

# following code for .mat file upload
form = cgi.FieldStorage()
fileitem = form["userfile"]
filename = form["userfile"].filename

if fileitem.file:
    name = datestr + filename
    out = open(FileLocation + name, 'wb')
    # It's an uploaded file; count lines
    while 1:
        line = fileitem.file.readline()
        out.write(line)
        if not line: break
    out.close()
    message = "The file '" + filename + "' was uploaded successfully"

    if filename.endswith(".csv"):
        data = open(FileLocation + name, 'rb')
        signature = open(matfiledir, 'a')
        while 1:
            data_line = data.readline()
            signature.write(data_line)
            if not data_line: break
        signature.close()

print "Content-type:text/html\r\n"
print message




