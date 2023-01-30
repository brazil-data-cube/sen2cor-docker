#
# This file is part of Brazil Data Cube Sen2cor Docker.
# Copyright (C) 2023 INPE.
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

# Base image
ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}

# Image metadata
LABEL "org.brazildatacube.maintainer"="Brazil Data Cube <brazildatacube@inpe.br>"
LABEL "org.brazildatacube.title"="Docker image for Sen2Cor"
LABEL "org.brazildatacube.description"="Software environment \
for Sentinel-2 Level 2A product generation and formatting."

# Build arguments
ARG SEN2COR_VERSION="2.11.0"
ARG SEN2COR_INSTALLER_NAME="Sen2Cor-02.11.00-Linux64.run"
ARG SEN2COR_INSTALLER_URL="http://step.esa.int/thirdparties/sen2cor/${SEN2COR_VERSION}/${SEN2COR_INSTALLER_NAME}"
ARG SEN2COR_INSTALLER_DIR="/tmp/"
ARG SEN2COR_INSTALL_PATH="/opt/sen2cor/${SEN2COR_VERSION}"

# Update package list and install required packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y unzip file && \
    rm -rf /var/lib/apt/lists/*

# Copy Sen2Cor installer to a temporary directory
ADD ${SEN2COR_INSTALLER_URL} ${SEN2COR_INSTALLER_DIR}

# Install Sen2Cor
RUN chmod +x ${SEN2COR_INSTALLER_DIR}/${SEN2COR_INSTALLER_NAME} && \
    bash ${SEN2COR_INSTALLER_DIR}/${SEN2COR_INSTALLER_NAME} --target ${SEN2COR_INSTALL_PATH} --nox11 && \
    mkdir ${SEN2COR_INSTALL_PATH}/cfg && \
    cp /root/sen2cor/2.11/cfg/L2A_GIPP.xml ${SEN2COR_INSTALL_PATH}/cfg/ && \
    rm ${SEN2COR_INSTALLER_DIR}/${SEN2COR_INSTALLER_NAME}

# Make Sen2Cor directory the current one
WORKDIR ${SEN2COR_INSTALL_PATH}

# Environment Variables
ENV SEN2COR_INPUT_DIR /mnt/input-dir
ENV SEN2COR_OUTPUT_DIR /mnt/output-dir
ENV SEN2COR_INSTALL_PATH ${SEN2COR_INSTALL_PATH}
ENV SEN2COR_CCI4SEN2COR ${SEN2COR_INSTALL_PATH}/lib/python2.7/site-packages/sen2cor/aux_data
ENV SEN2COR_GIP_L2A ${SEN2COR_INSTALL_PATH}/cfg/L2A_GIPP.xml

# Copy and install Docker entry point
ADD run-sen2cor.sh ${SEN2COR_INSTALL_PATH}/bin/run-sen2cor.sh

# Create Symbolic links to Sen2cor auxiliary files
RUN ln -s /mnt/aux_data/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif ${SEN2COR_CCI4SEN2COR}/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif && \
    ln -s /mnt/aux_data/ESACCI-LC-L4-WB-Map-150m-P13Y-2000-v4.0.tif ${SEN2COR_CCI4SEN2COR}/ESACCI-LC-L4-WB-Map-150m-P13Y-2000-v4.0.tif && \
    ln -s /mnt/aux_data/ESACCI-LC-L4-Snow-Cond-500m-P13Y7D-2000-2012-v2.0 ${SEN2COR_CCI4SEN2COR}/ESACCI-LC-L4-Snow-Cond-500m-P13Y7D-2000-2012-v2.0

ENTRYPOINT ["./bin/run-sen2cor.sh"]

CMD ["--help"]