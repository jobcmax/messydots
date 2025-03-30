#!/usr/bin/python3
import sys
import dbus
import argparse
import subprocess
import os

def toggle(service, object):
    bus = dbus.SessionBus()
    proxy = bus.get_object(service, object)
    method = proxy.get_dbus_method('toggle', service)
    return method()
    
if len(sys.argv) < 2:
    print("starting controls dbus service")
    subprocess.run(["python3", os.path.dirname(os.path.abspath(__file__)) + "/" + "control.py"])
elif len(sys.argv) > 1 and sys.argv[1] == "toggle":
    toggle('widget.control.service', '/widget/control/service')
