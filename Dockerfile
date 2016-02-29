FROM debian:testing
MAINTAINER Manabu ISHII
RUN apt-get update -qq \
        && apt-get install -y gfortran libbz2-dev libpcre3-dev build-essential  subversion libcurl4-openssl-dev libreadline6 libreadline-dev zlib1g-dev zlib1g liblzma-dev liblzma5 rsync openjdk-7-jdk openjdk-7-jre-headless openjdk-7-jre texlive-latex-base texlive-fonts-recommended subversion texinfo texlive-latex-extra \
        && apt-get clean

RUN svn checkout -r 70237 https://svn.r-project.org/R/trunk/  /usr/src/r-devel
RUN cd /usr/src/r-devel ;  ./configure --without-recommended-packages --enable-R-shlib --with-x=no --prefix=/usr/local/r-70237 ; ./tools/rsync-recommended ; ./tools/link-recommended ; make ; bin/R CMD INSTALL src/library/Recommended/MASS.tgz
RUN cd /usr/src/r-devel ; make check
RUN cd /usr/src/r-devel ; make install
RUN ln -s /usr/local/r-70237/bin/R /usr/local/bin
