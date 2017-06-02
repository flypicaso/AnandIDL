function dj_TimeRange, yea, mon, dat, hou, miu, sec, $
					margin=margin, noround=noround
;
;+
; Name         : dj_TimeRange
;
; Category     : plotting
;
; Purpose      : determine suitable time range a la PLOTRANGE
;
; Explanation  : it is desirable to have a margin around the
;                start and end data points in any plot. for all
;                other data, PLOTRANGE does a good job.
;                However, for time we need a special programme.
;                This one determines the Julian Day Numbers of the
;                min and max of the time array, and subtracts and
;                adds a margin of 10% to min and max.
;                The seconds returned are rounded to the nearest minute,
;                provided that the minutes do not carry over to hours
;                and the time margin, TMAR, is more than 5 minutes
;                This is done as in a very freak case, one may have to
;                carry over all the way up to years. For example:
;                2011-12-31 23:59:46 will lead to 2012-01-01 00:00:00
;                Instead at the error of 1 minute we round it to:
;                2011-12-31 23:59:00
;                 
; Syntax       : IDL> timran = dj_TimeRange(yea, mon, dat, hou, miu, sec)
;
; Inputs       : yea - year of time array
;                mon - month of time array
;                dat - date of time array
;                hou - hour of time array
;                miu - minute of time array
;                sec - second of time array
;
; Optional
; Inputs       : None
;
; Outputs      : timran - 2-element time range in the format
;                yyyy-mm-dd HH:MM:SS
;
; Optional
; Outputs      : None
;
; Keywords     : margin - specify the margin, in fraction, around
;                         the time array default is 0.1, i.e. 10%
;
; Common       : None
;
; Calls	       : JULDAY, CALDAT
;
; Restrictions : - Would run into problems if datatypes are not correct
;
; History      : 12-Sep-2013 - written by Anand D. Joshi
;                12-Dec-2013 - sec[NX] are rounded only if miu[NX] remains the same
;                            - rounding carried out only if timerange sufficiently large
;                            - added keyword, NOROUND, to return the exact time in seconds
;                   Apr-2014 - Data can be supplied in fractional hours as a float
;-
;
n = n_elements(hou)
xnp = n_params()


case xnp of
  1: begin
    Ryea = yea
    TFtemp = anytim2cal(yea, form=11)
    
;;;    date = strmid(TFtemp, 0, 10)
    yea = nint(strmid(TFtemp, 0, 4))
    mon = nint(strmid(TFtemp, 5, 2))
    dat = nint(strmid(TFtemp, 8, 2))

;;;    time = strmid(TFtemp, 11, 8)
    hou = nint(strmid(TFtemp, 11, 2))
    miu = nint(strmid(TFtemp, 14, 2))
    sec = nint(strmid(TFtemp, 17, 2))
  end
  4: begin
    TFtemp = temporary(hou)
    ;
    miu = (TFtemp - floor(TFtemp))*60
    sec = (miu - floor(miu))*60
    ;
    hou = floor(TFtemp)
    miu = floor(miu)
    sec = floor(sec)
  end
  else:
endcase

if ~n_elements(margin) then margin = 0.1

Jules = julday(mon, dat, yea, hou, miu, sec)

tmar = (max(Jules) - min(Jules))*margin
tmrN = min(Jules) - tmar
tmrX = max(Jules) + tmar


caldat, tmrN, monN, datN, yeaN, houN, miuN, secN

caldat, tmrX, monX, datX, yeaX, houX, miuX, secX


if (~keyword_set(noround) and (tmar*24*60 gt 5)) then begin
  if ((secN gt 30) and (miuN ne 59)) then miuN += 1
  secN = 0
  ;
  if ((secX gt 30) and (miuX ne 59)) then miuX += 1
  secX = 0
endif


dttmN = trim(yeaN,'(i04)') + '-' + month_cnv(monN,/shor) + '-' + $
					trim(datN,'(i02)') + ' ' + trim(houN,'(i02)') + ':' + $
					trim(miuN,'(i02)') + ':' + trim(secN,'(i02)')
dttmX = trim(yeaX,'(i04)') + '-' + month_cnv(monX,/shor) + '-' + $
					trim(datX,'(i02)') + ' ' + trim(houX,'(i02)') + ':' + $
					trim(miuX,'(i02)') + ':' + trim(secX,'(i02)')
;
timran = [dttmN, dttmX]


if (xnp eq 1) then yea = Ryea
return, timran


end


;;;if (n_params() eq 4) then begin
;;;  TFtemp = temporary(hou)
;;;  ;
;;;  miu = (TFtemp - floor(TFtemp))*60
;;;  sec = (miu - floor(miu))*60
;;;  ;
;;;  hou = floor(TFtemp)
;;;  miu = floor(miu)
;;;  sec = floor(sec)
;;;endif