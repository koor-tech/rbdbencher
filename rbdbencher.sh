#!/usr/bin/env bash

set -ex

RBD_POOL_NAME="${RBD_POOL_NAME:-}"
RBD_IMAGE_NAME_PREFIX="${RBD_IMAGE_NAME_PREFIX:-testimage}"
WAIT_AFTER_TEST="${WAIT_AFTER_TEST:-10}"

if [ -z ${RBD_POOL_NAME+x} ]; then
    echo "RBD_POOL_NAME env var is unset. Please set it to the pool name you want to test."
    exit 2
fi

DIR="rbdbencher-$(date '%Y-%m-%d %H:%M:%S')"
echo "$(date '%Y-%m-%d %H:%M:%S'): Creating test results dir at $DIR ..."
mkdir -p "$DIR"
cd "$DIR" || { echo "$(date '%Y-%m-%d %H:%M:%S'): Unable to enter test results dir $DIR"; exit 1; }

# Create test image
rbd create -p "${RBD_POOL_NAME}" --size=10G "${RBD_IMAGE_NAME_PREFIX}1"

# Sequential testsbash
IO_TYPES=( read write readwrite )
IO_SIZES=( 128 256 512 1024 2048 4096 )
IO_THREADS=( 8 16 32 64 128 256 )
IO_TOTALS=( 512M 1G 4G 8G 10G )
IO_PATTERNS=( rand seq)

for IO_TYPE in "${IO_TYPES[@]}"; do
    for IO_SIZE in "${IO_SIZES[@]}"; do
        for IO_THREAD in "${IO_THREADS[@]}"; do
            for IO_TOTAL in "${IO_TOTALS[@]}"; do
                for IO_PATTERN in "${IO_PATTERNS[@]}"; do
                    OUT_FILE=rbd-bench-iotype-"$IO_TYPE"-iosize-"$IO_SIZE"-iothread-"$IO_THREAD"-iototal-"$IO_TOTAL"-iopattern-"$IO_PATTERN".txt
                    echo "$(date '%Y-%m-%d %H:%M:%S'): Running rbd bench, storing results in $OUT_FILE ..."
                    rbd bench \
                        "${RBD_IMAGE_NAME_PREFIX}1" \
                        -p "${RBD_POOL_NAME}" \
                        --io-type "$IO_TYPE" \
                        --io-size "$IO_SIZE" \
                        --io-threads "$IO_THREAD" \
                        --io-total "$IO_TOTAL" \
                        --io-pattern "$IO_PATTERN" \
                            > "$OUT_FILE"
                    echo "$(date '%Y-%m-%d %H:%M:%S'): rbd bench test complete. Sleeping ${WAIT_AFTER_TEST}s before continuing ..."
		            sleep "$WAIT_AFTER_TEST"
                done
            done
        done
    done
done

echo "$(date '%Y-%m-%d %H:%M:%S'): rbd bencher completed all runs."
