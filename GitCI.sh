#!/bin/bash

function run {
# how we want to extract the variables from the commit message.
format_name="--format=%cn"
format_when="--format=%cr"
format_summary="--format=%s"
format_body="--format=%b"

# what repository do we want to watch (default to origin/master)
if [ -z "$1" ]; then
	repository="origin/master"
else
	repository="$1"
fi
# handle Exits
cleanup ()
{
kill -s SIGTERM $!
exit 0
}

trap cleanup SIGINT SIGTERM
# loop forever, need to kill the process.
while [ 1 ]; do

    # get the latest revision SHA.
    latest_revision="git rev-parse origin/master"
    #Get latest local revision
    current_revision="git rev-parse HEAD"

    # if we haven't seen that one yet, then we know there's new stuff.
    if [ $latest_revision != $current_revision ]; then
        #Fetch and Merge Changes
        git pull
        # mark the newest revision as seen.
        latest_revision=$current_revision
        # extract the details from the log.
        commit_name=`git log -1 $format_name $latest_revision`
        commit_when=`git log -1 $format_when $latest_revision`
        commit_summary=`git log -1 $format_summary $latest_revision`
        commit_body=`git log -1 $format_body $latest_revision`

        # notify the user of the commit.
        summary="$commit_name committed to $repository $commit_when!"
        body="$commit_summary\n\n$commit_body"

    fi
    echo 'no updates :)'
    sleep 60
done
}

if git rev-parse --git-dir > /dev/null 2>&1; then
	(run $1 &)
else
	echo "Error: not a git repository"
fi