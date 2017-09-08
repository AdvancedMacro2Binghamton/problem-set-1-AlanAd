#delimit ;

local dir "[set path]\problem-set-1-AlanAd\build_data\input\01_07_Earnings_PSID" ;

*  PSID DATA CENTER *****************************************************
   JOBID            : 232170                            
   DATA_DOMAIN      : PSID                              
   USER_WHERE       : NULL                              
   FILE_TYPE        : All Individuals Data              
   OUTPUT_DATA_TYPE : ASCII                             
   STATEMENTS       : do                                
   CODEBOOK_TYPE    : PDF                               
   N_OF_VARIABLES   : 11                                
   N_OF_OBSERVATIONS: 27200                             
   MAX_REC_LENGTH   : 45                                
   DATE & TIME      : September 4, 2017 @ 21:49:55
*************************************************************************
;

infix
      ER30000         1 - 1         ER30001         2 - 5         ER30002         6 - 8    
      ER33601         9 - 12        ER33602        13 - 14        ER33603        15 - 16   
      ER33627A       17 - 26        ER33901        27 - 31        ER33902        32 - 33   
      ER33903        34 - 35        ER33926A       36 - 45   
using "`dir'\PSID_Earnings_Data.txt", clear 
;
label variable ER30000    "RELEASE NUMBER"                           ;
label variable ER30001    "1968 INTERVIEW NUMBER"                    ;
label variable ER30002    "PERSON NUMBER                         68" ;
label variable ER33601    "2001 INTERVIEW NUMBER"                    ;
label variable ER33602    "SEQUENCE NUMBER                       01" ;
label variable ER33603    "RELATION TO HEAD                      01" ;
label variable ER33627A   "R26/R33/R41 REP EARNINGS AMT IN 1999  01" ;
label variable ER33901    "2007 INTERVIEW NUMBER"                    ;
label variable ER33902    "SEQUENCE NUMBER                       07" ;
label variable ER33903    "RELATION TO HEAD                      07" ;
label variable ER33926A   "R2/R11 EARNINGS AMT REPORTED IN 2005  07" ;
