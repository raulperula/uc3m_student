%Reconocimiento de caracteres

% Definición de matrices y constantes
[alphabet,targets] = prprob;
[R,Q] = size(alphabet);

% 10 neuronas intermedias, 26 de salida (S2)
S1 = 10;
[S2,Q] = size(targets);

% Define la red
net = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');

% Reduce los valores iniciales de los parámetros de la capa de salida
net.LW{2,1} = net.LW{2,1}*0.01;
net.b{2} = net.b{2}*0.01;

% Entrena la red sin ruído
% ==================================
% Condiciones de entrenamiento
net.performFcn = 'sse'; % Validación por error medio cuadrático
net.trainParam.goal = 0.1; % Error medio cuadrático deseado
net.trainParam.show = 20; % Frecuencia de visualización (en épocas)
net.trainParam.epochs = 5000; % Épocas
net.trainParam.mc = 0.95; % Constante de momento

% Entrena la red
P = alphabet;
T = targets;
[net,tr] = train(net,P,T);

% Entrena la red con ruído
% ===============================
% Parámetros de entrenamiento
net.trainParam.goal = 0.6; % Error medio cuadrático deseado
net.trainParam.epochs = 300; % Número de épocas

% Se entrena con 10 conjuntos de datos que representan letras
% ruidosas y no ruidosas intercaladas
T = [targets targets targets targets];
for pass = 1:10
fprintf('Pass = %.0f\n',pass);
P = [alphabet, alphabet, ...
(alphabet + randn(R,Q)*0.1), ...
(alphabet + randn(R,Q)*0.2)];
[net,tr] = train(net,P,T);
end

% Entrena la red sin ruído
% =========================================
net.trainParam.goal = 0.1; % Error medio cuadrático deseado
net.trainParam.epochs = 500; % Número de épocas
net.trainParam.show = 5; % Frecuencia de visualización (en épocas)

P = alphabet;
T = targets;
[net,tr] = train(net,P,T);

% Prueba sobre letra ruidosa
%################################################
% noisyJ = alphabet(:,17)+randn(35,1) * 0.2;
% plotchar(noisyJ);
% A2 = sim(net,noisyJ);
plotchar(B1);
A2 = sim(net,B1);

% Devuelve índice del mayor valor devuelto por la red
A22 = compet(A2);
answer = find(compet(A22) == 1);
figure;
plotchar(alphabet(:,answer));