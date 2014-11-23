%% Generacion de puntos de una recta entre dos puntos
function [ x,y ] = generationPoint( Xpos,Ypos,stepNumber )

%X = [-1.02, -0.4418, -0.4183, -0.9109, -1.036, -1.02];
%Y = [ 2.111,  1.151, -0.3928,  -1.099, -0.526, 2.111];
% stepNumber = 50;
    
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

end