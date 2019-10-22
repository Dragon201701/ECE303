function SOS2C(filename, varname, SOS, G)
%//////////////////////////////////////////////////////////////////////////
%/  Allie 2013
%/  Assumes fdatool was run and the SOS sections were exported to 
%/  Workspace as coefficients with the sos matrix named 'SOS' and scale
%/  values named 'G'. 
%/
%/      IMPORTANT: this routine assumes that fdatool generates the 
%/      denominator coeffs (a1 and a2 )with the products a1y1 and a2y2
%/      subtracted from the x0b0, x1b1 and x2b2 partial sum. Your
%/      biquad code should use this method. If the biquad adds the a1y1
%/      and a2y2 products then invert the signs of the a1 and a2
%/      coefficients as they are written to the .c file
%/
%/  filename: SOS2C
%/
%/  Synopsis: Writes an SOS filter coefficient matrix to a file in C 
%/  language format. Creates two files; "filename.h" which defines the size
%/  of the matrix and declares the matrix as extern, and "filename.c" which
%/  contains the instance of the matrix variable. The coefficient matrix is
%/  N by 6, where N is the number of second order sections designed with the 
%/  fdatool. The gain of each SOS is built into the direct (numerator)
%/  coefficients.
%/
%/ Usage:
%/  SOS2C( 'LP-8th-1000of48K','SOS_1', SOS, G)
%/
%/  Arguments:
%/  filename - specifies the name of the .c and .h files generated.
%/      This is a string. This function will append a .c and .h to the
%/      created files.
%/  varname - specifies the name of the SOS matrix for the C module.
%/      This is a string. The funtion will define a matix with the name
%/      varname.
%/  SOS - is the SOS matrix from fdatool
%/  G - is the gain vector from the fdatool
%/
%//////////////////////////////////////////////////////////////////////////


GSOS=SOS;
[rowSOS,colSOS]=size(SOS);
[rowG,colG]=size(G);
modG=zeros(rowG-1,1);
modG(1:rowG-1,1)=G(1:rowG-1,1);
GSOS=[modG(:,1).*SOS(:,1),modG(:,1).*SOS(:,2),modG(:,1).*SOS(:,3),SOS(:,4),SOS(:,5),SOS(:,6)];
SOS
GSOS

j = fopen([filename '.h'],'w');
fprintf(j, '/* %-40s */\n', [filename '.h']);
fprintf(j, '/* SOS filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using sos_dump2c.m  */\n');
fprintf(j, '/* order is {b0, b1, b2, a0, a1, a2}        */\n\n\n');
fprintf(j, '#define %s_SECTIONS %d\n\n', varname, rowSOS);
fprintf(j, 'extern float %s[%s_SECTIONS][6];\n\n', varname, varname);
      
fclose(j);

j = fopen([filename '.c'],'w');
fprintf(j, '/* %-40s */\n', [filename '.c']);
fprintf(j, '/* SOS filter coefficients                  */\n');
fprintf(j, '/* exported from MATLAB using SOS2c.m  */\n');
fprintf(j, '/* order is {b0, b1, b2, a0, a1, a2}          */\n\n\n');
fprintf(j, '#include "%s"\n\n', [filename '.h']);
fprintf(j, 'float %s[%s_SECTIONS][6] = {\n', varname, varname);

for i=1:rowSOS
      fprintf(j, '{%12g, %12g, %12g, %2g, %12g, %12g}, /* %s[%d] */\n', ...
          GSOS(i,1), GSOS(i,2), GSOS(i,3), 1, GSOS(i,5), GSOS(i,6), varname, i-1);
end
fprintf(j, '};\n');
fclose(j);
