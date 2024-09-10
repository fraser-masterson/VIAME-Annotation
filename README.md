# VIAME-Annotator v1
Annotates pre-existing geometries in VIAME to include measurement data

This code was originally created to expedite annotation work for an AI project that requires the lengths, widths and aperture sizes of whelk shells to be measured. It reads the rectangular borders around the various line measurements of each shell, and deduces whether or not they overlap and belong to the same individual. 

The rectangle's borders are defined by two sets of coordinates:
 - Top left x (in code: '4-7: Img-bbox(TL_x') and top left y (in code: 'TL_y')
 - Bottom right x (in code: 'BR_x') and bottom right y (in code: 'BR_y)')

If the current rectangle's borders overlap with the previous rectangle, the current rectangle' ID number becomes the same as the previous rectangle's ID. If the current rectangle does not overlap with the previous rectangle, it is labelled as 'x+y', with x representing the first individual's ID number, and y reoresenting the amount of groups that have been categorised prior to the current grouping. This cycle restarts at every new frame or image.

Due to the nature of this code, the ID numbers that are output from the code are reliant on the order in which the individuals are annotated in the frame.

In the original code - following grouping, the code refers to an index file that houses the known measurements of each whelk. By matching the whelk number to the respective whelk number in the index, the rectangles are labelled with the correct measurements depending on their order of annotation:
 - First rectangle in group: labelled as 'Whelk_total_shell_length_mm'
 - Second rectangle in group: labelled as 'Whelk_width_mm'
 - Third rectangle in group (if present): labelled as 'Whelk_aperture'



