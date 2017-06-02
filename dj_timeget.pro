function dj_timeget, tt, days=days
;
;+
; Name          : DJ_timeget
;
; Category      : time
;
; Purpose       : convert decimal time to format HH:MM:SS
;
; Explanation   : This is the oppposite of DJ_GETTIME.
;                 Given the time in hours (in float), this program would
;                 convert it back to HH:MM:SS format.
;
; Syntax        : IDL> time = DJ_timeget(tt)
;
; Inputs        : tt - time in float format
;
; Optional
; Inputs        : None
;
; Outputs       : time - time in HH:MM:SS format
;
; Optional
; Outputs       : None
;
; Keywords      : days - if TT is expressed in days instead
;                        of hours, use this format.
;
; Common        : None
;
; Calls	        : None
;
; Restrictions	: None
;
; History       : 01-Jan-2010 ... written by Anand D. Joshi
;-
;
tme = tt

if keyword_set(days) then begin
  dte = nint(floor(tt))
  tme = (tt mod 1) * 24
endif

tHH = floor(tme)
tM = (tme - tHH)*60.0  &  tMM = floor(tM)
tS = (tM - tMM)*60.0  &  tSS = floor(tS)

dtS = ''
if keyword_set(days) then dtS = trim(dte,'(i02)') + 'T '

return, dtS + strcompress(trim(tHH,'(i02)') + ':' + $
					trim(tMM,'(i02)') + ':' + trim(tSS,'(i02)'), /remo)


end