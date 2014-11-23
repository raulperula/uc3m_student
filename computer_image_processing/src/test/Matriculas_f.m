function varargout = Matriculas_f(varargin)
% MATRICULAS_F MATLAB code for Matriculas_f.fig
%      MATRICULAS_F, by itself, creates a new MATRICULAS_F or raises the existing
%      singleton*.
%
%      H = MATRICULAS_F returns the handle to a new MATRICULAS_F or the handle to
%      the existing singleton*.
%
%      MATRICULAS_F('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATRICULAS_F.M with the given input arguments.
%
%      MATRICULAS_F('Property','Value',...) creates a new MATRICULAS_F or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Matriculas_f_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Matriculas_f_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Matriculas_f

% Last Modified by GUIDE v2.5 08-Jan-2012 16:01:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Matriculas_f_OpeningFcn, ...
                   'gui_OutputFcn',  @Matriculas_f_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Matriculas_f is made visible.
function Matriculas_f_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Matriculas_f (see VARARGIN)

% Choose default command line output for Matriculas_f
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Matriculas_f wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Matriculas_f_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cargarimagen.
function cargarimagen_Callback(hObject, eventdata, handles)
% hObject    handle to cargarimagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[nombre direc] = uigetfile('*.*','Cargar Imagen');%Se carga la imagen con el formato que tenga
if nombre == 0
    return
end
img=imread(fullfile(direc,nombre)); %Se guarda la imagen en la variable img
subplot (handles.axes1), imshow(img),title('Imagen cargada'); %Se muesta en axis1


% --- Executes on button press in reconocimiento_matricula.
function reconocimiento_matricula_Callback(hObject, eventdata, handles)
% hObject    handle to reconocimiento_matricula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

foto = getimage(handles.axes1); %Se guarda en la variable foto la imagen de axis1
if foto == 0
    return
end

%Se pasa la imagen a escala de grises
I1 = rgb2gray(foto);
%Tama�o de la imagen
[Me,Ne] = size (I1);
%Recortamos la imagen para reducir la informacion de la foto
I1=imcrop(I1,[1,Me/4,Ne,Me/1.5]);
subplot (handles.axes2), imshow(I1),title('Imagen recortada');

%Se hace un filtro botton Hat
SA=strel('square',5);
I1_1=imbothat(I1,SA);
a=graythresh(I1); %Umbral
I1_1=edge(I1_1,'canny',a+0.1,'vertical'); %Deteccion de bordes verticales con umbral automatico

SE=strel('square',10);
I3 = imclose(I1_1,SA); %Se hace un close
I3 = imopen(I3,SA); %Se hace un open
I3 = imdilate(I3,SE); %Un dilate
%I3 = imerode(I3,SA);

subplot (handles.axes2), imshow(I1_1),title('Regi�n de la matr�cula');
subplot (handles.axes3), imshow(I3),title('Regi�n de la matr�cula');
% 
%**************************
%Se calcula el rectangulo de la placa
[L NE]=bwlabel(I3); %NE indicar� el n�mero de objetos etiquetados
   
propied=regionprops(L); %Tomar� medidas del objeto etiquetado
for n=1:size(propied,1)
      rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
  
  
y=propied(1).Area;  
%Vemos el m�ximo area de los rect�ngulos
w=1;
for i=1:NE
    if propied(i).Area > y
        y=propied(i).Area;
        w=i;
    end
end
  
%Marcar de rojo areas menores que el area mayor (y)
s=find([propied.Area]<y);
for i=1:size(s,2)
    rectangle('Position',propied(s(i)).BoundingBox,'EdgeColor','r','LineWidth',2)
end

%RECORTE HORIZONTAL
v=propied(w).BoundingBox; %Almacenamos en un vector todas las coordenadas
Imat_horizontal=imcrop(I1,[1,v(2),Ne,v(4)]);
subplot (handles.axes4), imshow(Imat_horizontal),title('Matr�cula recortada');

%ACCIONES PARA EL RECORTE VERTICAL
I5=imbothat(Imat_horizontal,SA);
I5=edge(I5,'canny',a+0.07,'horizontal');
SO = strel('square',20);
I5 = imclose(I5,SO);
subplot (handles.axes4), imshow(I5),title('Matr�cula recortada');

%Destacamos los rectangulos con un area de color verde
[L NE]=bwlabel(I5); %NE indicar� el n�mero de objetos etiquetados  
propied=regionprops(L); %Tomar� medidas del objeto etiquetado
for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
y=propied(1).Area;
%Buscamos el rectangulo con mayor area.
w=1;
for i=1:NE
    if propied(i).Area > y
        y=propied(i).Area;
        w=i;
    end      
end
v1=propied(w).BoundingBox;%Guardamos las coordenadas del rectangulo mas grande en v1.
Imat_vertical=imcrop(I1,[v1(1),v(2),v1(3),v(4)]);%Se recorta la imagen de forma vertical

%Las matriculas deben de tener una medida especifica, si miden m�s de 210
%habr� que recortar la foto porque ha cogido parte del coche (Mercedes1.png)
[mm,nn]=size(Imat_vertical)
if nn>210
    Imat_vertical=imcrop(I1,[v1(1)+30,v(2),v1(3)-60,v(4)]);
end
subplot (handles.axes5), imshow(Imat_vertical),title('Matr�cula recortada');


%SACAR CARACTERES DE LA MATRICULA  
    
a1 = graythresh(Imat_vertical); %Umbral
SO = strel ('square',10);
I6 = imbothat(Imat_vertical,SO);
I6 = im2bw(Imat_vertical, a1-0.13);
I6=not(I6);

subplot (handles.axes5), imshow(I6),title('Detecci�n de caracteres');
    
 
%Se calcula el rectangulo de la placa
[L NE]=bwlabel(I6); %NE indicar� el n�mero de objetos etiquetados
n1=1;
propied=regionprops(L); %Tomar� medidas del objeto etiquetado
for n=1:size(propied,1)
     %AB(n,:) = propied(n).BoundingBox
     if propied(n).BoundingBox(3)>5 &&propied(n).BoundingBox(3)<24 && propied(n).BoundingBox(4)>17 && propied(n).BoundingBox(3)<40
         rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
          A(n1,:) = propied(n).BoundingBox %Guardo todas las coordenadas del tama�o de los 7 rect�ngulos en una matriz llamada A
          n1=n1+1;
      end
end





   %Se muestra cada n�mero en un axes
   [mA nA] = size(A) %Tama�o de la matriz A
   Ifinal = not(I6);
   im_num1 = imcrop(Ifinal,[A(1,1),A(1,2),A(1,3),A(1,4)]);
   B = imresize (im_num1, [7 5]);
   B = reshape(B',35,1);
   B = double(not(B));
   assignin('base','B',B);
   subplot (handles.axes8), imshow(im_num1),title('Caracter 1');
   
   im_num2 = imcrop(Ifinal,[A(2,1),A(2,2),A(2,3),A(2,4)]);
   subplot (handles.axes9), imshow(im_num2),title('Caracter 2');
   im_num3 = imcrop(Ifinal,[A(3,1),A(3,2),A(3,3),A(3,4)]);
   subplot (handles.axes10), imshow(im_num3),title('Caracter 3');
   im_num4 = imcrop(Ifinal,[A(4,1),A(4,2),A(4,3),A(4,4)]);
   subplot (handles.axes11), imshow(im_num4),title('Caracter 4');
   im_num5 = imcrop(Ifinal,[A(5,1),A(5,2),A(5,3),A(5,4)]);
   subplot (handles.axes12), imshow(im_num5),title('Caracter 5');
   im_num6 = imcrop(Ifinal,[A(6,1),A(6,2),A(6,3),A(6,4)]);
   subplot (handles.axes13), imshow(im_num6),title('Caracter 6');
   im_num7 = imcrop(Ifinal,[A(7,1),A(7,2),A(7,3),A(7,4)]);
   subplot (handles.axes14), imshow(im_num7),title('Caracter 7');
   
   if mA == 8 %Si el numero de filas de A es 8 significa que existen 8 caracteres en la matricula:
       im_num8 = imcrop(Ifinal,[A(8,1),A(8,2),A(8,3),A(8,4)]);
       subplot (handles.axes15), imshow(im_num8),title('Caracter 8');
   else %Si hay 7 caracteres:
       im_num8=1; %Imagen en blanco
       subplot (handles.axes15), imshow(im_num8),title('Caracter 8');
   end
