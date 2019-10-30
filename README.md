# Rotary-Motor-Current-Biol.-2015 (Shrivastava, Lele, Berg)
These codes were used to fit an ellipse to a tethered bacterial cell. The frame-by-frame center of mass of the rotating cell was measured and plotted in the x-y spatial domain.
Reference: https://www.cell.com/current-biology/pdfExtended/S0960-9822(14)01506-1 

These codes open a .avi file which is of a tethered E. coli cell, threshold it, fit an ellipse to the object in that file, and measure the center of mass.
 
You need to download all these codes plus the attached Rotating_cell.avi file into one folder. Add that folder to your MATLAB path and run readavi.m You can do that by simply writing readavi in your command window and pressing enter. This script reads the .avi file and stores variables in your workspace.
 
Next, run Tetheredcell_analysis.m  this script will ask you to draw a crop box around an E. coli cell and then ask if you are happy with the outcome using a Boolean logic. Once you are input that you are happy it will store more variables in the workspace. You can then use the command plot(Xcenter, Ycenter) or scatter(Xcenter, Ycenter) to get the locations of the center of mass. This plot should look similar to com.fig.
 
