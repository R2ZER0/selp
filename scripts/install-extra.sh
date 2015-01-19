#!/bin/bash

# Install the Collector and Manager servers (& prereqs)

# If we are unable to install packages, try a different mirror:
# By default i am using my own mirror of CPAN, to ensure that we have the same
# versions of all the modules - also, it is a lot faster.
MYCPANM="cpanm --verbose --mirror-only --mirror http://gallium.r2zer0.net/minicpan/"
#MYCPANM="cpanm --verbose"  # Use public mirrors (possibly slower)

# There is a bug in ZMQx::Class, which causes tests to fail sometimes
# I have worked around it in my own application/tests
# So we install it here with no tests
$MYCPANM ZMQ::FFI
$MYCPANM --notest ZMQx::Class

# Install our distributions
# Feel free to comment these out if you don't want to run them
$MYCPANM dists/SquareStats-Collector-0.001.tar.gz
$MYCPANM dists/AC-Manager-0.002.tar.gz