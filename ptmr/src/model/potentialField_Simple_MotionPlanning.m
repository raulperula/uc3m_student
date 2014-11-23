clear all
clc
close all

%....Dimensión del plano XY..........%
dh=.4;
X=-5:dh:5;
Y=-5:dh:5;
[X,Y]=meshgrid(X,Y); 

%.....Parámetros de inicio...............%
x0=[-4;2];   % posición inicial
xT=[0;-4];   % posición final

Kr=10; %coeficiente de fuerza de repulsión %30
Vr=Kr./sqrt((X-x0(1)).^2+(Y-x0(2)).^2); % Potencial de repulsión inicial
[fxr,fyr]=gradient(Vr,dh,dh);

Ka=40; %coeficiente de fuerza de atracción %25
Va=Ka.*sqrt((X-xT(1)).^2+(Y-xT(2)).^2); % Potencial de atracción final
[fxa,fya]=gradient(Va,dh,dh);


%.....Obstáculo circuferencia..............%
% centro del obstáculo 1
cx1=0;  
cy1=0;
% centro del obstáculo 2
cx2=1;
cy2=1;
rad=1+.1;   %radio del obstáculo
th=(0:.1*dh:2).*pi; %ángulo 0-2pi
% circunferencia
xo=rad.*cos(th);
yo=rad.*sin(th);
%translación de la circunferencia - obstáculo
xo1=xo-cx1;
yo1=yo-cy1;
xo2=xo-cx2;
yo2=yo-cy2;

Vo1=[];
Vo2=[];
Vo=zeros(size(Vr));

% Potencial de repulsión de los obstáculos
Ko=5; %5
for i=1:length(th)
    Vo1=Ko./sqrt((X-xo1(i)).^2+(Y-yo1(i)).^2);
    Vo2=Ko./sqrt((X-xo2(i)).^2+(Y-yo2(i)).^2);
    Vo=Vo+Vo1+Vo2;  
end

%.....Suma de potenciales..................%
[fxo,fyo]=gradient(Vo,dh,dh);
fX=-fxr-fxa-fxo;
fY=-fyr-fya-fyo;
quiver(X,Y,fX,fY,'k')   %representa los vectores de fuerza
title('Potential Field of Area')
xlabel('X-Axis')
ylabel('Y-Axis')
hold on
plot(x0(1),x0(2),'ro',xT(1),xT(2),'r*') %plot punto inicial, punto final
fill(xo1,yo1,'b',xo2,yo2,'b')           %fill obstáculos
plot(xo1,yo1,'b',xo2,yo2,'b')           %plot obstáculos
hold off


%.....Planificación de la trayectoria según el campo potencial.......%
ss=1;
k=1;
xp=[];
yp=[];
xp(1)=x0(1);
yp(1)=x0(2);
ix=[];
iy=[];
jx=[];
jy=[];
fxx=0;
fyy=0;

while ss
    Pw=sqrt(((X-xp(k)).^2)+((Y-yp(k)).^2)); %Pw matrix de distancia respecto a la posicion actual
    xw(k)=min(min(Pw));          % valor mínimo de la matriz Pw
    [iix,iiy]=find(Pw==xw(k));   % encontrar la posición del matriz del valor mín
    ix(k)=iix(1);
    iy(k)=iiy(1);
    fx1=fX(ix(k),iy(k)); % busca el potencial mínimo del punto actual
    fy1=fY(ix(k),iy(k));
    fxx(k)=fx1./norm(fX); % convierte el potencial en su valor unitario
    fyy(k)=fy1./norm(fY);
    %ff(k,:)=[fX(ix(k),iy(k)),fY(ix(k),iy(k))];
    xp(k+1)=xp(k)+dh*(fxx(k)); % calcula el siguiente punto
    yp(k+1)=yp(k)+dh*(fyy(k));
    if (sqrt((xp(k+1)-xT(1)).^2+(yp(k+1)-xT(2)).^2)<=0.4)
        ss=0;
    end
    
    hold on
    plot(xp(k),yp(k),'r')
    
    k=k+1;
end

% figure
% surf(X,Y,(Vr)+(Va)+(Vo))
% title('Potential Surface')
