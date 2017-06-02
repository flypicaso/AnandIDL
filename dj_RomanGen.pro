function dj_RomanGen, numN, lowcase=lowcase
;
;+
; Name          : dj_RomanGen
;
; Category      : utility
;
; Purpose       : generate Roman numerals
;
; Explanation   : just like indgen generates integers and
;                 alphagen generates alphabets, this program
;                 generates Roman numerals.
;
; Syntax        : IDL> xx = dj_RomanGen(n)
;
; Inputs        : numN - number of numerals to be returned
;
; Optional
; Inputs        : None
;
; Outputs       : list of Roman numerals
;
; Optional
; Outputs       : None
;
; Keywords      : lowcase - returns lower case numerals
;                           default is upper case numerals
;
; Common        :
;
; Calls	        : ROMAN
;
; Restrictions	: generates a maximum of 30 nunmbers at present
;                 due to the inherent retriction in ROMAN
;
; History       : 14-Mar-2012 ... written by Anand D. Joshi
;-
;
if ~n_elements(numN) then numN = 30
RmnG = strarr(numN)

RmnG = strupcase(Roman(indgen(numN)+1))

if n_elements(lowcase) then RmnG = strlowcase(RmnG)


return, RmnG

end