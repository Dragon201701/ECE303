%//////////////////////////////////////////////////////////////////////
%/ Welch, Wright, & Morrow, 
%/ Real-time Digital Signal Processing, 2005
%/
%/ m-file to test the FFT routine for the DSK
%/
%//////////////////////////////////////////////////////////////////////

% comment out ONE of the lines below to control text file generation
%txtFile=1; % makes a text file copy in your directory
txtFile=0; % does NOT make a text file

% Simulation inputs, real numbers only
x = [0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0]; 
x=x'; % turn into column vector for printing

N=length(x);

y=fft(x); % result will be complex
% for easier printing
yr=real(y);
yi=imag(y);

fprintf(1,'FFT Results for N=%i \n',N);
fprintf(1,'  Input \t\t Real\t\t Imaginary\n');
for I=1:N
    fprintf(1,'%8.3f \t %8.3f \t %8.3f\n',x(I),yr(I),yi(I));
end

% generate text file copy of results
% Notepad has trouble with \n 
% Open and save from WordPad or Word to fix
if txtFile == 1
    fid = fopen('fft_ex.txt','w');
    fprintf(fid,'FFT Results for N=%i \n',N);
    fprintf(fid,'  Input       Real       Imaginary\n');
    for I=1:N
        fprintf(fid,'%8.3f  %8.3f  %8.3f \n',x(I),yr(I),yi(I));
    end
    fclose(fid);
end





