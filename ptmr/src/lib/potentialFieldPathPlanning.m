%% planificación de la trayectoria según el campo potencial
function [ xp, yp, ix, iy] = potentialFieldPathPlanning( Xpp, Ypp, fXpp, fYpp, dhpp, xOpp, xTpp)
%Xpp, Ypp ..    matriz que define el area del campo
%fXpp, fYpp ..  gradientes del campo potencial
%dhpp ..        paso
%XOpp, xTpp ..  vector de la posición inicial y final

ss=1;
k=1;
xp=[];
yp=[];
xp(1)=xOpp(1);
yp(1)=xOpp(2);
ix=[];
iy=[];
% jx=[];
% jy=[];
fxx=0;
fyy=0;

%while ss
for ss=1:5000
    Pw = sqrt(((Xpp-xp(k)).^2)+((Ypp-yp(k)).^2)); %Pw matrix de distancia respecto a la posicion actual
    xw(k)     = min(min(Pw));          % valor mínimo de la matriz Pw
    [iix,iiy] = find(Pw==xw(k));   % encontrar la posición del matriz del valor mín
    ix(k)   = iix(1);
    iy(k)   = iiy(1);
    fx1     = fXpp(ix(k),iy(k)); % busca el potencial mínimo del punto actual
    fy1     = fYpp(ix(k),iy(k));
    fxx(k)  = fx1./norm(fXpp); % convierte el potencial en su valor unitario
    fyy(k)  = fy1./norm(fYpp);
    xp(k+1) = xp(k)+dhpp*(fxx(k)); % calcula el siguiente punto
    yp(k+1) = yp(k)+dhpp*(fyy(k));
     if (sqrt((xp(k+1)-xTpp(1)).^2+(yp(k+1)-xTpp(2)).^2)<=dhpp)
         %ss=0;
         break;
     end
    k=k+1;
end

hold on
plot(xp, yp, 'r')

end

