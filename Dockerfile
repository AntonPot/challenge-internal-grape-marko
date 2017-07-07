FROM renra/ruby-node-postgres:ruby2.4.1-node8.1.2-postgres9.4.12

ENV dir /usr/src/app

RUN mkdir -p ${dir}
WORKDIR ${dir}

COPY . ${dir}

RUN gem install bundler && bundle install -j4
RUN gem cleanup
