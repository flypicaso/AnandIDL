pro DJ_FITimage, img0, window, xsize, ysize, aspect=aspect, noborder=noborder, $
					zero=zero, noscale=noscale, showname=showname, printname=printname, $
					xpos=xpos, ypos=ypos, colour=colour
;
;+
; Name         : DJ_FITimage
;
; Category     : image display
;
; Purpose      : resize large image before displaying
;
; Explanation  : TVIMAGE is a big program, but somehow
;                i have not been able to utilise it to
;                resize and display a large image properly.
;                Hence, this programme.
;                The image will be resized to the size of
;                the window currently set, and displayed.
;                zimbull
;
; Syntax       : IDL> DJ_FITimage, img0
;
; Inputs       : img0 - the input image to be displayed
;
; Optional
; Inputs       : window - window for the image to be displayed in
;                xsize - sepcify x size of window, default=700
;                ysize - sepcify y size of window, default=700
;                        if not specified, then ysize=xsize
;
; Outputs      : None
;
; Optional
; Outputs      : None
;
; Keywords     : aspect - use this keyword to maintain the aspect ratio
;                         of image. Window size, if not supplied,
;                         would be decided as per the image size
;                zero - to load the BnW colour table before display
;                noscale - no Byte Scaling, i.e. use TV instead of TVSCL
;                showname - display image name on window using XYOUTS
;                printname - display a use specified name
;                xpos - X value, to be supplied to XYOUTS (default 25)
;                ypos - Y value, to be supplied to XYOUTS (default 25)
;                colour - colour of name, to be supplied to XYOUTS (default ivory)
;
; Common       : None
;
; Calls	       : None
;
; Restrictions : ? Aspect ratio is always maintained in the present version [?]
;                - Assumes the window to be square, and changes aspect ratio
;                  of a non-square image to fit to the window
;                - If window index is not mentioned, you cannot specify its size
;                - ASPECT keyword suited only for greyscale image at present
;                - Works only for greyscale images
;                - currently name not shown if fn(img0) is supplied to DJ_FITimage
;                  e.g. SIGRANGE(img0) or img0[101:500,301:700] or img0/FtMsk
;
; History      : 24-Aug-2012 - written by Anand D. Joshi
;                08-Aug-2013 - added keywords XSIZE and YSIZE ... ADJ
;                13-Feb-2014 - added keywords ASPECT ... ADJ
;                08-Apr-2015 - a border in green would be drawn around
;                              the window edge to make it conspicuous.
;                            - added keyword NOBORDER ... ADJ
;                12-Jul-2016 - added keyword NOSCALE
;                            - added keywords SHOWNAME, PRINTNAME,
;                              XPOS, YPOS, and COLOUR ... ADJ
;-
;
if ~exist(img0) then begin
  message, 'variable not defined', /cont
  RETURN
end

if n_elements(xsize) then begin
  xsz = xsize
  if n_elements(ysize) then ysz = ysize else ysz = xsize
endif else begin
  if n_elements(aspect) then begin
    xsz = 700

    img0 = reform(temporary(img0))
    imsiz = size(img0)
    ;
    ysz = (imsiz[1] eq imsiz[2]) ? xsz : $
    					nint(float(xsz)*imsiz[2]/imsiz[1])
  endif
endelse


if keyword_set(zero) then loadct, 0, /sile

device, window=wodniw
winops = where(wodniw ne 0, nwin)
;
if n_elements(window) then begin
  Wopn = max(winops eq window)
  if (Wopn eq 1) then begin
    wset, window
    ;
    if n_elements(xsize) then begin
      if ((!d.x_size ne xsz) or (!d.y_size ne ysz)) then $
      					wdef, window, xsz, ysz, xp=30, yp=20
    endif else begin
      xsz = !d.x_size  &  ysz = !d.y_size
    endelse
  endif else begin
    wdef, window, xsz, ysz, xp=30, yp=20
  endelse
  ;
  imwin = window
endif else begin
  if (nwin eq 0) then begin
    wdef, 19, xsz, ysz, xp=30, yp=20
    imwin = 19
  endif else begin
    imwin = !d.window
    xsz = !d.x_size  &  ysz = !d.y_size
  endelse
endelse


img0 = reform(temporary(img0))
wstsh, imwin
imsiz = size(img0)
if (imsiz[0] eq 2) then begin
  img1 = congrid(img0, xsz, ysz)
  ;
  if ~keyword_set(noscale) then tvscl, img1 else tv, img1
endif else if (imsiz[0] eq 3) then begin
  if (imsiz[1] eq 3) then begin
    if (imsiz[2] ne imsiz[3]) then DJ_FITimage_aspect, imsiz, xsz, ysz
    if ((xsz lt imsiz[2]) and (ysz lt imsiz[3])) then $
    					img1 = congrid(img0, 3, xsz, ysz)
    ;
    if ~keyword_set(noscale) then tvscl, img1, true=1 else tv, img1, true=1
    stop
  endif else if (imsiz[2] eq 3) then begin
    if (imsiz[2] ne imsiz[3]) then DJ_FITimage_aspect, imsiz, xsz, ysz
    if ((xsz lt imsiz[2]) and (ysz lt imsiz[3])) then $
    					img1 = congrid(img0, xsz, 3, ysz)
    ;
    if ~keyword_set(noscale) then tvscl, img1, true=2 else tv, img1, true=2
  endif else if (imsiz[3] eq 3) then begin
    if (imsiz[2] ne imsiz[3]) then DJ_FITimage_aspect, imsiz, xsz, ysz
    if ((xsz lt imsiz[2]) and (ysz lt imsiz[3])) then $
    					img1 = congrid(img0, xsz, ysz, 3)
    ;
    if ~keyword_set(noscale) then tvscl, img0, true=3 else tv, img1, true=3
  endif
endif


if ~keyword_set(noborder) then begin
  tvlct, rr, gg, bb, /get
  djbox, 0, 0, xsz-1, ysz-1, colo=djcol(4)
  tvlct, rr, gg, bb
endif


if (keyword_set(showname) or keyword_set(printname)) then begin
  if ~keyword_set(Xpos) then Xpos = 25
  if ~keyword_set(Ypos) then Ypos = 25
  if ~keyword_set(colour) then colour = 'ivory'

  if (max(strcmp(scope_traceback(),'FITtwins',8,/fold)) eq 1) then $
  					level = -2 else level = -1

  tvlct, rr, gg, bb, /get

  if ~keyword_set(printname) then begin
    xyouts, Xpos, Ypos, scope_varname(img0,level=level), /devi, $
    					charsi=2.0, colo=fsc_color(colour)
  endif else begin
    xyouts, Xpos, Ypos, printname, /devi, charsi=2.0, $
    					colo=fsc_color(colour)
  endelse

  tvlct, rr, gg, bb
endif


;;aa = scope_traceback(/str)
;;bb = scope_traceback()

end


; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*

pro DJ_FITimage_aspect, imsiz, xsz, ysz

  xfac = 1.0*imsiz[2]/xsz
  yfac = 1.0*imsiz[3]/ysz
  ;
  if (xfac gt yfac) then begin
    ysz = imsiz[3]/xfac
  endif else if (yfac gt xfac) then begin
    xsz = imsiz[2]/yfac
  endif

end

; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*