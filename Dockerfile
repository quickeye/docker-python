FROM nvidia/cuda:8.0-cudnn5-devel
MAINTAINER David Wilding

ADD install /home
RUN /bin/bash /home/install

ADD digits.cfg /home/DIGITS-4.1-dev/digits
EXPOSE 5000

WORKDIR /home/DIGITS-4.1-dev
CMD ["./digits-devserver"]

