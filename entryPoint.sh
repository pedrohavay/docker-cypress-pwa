#!/bin/bash

export CURRENT_DATE="$(cat /build-timestamp)"
exec "$@"