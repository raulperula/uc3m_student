%Generacion de puntos de una recta entre dos puntos
%function [ x,y ] = generationPoint( Xpos,Ypos,stepNumber )
clear all
close all
clc

Xpos = ([-1.02, -0.4418, -0.4183, -0.9109, -1.036, -1.02] +0.2);
Ypos = ([ 2.111,  1.151, -0.3928,  -1.099, -0.526, 2.111] +0.09);
 stepNumber = 50;

    %step X
    for j=2:length(Xpos) 
       stepX(j-1) =(Xpos(j)-Xpos(j-1))/stepNumber;   
    end
    %step Y
    for k=2:length(Ypos) 
       stepY(k-1) =(Ypos(k)-Ypos(k-1))/stepNumber;   
    end

    elementX=1;
    elementY=1;

    for abc = 1: length(Xpos)-1
        for i = 0:stepNumber
            x(elementX)=Xpos(abc)+ stepX(abc) * i;
            elementX=elementX+1;
        end
       for i = 0:stepNumber
            y(elementY)=Ypos(abc)+ stepY(abc) * i;
            elementY=elementY+1;
       end

    end
   
   % plot(x,y,'r')
    plot(x,'r') 
   hold on 
    
    

    dh = 0.05;
    
    %% calculo de los valores en X e Y
    ixObstaclePoint = 1; % Contador del vector de puntos de X
    mm = 1;              % contador del vector de la pendiente
    %....Calculo de la pendiente de la recta..............................%
    mpr=zeros(1,length(Xpos)-1); % creo un vector para las pendientes
    for ipr = 1:length(mpr)
        mpr(ipr) = (Ypos(ipr+1)-(Ypos(ipr)))/(Xpos(ipr+1)-(Xpos(ipr)));
    end
    
    %.....calculo de los.valores de X ....................................%
    for ii=2:length(Xpos) % length(Xpos) 
        
        addXpos = Xpos(ii-1);
        %# Calcular el número de sumas de dh (countxg) necesarias para alcanzar el
        %# siguiente posicion
        countxg = 0;
       
        %# saber si hay que sumar o restar dh
        if (Xpos(ii -1) > Xpos(ii))
            dh = -dh;
        end
        if (Xpos(ii -1) < Xpos(ii))
            dh = abs(dh);
        end
        
       if(dh>0)
            while (addXpos <= Xpos(ii))
                addXpos =addXpos + dh;
                countxg = countxg + 1;
            end
       end
       if(dh<0)
            while (addXpos >= Xpos(ii))
                addXpos =addXpos + dh;
                countxg = countxg + 1;
            end
       end
       
       
        %# ahora que sé cuantas sumas tengo que hacer, crear los punto   
        xgp=zeros(1,countxg+1); % creo un vector para las posiciones nuevas
        xgp(1)= Xpos(ii-1);    % inicializo el vector de X de una recta
        for ig=1:countxg
            xgp(ig+1)=xgp(ig) + dh; % xgp 'x generate points'
        end
        
        %# con la pendiente de cada recta calculo los puntos de Y
        ygp=zeros(1,length(xgp)); %creo un vector para los valores de Y de una recta
        for j = 1:countxg
           ygp(j) = mpr(mm) * xgp(j);
        end
        
        %# Los paso a un vector final que contengan los punto de X e Y
        for igox = 1:countxg+1
            Xop(ixObstaclePoint) = xgp(igox); %Xop vector of X Obstacle Point
            Yop(ixObstaclePoint) = ygp(igox); 
            ixObstaclePoint = ixObstaclePoint + 1;
        end 
        
        mm = mm +1;
    end
    Xop(ixObstaclePoint)=Xpos(length(Xpos));
    Yop(ixObstaclePoint)=Ypos(length(Ypos));
   
    
   % plot(Xop, Yop)
   figure 
   plot (Xop)
  

%end