function dj_pathOS, path, OS=OS
;
;+
; Name         : dj_pathOS
;
; Category     : folders
;
; Purpose      : Use single path for Windows & Unix programs
;
; Explanation  : Often, when switching between Windows & unix OS's.
;                we have to manually change the path. This program
;                would take care of it.
;                Although, you have to specify the appropriate labels
;                for linux (or Mac) corresponding to the drive letters
;                used in Windows OS.
;
; Syntax       : IDL> outpath = dj_pathOS(path)
;
; Inputs       : path - a valid path to a Windows or Linux folder
;
; Optional
; Inputs       : None
;
; Outputs      : None
;
; Optional
; Outputs      : None
;
; Keywords     : OS - specify the OS of your choice
;                     either UNIX or WINDOWS
;
; Common       : None
;
; Calls	       : None
;
; Restrictions : None
;
; History      : 14-Sep-2015 ... written by Anand D. Joshi
;                
;-
;
if n_elements(OS) then begin
  case strlowcase(trim(OS)) of
    'unix': OSfam = OS
    'windows': OSfam = OS
    else: OSfam = strlowcase(!version.os_family)
  endcase
endif else begin
  OSfam = strlowcase(!version.os_family)
endelse

win = 0  &  lin = 0
if (strmid(path,0,1) eq '/') then lin = 1 else win = 1

if (OSfam eq 'windows') then begin
  if (win eq 1) then begin
    return, path
  endif else begin
    qath = strmid(path,13)
    qspl = strsplit(qath, '/', /extra, coun=nq)


    qath = strupcase(strmid(qspl[0],0,1)) + ':\' + strjoin(qspl[1:nq-1],'\')

    return, qath
  endelse

endif else if (OSfam eq 'unix') then begin
  if (lin eq 1) then begin
    return, path
  endif else begin
    qspl = strsplit(path, '\', /extra, coun=nq)

; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*
; *~*~*~*~*~*~*~*~*~*~*~* INSERT APPROPRIATE DRIVE LABELS *~*~*~*~*~*~*~*~*~*~*

    case strmid(qspl[0],0,1) of
      'E': drive = 'Echo'
      'F': drive = 'Fox'
      'G': drive = 'Golf'
      else: message, 'no appropriate drive found'

; *~*~*~*~*~*~*~*~*~*~*~* INSERT APPROPRIATE DRIVE LABELS *~*~*~*~*~*~*~*~*~*~*
; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*

    endcase


; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*
; *~*~*~*~*~*~*~*~*~*~*~*~*~* INSERT APPROPRIATE PATH *~*~*~*~*~*~*~*~*~*~*~*~*

    qath = '/media/user/' + drive + '/' + strjoin(qspl[1:nq-1],'/')

; *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*
; *~*~*~*~*~*~*~*~*~*~*~*~*~* INSERT APPROPRIATE PATH *~*~*~*~*~*~*~*~*~*~*~*~*

    return, qath
	endelse

endif


end