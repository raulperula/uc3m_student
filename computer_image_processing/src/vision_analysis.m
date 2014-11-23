function V = vision_analysis(imag)

% Se guarda la imagen en la variable img.
img = imread(imag);

% Las siguientes variables contendrán el tamano de la imagen y la imagen es
% a color o en escala de grises.
[Me,Ne,p] = size (img);

%Se diferencian las imagenes en color o escala de grises.
%Si la imagen es en color:
if p > 2
    %Se muestra la imagen.
    subplot(2,4,1);
    imshow(img);
    title('Imagen cargada');

    % Se pasa la imagen a escala de grises
    img_gray = rgb2gray(img);

%Si la imagen es en escala de grises:
else
    img_gray = img;
end

%Se diferencia entre la imagen completa del coche e imagenes solo con
%matricula.

%IMAGEN COMPLETA COCHE
if Ne > 200
    % Se recorta la imagen para reducir la informacion no valida en la
    % foto.
    img_gray = imcrop(img_gray, [1, Me / 5, Ne, Me / 1.5]);
    
    % Se muestra la imagen recortada
    subplot(2,4,2);
    imshow(img_gray);
    title('Imagen recortada');
    
    % RECORTE HORIZONTAL
    
    % Se hace un filtro Bottom-hat. El parametro del filtro dependera de si
    % la imagen esta en escala de grises o en color.
    if p>2
        SA = strel('square', 5);
    else
        SA = strel('square', 6);
    end
    img_gray_mod = imbothat(img_gray, SA);
    
    % El umbral es calculado automaticamente a partir de la imagen en escala
    %de grises.
    a = graythresh(img_gray);
    
    %Se hace una deteccion de bordes verticales por medio del Filtro Canny
    %junto con el umbral obtenido.
    if p > 2
        img_gray_mod = edge(img_gray_mod, 'canny', a + 0.1, 'vertical');
    else
        img_gray_mod = edge(img_gray_mod, 'canny', a + 0.011 , 'vertical');
    end
    
    %Tratado de la imagen para obtener la region buscada de la matricula.
    SE = strel('square', 10);
    aux = imclose(img_gray_mod, SA); % Se hace un close
    aux = imopen(aux, SA); % Se hace un open
    aux = imdilate(aux, SE); % Un dilate
    
    %Se muestra la region de la matricula.
    subplot(2,4,3);
    imshow(img_gray_mod);
    title('Region de la matricula');
    subplot(2,4,4);
    imshow(aux);
    title('Region de la matricula');
    
    %ETIQUETADO Y DISCRIMINACION
    
    %Por medio del comando bwlabel se sabe cuantas regiones existen en la
    %imagen.
    %L una matriz con los objetos etiquetados.
    %NE devuelve el numero de regiones etiquetadas.
    [L NE] = bwlabel(aux);

    %Se toman las medidas del objeto etiquetado.
    propied = regionprops(L);
    for n=1:size(propied, 1)
        %Cada area se encuadra con un cuadrado de color verde.
        r = propied(n).Area;
        rectangle('Position', propied(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
    end
    
    %El la region escogida tendra el mayor area siempre y cuando cumpla con
    %un rango especifico de altura (30 60) pixeles.
    y = propied(1).Area;
    w = 1;
    for i=1:NE
        if propied(i).Area > y && propied(i).BoundingBox(4)>30 && propied(i).BoundingBox(4)<60
            y = propied(i).Area;
            w = i;
        end
    end

    % Las areas no escogidas son marcadas de rojo.
    s = find([propied.Area] < y);
    for i=1:size(s, 2)
        rectangle('Position', propied(s(i)).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2)
    end


    % Almacenamos en un vector (v) las coordenadas de la region elegida.
    v = propied(w).BoundingBox;
    
    %La imagen es recortada (coordenada y; altura).
    img_horizontal = imcrop(img_gray, [1, v(2), Ne, v(4)]);
    
    %Se muestra la imagen.
    subplot(2,4,5);
    imshow(img_horizontal);
    title('Matricula recortada');
    
    
    % RECORTE VERTICAL

    a = graythresh(img_horizontal); %Se calcula el umbral automatico
    aux1 = imbothat(img_horizontal, SA); %Se aplica el filtro Bottom-hat
    aux1 = edge(aux1, 'canny', a + 0.07, 'horizontal'); %Se aplica el filtro Canny con un umbral ajustado
    SO = strel('square', 20);
    aux1 = imclose(aux1, SO); %Se hace un cierre en la imagen
    
    %Se muestra la imagen
    subplot(2,4,6);
    imshow(aux1);
    title('Matricula recortada');
    
    %ETIQUETADO Y DISCRIMINACION

    %Se a etiquetar la imagen.
    [L NE] = bwlabel(aux1);
    propied = regionprops(L);% Se toman medidas del objeto etiquetado
    for n=1:size(propied,1)
        rectangle('Position', propied(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
    end
    y = propied(1).Area;
    
    % Se busca el rectangulo con mayor area
    w = 1;
    for i=1:NE
        if propied(i).Area > y
            y = propied(i).Area;
            w = i;
        end
    end

    % Se guardan las coordenadas del rectangulo mas grande en v1
    v1 = propied(w).BoundingBox;

    % Se recorta la imagen con las coordenadas obtenidas en el eje
    % horizontal y el ancho de esta.
    img_vertical = imcrop(img_gray, [v1(1), v(2), v1(3), v(4)]);

    % Las matriculas deben de tener una medida especifica, si miden mas de 210
    % habra que recortar la foto porque ha cogido parte del coche.
    [mm nn] = size(img_vertical);
    if nn > 210
        img_vertical = imcrop(img_gray, [v1(1) + 30, v(2), v1(3) - 60, v(4)]);
    end
    
    subplot(2,4,7);
    imshow(img_vertical);
    title('Matricula recortada');
    

    % BINARIZACION
    
    %Imagen para obtencion de caracteres.
    a1 = graythresh(img_vertical); % Umbral
    I6 = im2bw(img_vertical, a1 - 0.12); %Binarizacion
    I6 = not(I6); %Se invierte la imagen
    
    %Imagen para recortar caracteres.
    im_contras = imadjust(img_vertical); %Se mejora el constraste de la imagen
    a1 = graythresh(im_contras); %Umbral de la imagen mejorada
    aux2 = im2bw(im_contras, a1); %Binarizacion
    
else %IMAGEN PLACA MATRICULA

    % BINARIZACION

    %Imagen para obtencion de caracteres
    a1 = graythresh(img); %Umbral
    I6 = im2bw(img, a1-0.073); %Binarizaciï¿½n
    I6 = not(I6); %Se invierte la imagen
    
    %Imagen para recortar caracteres
    im_contras = imadjust(img_gray); %Se mejora el constraste de la imagen
    a1 = graythresh(im_contras); %Umbral de la imagen mejorada
    aux2 = im2bw(im_contras, a1); %Binarizacion
    
end

subplot(2,4,8);
imshow(I6);
title('Deteccion de caracteres');


%DETECCION DE CARACTERES

%Se analizan las regiones de la imagen.
[L NE] = bwlabel(I6);
n1 = 1;

%ETIQUETADO
propied = regionprops(L);
for n=1:size(propied,1)

    %Los caracteres de la matricula deben de tener un rango: 
    %anchura [5, 24) y altura (17, 40).
	if propied(n).BoundingBox(3) >=5 && propied(n).BoundingBox(3) < 24 && propied(n).BoundingBox(4) > 17 && propied(n).BoundingBox(4) < 40
		rectangle('Position', propied(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2)
        %A contendra la cantidad y el tamano de los caracteres.
		A(n1,:) = propied(n).BoundingBox;
		n1 = n1+1;
	end
end

%RECORTE DE CADA CARACTER

[mA nA] = size(A);
fig = figure;
s1 = strel('square',2);
s2 = strel('square',3);

for i=1:mA
    if p<2 %Para las imagenes que estan directamente en blanco y negro
        aux4 = imcrop(aux2, [A(i,1), A(i,2), A(i,3), A(i,4)]);
    else 
        if Ne>200
            %Para la imagen a color coche entero
            aux4 = imcrop(aux2, [A(i,1), A(i,2), A(i,3), A(i,4)]);            
        else
            %Imagen a color solo matricula
            aux4 = imcrop(aux2, [A(i,1), A(i,2), A(i,3), A(i,4)]);
            %aux4 = im2bw(aux3, a1);
            %aux4 = imdilate(aux3,s1);
            %aux4 = imerode(aux4,s2);
            
        end
    end
    
    %Se muestran los caracteres obtenidos
    aux5 = imresize(aux4, [21 15]);
    j1=1;
    j2=1;
    for j=1:21
        if aux5(j,15)==1
            j1=j1+1;
        end
    end
    for j=1:15
        if aux5(21,j)==1
            j2=j2+1;
        end
    end
    
    if j1>20
        aux5(:,15)=[];
    end
     if j2>14
        aux5(21,:)=[];
    end
    aux6 = imresize(aux5, [7 5]);
    %aux6 = reshape(aux5', 21*15,1);
    %V(i) = {double(not(aux6))};
    %V(i) = {double(aux5(:))};
%     subplot(1,8,i);
%     imshow(aux6);
    aux7 = reshape(aux6', 35,1);
    V(i) = {double(not(aux7))};
    
    %Se muestran los caracteres obtenidos
    subplot(1,8,i);
    imshow(aux6);
end

% guardar matricula reconocida
 print(fig,'-dpng',strcat('../res/',strtok(imag,'.'),'.png'))

end
