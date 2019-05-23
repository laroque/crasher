ARG platform=amd64

#from debian:9 as deb-base
from multiarch/debian-debootstrap:${platform}-stretch as deb-base

RUN apt-get update && apt-get install -y \
    build-essential \
    gdb

from deb-base

COPY crasher.cc /usr/local/src/crasher.cc

RUN g++ -std=c++11 -lpthread -o /usr/local/bin/example_crasher /usr/local/src/crasher.cc

CMD ["gdb", "--return-child-result", "-ex", "run", "-ex", "bt", "-ex", "quit", "--batch", "--args", "/usr/local/bin/example_crasher", "13"]
