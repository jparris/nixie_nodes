#!/usr/bin/env python
import sys

# This my solution to generate unique-ish port based on a service's name.
# Cause everyone loves 8080, 8443, etc.
if len(sys.argv) != 2:
    print("Usage: <service name we're generating a port for>")
    sys.exit(1)

port = ""
letters = []
for c in sys.argv[1]:
    l_c = c.lower()
    num = ord(l_c) - ord('a') + 1
    next_port = port + str(num)
    if int(next_port) > 65535:
        break
    port = next_port
    letters.append("{} = {}".format(c, num))

print(port)
print(", ".join(letters))

