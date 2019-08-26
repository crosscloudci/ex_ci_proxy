FROM crosscloudci/ciproxy-deps:latest
MAINTAINER "W Watson <w.watson@vulk.coop>"

# CMD ["/bin/bash"]

COPY . /ciproxy
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY Dockerfiles/dev.secret.exs /ciproxy/config/dev.secret.exs

WORKDIR /ciproxy

RUN mix local.hex --force &&  \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile

# RUN bundle install --gemfile /backend/lib/gitlab/Gemfile

EXPOSE 4001

# RUN mix register_plugin.build.deps

RUN mix register_plugins.build.deps
RUN go version
RUN mix register_plugins.build

ENTRYPOINT ["/entrypoint.sh"]
