#!/usr/bin/env bash 

IMAGE=chop.flywheel.io/fsl-slicer:0.1.0

# Command:
docker run -u 0:0 -v \
	/Users/familiara/Documents/dev_processing/fw_gears/fw-fsl-slicer/input:/flywheel/v0/input \
	-v \
	/Users/familiara/Documents/dev_processing/fw_gears/fw-fsl-slicer/output:/flywheel/v0/output \
	-v \
	/Users/familiara/Documents/dev_processing/fw_gears/fw-fsl-slicer/work:/flywheel/v0/work \
	-v \
	/Users/familiara/Documents/dev_processing/fw_gears/fw-fsl-slicer/config.json:/flywheel/v0/config.json \
	-v \
	/Users/familiara/Documents/dev_processing/fw_gears/fw-fsl-slicer/manifest.json:/flywheel/v0/manifest.json \
	-e FLYWHEEL='/flywheel/v0' -e FSLDIR='/usr/share/fsl/6.0' -e FSLMULTIFILEQUIT='TRUE' -e \
	FSLOUTPUTTYPE='NIFTI_GZ' -e FSLTCLSH='/usr/bin/tclsh' -e FSLWISH='/usr/bin/wish' -e \
	FSL_DIR='/usr/share/fsl/6.0' -e LD_LIBRARY_PATH='/usr/share/fsl/6.0/lib:' -e \
	PATH='/usr/share/fsl/6.0/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
	-e POSSUMDIR='/usr/share/fsl/6.0/' -e PWD='/flywheel/v0' \
	$IMAGE \
