#!/bin/bash

GITHUB_ORGANIZATION=$1
GITHUB_REPO=$2
VERSION=$3
GITHUB_TOKEN=$4

RELEASE_NAME="release-ranger-${VERSION}-arm64"

release=$(curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    --data "{\"tag_name\": \"$RELEASE_NAME\", \"target_commitish\": \"$RELEASE_NAME\", \"name\": \"$RELEASE_NAME\", \"draft\": false }" \
    https://api.github.com/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases)

id=$(echo "$release" | sed -n -e 's/"id":\ \([0-9]\+\),/\1/p' | head -n 1 | sed 's/[[:blank:]]//g')

files=( \
    ranger-$VERSION-admin.tar.gz \
    ranger-$VERSION-atlas-plugin.tar.gz \
    ranger-$VERSION-elasticsearch-plugin.tar.gz \
    ranger-$VERSION-hbase-plugin.tar.gz \
    ranger-$VERSION-hdfs-plugin.tar.gz \
    ranger-$VERSION-hive-plugin.tar.gz \
    ranger-$VERSION-kafka-plugin.tar.gz \
    ranger-$VERSION-kms.tar.gz \
    ranger-$VERSION-knox-plugin.tar.gz \
    ranger-$VERSION-kylin-plugin.tar.gz \
    ranger-$VERSION-migration-util.tar.gz \
    ranger-$VERSION-ozone-plugin.tar.gz \
    ranger-$VERSION-presto-plugin.tar.gz \
    ranger-$VERSION-ranger-tools.tar.gz \
    ranger-$VERSION-solr_audit_conf.tar.gz \
    ranger-$VERSION-solr-plugin.tar.gz \
    ranger-$VERSION-sqoop-plugin.tar.gz \
    ranger-$VERSION-storm-plugin.tar.gz \
    ranger-$VERSION-tagsync.tar.gz \
    ranger-$VERSION-usersync.tar.gz \
    ranger-$VERSION-yarn-plugin.tar.gz \
)

for file in "${files[@]}"
do

    curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
        -H "Content-Type:application/octet-stream" \
        --data-binary @target/$file https://uploads.github.com/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases/$id/assets?name=$file
done
