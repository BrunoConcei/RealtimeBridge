#!C:/Python27/python.exe
import os
import cgi
import cgitb
cgitb.enable()
import datetime
import shutil
import imp

try: # Windows needs stdio set for binary mode.
    import msvcrt
    msvcrt.setmode (0, os.O_BINARY)  # stdin  = 0
    msvcrt.setmode (1, os.O_BINARY)  # stdout = 1
except ImportError:
    pass

# Obtain the date and time string for the file name
datestr = datetime.datetime.now().strftime("%Y%m%d%H%M")

# define local location for incoming files, if the directory doesn't exist, create directory
FileLocation = 'C:/Users/zzhao01/Documents/Webserver/tmp_copy/'
signaturedir = 'C:/Users/zzhao01/Documents/Webserver/SignatureFile/signature.csv'
signaturedir_temp = 'C:/Users/zzhao01/Documents/Webserver/SignatureFile/signature_temp.csv'

green = 'C:/Users/zzhao01/Documents/Webserver/website/image/green.png'
red = 'C:/Users/zzhao01/Documents/Webserver/website/image/red.png'
yellow = 'C:/Users/zzhao01/Documents/Webserver/website/image/yellow.png'
condition = 'C:/Users/zzhao01/Documents/Webserver/website/condition.png'

# read userfile
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
        if not line:
            break
    out.close()
    message = "The file '" + filename + "' was uploaded successfully"

    if filename.endswith(".csv"):
        data = open(FileLocation + name, 'rb')
        signature = open(signaturedir_temp, 'ab')
        while 1:
            data_line = data.readline()
            signature.write(data_line)
            if not data_line:
                break
        signature.close()

    with open(signaturedir) as myfile:
        count = sum(1 for line in myfile)

    # if the base model is big enough, run statistical analysis
    if count >= 500:
        os.system("C:/Users/zzhao01/Documents/Webserver/MATLAB_Programs/DamageIndex.exe")
        os.system("C:/Users/zzhao01/Documents/Webserver/MATLAB_Programs/BridgeSignature.exe")

        DI_file = open('C:/Users/zzhao01/Documents/Webserver/DIvalues/DI.csv')
        DI = DI_file.read()
        DI_file.close()

        DI_message = 'The Damage Index is ' + DI
        DI = float(DI)
        with open(signaturedir_temp) as myfile:
            count_temp = sum(1 for line in myfile)

        if DI <= 0.16:
            shutil.copyfile(green, condition)
            if (count_temp-count) >= 50:
                shutil.copyfile(signaturedir_temp, signaturedir)
        else:
            if DI < 0.5:
                shutil.copyfile(yellow, condition)
                msg_condition = "yellow.\nPlease plan to inspect."

            else:
                shutil.copyfile(red, condition)
                msg_condition = "red.\n\tPlease inspect immediately.\n\n"
                MakeCall = imp.load_source('call.py', 'C:/Users/zzhao01/Documents/Webserver/Voice/call.py')
                MakeCall.call()

            # Make PDF
            time = datetime.datetime.now().strftime("%Y/%m/%d-%H:%M")
            import MakePDF
            MakePDF.pdf(time,msg_condition,DI)

            # send email
            import SendEmail
            SendEmail.send(msg_condition)

print "Content-type:text/html\r\n"
try:
    print(message)
except NameError:
    print("No File Updated")

try:
    print DI_message
except NameError:
    print("Not enough data to compute Damage Index")



