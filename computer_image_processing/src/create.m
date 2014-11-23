function [net] = create()
%CREATE 

% Definición de matrices y constantes
[patron targets] = alphabet();

% 20 neuronas intermedias, 36 de salida (S2)
S1 = 60;
S2 = size(targets, 1);

% Define la red
% net = newff(minmax(patron), targets, [S1 S2], {'logsig' 'logsig'}, 'traingdx');
net = newff(minmax(patron), targets, [S1 S2], {'logsig' 'logsig'}, 'trainlm');

% Reduce los valores iniciales de los parámetros de la capa de salida
net.LW{2,1} = net.LW{2,1} * 0.01;
net.b{2} = net.b{2} * 0.01;

end
