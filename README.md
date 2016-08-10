# Honeywell

[![Build Status](https://travis-ci.org/jeffutter/honeywell-elixir.svg?branch=master)](https://travis-ci.org/jeffutter/honeywell-elixir)
[![Hex.pm](https://img.shields.io/hexpm/v/honeywell.svg?maxAge=2592000)](https://hex.pm/packages/honeywell)
[![Inline docs](http://inch-ci.org/github/jeffutter/honeywell-elixir.svg)](http://inch-ci.org/github/jeffutter/honeywell-elixir)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/jeffutter/honeywell-elixir.svg)](https://beta.hexfaktor.org/github/jeffutter/honeywell-elixir)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

Honeywell Cloud API Client for Elixir:

This is an unofficial client for the [Honeywell Round and Water Leak & Freeze Detector APIs](https://developer.honeywell.com/). 

## Usage

Installation

```elixir
def deps do
  [{:honeywell, "~> 0.1.0"}]
end
```

and run `mix deps.get`. Now, list the :honeywell application as your application dependency:

```elixir
def application do
  [applications: [:honeywell]]
end
```

## Configuration

You will need to set the following configuration variables in your `config/config.exs` file:

```elixir
use Mix.Config

config :honeywell,
  client_id: System.get_env("HONEYWELL_CLIENT_ID"),
  client_secret: System.get_env("HONEYWELL_CLIENT_SECRET"),
  site: System.get_env("SITE"),
  redirect_uri: System.get_env("HONEYWELL_REDIRECT_URL")
```
