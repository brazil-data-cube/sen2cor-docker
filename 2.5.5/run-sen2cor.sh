#!/bin/bash
#
# This file is part of Brazil Data Cube Sen2cor Docker.
# Copyright (C) 2022 INPE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.
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