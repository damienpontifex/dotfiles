#!/usr/bin/env bash

TAVILY_API_KEY=$(security find-generic-password -a "$USER" -s MY_SECRET -w 2>/dev/null || true)
export TAVILY_API_KEY
