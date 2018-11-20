#!/usr/bin/env bash

helm repo update
helm install stable/cockroachdb --version 2.0.5 --name mycockroach