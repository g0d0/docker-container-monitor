#!/bin/env bash

usage() { echo "Usage: $0 [-h <hours>] [-r <rate_in_seconds>] [-f <docker_stats_format>] [-o <output_file>] [-c <container_name>]" 1>&2; exit 1; }

TOTAL_TIME_SPENT='5 minute'

# SLEEP BASH COMMAND
#
# s for seconds (the default)
# m for minutes.
# h for hours.
# d for days.
#
# Reference: https://www.cyberciti.biz/faq/linux-unix-sleep-bash-scripting/
RATE_TIME='2s'

CONTAINER_NAME=''

# DOCKER STATS FORMATTING
#
# .Container	Container name or ID (user input)
# .Name	Container name
# .ID	Container ID
# .CPUPerc	CPU percentage
# .MemUsage	Memory usage
# .NetIO	Network IO
# .BlockIO	Block IO
# .MemPerc	Memory percentage (Not available on Windows)
# .PIDs	Number of PIDs (Not available on Windows)
#
# Reference: https://docs.docker.com/engine/reference/commandline/stats/#formatting

DOCKER_STATS_FORMAT="{{.Container}},{{.CPUPerc}}"

while getopts "h:r:f:o:c:" argument; do
    case "${argument}" in
        h)
            TOTAL_TIME_SPENT=${OPTARG}
            ;;
        r)
            RATE_TIME=${OPTARG}
            ;;
        f)
            DOCKER_STATS_FORMAT=${OPTARG}
            ;;
        o)
            FILE=${OPTARG}
            ;;
        c)
            CONTAINER_NAME=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

FORMATTED_START_TIME=$(date +'%F %H:%M:%S')
FORMATTED_END_TIME=$(date -d '+'"$TOTAL_TIME_SPENT" +'%F %H:%M:%S')

echo -en "Monitoring docker container ${CONTAINER_NAME}"
echo -en "\nRate time ${RATE_TIME}"
echo -en "\nStarted at: ${FORMATTED_START_TIME}"
echo -en "\nEnds at: ${FORMATTED_END_TIME}"
echo -en "\nTotal time: ${TOTAL_TIME_SPENT}\n\n"

START_TIME=$(date +%s)
END_TIME=$(date -d '+'"$TOTAL_TIME_SPENT" '+%s')

while [ $START_TIME -lt $END_TIME ]
do
    START_TIME=$(date +%s)

    echo -en "\n"$(date +'%F,%H:%M:%S')","$(docker stats --no-stream --format "${DOCKER_STATS_FORMAT}" "${CONTAINER_NAME}") >> $FILE
    sleep ${RATE_TIME}
done

echo 'Finished at: ' $(date +'%F %H:%M:%S')
