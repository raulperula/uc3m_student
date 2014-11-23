clear
clc

% Se carga la imagen con el formato que tenga
% [nombre direc] = uigetfile('*.*','Cargar Imagen');
% if nombre == 0
%     return
% end

% Tamaño de la imagen

% Se guarda la imagen en la variable img
% img = imread(fullfile(direc, nombre));
 img = imread('img/car/car6.png');
 % Tamaño de la imagen y color
 [Me,Ne,p] = size (img)

%Se diferencia una imagen en color RGB u escala de grises
if p > 2 
    % Se muesta en axis1
    subplot(2,4,1);
    imshow(img);
    title('Imagen cargada');

    % Se pasa la imagen a escala de grises
    
    img_gray = rgb2gray(img);
    %img_gray = imadjust(img_gray);
else
    img_gray = img;
end

if Ne>200
    %[Me,Ne,p] = size (img_gray);

    % Recortamos la imagen para reducir la informacion de la foto
    img_gray = imcrop(img_gray, [1, Me / 5, Ne, Me / 1.5]);
    subplot(2,4,2);
    imshow(img_gray);
    title('Imagen recortada');

    % Se hace un filtro botton Hat
    if p>2
        SA = strel('square', 5);
    else
        SA = strel('square', 6);
    end
    img_gray_mod = imbothat(img_gray, SA);

    % Umbral
    a = graythresh(img_gray);

    % Deteccion de bordes verticales con umbral automatico
    if p>2
        img_gray_mod = edge(img_gray_mod, 'canny', a + 0.1, 'vertical');
    else
        img_gray_mod = edge(img_gray_mod, 'canny', a+0.011 , 'vertical');
    end

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
    a = graythresh(img_horizontal);
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
    %SO = strel('square',10);
    %I6 = imbothat(img_vertical, SO);
    I5 = im2bw(img_vertical, a1 - 0.12);
    I6 = not(I5);
    im_contras = imadjust(img_vertical);
else
    a1 = graythresh(img);
    %SO = strel('square',10);
    %I6 = imbothat(img, SO);
    I6 = im2bw(img, a1-0.073);
    I6 = not(I6);
    im_contras = imadjust(img_gray);
end


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
	if propied(n).BoundingBox(3) >=5 && propied(n).BoundingBox(3) < 24 && propied(n).BoundingBox(4) > 17 && propied(n).BoundingBox(4) < 40
		rectangle('Position', propied(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
		% Guardo todas las coordenadas del tamaño de los 7 rectangulos en una
		% matriz llamada A
		A(n1,:) = propied(n).BoundingBox;
		n1 = n1+1;
	end
end

% %%%%%%%%%%%
 [mA nA] = size(A);
figure;
s1 = strel('square',2);
s2 = strel('square',3);


a1 = graythresh(im_contras);
for i=1:mA
    if p<2 %Para las imagenes que est�n directamente en blanco y negro
        aux2 = imcrop(im_contras, [A(i,1)-2, A(i,2)-1, A(i,3)+3, A(i,4)+2]);
        aux3 = im2bw(aux2, a1);
        aux3 = imdilate(aux3,s2);
        aux3 = imerode(aux3,s2);
    else 
        if Ne>200
            %Para la imagen a color coche entero
            aux2 = imcrop(im_contras, [A(i,1)-2, A(i,2)-1, A(i,3)+3, A(i,4)+2]);
            aux3 = im2bw(aux2, a1);
            aux3 = imdilate(aux3,s1);
            aux3 = imerode(aux3,s2);    
        else
            %Imagen a color solo matricula
            %s1 = strel('disk',1);
            %s2 = strel('disk',2);
            aux2 = imcrop(im_contras, [A(i,1)-2, A(i,2)-1, A(i,3)+3, A(i,4)+2]);
            aux3 = im2bw(aux2, a1);

        end
        
    end
    
    
    character = zeros(35,mA);
    subplot(1,8,i);
    imshow(aux3);
%     aux4 = imresize(aux3, [7 5]);
%     aux4 = reshape(aux4', 7 * 5, 1);
%     character(:,i) = double(not(aux4));
%     subplot(1, 8, i);
%     plotchar(character(:,i));
%     str = sprintf('%s %d', 'Char', i);
%     title(str);
 end


%%%%%%%%%%%



% Se muestra cada numero en un axes
% Tamaño de la matriz A
% [mA nA] = size(A);
% 
% img_final = not(I6);
% character = zeros(35,mA);
% figure;
% for i=1:mA
%     aux2 = imcrop(img_final, [A(i,1), A(i,2), A(i,3), A(i,4)]);
%     aux3 = imresize(aux2, [7 5]);
%     aux3 = reshape(aux3', 7 * 5, 1);
%     character(:,i) = double(not(aux3));
%     subplot(1, 8, i);
%     plotchar(character(:,i));
%     str = sprintf('%s %d', 'Char', i);
%     title(str);
% end
