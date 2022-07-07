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

if [ ${1} == "--help" ]; then
    echo "Usage: \
    docker run --rm \
    -v /path/to/input-dir/:/mnt/input-dir \
    -v /path/to/output-dir:/mnt/output-dir \
    -v /path/to/CCI4SEN2COR:/mnt/sen2cor-aux/CCI4SEN2COR \
    -v /path/to/L2A_GIPP.xml:${SEN2COR_INSTALL_PATH}/cfg/L2A_GIPP.xml \
    -v /path/to/srtm:/mnt/sen2cor-aux/srtm \
    brazildatacube/sen2cor:2.8.0 <SENTINEL-2_L1C.SAFE>"
    exit 0
fi

SAFENAME_L1C=$1
SAFEDIR_L1C=${SEN2COR_INPUT_DIR}/${SAFENAME_L1C}

if [[ ${SAFENAME_L1C} != *.SAFE ]] || [[ ${SAFENAME_L1C:4:6} != MSIL1C ]]; then
    echo "ERROR: Not valid Sentinel-2 L1C"
    exit 1
fi

# load Sen2Cor environment variables
source ${SEN2COR_INSTALL_PATH}/L2A_Bashrc

mkdir -p ${SEN2COR_OUTPUT_DIR}

L2A_Process --resolution 10 \
            --output_dir ${SEN2COR_OUTPUT_DIR} \
            --GIP_L2A ${SEN2COR_GIP_L2A} \
            ${SAFEDIR_L1C}

exit 0