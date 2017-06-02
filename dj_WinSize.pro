pro dj_WinSize, index1, index2, index3, index4, index5, current=current, set=set
;
;+
; Name         : dj_WinSize
;
; Category     : window utility
;
; Purpose      : determine size of a window
;
; Explanation  : often it is necessary to determine the
;                the size of window. this gives an easy
;                way to look into the structure !d.
;
; Syntax       : IDL> dj_winsize, index
;
; Inputs       : None window size of currently set window
;                returned if no index specified
;
; Optional
; Inputs       : indexi - index of window whose size is to be determined
;                         (i going from 1 to 5)
;
; Outputs      : None
;
; Optional
; Outputs      : None
;
; Keywords     : current - return size of only the currently set window
;                set - procedure would not set the window normally
;                      however it can be done thorugh this keyword
;
; Common       : None
;
; Calls	       : None
;
; Restrictions : None
;
; History      : 21 May 2011 - written by Anand D. Joshi
;                23 May 2011 - modified to call sizes of more than
;                              one window at a time ... ADJ
;                05 Jul 2011 - tag inserted in print statement that
;                              would identify the active window ... ADJ
;                06 Jul 2012 - default made to show all window sizes ... ADJ
;                04-Feb-2014 - rectified  malfunctioning keyword CURRENT
;                              removed the redundant keyword ALL
;                              ALL has been made deafult
;                03-Mar-2014 - rectified  malfunctioning input parameters
;                              indexi (i: 1 to 5)
;-
;
COMMON PinWheel, winops, curwin

on_error, 2

if ((strlowcase(!d.name) ne 'x') and (strlowcase(!d.name) ne 'win')) then $
					message, string('procedure not defined for device ', !d.name)

curwin = !d.window
;
if (curwin eq -1) then begin
  print, ' -1    -   -1', form='(a)'
  RETURN
endif

if n_elements(current) then begin
  print, 'C', curwin, !d.x_size, !d.y_size, form='(a-2, i3,2i7)'
  RETURN
endif


device, window=wdow
winops = where(wdow ne 0, nwin)

xwn = n_params()
;
case xwn of
0: $
  for i=0,nwin-1 do prin_WinSiz, winops[i]
else: $
  begin
    for i=1,xwn do begin
      Wincmd = 'wnx = index' + trim(i)
      Winexe = execute(Wincmd)

      if (max(winops eq wnx) ne 1) then begin
        print, wnx, 'window not defined', form='(i5,4x,a)'
        CONTINUE
      endif

      prin_WinSiz, wnx
    endfor
  end
endcase

if ~n_elements(set) then wset, curwin




end


pro prin_WinSiz, idx
COMMON PinWheel, winops, curwin

  chkdx = where(winops eq idx, nidx)
  if (nidx eq 0) then begin
    message, strtrim(trim(idx,'(i02)')+' --- window not open!', 2), /info
  endif else begin
    wset, idx
    if (idx ne curwin) then begin
      print, idx, !d.x_size, !d.y_size, form='(i5,2i7)'
    endif else begin
      print, 'C', idx, !d.x_size, !d.y_size, form='(a-2, i3,2i7)'
    endelse
  endelse

end


;;;if n_elements(all) then begin
;;;  if (nwin eq 0) then message, 'Pandoo, aadhi ekhadi khidki tar ughad!!!', /info
;;;  ;
;;;  for i=0,nwin-1 do begin
;;;    prin_WinSiz, winops[i], winops, curwin
;;;  endfor
;;;endif else if n_elements(index1) then begin
;;;  prin_WinSiz, index1, winops, curwin
;;;
;;;  if n_elements(index2) then prin_WinSiz, index2, winops, curwin
;;;
;;;  if n_elements(index3) then prin_WinSiz, index3, winops, curwin
;;;
;;;  if n_elements(index4) then prin_WinSiz, index4, winops, curwin
;;;
;;;  if n_elements(index5) then prin_WinSiz, index5, winops, curwin
;;;endif else begin
;;;  print, curwin, !d.x_size, !d.y_size, form='(i5,2i7)'
;;;endelse