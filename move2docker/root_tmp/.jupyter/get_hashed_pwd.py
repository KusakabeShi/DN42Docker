#!/usr/bin/python3
from notebook.auth import passwd
import os
my_password = os.environ.get('JUPYTER_PASSWORD')

hashed_password = passwd(passphrase=my_password, algorithm='sha256')

print(hashed_password)
