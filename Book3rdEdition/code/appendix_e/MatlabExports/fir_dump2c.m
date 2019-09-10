function fir_dump2c(filename, varname, coeffs, FIR_length)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2017
%/
%/  Filename: fir_dump2c.m
%/
%/  Synopsis: Dumps FIR filter coefficient vector to file in C language format in forward 
%/            order.  Creates two files; "filename.h" which defines the size of the array
%/            and declares the array as extern, and "filename.c" which contains the 
%/            instance of the array variable.
%/           
%/            "chdir" to the desired directory PRIOR to execution, or provide full
%/            path for filename.
%/
%/     Usage: fir_dump2c('coeff', 'B', filt1.tf.num, length(filt1.tf.num))
%/
%/ Arguments: filename   - Filename to open for writing coefficients to, no extension
%/            varname    - Variable name to be assigned to coefficient array
%/            coeffs     - 1xN vector with FIR filter coefficients
%/            FIR_length - Length of array desired (padded with zeros if necessary)
%/
%//////////////////////////////////////////////////////////////////////

j = fopen([filename '.h'],'w');
fprintf(j, '/* %-40s */\n', [filename '.h']);
fprintf(j, '/* DF2 filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using fir_dump2c.m  */\n\n\n');
fprintf(j, '#define %s_SIZE %d\n\n', varname, FIR_length);
fprintf(j, 'extern float %s[];\n\n', varname);
      
fclose(j);

j = fopen([filename '.c'],'w');
fprintf(j, '/* %-40s */\n', [filename '.c']);
fprintf(j, '/* DF2 filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using fir_dump2c.m  */\n\n\n');
fprintf(j, '#include "%s"\n\n', [filename '.h']);
fprintf(j, 'float %s[%s_SIZE] = {\n', varname, varname);

for i=1:FIR_length
   if i <= length(coeffs)
      fprintf(j, '%12g,	/* %s[%d] */\n', coeffs(i), varname, i-1);
   else
      fprintf(j, '%12g,	/* %s[%d] */\n',         0, varname, i-1);
   end
end
fprintf(j, '};\n');
fclose(j);
