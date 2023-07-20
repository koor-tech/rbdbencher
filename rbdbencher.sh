#!/usr/bin/env bash

set -ex

RBD_POOL_NAME="${RBD_POOL_NAME:-}"
RBD_IMAGE_NAME_PREFIX="${RBD_IMAGE_NAME_PREFIX:-testimage}"

# Create test image
rbd create -p "${RBD_POOL_NAME}" --size=10G "${RBD_IMAGE_NAME_PREFIX}1"

# Sequential testsbash
IO_TYPES=( read write readwrite )
IO_SIZES=( 128 256 512 1024 2048 4096 8192 )
IO_THREADS=( 8 16 32 64 128 256 )
IO_TOTALS=( 512M 1G 4G 8G 10G )
IO_PATTERNS=( rand seq)

for IO_TYPE in "${IO_TYPES[@]}"; do
    for IO_SIZE in "${IO_SIZES[@]}"; do
        for IO_THREAD in "${IO_THREADS[@]}"; do
            for IO_TOTAL in "${IO_TOTALS[@]}"; do
                for IO_PATTERN in "${IO_PATTERNS[@]}"; do
                    rbd bench \
                        "${RBD_IMAGE_NAME_PREFIX}1" \
                        -p "${RBD_POOL_NAME}" \
                        --io-type "$IO_TYPE" \
                        --io-size "$IO_SIZE" \
                        --io-threads "$IO_THREAD" \
                        --io-total "$IO_TOTAL" \
                        --io-pattern "$IO_PATTERN"
                done
            done
        done
    done
done
