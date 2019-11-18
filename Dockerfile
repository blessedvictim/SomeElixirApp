FROM elixir:latest
RUN mix local.hex --force && mix local.rebar --force
RUN mix archive.install hex phx_new 1.4.11 --force
ADD . /elixirapp/
WORKDIR /elixirapp
RUN mix deps.get --only prod