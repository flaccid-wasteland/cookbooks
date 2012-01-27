#!/usr/bin/python

import sys

try: 
        import boto
except ImportError:
        print('boto module not installed.')
        sys.exit(1)