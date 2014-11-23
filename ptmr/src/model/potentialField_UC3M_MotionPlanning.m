% Planificación de rutas por el campus de UC3M de Leganés por Campos Potenciales
clear all
clc
close all
addpath('../data')
addpath('../lib')


%..Definición del area del campo.................................%
dh=6; %paso
X=-60:dh:60; %60
Y=-150:dh:150; %150
[X,Y]=meshgrid(X,Y);

%..Punto de partida y Punto de llegada.............................%
xO=[20;-14];   % posición inicial
xT=[-50;-100];   % posición final

Kr=30; %coeficiente de fuerza de repulsión 
Ka=20; %coeficiente de fuerza de atracción 

Vr=Kr./sqrt((X-xO(1)).^2+(Y-xO(2)).^2); % Potencial de repulsión inicial
[fxr,fyr]=gradient(Vr,dh,dh);

Va=0.5*Ka.*sqrt((X-xT(1)).^2+(Y-xT(2)).^2); % Potencial de atracción final
[fxa,fya]=gradient(Va,dh,dh);

%..Potencial de los obstáculos/edificios de UC3M................................%
VinitZero = zeros(size(Vr));
[ Vo,... %potencial 
  xo1, yo1, xo2, yo2, xo3_4, yo3_4, xo5_6, yo5_6, xo7,yo7 ] =... %puntos de los obstáculos
  obstacleUC3MdataField(X,Y, VinitZero); 

[fxo,fyo]=gradient(Vo,dh,dh);%Vo está calculado dentro de obstacleData.m en la carperta data

%..Suma de potenciales.....................................................%
fX=  - fxo  - fxr - fxa ;
fY=  - fyo  - fyr - fya ;
quiver(X,Y,fX,fY,'k')   %representa los vectores de fuerza
title('Potential Field of Area')
xlabel('X - Axis')
ylabel('Y - Axis')
hold on
plot(xO(1),xO(2),'ro',xT(1),xT(2),'r*') %plot punto inicial, punto final
fill(xo1,yo1,'b',xo2,yo2,'r',xo3_4,yo3_4,'m',xo5_6,yo5_6,'y',xo7,yo7,'g')  %fill obstáculos
plot(xo1,yo1,'b',xo2,yo2,'r',xo3_4,yo3_4,'m',xo5_6,yo5_6,'y',xo7,yo7,'g')   %plot obstáculos
hold off
   

.....Calculo de la trayectoria..........................................%
[ xp, yp, ix, iy]= potentialFieldPathPlanning( X, Y, fX, fY, dh, xO, xT);

hold on
plot(xp, yp, 'r')

Vf = (Vr)+(Va)+(Vo);

figure
surf(X,Y,Vf)

title('Potential Surface')

aa=1;
 for asd = 1:length(ix)/aa
     ixr(asd)= ix(asd *aa);
     iyr(asd)= iy(asd *aa);
     izr (asd)= Vf(ixr(asd),iyr(asd));
 end
 figure
 plot3(iyr,ixr,izr)
 


