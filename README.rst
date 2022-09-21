..
    This file is part of Brazil Data Cube Sen2cor Docker.
    Copyright (C) 2022 INPE.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.


Docker Support for Sen2Cor
==========================


.. image:: https://img.shields.io/badge/License-GPLv3-blue.svg
        :target: https://github.com/brazil-data-cube/sen2cor-docker/blob/master/LICENSE
        :alt: Software License


.. image:: https://img.shields.io/badge/lifecycle-experimental-orange.svg
        :target: https://www.tidyverse.org/lifecycle/#experimental
        :alt: Software Life Cycle


About
-----


Sen2Cor is a processor for Sentinel-2 Level 2A product generation and formatting. The detailed information about this software can be found in `Configuration and User Manual <http://step.esa.int/thirdparties/sen2cor/2.9.0/docs/S2-PDGS-MPC-L2A-SUM-V2.9.0.pdf>`_.


Image Build Dependencies
------------------------


In order to build the Docker image you should have `Docker <https://docs.docker.com/>`_ installed. Please, refer to the official documentation section `Install Docker Engine <https://docs.docker.com/engine/install/>`_ if you do not have it installed.


Image Build
-----------


You can create docker images for Sen2Cor version 2.5.5, 2.8.0, or 2.9.0. If you intend to build the 2.9.0 version, go to the folder named 2.9.0 and build the image with the following command::

    cd 2.9.0

    docker build  --no-cache --tag brazildatacube/sen2cor:2.9.0 .


.. note::

    If you have the file ``Sen2Cor-02.09.00-Linux64.run`` in the ``2.9.0`` folder, you can add the following option to the build args::

        --build-arg SEN2COR_INSTALLER_URL=Sen2Cor-02.09.00-Linux64.run



Auxiliary Files for Running Sen2Cor
-----------------------------------


Sen2Cor cloud screening and classification modules depend on `ESACCI-LC for Sen2Cor data package <http://maps.elie.ucl.ac.be/CCI/viewer/download.php>`_. Please, download the package named ``ESACCI-LC-L4-ALL-FOR-SEN2COR.zip``. After downloading and extracting the package, you should have a folder named CCI4SEn2COR with the following content:

- ``ESACCI-LC-L4-Snow-Cond-500m-P13Y7D-2000-2012-v2.0`` (directory).

- ``ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif`` (GeoTIFF file).

- ``ESACCI-LC-L4-WB-Map-150m-P13Y-2000-v4.0.tif`` (GeoTIFF file).


Running
-------


You can create a temporary container that runs Sen2Cor with the following command::

    docker run --rm \
               --volume /path/to/input_dir:/mnt/input-dir:ro \
               --volume /path/to/output_dir:/mnt/output-dir:rw \
               --volume /path/to/CCI4SEN2COR:/mnt/sen2cor-aux/CCI4SEN2COR \
               --volume /path/to/L2A_GIPP.xml:/opt/sen2cor/2.9.0/cfg/L2A_GIPP.xml \
               --volume /path/to/srtm:/mnt/sen2cor-aux/srtm:rw \
               brazildatacube/sen2cor:2.9.0 S2A_MSIL1C_20210903T140021_N0301_R067_T21KVR_20210903T172609.SAFE


.. note::

    The lines binding the ``SRTM`` images directory and the ``L2A_GIPP.xml`` file are not mandatory.
