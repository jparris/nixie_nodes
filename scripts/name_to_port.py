#!/usr/bin/env python
import sys

# This my solution to generate unique-ish port based on a service's name.
# Cause everyone loves 8080, 8443, etc.
if len(sys.argv) != 2:
    print("Usage: <service name we're generating a port for>")
    sys.exit(1)

port = ""
for c in sys.argv[1].lower():
    num = ord(c) - ord('a') + 1
    next_port = port + str(num)
    if int(next_port) > 65535:
        break
    port = next_port

print(port)
