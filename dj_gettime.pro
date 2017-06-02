function dj_gettime, tm, short=short, days=days
;
;+
; Name         : DJ_GETTIME
;
; Category     : Utilities
;
; Purpose      : To get time in hours (or days) from fits header
;
; Explanation  : Often during plotting a time series, you need
;                time as a float. This program would do the same.
;                Additionally, if you need time over several days,
;                use the keyword DAYS to get the time as a fraction
;                of the days.
;                2007-05-19T12:51:45.007 ... time format
;                0123456789_123456789_12 ... string
;
; Syntax       : IDL> time = DJ_gettime(tm)
;                IDL> time = DJ_gettime(tm, /days)
;
; Inputs       : tm - time in YYYY-MM-DDTHH:MM:SS format
;
; Optional
; Inputs       : None
;
; Outputs      : time - as a float in 24-hour format
;
; Optional
; Outputs      : None
;
; Keywords     : short - use this if tm is in HH:MM:SS format
;                days - if the output is required to include dates
;                       as well, i.e. DD + time/24
;
; Common       : None
;
; Calls	       : None
;
; Restrictions : - cannot use DAYS if tm is in SHORT format
;
; History      : 01-Jan-2009 ... written by Anand D. Joshi
;-
;
if n_elements(short) then begin
  return, strmid(tm,00,2)*1.0d + strmid(tm,03,2)/60.0d + strmid(tm,06)/3600.d
endif else if n_elements(days) then begin
  return, strmid(tm,08,2)*1.0d + $
  					(strmid(tm,11,2)*1.0d + strmid(tm,14,2)/60.0d + strmid(tm,17)/3600.d)/24
endif else begin
  return, strmid(tm,11,2)*1.0d + strmid(tm,14,2)/60.0d + strmid(tm,17)/3600.d
endelse


end