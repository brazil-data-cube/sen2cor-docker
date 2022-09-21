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


# Sen2cor

Sentinel-2 Sen2cor (2.5.5) atmospheric correction.

## Dependencies

- Docker


## Sen2cor 2.5.5 Parameters
Sen2cor parameters can be changed by modifing the /2.5/cfg/L2A_GIPP.xml file and mounting it (-v /path/to/sen2cor/2.5/cfg:/root/sen2cor/2.5/cfg).
If you wish to use sen2cor default parameters, don't mount the parameters folder.

More info regarding Sen2Cor can be found on its Configuration and User Manual (http://step.esa.int/thirdparties/sen2cor/2.5.5/docs/S2-PDGS-MPC-L2A-SRN-V2.5.5.pdf).


## Downloading Sen2cor auxiliarie files:
  Download from http://maps.elie.ucl.ac.be/CCI/viewer/download.php (fill info on the right and download "ESACCI-LC for Sen2Cor data package")
  extract the downloaded file and the files within. It will contain two files and one directory:

  Example on Ubuntu (Linux) installation:

    $ ls home/user/sen2cor/CCI4SEN2COR

  ESACCI-LC-L4-LCCS-Map-300m-P1Y-2015-v2.0.7.tif

  ESACCI-LC-L4-Snow-Cond-500m-P13Y7D-2000-2012-v2.0

  ESACCI-LC-L4-WB-Map-150m-P13Y-2000-v4.0.tif


## Installation

1. Run

   ```bash
   $ docker build -t sen2cor:2.5.5 .
   ```

   from the root of this repository.

## Usage


To process a Sentinel-2 scene, using Sen2cor default parameters, run:

```bash
    $ docker run --rm \
    -v /path/to/CCI4SEN2COR:/home/lib/python2.7/site-packages/sen2cor/aux_data \
    -v /path/to/folder/containing/.SAFEfile:/mnt/input-dir \
    -v /path/to/output:/mnt/output-dir:rw \
    sen2cor:2.5.5 yourFile.SAFE
```

To process a Sentinel-2 scene, changing Sen2cor parameters, e.g. disable terrain correction, configure the /2.5/cfg/L2A_GIPP.xml and run mounting it as:

```bash
    $ docker run --rm \
    -v /path/to/CCI4SEN2COR:/home/lib/python2.7/site-packages/sen2cor/aux_data \
    -v /path/to/sen2cor/2.5/cfg:/root/sen2cor/2.5/cfg \
    -v /path/to/folder/containing/.SAFEfile:/mnt/input-dir \
    -v /path/to/output:/mnt/output-dir:rw \
    sen2cor:2.5.5 yourFile.SAFE
```

Results are written on mounted `/mnt/output-dir/`.
