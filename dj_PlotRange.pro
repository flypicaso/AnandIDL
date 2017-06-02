function dj_PlotRange, array1, array2, array3, array4, margin=margin
;
;+
; Name          : DJ_PlotRange
;
; Category      : plotting
;
; Purpose       : find the range for plotting given an array
;
; Explanation   : if one is making frequent changes to a
;									program which plots variables, it is very
;									annoying to set the range every time. so
;									here's a convenient function which does the
;									job. it can handle a max of 3 arrays at a time,
;									i.e. it'll calculate the eventual range by
;									considering max and min of all the arrays.
;									the default is to add 10% of the total
;									range on both the lower & upper sides, but
;									it can be changed thru an optional input.
;
; Syntax        : IDL> result = DJ_PlotRange(array1, marg=0.15)
;									IDL> result = DJ_PlotRange(array1, array2)
;
; Inputs        : array1 - a non-string array of numbers
;
; Optional
; Inputs        : array2 - a non-string array of numbers
;									array3 - a non-string array of numbers
;									margin - upper & lower margins to be
;													 appended to min & max in
;													 fraction (default = 0.1)
;
; Outputs       : result - an array containing 2 elements
; 								 				 which can be right away used as
; 								 				 an input to the [xyz]range keyword
;
; Optional
; Outputs       : None
;
; Keywords      : None
;
; Common        : None
;
; Calls	        : None
;
; Restrictions	: can handle maximum of 4 arrays at a time
;
; History       : 23-Sep-2009 ... written by Anand D. Joshi
;-
;
if ~n_elements(margin) then margin = 0.1

case n_params() of
  1: armin = min(array1, max=armax)

  2: begin
    ar1mn = min(array1, max=ar1mx)
    ar2mn = min(array2, max=ar2mx)
    ;
    armin = ar1mn < ar2mn
    armax = ar1mx > ar2mx
  end

  3: begin
    ar1mn = min(array1, max=ar1mx)
    ar2mn = min(array2, max=ar2mx)
    ar3mn = min(array3, max=ar3mx)
    ;
    armin = ar1mn < ar2mn < ar3mn
    armax = ar1mx > ar2mx > ar3mx
  end

  4: begin
    ar1mn = min(array1, max=ar1mx)
    ar2mn = min(array2, max=ar2mx)
    ar3mn = min(array3, max=ar3mx)
    ar4mn = min(array4, max=ar4mx)
    ;
    armin = ar1mn < ar2mn < ar3mn < ar4mn
    armax = ar1mx > ar2mx > ar3mx > ar4mx
  end

  else: print, 'maa kassam!!! too many arguments!!!'
endcase
;
armar = margin*(armax - armin)

rng = [armin-armar, armax+armar]

return, rng



end