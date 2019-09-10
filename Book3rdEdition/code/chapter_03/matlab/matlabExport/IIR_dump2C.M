function IIR_dump2C(filename, varname, coeffs, varname2, coeffs2, IIR_length)
%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2012
%/
%/ Modified April 2013 to remove unnecessary brackets and to change format
%/ of coefficients from %14.12f to %12g to provide greater precision
%/
%/ Dumps IIR filter coefficients to file in C language format in forward order.
%/ "chdir" to the desired directory PRIOR to execution ... this will provide 
%/ for increased c code portability
%/
%/ e.g. IIR_dump2c('coeff','B',filt1.tf.num,'A',filt1.tf.den,length(filt1.tf.den))
%/
%/ Arguments: filename - Filename to open for writing coefficients to, no extension
%/            varname  - Name to be assigned to the numerator coefficient array
%/            coeffs   - Vector with FIR filter coefficients
%/            varname2 - Name to be assigned to the denominator coefficient array
%/            coeffs2  - Vector with IIR filter coefficients
%/            length   - Length IIR data desired (padded with zeros if necessary)
%/
%//////////////////////////////////////////////////////////////////////


j = fopen([filename '.h'],'w');
%fprintf(1, 'File opened - %d returned\n', j);
fprintf(j, '/* %-35s */\n', [filename '.h']);
fprintf(j, '/* IIR filter coefficients             */\n');
fprintf(j, '/* exported by MATLAB using IIR_dump2C */\n');
fprintf(j, '/* Michael G. Morrow - 2000            */\n\n\n');
fprintf(j, '#define N %d\n\n', IIR_length);
fprintf(j, 'extern float %s[];\n\n', varname);
fprintf(j, 'extern float %s[];\n\n', varname2);
      
fclose(j);

j = fopen([filename '.c'],'w');
%fprintf(1, 'File opened - %d returned\n', j);
fprintf(j, '/* %-35s */\n', [filename '.c']);
fprintf(j, '/* IIR filter coefficients             */\n');
fprintf(j, '/* exported by MATLAB using IIR_dump2C */\n');
fprintf(j, '/* Michael G. Morrow - 2000, 2013      */\n\n\n');
fprintf(j, '#include "%s"\n\n', [filename '.h']);
fprintf(j, 'float %s[N] = {\n', varname);

for i=1:IIR_length
   if i <= length(coeffs)
      fprintf(j, '%12g,	/* B[%d] */\n', coeffs(i),i-1);
   else
      fprintf(j, '%12g,	/* ;B[%d] */\n',0,i-1);
   end
end

fprintf(j, '};\n\n');
fprintf(j, 'float %s[N] = {\n', varname2);

for i=1:IIR_length
   if i <= length(coeffs2)
      fprintf(j, '%12g,	/* A[%d] */\n', coeffs2(i),i-1);
   else
      fprintf(j, '%12g,	/* ;A[%d] */\n',0,i-1);
   end
end
fprintf(j, '};\n');
fclose(j);
