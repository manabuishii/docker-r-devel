FROM debian:testing
MAINTAINER Manabu ISHII
RUN apt-get update -qq \
        && apt-get install -y texlive-fonts-extra gfortran libbz2-dev libpcre3-dev build-essential  subversion libcurl4-openssl-dev libreadline8 libreadline-dev zlib1g-dev zlib1g liblzma-dev liblzma5 rsync openjdk-17-jdk openjdk-17-jre-headless openjdk-17-jre texlive-latex-base texlive-fonts-recommended subversion texinfo texlive-latex-extra lzma libpcre2-dev git git-svn \
        && apt-get clean

RUN git clone --depth 1 https://github.com/wch/r-source.git /usr/src/r-devel ; cd /usr/src/r-devel ; git fetch --depth 1 origin 4db01020a4ba2ecc94ca41690b20769a630de6e1 ; git checkout FETCH_HEAD
RUN cd /usr/src/r-devel ; git svn init --prefix=origin/ -s https://svn.r-project.org/R/ ;  ./tools/rsync-recommended ; ./tools/link-recommended ;./configure --without-recommended-packages --enable-R-shlib --with-x=no --prefix=/usr/local/r-79911 ; make ; bin/R CMD INSTALL src/library/Recommended/MASS.tgz ; bin/R CMD INSTALL src/library/Recommended/lattice.tgz ; bin/R CMD INSTALL src/library/Recommended/Matrix.tgz
RUN apt-get install -y locales
RUN echo "en_US UTF-8" > /etc/locale.gen
RUN locale-gen
RUN cd /usr/src/r-devel ; make check
RUN cd /usr/src/r-devel ; make install
RUN ln -s /usr/local/r-79911/bin/R /usr/local/bin
