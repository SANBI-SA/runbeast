#!/usr/bin/env python

import sys
from random import SystemRandom

if len(sys.argv) == 2:
  seed = sys.argv[1]
else:
  seed = '143'

# generate a seed
# e.g. 1433686807619

seedlen = len('1433686807619')

generator = SystemRandom()
for i in range(seedlen-len(seed)):
  seed += str(generator.randint(0,9))

print seed
