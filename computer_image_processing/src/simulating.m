function [char,SSE] = simulating(net,character)

% Definición de matrices y constantes
patron = alphabet();

% Simulación
output = sim(net, character(:));

% Devuelve índice del mayor valor devuelto por la red
aux = compet(output);
answer = find(compet(aux) == 1);
char = patron(:,answer);

% calculating error
SSE = sse(char,output);

end
