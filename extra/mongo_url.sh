#!/bin/bash
#
# If MONGO_URL is not specified, try the following in order:
#
# - MONGODB_URI: current default for mongolab addon
# - MONGOLAB_URI: old default for mongolab addon
# - MONGOHQ_URL: old default for mongohq addon
#
echo "-----> Adding profile script to resolve MONGO_URL from mongolab addon"
cat > "$APP_CHECKOUT_DIR"/.profile.d/mongo_url.sh <<EOF
  #!/bin/bash
  if [ -z \$MONGO_URL ] ; then
    export MONGO_URL=\${MONGODB_URI:-\${MONGODB_URI:-\$MONGOHQ_URL}}
  fi
  if [ -z \$MONGO_URL ] ; then
    echo "meteor-buildpack-horse: MONGO_URL missing, you must define it for meteor to work."
  fi
  if [ -z \$MONGO_OPLOG_URL ] ; then
    export MONGO_OPLOG_URL=\${MONGODB_OPLOG_URL:-\${MONGODB_OPLOG_URL:-\$MONGOHQ_OPLOG_URL}}
  fi
  if [ -z \$MONGO_OPLOG_URL ] ; then
    echo "meteor-buildpack-horse: MONGO_OPLOG_URL missing, you must define it for meteor to be happy."
  fi
EOF
# Execute script to echo error if MONGO_URL is undefined.
/bin/bash "$APP_CHECKOUT_DIR"/.profile.d/mongo_url.sh
