* Welch, Wright, & Morrow, 
* Real-time Digital Signal Processing, 2011

*//////////////////////////////////////////////////////////////////////
*/ Filename: vectors.asm
*/
*/ Synopsis: Interrupt vector table for OMAP-L138 DSP
*/
*//////////////////////////////////////////////////////////////////////

    .ref    _c_int00
    .ref    _Codec_ISR        
  
    .sect   "vectors"
	.nocmp	; do not allow 16 bit instructions to be used in the vector table
			; so everything remains aligned
RESET_RST:
    MVKL .S2 _c_int00, B0
    MVKH .S2 _c_int00, B0
    B    .S2 B0
	NOP
	NOP
	NOP
	NOP
    NOP
NMI_RST:  b NMI_RST	; stall here if interrupt occurs  
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
RESV1:	b RESV1	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
RESV2:	b RESV2	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT4:   b INT4	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT5:   b INT5	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT6: 	b INT6	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT7:   b INT7	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT8:   b INT8	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT9:   b INT9	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT10:   b INT10	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT11:  b INT11	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT12:  b _Codec_ISR
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT13:   b INT13	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT14:   b INT14	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
INT15:   b INT15	; stall here if interrupt occurs
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
 

