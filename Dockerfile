# ./Dockerfile

# Extend from the official Elixir image
FROM qixxit/elixir-centos:latest
ENV LOCATION=docker

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile
RUN mix release

CMD ["_build/dev/rel/ingress/bin/ingress", "foreground"]