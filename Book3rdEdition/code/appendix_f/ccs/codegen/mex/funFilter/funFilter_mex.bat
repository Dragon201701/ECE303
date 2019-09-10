@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2015a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2015a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=funFilter_mex
set MEX_NAME=funFilter_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for funFilter > funFilter_mex.mki
echo COMPILER=%COMPILER%>> funFilter_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> funFilter_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> funFilter_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> funFilter_mex.mki
echo LINKER=%LINKER%>> funFilter_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> funFilter_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> funFilter_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> funFilter_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> funFilter_mex.mki
echo BORLAND=%BORLAND%>> funFilter_mex.mki
echo OMPFLAGS= >> funFilter_mex.mki
echo OMPLINKFLAGS= >> funFilter_mex.mki
echo EMC_COMPILER=msvc100>> funFilter_mex.mki
echo EMC_CONFIG=optim>> funFilter_mex.mki
"C:\Program Files\MATLAB\R2015a\bin\win64\gmake" -B -f funFilter_mex.mk
