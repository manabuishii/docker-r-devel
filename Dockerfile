FROM debian:testing
MAINTAINER Manabu ISHII
RUN apt-get update -qq \
        && apt-get install -y gfortran libbz2-dev libpcre3-dev build-essential  subversion libcurl4-openssl-dev libreadline7 libreadline-dev zlib1g-dev zlib1g liblzma-dev liblzma5 rsync openjdk-12-jdk openjdk-12-jre-headless openjdk-12-jre texlive-latex-base texlive-fonts-recommended subversion texinfo texlive-latex-extra \
        && apt-get clean

RUN svn checkout -r 77239 https://svn.r-project.org/R/trunk/  /usr/src/r-devel
RUN cd /usr/src/r-devel ;  ./configure --without-recommended-packages --enable-R-shlib --with-x=no --prefix=/usr/local/r-77239 ; ./tools/rsync-recommended ; ./tools/link-recommended ; make ; bin/R CMD INSTALL src/library/Recommended/MASS.tgz ; bin/R CMD INSTALL src/library/Recommended/lattice.tgz ; bin/R CMD INSTALL src/library/Recommended/Matrix.tgz
RUN cd /usr/src/r-devel ; make check
RUN cd /usr/src/r-devel ; make install
RUN ln -s /usr/local/r-77239/bin/R /usr/local/bin
