if [ "$ERLANG_COOKIE" = "" ]
then
    echo "environment variable ERLANG_COOKIE, should be set by secret configuration."
    exit 1;
fi