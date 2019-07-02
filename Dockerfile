ARG platform=amd64

#from arm32v7/debian:9
#from multiarch/debian-debootstrap:${platform}-stretch as deb-base
FROM ${platform}/debian:9

COPY ./qemu-arm-static /usr/bin/qemu-arm-static

SHELL ["/usr/bin/qemu-arm-static", "/bin/sh", "-c"]

#RUN ["/usr/bin/qemu-arm-static", "/bin/sh", "-c", "apt-get update && apt-get install -y build-essential gdb"]
RUN apt-get update && apt-get install -y build-essential gdb

COPY crasher.cc /usr/local/src/crasher.cc

#RUN ["/usr/bin/qemu-arm-static", "/bin/sh", "-c", "g++ -std=c++11 -lpthread -o /usr/local/bin/example_crasher /usr/local/src/crasher.cc"]
RUN g++ -std=c++11 -lpthread -o /usr/local/bin/example_crasher /usr/local/src/crasher.cc

CMD ["gdb", "--return-child-result", "-ex", "run", "-ex", "bt", "-ex", "quit", "--batch", "--args", "/usr/local/bin/example_crasher", "13"]
