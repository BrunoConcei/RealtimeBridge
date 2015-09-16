#!/usr/bin/python

__author__ = 'ZHIYONG ZHAO'

import os
import cgi
import cgitb
import mat4py
import datetime
# enable to see the server log
cgitb.enable()

temp_folder = 'F:/webserver/RealtimeSHM/tmp_copy/'
matfiledir = 'F:/webserver/RealtimeSHM/Matfile/signature.mat'

event_names = os.listdir(temp_folder)


for name in event_names:
    file_process = temp_folder+name
    if file_process.endswith('.mat'):
        data = mat4py.loadmat(file_process)
        os.remove(file_process)
        if os.path.isfile(matfiledir):
            signature = mat4py.loadmat(matfiledir)
            ds = [signature, data]
            d = {}
            for k in data.iterkeys():
                d[k] = tuple(d[k] for d in ds)
            signature = d
        else:
            signature = data
        mat4py.savemat(matfiledir, signature)



