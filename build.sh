#!/usr/bin/env bash

mvn clean verify
mvn -Pdist
cp target/brxm-cockroachdb-0.1.0-SNAPSHOT-distribution.tar.gz kubernetes/cms-site
docker build -t dev/brxm-cockroachdb:v1 kubernetes/cms-site
