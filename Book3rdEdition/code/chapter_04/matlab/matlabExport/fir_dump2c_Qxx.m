function fir_dump2c_Qxx(filename, varname, coeffs, FIR_length, Qxx)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/  Filename: fir_dump2c.m
%/
%/  Synopsis: Dumps FIR filter coefficient vector to file in C language format in forward 
%/            order.  Creates two files; "filename.h" which defines the size of the array
%/            and declares the array as extern, and "filename.c" which contains the 
%/            instance of the array variable.  The coefficients are stored as Q format
%/            numbers.
%/           
%/            "chdir" to the desired directory PRIOR to execution, or provide full
%/            path for filename.
%/
%/     Usage: fir_dump2c_Qxx('coeff', 'B', filt1.tf.num, length(filt1.tf.num), 15)
%/
%/ Arguments: filename   - Filename to open for writing coefficients to, no extension
%/            varname    - Variable name to be assigned to coefficient array
%/            coeffs     - 1xN vector with FIR filter coefficients
%/            FIR_length - Length of array desired (padded with zeros if necessary)
%/            Qxx        - Specifies Q format to use (i.e. 12 or 15)
%/
%//////////////////////////////////////////////////////////////////////

% convert coefficients to Q format and check for out of range values
Qfactor = 2^Qxx;            % compute factor for chosen Q format
Qcoeffs = round(coeffs.*Qfactor);
for i=1:length(coeffs)
   if (Qcoeffs(i) > 32767) | (Qcoeffs(i) > 32767)
       fprintf(1, 'Error: Coefficient [%d] out of bounds in Q%d format', i, Qxx);
       return
   end
end

j = fopen([filename '.h'],'w');
fprintf(j, '/* %-40s */\n', [filename '.h']);
fprintf(j, '/* DF2 filter coefficients in Q%d format        */\n', Qxx);
fprintf(j, '/* exported from MATLAB using fir_dump2c_Qxx.m  */\n\n\n');
fprintf(j, '#define %s_SIZE %d\n\n', varname, FIR_length);
fprintf(j, 'extern short %s[];\n\n', varname);
      
fclose(j);

j = fopen([filename '.c'],'w');
fprintf(j, '/* %-40s */\n', [filename '.c']);
fprintf(j, '/* DF2 filter coefficients in Q%d format        */\n', Qxx);
fprintf(j, '/* exported from MATLAB using fir_dump2c_Qxx.m  */\n\n\n');
fprintf(j, '#include "%s"\n\n', [filename '.h']);
fprintf(j, 'short %s[%s_SIZE] = {\n', varname, varname);

for i=1:FIR_length
   if i <= length(coeffs)
      fprintf(j, '{%8d},	/* %s[%d] */\n', Qcoeffs(i), varname, i-1);
   else
      fprintf(j, '{%8d},	/* %s[%d] */\n',          0, varname, i-1);
   end
end
fprintf(j, '};\n');
fclose(j);
