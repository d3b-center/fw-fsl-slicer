#####################################################################

#Required : $1 -  .nii from which creates a 4x6 montage.
#Required : $2 -  output file path for the montage png.
#Optional:
#   $3 - Bottom slice to include. Default 0.
#   $4 - Top slice to include.  Default max_slice.
#Christopher Benjamin May 13 2018


#####################################################################

## Specify inputs.

#####################################################################

image_to_slice=$1
output_file_path=$2

#Count the number of slices in your image
number_of_slices=`fslval $image_to_slice dim3`

#Specify the upper and lower-most slices you want to cut.
if [ -z $3 ] ; then
  slice_bottom=0;               #Slice you will start slicing from
else
  slice_bottom=$3;
fi
if [ -z $4 ] ; then
  slice_top=$number_of_slices;  #Slice you will stop slicing at
else
  slice_top=$4;
fi

#Calculate the number of actual slices of brain you want to slice from.
dead_space_above_brain=`echo "$number_of_slices-$slice_top" | bc -l`
n_slices_of_actual_brain=`echo "$number_of_slices-$slice_bottom-$dead_space_above_brain" | bc -l`

#Calculate the max spacing necessary to allow 24 slices to be cut
# let slice_increment=($n_slices_of_actual_brain+24-1)/24
let slice_increment=2


#####################################################################

## Run loop to slice and stitch montage

#####################################################################

count=1
col_count=7
row=0

#Slice the image.
for (( N = $slice_bottom; N <= $slice_top; N += $slice_increment )); do
  echo "Processing slice $N / $number_of_slices"
  FRAC=$(echo "scale=2; $N / $number_of_slices" | bc -l);
  slicer "$image_to_slice" -L -z $FRAC "${image_to_slice}_$count.png";

  #Add current image to a row.
  #If you have the first image of a new row (i.e., column 7), create new row
  if [[ $col_count == 7 ]] ; then
    row=$(echo "${row}+1" | bc -l);
    mv "${image_to_slice}_$count.png" montage_row$row.png
    col_count=2;
    just_started_a_new_row=1;
  #Otherwise, append your image to the existing row.
  else
    pngappend montage_row$row.png + "${image_to_slice}_$count.png" montage_row$row.png
    col_count=$(echo "${col_count}+1" | bc -l);
    just_started_a_new_row=0;
    rm "${image_to_slice}_$count.png"
  fi
  count=$(echo "${count}+1" | bc -l);
done

#####################################################################

## Stitch your rows into a single montage

#####################################################################

label=`basename $image_to_slice .nii.gz`

for ((row_num=1; row_num<=row; row_num++)) ; do # row = last row number
  if [[ $row_num == 1 ]] ; then
    mv montage_row1.png montage-$label.png
  else
    pngappend montage-$label.png - montage_row${row_num}.png montage-$label.png
  fi
done
rm montage_row*

mv montage-$label.png $output_file_path
