# Flywheel gear that implements FSL's slicer command

This gear implements a basic usage of [FSL SLICER](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Miscvis) (does not include all command options). Takes 3D images and produces 2D pictures of slices within these files. Outputs "sliced_image.png".

### Inputs

* input: nifti file to slice

### Configuration

* mid_slices: output mid-sagittal, -coronal and -axial slices into one image.