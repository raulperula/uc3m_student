function [fl re]=lines(aa)
%Divide text in lines.
%aa->input image; fl->first line; re->remain line
%Example:
% aa=imread('heavy_metal.bmp');
% [fl re]=lines(aa);
% subplot(3,1,1);imshow(aa);title('INPUT IMAGE')
% subplot(3,1,2);imshow(fl);title('FIRST LINE')
% subplot(3,1,3);imshow(re);title('REMAIN LINES')
aa=clip(aa);
r=size(aa,1);
for s=1:r
    if sum(aa(s,:))==0
        nm=aa(1:s-1,1:end);%First line matrix
        rm=aa(s:end,1:end);%Remain line matrix
        fl=~clip(~nm);
        re=~clip(~rm);
        %*-*-*Uncomment lines below to see the result*-*-*-*-
        %         subplot(2,1,1);imshow(fl);
        %         subplot(2,1,2);imshow(re);
        break
    else
        fl=~aa;%Only one line.
        re=[];
    end
end