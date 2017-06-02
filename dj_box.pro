pro DJbox, x0, y0, x1, y1, colour=colour, linest=linest, thick=thick, $
							data=data, normal=normal, device=device, fill=fill
;
;+
; Name         : DJbox
;
; Category     : window building
;
; Purpose      : create a box with coordinates of four vertices specified 
;
; Explanation  : Surprisingly, there is no commonly found program in
;                the standard libraries that would rectangular draw a
;                box in a window, given the coordinates of the any two
;                DIAGONALLY OPPOPSITE points.
;                This one does the job. You can also specify whether the
;                coordinates are DATA, NORMAL or DEVICE, and do some
;                basic formatting of the box, as indicated by the keywords. 
;
; Syntax       : IDL> DJbox, x0, y0, x1, y1    ; specify all coords as scalars
;                IDL> DJbox, x0, y0            ; specify coords in pairs
;                IDL> DJbox, x0                ; a single array of 4 coords
;
; Inputs       : x0 - x coordinate of 1st point
;                     OR
;                     if present as the only input, should be a 4-element
;                     array giving [x0, y0, x1, y1] in that order
;                y0 - y coordinate of 1st point
;                     OR
;                     if present as the only input along with x0, then
;                     both should be 2-element arrays providing
;                     [x0, y0] and [x1, y1] respectively.
;                x1 - x coordinate of 2nd point (diagonally opposite to 1st)
;                y1 - y coordinate of 2nd point (diagonally opposite to 1st)
;
; Optional
; Inputs       : None
;
; Outputs      : None
;
; Optional
; Outputs      : None
;
; Keywords     : colour - colour of box to be drawn
;                linest - linestyle of the box to be drawn
;                data - if coordinates are in DATA units
;                normal - if coordinates are in NORMAL units
;                device - if coordinates are in DEVICE units
;                fill - if the box is to be filled with COLOUR
;
; Common       : None
;
; Calls	       : FSC_COLOR
;
; Restrictions : - coordinates have to be supplied correctly
;                - when using NORMAL or DATA coordinates, position
;                  of the box is not exactly the same for different
;                  values of !P.FONT and 
;
; History      : 31-Oct-2009 - written by Anand D. Joshi
;                14-Jul-2016 - use CASE instead of IF for n_params()
;                              changed N_ELEMENTS to KEYWORD_SET ... ADJ
;-
;
if ~n_elements(colour) then colour=fsc_color('white')
if ~n_elements(linest) then linest=0
if ~n_elements(thick) then thick=1.0
if ~n_elements(charsi) then charsi=1.0
if ~n_elements(charth) then charth=1.0


if (n_elements(x0) eq 4) then begin
	x0P = x0[0]  &  y0P = x0[1]
	x1P = x0[2]  &  y1P = x0[3]
endif else if ((n_elements(x0) eq 2) and (n_elements(y0) eq 2)) then begin
  x0P = x0[0]  &  y0P = x0[1]
  x1P = y0[0]  &  y1P = y0[1]
endif else begin
  x0P = x0  &  y0P = y0
  x1P = x1  &  y1P = y1
endelse  


;;;data = 0  &  normal = 0
;;;if keyword_set(data) then data = 1 else if keyword_set(normal) then normal = 1

data = keyword_set(data)
normal = keyword_set(normal)


if (~data and ~normal) then device = 1


plots, [x0P,x1P], [y0P,y0P], color=color, linest=linest, thick=thick, $
					data=data, normal=normal, device=device
plots, [x1P,x1P], [y0P,y1P], color=color, linest=linest, thick=thick, $
					data=data, normal=normal, device=device
plots, [x1P,x0P], [y1P,y1P], color=color, linest=linest, thick=thick, $
					data=data, normal=normal, device=device
plots, [x0P,x0P], [y1P,y0P], color=color, linest=linest, thick=thick, $
					data=data, normal=normal, device=device
;
if keyword_set(fill) then $
					polyfill, [x0P,x1P,x1P,x0P], [y0P,y0P,y1P,y1P], $
					data=data, normal=normal, device=device, /fill, $
					transparent=transparent


end


;;;if keyword_set(data) then begin
;;;  plots, [x0P,x1P], [y0P,y0P], /data, color=colour, linest=linest, thick=thick
;;;  plots, [x1P,x1P], [y0P,y1P], /data, color=colour, linest=linest, thick=thick
;;;  plots, [x1P,x0P], [y1P,y1P], /data, color=colour, linest=linest, thick=thick
;;;  plots, [x0P,x0P], [y1P,y0P], /data, color=colour, linest=linest, thick=thick
;;;  ;
;;;  if keyword_set(fill) then $
;;;  					polyfill, [x0P,x1P,x1P,x0P], [y0P,y0P,y1P,y1P], /data, color=colour, /fill
;;;
;;;endif else if keyword_set(normal) then begin
;;;  plots, [x0P,x1P], [y0P,y0P], /norm, color=color, linest=linest, thick=thick
;;;  plots, [x1P,x1P], [y0P,y1P], /norm, color=color, linest=linest, thick=thick
;;;  plots, [x1P,x0P], [y1P,y1P], /norm, color=color, linest=linest, thick=thick
;;;  plots, [x0P,x0P], [y1P,y0P], /norm, color=color, linest=linest, thick=thick
;;;  ;
;;;  if keyword_set(fill) then $
;;;  					polyfill, [x0P,x1P,x1P,x0P], [y0P,y0P,y1P,y1P], /norm, color=colour, /fill
;;;
;;;endif else begin
;;;  plots, [x0P,x1P], [y0P,y0P], /devi, color=color, linest=linest, thick=thick
;;;  plots, [x1P,x1P], [y0P,y1P], /devi, color=color, linest=linest, thick=thick
;;;  plots, [x1P,x0P], [y1P,y1P], /devi, color=color, linest=linest, thick=thick
;;;  plots, [x0P,x0P], [y1P,y0P], /devi, color=color, linest=linest, thick=thick
;;;  ;
;;;  if keyword_set(fill) then $
;;;  					polyfill, [x0P,x1P,x1P,x0P], [y0P,y0P,y1P,y1P], /devi, color=colour, /fill
;;;endelse