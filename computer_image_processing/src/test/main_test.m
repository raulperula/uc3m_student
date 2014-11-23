clear
clc

% Se carga la imagen con el formato que tenga
% [nombre direc] = uigetfile('*.*','Cargar Imagen');
% if nombre == 0
%     return
% end

% Se guarda la imagen en la variable img
% img = imread(fullfile(direc, nombre));
img = imread('img/car/car7.png');

% Se muesta en axis1
subplot(2,4,1);
imshow(img);
title('Imagen cargada');

% Se pasa la imagen a escala de grises
img_gray = rgb2gray(img);

% Tamaño de la imagen
[Me,Ne] = size (img_gray);

% Recortamos la imagen para reducir la informacion de la foto
%img_gray = imcrop(img_gray, [1, Me / 4, Ne, Me / 1.5]);
subplot(2,4,2);
imshow(img_gray);
title('Imagen recortada');

% Se hace un filtro botton Hat
SA = strel('square', 5);
img_gray_mod = imbothat(img_gray, SA);

% Umbral
a = graythresh(img_gray);

% Deteccion de bordes verticales con umbral automatico
img_gray_mod = edge(img_gray_mod, 'canny', a + 0.1, 'vertical');

% Tratado de la imagen
SE = strel('square', 10);
aux = imclose(img_gray_mod, SA); % Se hace un close
aux = imopen(aux, SA); % Se hace un open
aux = imdilate(aux, SE); % Un dilate
%aux = imerode(aux, SA);

subplot(2,4,3);
imshow(img_gray_mod);
title('Región de la matrícula');
subplot(2,4,4);
imshow(aux);
title('Región de la matrícula');

%**************************
% Se calcula el rectangulo de la placa
% NE indicara el numero de objetos etiquetados
[L NE] = bwlabel(aux);

% Tomar medidas del objeto etiquetado
propied = regionprops(L);
for n=1:size(propied, 1)
    rectangle('Position', propied(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
end

% Vemos el maximo area de los rectangulos
y = propied(1).Area;
w = 1;
for i=1:NE
    if propied(i).Area > y
        y = propied(i).Area;
        w = i;
    end
end
  
% Marcar de rojo areas menores que el area mayor (y)
s = find([propied.Area] < y);
for i=1:size(s, 2)
    rectangle('Position', propied(s(i)).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2)
end

% RECORTE HORIZONTAL

% Almacenamos en un vector todas las coordenadas
v = propied(w).BoundingBox;
img_horizontal = imcrop(img_gray, [1, v(2), Ne, v(4)]);
subplot(2,4,5);
imshow(img_horizontal);
title('Matricula recortada');

% ACCIONES PARA EL RECORTE VERTICAL
aux1 = imbothat(img_horizontal, SA);
aux1 = edge(aux1, 'canny', a + 0.07, 'horizontal');
SO = strel('square', 20);
aux1 = imclose(aux1, SO);
subplot(2,4,6);
imshow(aux1);
title('Matrícula recortada');

% Destacamos los rectangulos con un area de color verde
% NE indicara el numero de objetos etiquetados
[L NE] = bwlabel(aux1);

% Tomar medidas del objeto etiquetado
propied = regionprops(L);
for n=1:size(propied,1)
    rectangle('Position', propied(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
end
y = propied(1).Area;

% Buscamos el rectangulo con mayor area
w = 1;
for i=1:NE
    if propied(i).Area > y
        y = propied(i).Area;
        w = i;
    end
end

% Guardamos las coordenadas del rectangulo mas grande en v1
v1 = propied(w).BoundingBox;

% Se recorta la imagen de forma vertical
img_vertical = imcrop(img_gray, [v1(1), v(2), v1(3), v(4)]);

% Las matriculas deben de tener una medida especifica, si miden mas de 210
% habra que recortar la foto porque ha cogido parte del coche (Mercedes1.png)
[mm nn] = size(img_vertical);
if nn > 210
    img_vertical = imcrop(img_gray, [v1(1) + 30, v(2), v1(3) - 60, v(4)]);
end
subplot(2,4,7);
imshow(img_vertical);
title('Matricula recortada');

% SACAR CARACTERES DE LA MATRICULA

% Umbral
a1 = graythresh(img_vertical);
SO = strel('square',10);
I6 = imbothat(img_vertical, SO);
I6 = im2bw(img_vertical, a1 - 0.13);
I6 = not(I6);

subplot(2,4,8);
imshow(I6);
title('Detección de caracteres');

% Se calcula el rectangulo de la placa
% NE indicara el numero de objetos etiquetados
[L NE] = bwlabel(I6);
n1 = 1;
%Tomara medidas del objeto etiquetado
propied = regionprops(L);
for n=1:size(propied,1)
	% AB(n,:) = propied(n).BoundingBox
	if propied(n).BoundingBox(3) > 5 && propied(n).BoundingBox(3) < 24 && propied(n).BoundingBox(4) > 17 && propied(n).BoundingBox(3) < 40
		rectangle('Position', propied(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
		% Guardo todas las coordenadas del tamaño de los 7 rectangulos en una
		% matriz llamada A
		A(n1,:) = propied(n).BoundingBox;
		n1 = n1+1;
	end
end

% Se muestra cada numero en un axes
% Tamaño de la matriz A
[mA nA] = size(A);

img_final = not(I6);
character = zeros(35,mA);
figure;
for i=1:mA
    aux2 = imcrop(img_final, [A(i,1), A(i,2), A(i,3), A(i,4)]);
    aux3 = imresize(aux2, [7 5]);
    aux3 = reshape(aux3', 7 * 5, 1);
    character(:,i) = double(not(aux3));
    subplot(2, mA, i);
    plotchar(character(:,i));
%     str = sprintf('%s %d', 'Char', i);
%     title(str);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reconocimiento de cada caracter de la matricula mediante red neuronal
for i=1:mA
    [char SSE] = network_analysis(character(:,i));
    subplot(2, mA, i+mA);
    plotchar(char);
%     str = sprintf('%f', SSE);
%     title(str);
end
