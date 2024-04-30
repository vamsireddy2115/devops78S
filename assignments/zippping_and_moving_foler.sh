#!/bin/bash

#Assignment given on 24th April 2024.
#Q:Make a folder into zip file and move it another desrtination.
#Use-case: Moving old log files to other destination


dnf install zip


echo "Enter the source folder to do zipping:"
read source

echo "Enter the destination folder to move the zip files:"
read destination

zip -r assignment_for_zip_folders $source
#assignment_for_zip_folders: file name of zip.

mv $source $destination
