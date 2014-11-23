% clc
% clear

character = alphabet;
matricula = character(:,31)+randn(35, 1) * 0.3;

[char,SSE] = network_analysis(matricula);

subplot(1,2,1)
plotchar(matricula)
subplot(1,2,2)
plotchar(char)
