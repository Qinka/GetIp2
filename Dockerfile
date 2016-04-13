FROM index.docker.io/library/haskell:7.10.3
MAINTAINER qinka
ADD . /src
RUN cd /src && cabal sandbox init
RUN cd /src && cabal update && cabal install -j9 text yesod stm
RUN cd /src && cabal install
RUN cp /src/.cabal-sandbox/bin/* /usr/bin
RUN rm -r src
EXPOSE 3000
CMD getip
