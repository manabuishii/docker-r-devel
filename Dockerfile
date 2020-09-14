FROM debian:testing
MAINTAINER Manabu ISHII
RUN apt-get update -qq \
        && apt-get install -y gfortran libbz2-dev libpcre3-dev build-essential  subversion libcurl4-openssl-dev libreadline8 libreadline-dev zlib1g-dev zlib1g liblzma-dev liblzma5 rsync openjdk-13-jdk openjdk-13-jre-headless openjdk-13-jre texlive-latex-base texlive-fonts-recommended subversion texinfo texlive-latex-extra lzma libpcre2-dev git git-svn \
        && apt-get clean

RUN git clone --depth 1 https://github.com/wch/r-source.git /usr/src/r-devel ; cd /usr/src/r-devel ; git fetch --depth 1 origin 0b350662e6d128169440cb231947e2482af91f89 ; git checkout FETCH_HEAD
RUN cd /usr/src/r-devel ; git svn init --prefix=origin/ -s https://svn.r-project.org/R/ ;  ./tools/rsync-recommended ; ./tools/link-recommended ;./configure --without-recommended-packages --enable-R-shlib --with-x=no --prefix=/usr/local/r-79195 ; make ; bin/R CMD INSTALL src/library/Recommended/MASS.tgz ; bin/R CMD INSTALL src/library/Recommended/lattice.tgz ; bin/R CMD INSTALL src/library/Recommended/Matrix.tgz
RUN apt-get install -y locales
RUN echo "en_US UTF-8" > /etc/locale.gen
RUN locale-gen
RUN cd /usr/src/r-devel ; make check
RUN cd /usr/src/r-devel ; make install
RUN ln -s /usr/local/r-79195/bin/R /usr/local/bin
