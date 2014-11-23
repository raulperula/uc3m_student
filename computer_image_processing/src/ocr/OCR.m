%OCR (Optical Character Recognition).
%PRINCIPAL PROGRAM
%*********************************************************

warning off
clc, close all, clear all

imagen=imread('TEST.bmp');%Read Binary Image

%Try with images:heavy_metal.bmp, scanner.bmp
imshow(imagen);title('INPUT IMAGE WITH NOISE')

%*-*-*Filter Image Noise*-*-*-*
if length(size(imagen))==3 %RGB image
    imagen=rgb2gray(imagen);
end
imagen = medfilt2(imagen);
[f c]=size(imagen);
imagen (1,1)=255;
imagen (f,1)=255;
imagen (1,c)=255;
imagen (f,c)=255;
%*-*-*END Filter Image Noise*-*-*-*
word=[];%Storage matrix word from image
re=imagen;
fid = fopen('text.txt', 'wt');%Opens text.txt as file for write
while 1
    [fl re]=lines(re);%Fcn 'lines' separate lines in text
    imgn=~fl;
		
    %*-*Uncomment line below to see lines one by one*-*-*-*
%        imshow(fl);pause(1)
    %*-*--*-*-*-*-*-*-
		
    %*-*-*-*-*-Calculating connected components*-*-*-*-*-
    %Code from:
    %http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=8031&objectType=FILE
    L = bwlabel(imgn);
    mx=max(max(L));
    BW = edge(double(imgn),'sobel');
    [imx,imy]=size(BW);
    for n=1:mx
        [r,c] = find(L==n);
        rc = [r c];
        [sx sy]=size(rc);
        n1=zeros(imx,imy);
        for i=1:sx
            x1=rc(i,1);
            y1=rc(i,2);
            n1(x1,y1)=255;
        end
        %*-*-*-*-*-END Calculating connected components*-*-*-*-*
				
        n1=~n1;
        n1=~clip(n1);
        img_r=same_dim(n1);%Transf. to size 42 X 24
				
        %*-*Uncomment line below to see letters one by one*-*-*-*
%                imshow(img_r);pause(1)
        %*-*-*-*-*-*-*-*
				
        letter=read_letter(img_r);%img to text
        word=[word letter];
    end
    %fprintf(fid,'%s\n',lower(word));%Write 'word' in text file (lower)
    fprintf(fid,'%s\n',word);%Write 'word' in text file (upper)
    word=[];%Clear 'word' variable
		
    %*-*-*When the sentences finish, breaks the loop*-*-*-*
    if isempty(re)  %See variable 're' in Fcn 'lines'
        break
    end
    %*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
end
fclose(fid);
open('text.txt') %Open 'text.txt' file
