%% Variables Iniciales n^2+2n n=numero de fichas.
NBE= 4;% Número Bloques Equipo
EstadoInicial=[1:NBE 0 NBE+1:2*NBE];
GrafoEscalera=[EstadoInicial 0]; MatrizMatlab=[];
EstadosPendientes = 1; 
%% Generar Grafo
while (EstadosPendientes ~= 0)
    CEC=GrafoEscalera(:,end); % Ultima posición (Si ha sido visitado o no)
    PosicionEstadoConCero=find(CEC==0); % Encuentra 0s en la Matriz
    if isempty(PosicionEstadoConCero)
       EstadosPendientes = 1;
       break;
    end
    [NuevaCopiaEC] = GrafoEscalera(PosicionEstadoConCero(1,1),1:end-1);
    for P=1:4
        if P==1 % Accion 1 Mover 1 casilla a derecha
           NuevaCEC=NuevaCopiaEC;
           [MMatriz] = mover(NuevaCEC, 1);
           [MatrizMatlab] = NodosVertices(NuevaCEC, MMatriz, MatrizMatlab);
           [GrafoEscalera] = NuevoGrafo(MMatriz, GrafoEscalera);
        elseif P==2 % Accion 2 Mover 1 casilla a izquierda
           NuevaCEC=NuevaCopiaEC;
           [MMatriz] = mover(NuevaCEC, 2);
           [MatrizMatlab] = NodosVertices(NuevaCEC, MMatriz, MatrizMatlab);
           [GrafoEscalera] = NuevoGrafo(MMatriz, GrafoEscalera);
        elseif P==3 % Accion 3 Saltar 1 casilla a derecha
           NuevaCEC=NuevaCopiaEC;
           [SMatriz] = saltar(NuevaCEC, 1, NBE);
           [MatrizMatlab] = NodosVertices(NuevaCEC, SMatriz, MatrizMatlab);
           [GrafoEscalera] = NuevoGrafo(SMatriz, GrafoEscalera);
        elseif P==4 % Accion 4 Saltar 1 casilla a izquierda
           NuevaCEC=NuevaCopiaEC;
           [SMatriz] = saltar(NuevaCEC, 2, NBE);
           [MatrizMatlab] = NodosVertices(NuevaCEC, SMatriz, MatrizMatlab);
           [GrafoEscalera] = NuevoGrafo(SMatriz, GrafoEscalera);
        end
    end
    GrafoEscalera(PosicionEstadoConCero(1,1),end)=1;
end
%% Hallar la Frecuencia
% Cargar ECB y ESB
load ESB.txt;
[Estados]=filtro_datos(ESB);
[Frecuencia] = tablafrecuencia(Estados,GrafoEscalera);
%% Generar Grafo
[s,t] = IDNodos(GrafoEscalera, MatrizMatlab);
% MatrizA=[ID' num2str(Matriz1(:,1:end-1))];sourceTarget=[Matriz2 Matriz3];
G = graph(s,t);
h = plot(G,'Layout','force','WeightEffect','direct');
h.EdgeColor='b';
% https://www.mathworks.com/help/matlab/ref/graph.shortestpath.html
path = shortestpath(G,1,620);
highlight(h,path,'EdgeColor','white',"LineWidth",3)
highlight(h,path)
labelnode(h,1,'Start')
labelnode(h,620,'End')
h.NodeLabelColor='w';
H=Frecuencia(:,end);
for i=1:630
    if H(i)>=30
        H(i)=10;
    end
end
h.NodeCData = H;
h.MarkerSize=H+0.1;
set(gca,'color',[0 0 0])
colormap jet
%colorbar
%title('Juego La Escalera - Exploración Autónoma')
hold on
%% Funciones
% Levantar
function [MMatriz] = mover(MatrizB, lado)
    idx=find(MatrizB==0);
    [~,B]=size(MatrizB);
    if lado==1 && idx < B && idx > 1% Derecha
       Bloque=MatrizB(idx-1);
       MatrizB(idx-1)=0;
       MatrizB(idx)=Bloque;
    elseif lado==2 && idx < B % Izquierda
       Bloque=MatrizB(idx+1);
       MatrizB(idx+1)=0;
       MatrizB(idx)=Bloque;
    end
    MMatriz=MatrizB;
end
function [SMatriz] = saltar(MatrizB, lado, NB)
    idx=find(MatrizB==0);
    [~,B]=size(MatrizB);
    MA=(1:NB);MB=(NB+1:NB*2);
    if lado==1 && idx>2 % Derecha
       Bloque=MatrizB(idx-2);
       BloqueDeSalto=MatrizB(idx-1);
       % En que grupo esta Bloque y BloqueDeSalta
       if (ismember(Bloque,MA) && ismember(BloqueDeSalto,MB)) || (ismember(Bloque,MB) && ismember(BloqueDeSalto,MA))
          MatrizB(idx-2)=0;
          MatrizB(idx)=Bloque;
       end
    elseif lado==2 && idx < B-2% Izquierda
       Bloque=MatrizB(idx+2);
       BloqueDeSalto=MatrizB(idx+1);
       if (ismember(Bloque,MA) && ismember(BloqueDeSalto,MB)) || (ismember(Bloque,MB) && ismember(BloqueDeSalto,MA))
          MatrizB(idx+2)=0;
          MatrizB(idx)=Bloque;
       end
    end
    SMatriz=MatrizB;
end
function [MatrizMatlab] = NodosVertices(Matriz1, Matriz2, MatrizMatlab)
    [A,~]=size(MatrizMatlab);Comparar=1;
    if isequal(Matriz1, Matriz2)
        Comparar=0;
    else
        Matriz3 = [Matriz1 Matriz2];
        Matriz4 = [Matriz2 Matriz1];
        for j=1:A
            if isequal(Matriz3, MatrizMatlab(j,:)) || isequal(Matriz4, MatrizMatlab(j,:))
               Comparar=0;
            end
        end
    if Comparar==0
       MatrizMatlab=MatrizMatlab;
    elseif Comparar==1
           MatrizMatlab = cat(1,MatrizMatlab,Matriz3);
    end
    end
end
function [GrafoEscalera] = NuevoGrafo(Matriz1, Matriz2)
    [A,~]=size(Matriz2);
    Comparar=1;
    Matrizi=[Matriz1 0];
    for j=1:A
        if isequal(Matriz1, Matriz2(j,1:end-1))
           Comparar=0;
        end
    end
    if Comparar==0
       GrafoEscalera=Matriz2;
    elseif Comparar==1
       GrafoEscalera=cat(1,Matriz2,Matrizi);
    end
end
function [s,t] = IDNodos(Matriz1, Matriz2)
    [A,~]=size(Matriz1);
    [B,C]=size(Matriz2);
    s=[];t=[];
    for i=1:A
        Nodo = Matriz1(i,1:end-1);
        for j=1:B
            if isequal(Nodo, Matriz2(j,1:C/2))
                s(j,1) = i;
            end
            if isequal(Nodo, Matriz2(j,C/2+1:C))
                t(j,1) = i;
            end                        
        end
    end
end
function [Estados]=filtro_datos(Matriz)
    [A,~]=size(Matriz);
    Estados=[];
    for i=1:A
        C=Matriz(i,:);
        Estado=str2double(regexp(num2str(C),'\d','match'));
        [~,N]=size(Estado);
        if N==9
            Estados=cat(1,Estados,Estado);
        end
    end
end
function [Frecuencia] = tablafrecuencia(Matriz1,Matriz2)
    Frecuencia=[];
    MatrizGrafo=Matriz2(:,1:9);
    [A,~]=size(Matriz2);
    [B,~]=size(Matriz1);
    for i=1:A
        frecuencia=0;
        for j=1:B
            if isequal(MatrizGrafo(i,:),Matriz1(j,:))
                frecuencia=frecuencia+1;
            end
        end
        F= [MatrizGrafo(i,:) frecuencia];
        Frecuencia = cat(1,Frecuencia,F);
    end
end