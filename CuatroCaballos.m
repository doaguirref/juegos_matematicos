%% Juego Cuatro Caballos
% Pilas: Estado=str2double(regexp(num2str(C, '%09.f'),'\d','match')); El
% nueve corresponde a la cantidad de espacios para ubicar bloques
% Equipo A: [1,3] Equipo B: [2,4]
EIJ=[1 0 3; 0 0 0 ; 2 0 4];% Estado Inicial Juan EIJ
EstadoInicial = ConvertirMatriz(EIJ);
MatrizNodosCaballos=[];
MatrizNodosHijos=[EstadoInicial 0];
NoPe=1;
%% Construir Grafo
while(NoPe ~= 0)
    % Busque Candidato en MatrizNodosHijos
    [filaCandidato, NoPe] = buscarCandidato(MatrizNodosHijos);
    % Envie Candiado
    EstadoPosible=MatrizNodosHijos(filaCandidato,1:end-1); % Uno de los NodosPendientes
    for i=1:3
        for j=1:3
            Matriz = regla(EstadoPosible,i,j,1);
            MatrizNodosHijos = NodosPendientes(Matriz, MatrizNodosHijos);
            MatrizNodosCaballos = llenarMatrizNodos(EstadoPosible, Matriz, MatrizNodosCaballos);
            Matriz = regla(EstadoPosible,i,j,2);
            MatrizNodosHijos = NodosPendientes(Matriz, MatrizNodosHijos);
            MatrizNodosCaballos = llenarMatrizNodos(EstadoPosible, Matriz, MatrizNodosCaballos);
        end
    end    
    MatrizNodosHijos(filaCandidato,end)=1;    
    evaluarNodosPendientes(MatrizNodosHijos); % Evaluar si hay o no NodosPendientes
end
%% Generar Grafo
hold on
[s,t] = IDNodos(MatrizNodosHijos, MatrizNodosCaballos);
G = digraph(s,t);
h = plot(G,'Layout','force','UseGravity',true);
XXX=get(h,'XData');
YYY=get(h,'YData');
% https://www.mathworks.com/help/matlab/ref/graph.shortestpath.html
%https://www.mathworks.com/help/bioinfo/ref/graphshortestpath.html
W = ones(1,length(s));S=s';T=t';
maxnode = max([S,T]);
DG = sparse(S, T, W, maxnode, maxnode);
h = view(biograph(DG,[],'ShowWeights','on'));
[dist,path,pred] = graphshortestpath(DG,1,274);
set(h.Nodes(path),'Color',[1 0.4 0.4])
edges = getedgesbynodeid(h,get(h.Nodes(path),'ID'));
set(edges,'LineColor',[1 0 0])
set(edges,'LineWidth',1.5)
% highlight(h,path,'EdgeColor','red',"LineWidth",3)
% highlight(h,path)
% labelnode(h,1,'Start')
% labelnode(h,274,'End')
% h.NodeLabelColor='b';
%% Dibujar Trayectoria
% load THA3.txt;
% [EstadosTHA]=filtro_datos(THA3);
% [Trayectoria] = trayectoriasujeto(EstadosTHA,MatrizNodosHijos);
% highlight(h,Trayectoria,'EdgeColor','black',"LineWidth",2);
%% Hallar la Frecuencia
% Cargar CC "Cuatro Caballos"
% load CC.txt;
% [Estados]=filtro_datos(CC);
% [Frecuencia] = tablafrecuencia(Estados,MatrizNodosHijos);
% H=Frecuencia(:,end)/40;
% h.NodeCData = H;
% h.MarkerSize=H+0.1;
% ucc = centrality(G,'closeness');
% h.NodeCData = ucc;
% colormap jet
% colorbar
% title('Closeness Centrality Scores - Unweighted')
 %set(gca,'color',[0 0 0])
 %colormap jet
% colorbar
title('Juego Cuatro Caballos')
%% Funcion CONVERTIR matriz a vector
function NuevaMatriz = ConvertirMatriz(Matriz)
    NuevaMatriz=[];
    for j=1:3
        NuevaMatriz = cat(2,NuevaMatriz,Matriz(j,:));
    end
end
%% Funcion Si el NODO ya fue Evaluado
function [filaCandidato,Nope] = buscarCandidato(Matriz)
    [F,~]=size(Matriz);
    for i=1:F
        if Matriz(i,end) == 0
            Nope=1;
            filaCandidato=i;
            break;
        else
            Nope=0;
            filaCandidato=1;
        end
    end
end
%% Funcion Regla [i=Filas, j=Columnas]
function Matriz = regla(MatrizA,i,j,Opcion)
    Matriz=[MatrizA(1:3);MatrizA(4:6);MatrizA(7:9)];
    % Posicion 1 -->(6)
    if (i==1 && j==1) && (Matriz(i,j)~=0) && Matriz(2,3)==0 && Opcion==1
    Matriz(2,3)=Matriz(i,j);
    Matriz(i,j)=0;
    end
    % Posicion 1 -->(8) 
    if (i==1 && j==1) && (Matriz(i,j)~=0) && Matriz(3,2)==0 && Opcion==2
    Matriz(3,2)=Matriz(i,j);
    Matriz(i,j)=0;
    end
    % Posicion 2 -->(7)
    if (i==1 && j==2) && (Matriz(i,j)~=0) && Matriz(3,1)==0 && Opcion==1
    Matriz(3,1)=Matriz(i,j);
    Matriz(i,j)=0;
    end
    % Posicion 2 -->(9)
    if (i==1 && j==2) && (Matriz(i,j)~=0) && Matriz(3,3)==0 && Opcion==2
    Matriz(3,3)=Matriz(i,j);
    Matriz(i,j)=0;
    end
    % Posicion 3 -->(4)
    if (i==1 && j==3) && (Matriz(i,j)~=0) && Matriz(2,1)==0 && Opcion==1
    Matriz(2,1)=Matriz(i,j);
    Matriz(i,j)=0;
    end
    % Posicion 3 -->(8)
    if (i==1 && j==3) && (Matriz(i,j)~=0) && Matriz(3,2)==0 && Opcion==2
    Matriz(3,2)=Matriz(i,j);
    Matriz(i,j)=0;
    end
    % Posicion 4 -->(3)
    if (i==2 && j==1) && (Matriz(i,j)~=0) && Matriz(1,3)==0 && Opcion==1
    Matriz(1,3)=Matriz(i,j);
    Matriz(i,j)=0;
    end
    % Posicion 4 -->(9)
    if (i==2 && j==1) && (Matriz(i,j)~=0) && Matriz(3,3)==0 && Opcion==2
        Matriz(3,3)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 5 -->(-,-)
    % Posicion 6 -->(1)
    if (i==2 && j==3) && (Matriz(i,j)~=0) && Matriz(1,1)==0 && Opcion==1
        Matriz(1,1)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 6 -->(7)
    if (i==2 && j==3) && (Matriz(i,j)~=0) && Matriz(3,1)==0 && Opcion==2
        Matriz(3,1)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 7 -->(2)
    if (i==3 && j==1) && (Matriz(i,j)~=0) && Matriz(1,2)==0 && Opcion==1
        Matriz(1,2)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 7 -->(6)
    if (i==3 && j==1) && (Matriz(i,j)~=0) && Matriz(2,3)==0 && Opcion==2
        Matriz(2,3)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 8 -->(1)
    if (i==3 && j==2) && (Matriz(i,j)~=0) && Matriz(1,1)==0 && Opcion==1
        Matriz(1,1)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 8 -->(3)
    if (i==3 && j==2) && (Matriz(i,j)~=0) && Matriz(1,3)==0 && Opcion==2
        Matriz(1,3)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 9 -->(2)
    if (i==3 && j==3) && (Matriz(i,j)~=0) && Matriz(1,2)==0 && Opcion==1
        Matriz(1,2)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    % Posicion 9 -->(4)
    if (i==3 && j==3) && (Matriz(i,j)~=0) && Matriz(2,1)==0 && Opcion==2
        Matriz(2,1)=Matriz(i,j);
        Matriz(i,j)=0;
    end
    Matriz=[Matriz(1,:) Matriz(2,:) Matriz(3,:)];
end
%% Funcion NodosPendientes
function MatrizNodosHijos = NodosPendientes(Matriz, MatrizNodosHijos)
    % Buscar Matriz en MatrizNodosHijos
    [N,~] = size(MatrizNodosHijos);
    Permiso=1;
    for i=1:N
        if MatrizNodosHijos(i,1:end-1) == Matriz
            Permiso=0;
        end
    end
    if Permiso == 1
        MatrizB = [Matriz 0];
        MatrizNodosHijos= cat(1,MatrizNodosHijos,MatrizB);
    end
end
%% Llenar la MatrizNodosEscalera con todos los nodos
function [MatrizNodosCaballos] = llenarMatrizNodos(EstadoPosible, NodoCandidato, MatrizNodosCaballos)
    [N,~] = size(MatrizNodosCaballos);
% Buscar en MatrizNodosEscalera a NodoCandidato
    validacion = 0;
    M1=[EstadoPosible NodoCandidato];
    M2=[NodoCandidato EstadoPosible];
    for i=1:N
    % Si no está, entonces agregarlo. % Si está, entonces desecharlo.
        if isequal(M1,MatrizNodosCaballos(i,:)) || isequal(M2,MatrizNodosCaballos(i,:)) || isequal(EstadoPosible,NodoCandidato)
            validacion = 1;
        end
    end
    if validacion == 0 
        MatrizJerarquia = [EstadoPosible NodoCandidato];
        MatrizNodosCaballos = cat(1,MatrizNodosCaballos,MatrizJerarquia);
    end
end
%% Funcion Comparar PAR vs IMPAR
function [AccionNodoValido] = CompararParImpar(EstadoPosible,Matriz,MatrizNodosCaballos)
    % Determinar V1
        % Encontrar el Padre de EstadoPosible
        [F,C]=size(MatrizNodosCaballos);
        MatrizNodosCaballosA=MatrizNodosCaballos(:,1:C/2);
        MatrizNodosCaballosB=MatrizNodosCaballos(:,C/2+1:end);
        for i=1:F
            if isequal(MatrizNodosCaballosB(i,:),EstadoPosible)
                PadreEstadoPosible=MatrizNodosCaballosA(i,:);
                
            end
        end
        % Definir la ficha movida entre Padre y EstadoPosible
    % Determinar V2
    % Definir si/no ingresar nodo
end
function NoPe=evaluarNodosPendientes(Matriz)
    [N,~]=size(Matriz);
    for i=1:N
        if Matriz(i,end)==0
            Nope=1;
            break;
        end
    end
end
%% IDNodos
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
        %Estado=str2double(regexp(num2str(C),'\d','match'));
        Estado=str2double(regexp(num2str(C, '%09.f'),'\d','match'));
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
function [Trayectoria] = trayectoriasujeto(Matriz1,Matriz2)
    Trayectoria=[];
    MatrizGrafo=Matriz2(:,1:9);
    [A,~]=size(Matriz1);
    [B,~]=size(Matriz2);
    for i=1:A
        for j=1:B
            if isequal(Matriz1(i,:),MatrizGrafo(j,:))
                Trayectoria = cat(1,Trayectoria,j);
            end
        end
    end
end