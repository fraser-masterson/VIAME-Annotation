# VIAME-Annotator v1
Annotates pre-existing geometries in VIAME to include measurement data

## Models and Data
This code was originally created to expedite annotation work for an AI project that requires the lengths, widths and aperture sizes of whelk shells to be measured. It reads the rectangular borders around various line measurements of each shell, and groups those that overlap and belong to the same individual. 

# Using the Annotator

## Prerequisites
- R 4.0 or higher

## Setting Up the Environment (Whelk Shells)
1. Complete basic annotation of whelk shells on VIAME using the linestring tool, drawing lines for the shells' length, width, and aperture size (be sure to maintain that order). Complete all frames in the video. Ensure no labelling/data entry has been performed.

![image](https://github.com/user-attachments/assets/a85141b5-db06-40fe-ab5a-7200dc270267)

3. Once completed, download the file as a .csv from VIAME's 'Download media and annotations' dropdown.
4. In R, copy the file's directory into the 'data' and 'header' lines:
```{r}
library(dplyr)
setwd("WORKING-DIRECTORY")
data = read.csv("VIAME-FILENAME.csv", skip = 2, header = TRUE)
header = read.csv("VIAME-FILENAME.csv", nrows = 1, header = FALSE, stringsAsFactors = FALSE)
colnames(data) <- header
```
4. Create a .csv file that contains the ID numbers of the individual whelk, along with their respective total length, width, and aperture measurements in the following format:
```{r}
Whelk number | Total_length | Aperture_Length | Width
```
5. Import this .csv file into R under the name 'index':
```{r}
index = read.csv("INDEX-FILENAME.csv")
index$Whelk.number = paste("Whelk", index$Whelk.number, sep = "_")
```
6. Set the desired output file name at the end of the code:
```{r}
write.csv(data, "OUTPUT-FILENAME.csv", row.names = FALSE)
```
7. Set the 'group_id' object so that it is 1 below the first ID in your sample (e.g., our whelk IDs were 6-20, so 'group_id' was set to 5).
8. Run the main code.
9. Import the output .csv file back into VIAME, the annotations should now be grouped and labelled with respective measurements.

![image](https://github.com/user-attachments/assets/4ace744a-6b9a-4207-af88-3f2f83d69b4e)
![image](https://github.com/user-attachments/assets/483cd1a4-eb09-4db2-b77f-da04ac25bc9a)
![image](https://github.com/user-attachments/assets/a1f28d6a-64c1-437c-bafd-031d800b3900)
![image](https://github.com/user-attachments/assets/ae6aa522-abff-4ff4-80c4-98c30efb63fe)


## Additional Notes and Further Info:

The rectangle's borders are defined by two sets of coordinates:
 - Top left x (in code: '4-7: Img-bbox(TL_x') and top left y (in code: 'TL_y')
 - Bottom right x (in code: 'BR_x') and bottom right y (in code: 'BR_y)')

If the current rectangle's borders overlap with the previous rectangle, the current rectangle' ID number becomes the same as the previous rectangle's ID. If the current rectangle does not overlap with the previous rectangle, it is labelled as 'x+y', with x representing the first individual's ID number, and y reoresenting the amount of groups that have been categorised prior to the current grouping. This cycle restarts at every new frame or image.

Due to the nature of this code, the ID numbers that are output from the code are reliant on the order in which the individuals are annotated in the frame.

In the original code - following grouping, the code refers to an index file that houses the known measurements of each whelk. By matching the whelk number to the respective whelk number in the index, the rectangles are labelled with the correct measurements depending on their order of annotation:
 - First rectangle in group: labelled as 'Whelk_total_shell_length_mm'
 - Second rectangle in group: labelled as 'Whelk_width_mm'
 - Third rectangle in group (if present): labelled as 'Whelk_aperture'



