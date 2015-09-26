#!C:\Python27\python.exe
import requests
import os
import time
from requests.auth import HTTPDigestAuth

# the server url location
url = "http://130.64.82.124:8080/cgi-bin/Server.py"

# upload directory
UploadDirectory = "C:/Users/zzhao01/Documents/Client/Upload/"

while True:
    # get all files in upload directory
    file_names = os.listdir(UploadDirectory)

    for filename in file_names:
        file_address = UploadDirectory + filename
        data = open(file_address, "rb")
        current_file = {"userfile": data}

    # Create the Request object
        r = requests.post(url, files=current_file, auth=HTTPDigestAuth('bridge', 'pass'))
        print r.text

    # remove old files
        data.close()
        os.remove(file_address)

    time.sleep(1)