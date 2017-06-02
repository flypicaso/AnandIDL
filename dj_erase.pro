pro DJ_erase, wdx1, wdx2, wdx3, wdx4, wdx5, all=all
;
;+
; Name         : DJ_erase
;
; Category     : Window utility
;
; Purpose      : to erase the window specified in a single command
;
; Explanation  : While PLOTting, OVERPLOTting, re-PLOTting and 
;                re-OVERPLOTting, one often needs to clean the
;                window, reset plot and !MOUSE.BUTTON, and do
;                so at the same time for several windows.
;
; Syntax       : IDL> djerase, wdx1, wdx2
;
; Inputs       : wdxi - index of window to be erased
;                       maximum 5 indices can be specified, or
;                       ALL open windows can be erased with
;                       the corresponsing keyword.
;                       (default is the current window)
;
; Optional
; Inputs       : None
;
; Outputs      : None
;
; Optional
; Outputs      : None
;
; Keywords     : None
;
; Common       : None
;
; Calls	       : None
;
; Restrictions : - windows will be erased
;
; History      : 18-Nov-2015 - written by Anand D. Joshi
;                20-Nov-2015 - can now handle an array of 
;                              window indices ... ADJ
;                08-Dec-2015 - use list of indices instead of an array
;                            - added keyword ALL ... ADJ
;                14-Jan-2016 - reset !mouse.button too ... ADJ
;                18-Jan-2016 - issue error message if window is
;                              not defined ... ADJ
;                17-May-2016 - now works at !d.name='PS' ... ADJ
;                07-Jul-2016 - defines 600x600 window if not defined ... ADJ
;-
;
on_error, 2

ptwd = !d.window

if (n_elements(wnx) eq 0) then begin
endif

xwn = n_params()


if (strlowcase(!d.name) eq 'ps') then begin
  !mouse.button = 1  &  loadct, 0, /sile  &  cleanplot, /sile

  return
endif


device, window=wdow
winops = where(wdow ne 0, nwin)


if keyword_set(all) then begin
  !mouse.button = 1  &  loadct, 0, /sile  &  cleanplot, /sile

  for i=0,nwin-1 do begin
    wstsh, winops[i]  &  erase
  endfor

endif else begin
  case xwn of
    0: begin
      !mouse.button = 1  &  loadct, 0, /sile  &  cleanplot, /sile
      erase

      return
    end
		else: begin $
      !mouse.button = 1  &  loadct, 0, /sile  &  cleanplot, /sile
      for i=1,xwn do begin
        Wincmd = 'wnx = wdx' + trim(i)
        Winexe = execute(Wincmd)

        if (max(winops eq wnx) ne 1) then begin
          box_message, ['window '+trim(wnx)+' NOT open', $
          					'using: WDEF, '+trim(wnx)+', 600']
          wdef, wnx, 600
;;;        	 message, string('window ' + trim(wnx) + ' NOT open')
;;;          print, 'E DJERASE: window ', trim(wnx), ' NOT open', form='(a,a,a)'
;;;          RETURN
;;;        endif
        endif

        wstsh, wnx  &  erase
      endfor
    end
  endcase

endelse


if (xwn gt 1) then wstsh, ptwd


end