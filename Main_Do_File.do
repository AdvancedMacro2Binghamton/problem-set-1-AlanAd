
**************************************************************************
************** 		    	Alan Adelman           ***********************
**************            Advanced Macro II        ***********************
**************                 HW #1               ***********************
**************************************************************************

** This DO-FILE runs the whole HW1, including Build and Analysis

local indirB "[set path]\problem-set-1-AlanAd\build_data\code"

local indirA "[set path]\problem-set-1-AlanAd\analysis\code"

do "`indirB'\HW1_Build_File.do"

do "`indirA'\HW1_Analysis.do"
