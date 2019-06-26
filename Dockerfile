ARG platform=amd64
#or platform=arm32v7

#from debian:9 as deb-base
#from arm32v7/debian:9
#from multiarch/debian-debootstrap:${platform}-stretch as deb-base
from ${platform}/debian:9

COPY ./qemu-arm-static /usr/bin/qemu-arm-static
#RUN ["/bin/uname", "-a"]
#RUN ["/usr/bin/qemu-arm-static", "/bin/uname", "-a"l]
#RUN ["/usr/bin/qemu-arm-static", "/bin/sh", "-c", "uname -a"]

#RUN file /usr/bin/qemu-arm-static

RUN ["/usr/bin/qemu", "/bin/sh", "-c", "apt-get update && apt-get install -y build-essential gdb"]

#from deb-base

COPY crasher.cc /usr/local/src/crasher.cc

RUN g++ -std=c++11 -lpthread -o /usr/local/bin/example_crasher /usr/local/src/crasher.cc

CMD ["gdb", "--return-child-result", "-ex", "run", "-ex", "bt", "-ex", "quit", "--batch", "--args", "/usr/local/bin/example_crasher", "13"]
