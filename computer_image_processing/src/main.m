% limpieza
clc
clear
close all

% se carga la red entrenada
load('net60.mat','net')

% se cargan todas las imagenes de la base de datos
% (hay que ejecutar el programa estando dentro de la carpeta 'src')
dout = dir('../img/car');
% dout = dir('../img/licenses');

% se crea el fichero de resultados
% f = fopen('../res/resultados.csv','w+');

% se crea la red neuronal
% net = create();

% se entrena la red
% net = training(net);
% save('net.mat','net');

% for i=3:length(dout)
    % primera linea de fichero de resultados
%     fprintf(f,strcat('filename: ',strtok(dout(i).name,'.'),'\n\n'));
%     fprintf(f,'caracter,SSE\n');
    
    % se analizan una a una las imagenes
%     vector = vision_analysis(dout(i).name);
    vector = vision_analysis('car/car24.png');
    figure;
    for h=1:length(vector)
        subplot(2,length(vector),h);
        plotchar(vector{:,h});
    end

    % string que contiene la matricula
    aux = '';
        
    for j=1:length(vector)
        % simulacion de la salida y obtencion de la cadena en modo imagen
        [char,SSE] = simulating(net,vector{:,j});
            
        % se obtiene el caracter en modo texto
        character = read_letter(char);
        aux = strcat(aux,character);
        
        % se muestran las caracteres reconocidos
        subplot(2, length(vector), j+length(vector));
        plotchar(char);

        % se almacena el caracter y el error
        fprintf(f,'%s,%f\n',character,SSE);
    end
    
    fprintf(f,'%s\n\n',aux);
    close all
% end

% se cierran los ficheros
fclose('all');
