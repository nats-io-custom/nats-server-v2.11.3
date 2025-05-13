# NATS-SERVER-V2.11.3

This is a simple Dockerfile wrapper around the generic [nats-server](https://github.com/nats-io/nats-server). There are many reasons we have this wrapper:

1. From time-to-time we need to replace a few files and build our own `nats-server` binary. This repo supports an overlay/rebuild/swap pattern to do this.

2. Wrapping allows us to control release timing.

# How this works

If there are files in the `overlay` folder, the CI scripts will:

1. `git clone git@github.com:nats-io/nats-server.git`
2. Copy everything in `overlay/*` on top of the cloned repo

If the above produces a `nats-server` binary, then our `Dockerfile` will overwrite the original `nats-server` binary with the one we just produced.
