pro DJ_cursor, xx, yy, count=count, windo=windo, data=data, norm=norm, $
								devi=devi, none=none, silent=silent, ch=ch
;
;+
; Name        : DJ_cursor
;
; Category    :	user utility
;
; Explanation : ask the user to click some positions
;               and print values in device coordinates.
;               Selects the current/specified window
;               and brings it in front upon execution.
;
; Syntax      :	IDL> DJ_cursor
;
; Inputs      : None
;
; Outputs	    :	xx, yy, coords of count number of positions
;						    in specified coordinates
;
; Optional
; Outputs	    : None
;
; Keywords	  :	count - specify number of positions to click, cefault 1
;               windo - specify the window number to work on, default current window
;               norm  - specify if coords are needed in normalised form
;               data  - specify if coords are needed in data form
;               none  - no keyword for coordinate form
;               default - device
;                       NOTE:   /data, /norm, /none keywords are mutually exclusive
;               silent - no stuff printed in output log
;               ch     - the usual flag for !mouse.button
;
; Restrictions:	None.
;
; History     :	24-Mar-2009 - written by Anand D. Joshi
;               01-Apr-2009 - added keywords xx and yy ... ADJ
;               03-Jul-2015 - added keyword ch ... ADJ
;               21-Jul-2016 - IFs replaced by CASE, thus ensuring the
;                             mutual exclusivity of keywords ... ADJ
;                             Actually keywords would be processed in the
;                             priority order NORM, DATA, NONE, even if
;                             more than one are supplied.
;-
;
on_error, 2


if (!d.name eq 'ps') then begin
  message, 'routine not defined for PS!!!', /info
  return
endif
if (!d.window eq -1) then begin
  message, 'maa kasam!!! no window openaa!', /info
  return
endif
if n_elements(windo) then wstsh, windo else wstsh, !d.window
if keyword_set(count) then m = count else m = 1
;
for i=0,m-1 do begin
  case 1 of
  	keyword_set(norm): cursor, xx, yy, /norm, /down, wait
    keyword_set(data): cursor, xx, yy, /data, /down, wait
    keyword_set(none): cursor, xx, yy, /down, wait
    else: cursor, xx, yy, /devi, /down, wait
  endcase

  if ~keyword_set(silent) then print, xx, yy
endfor

if n_elements(ch) then begin
  if (!mouse.button eq 4) then begin
    stop
    return
  endif
endif


end