FROM ubuntu:18.04


RUN apt-get update && apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y python3.8 python3-distutils python3-pip python3-apt
RUN pip3 install gdown

RUN apt-get install -y wget


COPY ./ANI.pl /var/

WORKDIR /var

RUN wget 'ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.23/blast-2.2.23-x64-linux.tar.gz' \
    && tar -zxvf blast-2.2.23-x64-linux.tar.gz
