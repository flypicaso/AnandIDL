pro DJ_OpenPro, pronam, sudo=sudo, new=new, exact=exact
;
;+
; Name         : DJ_OpenPro
;
; Category     : file managing
;
; Purpose      : to search for and open a .pro file from within IDL
;
; Explanation  : XDOC has couple of limitations.
;                     only 1 program can be opened at a time
;                     we need to use RETALL sometimes
;                this program directly opens the program that you want
;                to see in gedit, by searching it using the WHICH command.
;                ALL and SEARCH arguments are not used in WHICH, so only
;                the 1st result of the program is opened. that's good as
;                the 1st result is the one that is compiled on .COM
;
; Syntax       : IDL> DJ_OpenPro, pronam, /sudo
;
; Inputs       : pronam - complete name of the program, no wildcard or short name
;
; Optional
; Inputs       : None
;
; Outputs      : None
;
; Optional
; Outputs      : None
;
; Keywords     : sudo - if the program has to be opened as a superuser
;              : new - to be used if a new window has to be opened
;
; Common       : None
;
; Calls	       : WHICH, SPAWN
;
; Restrictions : complete name of the program has to be mentioned
;
; History      : 19-Aug-2013 written by Anand D. Joshi
;                10-Sep-2013 able to open a full path directly ... ADJ
;                30-Oct-2013 added keyword NEW for --new-window ... ADJ
;;;                30-Mar-2017 added keyword EXACT ... ADJ
;-
;
if ~n_elements(pronam) then begin
  pronam = ''
  read, prom='     enter program name: ', pronam
endif

if n_elements(sudo) then st_sud = 'sudo ' else st_sud = ''
					
if n_elements(new) then st_new = ' --new-window' else st_new = ''


if (datatype(pronam) ne 'STR') then begin
  print, '     only string arguments allowed; did you forget the quotes?'
  return
endif

if file_exist(pronam) then begin
  spnst = 'gedit ' + pronam
endif else begin
  which, pronam, outfi=propth

  if (propth eq '') then begin
    print, '     ', pronam, ' - no program found with the name; returning', form='(3a)'
;;    return
  endif else if (n_elements(strsplit(propth,' ')) gt 1) then begin
    return
  endif

  propath = propth[0]

  spnst = 'gedit ' + propth
endelse
;
spnst = st_sud + spnst + st_new + ' &'


spawn, spnst


end
