
## Original whelk annotation code for VIAME
## This is specific to the data we were using and will require editing before wider use
## Index column format: ID, total length, aperture size, width
## Delete any pre-existing labels in VIAME before processing this code

## -------------------------------------------------------------------------------
## Author: Fraser Masterson; Wed Sep 4 13:41:22 2024

require(dplyr)

# Import .csv file from VIAME (download VIAME csv from website)
setwd("workingdirectory")
data = read.csv("VIAME_file.csv", skip = 2, header = TRUE)
header = read.csv("VIAME_file.csv", nrows = 1, header = FALSE, stringsAsFactors = FALSE)
colnames(data) <- header


index = read.csv("measurements.csv")

index$Whelk.number = paste("Whelk", index$Whelk.number, sep = "_")

## -------------------------------------------------------------------------------


# Remove pre-existing measurement data if present
for (i in 1:nrow(data)) {
  
  if (grepl('(atr)', data[i, 12]) == TRUE) {
    data[i, 12] = data[i, 13]
    data[i, 13] = data[i, 14]
  } 
  
  else if (grepl('(atr)', data[i, 12]) == FALSE) {
    data[i, 12] = data[i, 12]
  }
}

# Shift columns over by 1
data[14] = data[13]
data[13] = data[12]

data[12] = 0

# Convert columns to numeric
data$"4-7: Img-bbox(TL_x" <- as.numeric(data$"4-7: Img-bbox(TL_x")
data$TL_y <- as.numeric(data$TL_y)
data$BR_x <- as.numeric(data$BR_x)
data$"BR_y)" <- as.numeric(data$"BR_y)")


## -------------------------------------------------------------------------------


# Initialize groups
data$"10-11+: Repeated Species" <- NA
group_id <- 5 # Starting whelk number, if first whelk number is 1, call this 0

# Iterate over rows
for (i in 1:nrow(data)) {
  # Reset group_id when a new factor is encountered
  if (i > 1 && data[i, 2] != data[i-1, 2]) {
    group_id <- 5
  }
  
  # Extract bounding box coordinates for the current and previous rows
  x1_current <- c(data$"4-7: Img-bbox(TL_x"[i], data$BR_x[i])
  y1_current <- c(data$TL_y[i], data$"BR_y)"[i])
  x2_previous <- if (i > 1) c(data$"4-7: Img-bbox(TL_x"[i-1], data$BR_x[i-1]) else c(NA, NA)
  y2_previous <- if (i > 1) c(data$TL_y[i-1], data$"BR_y)"[i-1]) else c(NA, NA)
  
  # Check if there are no NA values in the necessary comparisons
  if (!any(is.na(c(x1_current, x2_previous, y1_current, y2_previous)))) {
    # Check for overlap with the previous row
    if (!(x1_current[1] > x2_previous[2] || x2_previous[1] > x1_current[2] ||
          y1_current[1] > y2_previous[2] || y2_previous[1] > y1_current[2])) {
      data[i, 10] <- data[i-1, 10]  # Same group as the previous row
    } else {
      # Increment group_id, but cap it at 20
      group_id <- min(group_id + 1, 20)
      data[i, 10] <- group_id
    }
  } else {
    # Increment group_id, but cap it at 20
    group_id <- min(group_id + 1, 20)
    data[i, 10] <- group_id
  }
}


data[12] = 0
data$"10-11+: Repeated Species" <- paste("Whelk", data$"10-11+: Repeated Species", sep = "_")


for (i in 1:nrow(data)) {
  current_whelk = data$"10-11+: Repeated Species"[i]
  
  if (i == 1) {
    data[i, 12] = index$Total_length[index$Whelk.number == current_whelk]
    data[i, 12] = paste("(atr)", "Whelk_total_shell_length_mm", data[i, 12], sep = " ")
  }
  
  else if (i > 1 && data$"10-11+: Repeated Species"[i - 1] != current_whelk) {
    data[i, 12] = index$Total_length[index$Whelk.number == current_whelk]
    data[i, 12] = paste("(atr)", "Whelk_total_shell_length_mm", data[i, 12], sep = " ")
  }
  
  else if (i > 2 && data$"10-11+: Repeated Species"[i - 2] == current_whelk) {
    data[i, 12] = index$Aperture_Length[index$Whelk.number == current_whelk]
    data[i, 12] = paste("(atr)", "Whelk_aperture", data[i, 12], sep = " ")
  }
  
  else if (i > 1 && data$"10-11+: Repeated Species"[i - 1] == current_whelk) {
    data[i, 12] = index$Width[index$Whelk.number == current_whelk]
    data[i, 12] = paste("(atr)", "Whelk_width_mm", data[i, 12], sep = " ")
  }
}

data[1, 12] = index$Total_length[index$Whelk.number == current_whelk]
    data[1, 12] = paste("(atr)", "Whelk_total_shell_length_mm", data[1, 12], sep = " ")


## -------------------------------------------------------------------------------

# Reformatting dataset to work in VIAME
data$"# 1: Detection or Track-id"  = data$"# 1: Detection or Track-id"  - 1
    
names(data)[names(data) == "NA.1"] = ""
names(data)[names(data) == "NA.2"] = ""
  
blank_row = as.data.frame(matrix(NA, nrow = 1, ncol = 14))
names(blank_row) = names(data)

data = rbind(blank_row, data)

data[1, 1] = "# metadata"
data[1, 2] = 'exported_by: "dive:python"'
data[1, 3] = 'exported_time: "Wed Aug 28 15:36:29 2024"'
data[1, 4:14] = ""
names(data)[names(data) == "NA"] = ""

head(data)


## -------------------------------------------------------------------------------


# Output file with measurements
write.csv(data, "VIAME_file_withmeasurements.csv", row.names = FALSE)



