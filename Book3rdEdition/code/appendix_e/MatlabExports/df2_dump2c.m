function df2_dump2c(filename, varname, coeffs)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2017
%/
%/  Filename: df2_dump2c.m
%/
%/  Synopsis: Dumps DF2 filter coefficient vectors to file in C language format in forward 
%/            order.  Creates two files; "filename.h" which defines the size of the array
%/            and declares the arrays as extern, and "filename.c" which contains the
%/            instances of the array variable.  Appends '_B' to numerator variable name
%/             and '_A' to denominator variable name.
%/           
%/            "chdir" to the desired directory PRIOR to execution, or provide full
%/            path for filename.
%/
%/     Usage: df2_dump2c('HPF_coeff', 'HPF', filt1.tf)
%/
%/ Arguments: filename   - Filename to open for writing coefficients to, no extension
%/            varname    - Base variable name to be assigned to coefficient arrays
%/            coeffs     - Transfer function (tf) data object with 'den' and 'num' members
%/
%//////////////////////////////////////////////////////////////////////

j = fopen([filename '.h'],'w');
fprintf(j, '/* %-40s */\n', [filename '.h']);
fprintf(j, '/* DF2 filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using df2_dump2c.m  */\n\n\n');
fprintf(j, '#define %s_SIZE %d\n\n', [varname '_B'], length(coeffs.num));
fprintf(j, 'extern float %s[];\n\n', [varname '_B']);
fprintf(j, '#define %s_SIZE %d\n\n', [varname '_A'], length(coeffs.den));
fprintf(j, 'extern float %s[];\n\n', [varname '_A']);
      
fclose(j);

j = fopen([filename '.c'],'w');
fprintf(j, '/* %-40s */\n', [filename '.c']);
fprintf(j, '/* DF2 filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using fir_dump2c.m  */\n\n\n');
fprintf(j, '#include "%s"\n\n', [filename '.h']);

fprintf(j, 'float %s[%s_SIZE] = {\n', [varname '_B'], [varname '_B']);
for i=1:length(coeffs.num)
      fprintf(j, '%12g,	/* %s[%d] */\n', coeffs.num(i), [varname '_B'], i-1);
end
fprintf(j, '};\n\n\n');

fprintf(j, 'float %s[%s_SIZE] = {\n', [varname '_A'], [varname '_A']);
for i=1:length(coeffs.den)
      fprintf(j, '%12g,	/* %s[%d] */\n', coeffs.den(i), [varname '_A'], i-1);
end
fprintf(j, '};\n');
fclose(j);
