pro dj_minmax, var1, var2, var3, var4, var5, var6, var7, var8, var9
;
;+
; Name         : dj_minmax
;
; Category     : user utility
;
; Purpose      : commands HELP & MNMX bundled into one
;
; Explanation  : several times you need to check help on the
;                image, and simultaneously also need to
;                see the minmax values, especially on an
;                image. this program combines the two
;                and prints the output on a single line
;                for multiplte images at once.
;
; Syntax       : IDL> dj_minmax, var1, var2, ..., var9
;
; Inputs       : vari - a multi dimensional variable (not a STRUCT)
;
; Optional
; Inputs       : None
;
; Outputs      : varname, datatype, size, min, max
;
; Optional
; Outputs      : None
;
; Keywords     : None
;
; Common       : None
;
; Call         : SCOPE_VARNAME, STRLOWCASE
;
; Restrictions : - doesn't work with structures
;                - accepts a maximum of 9 variables
;                - array can have a maximum of 3 dimensions
;
; History      : 16-Sep-2009 written by Anand D. Joshi
;              : 26-Oct-2015 dj_minmax now accepts only 9 variables
;                            adjusted FORMATting in output ... ADJ
;-
;
xx = n_params()
if (xx eq 0) then message, 'no argumentAAA!!!', /info


i = 1
;
while (i le xx) do begin
  lycmd = 'lucy, ' + 'var'+trim(i)
  lyxst = execute(lycmd)

  i++
endwhile

end


; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*

pro lucy, var

  if ~exist(var) then begin
    print, strlowcase(scope_varname(var,leve=-2)), $
    					'... does not exist', format='(a8,1x, a)'
    return
  endif
  ;
  if (size(var,/type) eq 7) then begin
    if (n_elements(var) eq 1) then begin
      print, strlowcase(scope_varname(var,leve=-2)), size(var,/tnam), $
      					var, format='(2a10, 4x, a)'
    endif else begin
      print, strlowcase(scope_varname(var,leve=-2)), size(var,/tnam), $
      					'ARRAY['+trim(n_elements(var))+']', format='(2a10, 4x, a)'
    endelse

    RETURN
  endif


  varn = min(var, max=varx)
  ;
  case size(var,/n_dimen) of
    0: print, strlowcase(scope_varname(var,leve=-2)), $
    					size(var,/tnam), size(var,/dimen), trim(varn*1), $
    					format='(2a10, 8x, 1(i8,2x), 2x, 1(a,2x))'
    ;
    1: print, strlowcase(scope_varname(var,leve=-2)), size(var,/tnam), $
    					size(var,/dimen), trim(varn), trim(varx*1), $
    					format='(2a10, 8x, 1(i8,2x), 2x, 2(a,2x))'
    ;
    2: print, strlowcase(scope_varname(var,leve=-2)), size(var,/tnam), $
    					size(var,/dimen), trim(varn), trim(varx*1), $
    					format='(2a10, 6x, 2(i4,2x), 2x, 2(a,2x))'
    ;
    3: print, strlowcase(scope_varname(var,leve=-2)), size(var,/tnam), $
    					size(var,/dimen), trim(varn), trim(varx*1), $
    					format='(2a10, 3(i4,2x), 2x, 2(a,2x))'
    ;
    else: print, strlowcase(scope_varname(var,leve=-2)), $
    					'NOT SUPPORTED by dj_minmax', format='(a10, 2x, a)'
  endcase

end

; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~