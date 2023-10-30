;
; by KK
;

.macro LOAD_CONST
ldi @0, high(@2)
ldi @1,  low(@2)
.endmacro

LOAD_CONST R17,R16,0x1234
