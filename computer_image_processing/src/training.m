function [net] = training(net)

% Definición de matrices y constantes
[patron targets] = alphabet();

% Dimensiones patron
[R Q] = size(patron);

% Entrena primera vez (sin ruido)
% ==================================
% Condiciones de entrenamiento
net.performFcn = 'sse';         % Validación por error medio cuadrático
net.trainParam.goal = 0.1;      % Error medio cuadrático deseado
net.trainParam.show = 20;       % Frecuencia de visualización (en épocas)
net.trainParam.epochs = 5000;   % Épocas
net.trainParam.mc = 0.95;       % Constante de momento
net.trainParam.showWindow = false; % Ocultar interfaz entrenamiento

% Entrena la red
P = patron;
T = targets;
[net tr] = train(net, P, T);

% Entrena segunda vez (con ruido)
% ===============================
% Parámetros de entrenamiento
net.trainParam.goal = 0.6;      % Error medio cuadrático deseado
net.trainParam.epochs = 300;    % Número de épocas

% Se entrena con 10 conjuntos de datos que representan letras
% ruidosas y no ruidosas intercaladas
T = [targets targets targets targets targets];
for pass = 1:10
    P = [patron, patron,...
        (patron + randn(R, Q) * 0.1),...
        (patron + randn(R, Q) * 0.2),...
        (patron + randn(R, Q) * 0.3)];
    [net tr] = train(net, P, T);
end

% Entrena tercera vez (sin ruido)
% =========================================
net.trainParam.goal = 0.1;      % Error medio cuadrático deseado
net.trainParam.epochs = 500;    % Número de épocas
net.trainParam.show = 5;        % Frecuencia de visualización (en épocas)

P = patron;
T = targets;
[net tr] = train(net, P, T);

end
