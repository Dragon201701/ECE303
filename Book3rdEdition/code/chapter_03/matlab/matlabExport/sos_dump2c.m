function sos_dump2c(filename, varname, coeffs, SOS_length)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/  Filename: sos_dump2c.m
%/
%/  Synopsis: Dumps SOS filter coefficients to file in C language format in forward 
%/            order.  Creates two files; "filename.h" which defines the size of the array
%/            and declares the array as extern, and "filename.c" which contains the
%/            instance of the array variable.  Only 5 terms are written per section, a0
%/            is ignored.  The output array order is {b0, b1, b2, -a1, -a2}.
%/           
%/            "chdir" to the desired directory PRIOR to execution, or provide full
%/            path for filename.
%/
%/     Usage: sos_dump2c('coeff', 'B', filt1.ss, size(filt1.ss, 1))
%/
%/ Arguments: filename   - Filename to open for writing coefficients to, no extension
%/            varname    - Name to be assigned to coefficient array
%/            coeffs     - Vector with FIR filter coefficients
%/            SOS_length - Length of array (sections) desired (padded with zeros if necessary)
%/
%//////////////////////////////////////////////////////////////////////

j = fopen([filename '.h'],'w');
fprintf(j, '/* %-40s */\n', [filename '.h']);
fprintf(j, '/* SOS filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using sos_dump2c.m  */\n');
fprintf(j, '/* order is {b0, b1, b2, -a1, -a2}          */\n\n\n');
fprintf(j, '#define %s_SIZE %d\n\n', varname, SOS_length);
fprintf(j, 'extern float %s[][5];\n\n', varname);
      
fclose(j);

j = fopen([filename '.c'],'w');
fprintf(j, '/* %-40s */\n', [filename '.c']);
fprintf(j, '/* SOS filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using sos_dump2c.m  */\n');
fprintf(j, '/* order is {b0, b1, b2, -a1, -a2}          */\n\n\n');
fprintf(j, '#include "%s"\n\n', [filename '.h']);
fprintf(j, 'float %s[%s_SIZE][5] = {\n', varname, varname);

for i=1:SOS_length
   if i <= size(coeffs, 1)
      fprintf(j, '{%12g, %12g, %12g, %12g, %12g}, /* %s[%d] */\n', ...
          coeffs(i,1), coeffs(i,2), coeffs(i,3), -coeffs(i,5), -coeffs(i,6), varname, i-1);
   else
      fprintf(j, '{%12g, %12g, %12g, %12g, %12g}, /* %s[%d] */\n', ...
                1, 0, 0, 0, 0, varname, i-1);
   end
end
fprintf(j, '};\n');
fclose(j);
