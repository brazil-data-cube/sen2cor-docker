#!/bin/bash
set -e
shopt -s nullglob
if [ $1 == "--help" ]; then
    echo "Usage: \
    docker run --rm \
    -v /path/to/input/:/mnt/input-dir \
    -v /path/to/output:/mnt/output-dir \
    -v /path/to/CCI4SEN2COR:/home/lib/python2.7/site-packages/sen2cor/aux_data \
    -v /path/to/sen2cor/2.5/cfg:/root/sen2cor/2.5/cfg \
    -t sen2cor:2.5.5 <SENTINEL-2.SAFE>"
    exit 0
fi

# Set default directories to the INDIR and OUTDIR
# You can customize it using INDIR=/my/custom OUTDIR=/my/out run_sen2cor_fmask.sh
if [ -z "${INDIR}" ]; then
    INDIR=/mnt/input-dir
fi

if [ -z "${OUTDIR}" ]; then
    OUTDIR=/mnt/output-dir/
fi

if [ -z "${WORKDIR}" ]; then
    WORKDIR=/mnt/work-dir/
fi
mkdir -p ${WORKDIR}

INPUT_PRODUCT=$1
shift
if [[ $INPUT_PRODUCT == *.SAFE ]]; then
    SAFENAME_L1C=$INPUT_PRODUCT
    SAFEDIR_L1C=${INDIR}/${SAFENAME_L1C}
elif [[ $INPUT_PRODUCT == *.zip ]]; then
    SAFENAME_L1C_="$(unzip -qql ${INDIR}/$INPUT_PRODUCT | head -n1 | tr -s ' ' | cut -d' ' -f5-)"
    SAFENAME_L1C="${SAFENAME_L1C_::-1}"
else
    echo "ERROR: Not valid Sentinel-2 L1C"
    exit 1
fi

# Ensure that workdir/sceneid is clean
if [ -d "${WORKDIR}/${SAFENAME_L1C}" ]; then
    rm -r ${WORKDIR}/${SAFENAME_L1C}
fi

#check if dir or .zip
if [[ $INPUT_PRODUCT == *.SAFE ]]; then
    cp -r ${SAFEDIR_L1C} ${WORKDIR}
elif [[ $INPUT_PRODUCT == *.zip ]]; then
    unzip ${INDIR}/$INPUT_PRODUCT -d ${WORKDIR}
fi

## SENTINEL-2
SAFENAME_L2A=${SAFENAME_L1C//L1C/L2A}
SAFENAME_L2A=${SAFENAME_L2A::45}
SAFEDIR_L1C=${INDIR}/${SAFENAME_L1C}

# Prepare Sen2cor parameters
if [ $# -ne 0 ]
  then
    python3 /usr/local/bin/change-sen2cor-meta.py /root/sen2cor/2.5/cfg/L2A_GIPP.xml $@
fi

# Process Sen2cor
cd ${WORKDIR}
/home/bin/L2A_Process --resolution 10 ${SAFENAME_L1C}

for entry in `ls ${WORKDIR}`; do
    if [[ $entry == "$SAFENAME_L2A"* ]]; then
        SAFENAME_L2A=$entry
    fi
done

cp -r ${WORKDIR}/${SAFENAME_L2A} $OUTDIR
rm -r $WORKDIR/${SAFENAME_L2A}
rm -r $WORKDIR/${SAFENAME_L1C}
exit 0
