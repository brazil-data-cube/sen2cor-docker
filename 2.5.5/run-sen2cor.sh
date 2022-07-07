#!/bin/bash
#
# This file is part of Sen2Cor Docker.
# Copyright (C) 2021-2022 INPE.
#
# Sen2cor Docker is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

set -e
shopt -s nullglob

if [[ ${1} == "--help" ]]; then
    echo "Usage: \
    docker run --rm \
    -v /path/to/input-dir/:/mnt/input-dir \
    -v /path/to/output-dir:/mnt/output-dir \
    -v /path/to/CCI4SEN2COR:/mnt/sen2cor-aux/CCI4SEN2COR \
    -v /path/to/L2A_GIPP.xml:${SEN2COR_INSTALL_PATH}/cfg/L2A_GIPP.xml \
    -v /path/to/srtm:/mnt/sen2cor-aux/srtm \
    brazildatacube/sen2cor:2.5.5 <SENTINEL-2_L1C.SAFE>"
    exit 0
fi

SAFENAME_L1C=$1
SAFEDIR_L1C=${SEN2COR_INPUT_DIR}/${SAFENAME_L1C}

if [[ ${SAFENAME_L1C} != *.SAFE ]] || [[ ${SAFENAME_L1C:4:6} != MSIL1C ]]; then
    echo "ERROR: Not valid Sentinel-2 L1C"
    exit 1
fi

# Create workdir
if [ -z "${WORKDIR}" ]; then
    WORKDIR=/mnt/work-dir/
fi
mkdir -p ${WORKDIR}

# Ensure that workdir/sceneid is clean
if [ -d "${WORKDIR}/${SAFENAME_L1C}" ]; then
    rm -r ${WORKDIR}/${SAFENAME_L1C}
fi

cp -r ${SAFEDIR_L1C} ${WORKDIR}

SAFENAME_L2A=${SAFENAME_L1C//L1C/L2A}

# load Sen2Cor environment variables
source ${SEN2COR_INSTALL_PATH}/L2A_Bashrc

L2A_Process --GIP_L2A ${SEN2COR_GIP_L2A} \
            ${WORKDIR}/${SAFENAME_L1C}


cp -r ${WORKDIR}/${SAFENAME_L2A} $SEN2COR_OUTPUT_DIR
rm -r $WORKDIR/${SAFENAME_L2A}
rm -r $WORKDIR/${SAFENAME_L1C}

exit 0