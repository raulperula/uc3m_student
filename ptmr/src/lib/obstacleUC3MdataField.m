%% Calculo del potencial de repulsión de los obstáculos -edificios de UC3M

function [ Vo,xo1, yo1, xo2, yo2, xo3_4, yo3_4, xo5_6, yo5_6, xo7,yo7 ] = ...
          obstacleUC3MdataField(X, Y, VinitZero )
% X, Y .. matriz que defiene la area del campo potencial
%VinitZero .. Inicialización de la matriz potencial
      
    %Posicion de los edificios - obstáculos
    factorGain = 40;
    % edificio 1
    X1 = [-1.02, -0.4418, -0.4183, -0.9109, -1.036, -1.02] .*factorGain;
    Y1 = [ 2.111,  1.151, -0.3928,  -1.099, -0.526, 2.111] .*factorGain;
    % edificio 2
    X2 = [-0.864, -0.3245, 0.2619, -0.2776, -0.864] .*factorGain;
    Y2 = [-1.671, -2.5500, -1.591, -0.6858, -1.671] .*factorGain;
    % edificio 3,4
    X3_4 = [0.6138, 1.216, 1.2160, 0.8249,  0.9578,  0.6919,  0.4261,  0.5981, 0.6138] .*factorGain;
    Y3_4 = [1.1250, 1.991, 0.3395, 0.2863, -0.2197, -0.6591, -0.2064,  0.1798, 1.1250] .*factorGain;
    % edificio 5,6
    X5_6 = [-0.215, 0.6138, 0.880, 0.2697, -0.215] .*factorGain;
    Y5_6 = [ 1.072, 2.4570, 2.084, 0.9787,  1.072] .*factorGain;
    % edificio 7
    X7 = [-1.224, -1.099, -1.099, -1.229, -1.224] .*factorGain;
    Y7 = [ 2.403,  2.137, 0.8722,  0.855,  2.403] .*factorGain;

%     Vo1  = VinitZero;     %edificio1
%     Vo2  = VinitZero;     %edificio2
%     Vo3_4= VinitZero;   %edificio3,4
%     Vo5_6= VinitZero;   %edificio5,6
%     Vo7  = VinitZero;     %edicifio7
   % Vo   = VinitZero;
   V1o     = VinitZero;
   V2o     = VinitZero;
   V3_4o   = VinitZero;
   V5_6o   = VinitZero;
   V7o     = VinitZero;
   

    % Potencial de repulsión de los obstáculos
    Ko1  = 30; 
    Ko2  = 40;
    Ko3_4= 20;
    Ko5_6= 25;
    Ko7  = 20;
    stepNumber = 60;
    [xo1, yo1]=generationPoint(X1, Y1, stepNumber);
    [xo2, yo2]=generationPoint(X2, Y2, stepNumber);
    [xo3_4, yo3_4]=generationPoint(X3_4, Y3_4, stepNumber);
    [xo5_6, yo5_6]=generationPoint(X5_6, Y5_6, stepNumber);
    [xo7, yo7]=generationPoint(X7, Y7, stepNumber);

    %# X Y son los puntos del potencial
    for i=1:length(xo1)
        Vo1 = Ko1 ./sqrt((X-xo1(i)).^2+(Y-yo1(i)).^2);
        V1o=V1o+Vo1;
     end
    for i=1:length(xo2)
        Vo2=Ko2 ./sqrt((X-xo2(i)).^2+(Y-yo2(i)).^2);
        V2o=V2o+Vo2;
    end
    for i=1:length(xo3_4)
        Vo3_4=Ko3_4 ./sqrt((X-xo3_4(i)).^2+(Y-yo3_4(i)).^2);
        V3_4o=V3_4o+Vo3_4;
    end
    for i=1:length(xo5_6)
        Vo5_6=Ko5_6 ./sqrt((X-xo5_6(i)).^2+(Y-yo5_6(i)).^2);
        V5_6o=V5_6o+Vo5_6;
    end
    for i=1:length(xo7)
        Vo7=Ko7 ./sqrt((X-xo7(i)).^2+(Y-yo7(i)).^2);
        V7o=V7o+Vo7;
    end
    Vo = V1o + V2o + V3_4o + V5_6o + V7o;
    
    %hold on
    %fill(xo1,yo1,'b',xo2,yo2,'r',xo3_4,yo3_4,'m',xo5_6,yo5_6,'y',xo7,yo7,'g')  %fill obstáculos
    %plot(xo1,yo1,'b',xo2,yo2,'r',xo3_4,yo3_4,'m',xo5_6,yo5_6,'y',xo7,yo7,'g')   %plot obstáculos+

end


