// Welch, Wright, & Morrow,
// Real-time Digital Signal Processing, 2017

///////////////////////////////////////////////////////////////////////
// Filename: lnk6713.cmd
//
// Synopsis: Linker command file for 6713 DSK
//
///////////////////////////////////////////////////////////////////////
-c
-heap  0x400
-stack 0x400  // very large stack for DSP programs.
-lrts6700.lib // floating point library
  
MEMORY
{
    vecs:       o = 00000000h   l = 00000200h
    IRAM:       o = 00000200h   l = 0003FE00h                           
    SDRAM:      o = 80000000h	l = 01000000h 
}

SECTIONS
{
    "vectors"   >       vecs 
    .cinit      >       IRAM
    .text       >       IRAM
    .stack      >       IRAM
    .bss        >       IRAM
    .const      >       IRAM
    .data       >       IRAM
    .far        >       IRAM
    .switch     >       IRAM
    .sysmem     >       IRAM
    .tables     >       IRAM
    .cio        >       IRAM
    "CE0"		>		SDRAM
}                             

 
