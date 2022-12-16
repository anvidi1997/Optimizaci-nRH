clc
close all
clear all

%Excel con los pacientes a una matriz "A"
% filename = 'platillaReducida.xlsx';
filename = '120922SOL.xlsx';
[num,txt,raw] = xlsread(filename);


%quitamos la primera fila de la matriz de datos (no contiene inforacion
%relevante
txt(1,:)=[];

%matriz para leer el tipo de estudio
A=txt(:,5);


%sacamos el tamaño de la matriz para saber cuantos pacientes tenemos
j=size(A,1);

%Declaro una matriz para guardar las prioridades del tamaño del numero de
%pacientes

prioridad_base = zeros(j,0);

%rellenamos con la prioridad segun el tipo de estudio

for i = 1:j
    
  if  A(i,1)=="TUMOR" 
       prioridad_base(i,1)=1;
%     else if  A(i,1)=="TUMOR"
%         prioridad_base(i-1,1)=1;
  
    elseif A(i,1)=="INFECCIOSO"
        prioridad_base(i,1)=1.6;
        else
            prioridad_base(i,1)=3;
 
   end 
end
  

%imprimimimos para comprobar que lo esta calculando bien
prioridad_base;

%--------------------------------------------------------------------
%Actualizamos la prioridad base según el estado clínico

%valores para actualizar prioridad segun su estado
ponderaciones= [-0.4,-0.2,-0.3,0.6];

%matriz para leer el estado clinico
B=txt(:,9);

%tamaño matriz estado clinico
k=size(B,1);

%Matriz para actualizar prioridad
prioridad_actualizada= zeros(k,0);


%Calculo segun el estado clinico
for i = 1:k
    
    n=B(i,1);
      
   switch true
       
    case (strcmpi(n,'Diagnostico')==1)
       prioridad_actualizada(i,1)=prioridad_base(i,1)+ponderaciones(1,1);
    case (strcmpi(n,'Progresion')==1)
        prioridad_actualizada(i,1)=prioridad_base(i,1)+ponderaciones(1,2);
    case (strcmpi(n,'Respuesta')==1)
        prioridad_actualizada(i,1)=prioridad_base(i,1)+ponderaciones(1,3);
    case (strcmpi(n,'Estable')==1) 
        prioridad_actualizada(i,1)=prioridad_base(i,1)+ponderaciones(1,4);
    otherwise
        prioridad_actualizada(i,1)=prioridad_base(i,1);
   
   end
end


%comprobamos que el calculo de la prioridad sea correcto
prioridad_actualizada;

%-------------------------------------------------------------------------

%Actualizamos la prioiridad según los criterios alarma
ponderacionesAlarma = [-0.6,0.2];

%matriz para leer criterios de alarma
B=txt(:,27);

%Calculo segun el criterio de alarma
for i = 1:k
    
    n=B(i,1);
    
   switch true
       
    case (strcmpi(n,'si')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesAlarma(1,1);
    case (strcmpi(n,'no')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesAlarma(1,2);

    otherwise
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesAlarma(1,2);

  
      
     
    end
end

%comprobamos que se calculo correctamente
prioridad_actualizada;

%-------------------------------------------------------------------------
%Actualizamos según Prioridad clínica
ponderacionesPrioridadClinica = [0.2,-0.1,-0.2];

%matriz para leer Prioridad clínica
B=txt(:,10);

%Calculo segun la Prioridad clínica
for i = 1:k
    
    n=B(i,1);

   switch true
       
    case (strcmpi(n,'Ambulatorio sin visita sucesiva')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesPrioridadClinica(1,1);
    case (strcmpi(n,'Ambulatorio con visita sucesiva')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesPrioridadClinica(1,1);
    case (strcmpi(n,'Ambulatorio preferente')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesPrioridadClinica(1,2);
    case (strcmpi(n,'Paciente en Consulta Diagnóstico Rápido')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesPrioridadClinica(1,3);
    otherwise
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1);

   end
    
end

%comprobamos

prioridad_actualizada;

%--------------------------------------------------------------------
%Actualizando la prioridad por objetivo de la visita

ponderacionesObjetivoExp = [0,-0.2];

%matriz para leer objetivo de la visita
B=txt(:,6);

%Calculo segun objetivo de la visita

for i = 1:k
    
    n=B(i,1);
    
   switch true
       
    case (strcmpi(n,'Seguimiento')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesObjetivoExp(1,1);
    case (strcmpi(n,'Diagnóstico')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesObjetivoExp(1,2);
   otherwise
          prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesObjetivoExp(1,1);
   
   end 
   
end

prioridad_actualizada;

%-----------------------------------------------------------------------
%Actualizamos por COTMES

ponderacionesCOTMES = [0,-0.3];

%matriz para leer COTMES
B=txt(:,28);

%Calculo segun COTMES
for i = 1:k
    
    n=B(i,1);
    
   switch true
       
    case (strcmpi(n,'no')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesCOTMES(1,1);
    case (strcmpi(n,'si')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesCOTMES(1,2);
   otherwise
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesCOTMES(1,1);
   
   end 
   
end

%comprobamos
prioridad_actualizada;

%-----------------------------------------------------------------------
%Actualizando la prioridad por ensayo clínico

ponderacionesEnsayoC= [0,-2];

%matriz para leer ensayo clínico
B=txt(:,26);

%Calculo segun ensayo clínico

for i = 1:k
    
    n=B(i,1);
    
   switch true
       
    case (strcmpi(n,'no')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesEnsayoC(1,1);
    case (strcmpi(n,'si')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesEnsayoC(1,2);
   otherwise
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesEnsayoC(1,1);
   
   end 
   
end

%comprobamos
prioridad_actualizada;
%-----------------------------------------------------------------------
%Actualizando por incapacidad laboral

ponderacionesIncapacidadLaboral = [0,-0.2];

%matriz para leer incapacidad laboral
B=txt(:,24);

%Calculo segun incapacidad laboral

for i = 1:k
    
    n=B(i,1);
    
   switch true
       
    case (strcmpi(n,'no')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesIncapacidadLaboral(1,1);
    case (strcmpi(n,'si')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesIncapacidadLaboral(1,2);
   otherwise
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesIncapacidadLaboral(1,1);
   
   end 
   
end

%comprobamos
prioridad_actualizada;
%-----------------------------------------------------------------------
%Actualizando por si hay dependientes a cargo del paciente

ponderacionesHayDependientes = [0,-0.2];

%matriz para leer hay dependientes a cargo del paciente
B=txt(:,25);
for i = 1:k
    
    n=B(i,1);
    
   switch true
       
    case (strcmpi(n,'no')==1)
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesIncapacidadLaboral(1,1);
    case (strcmpi(n,'si')==1)
        prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesIncapacidadLaboral(1,2);
   otherwise
       prioridad_actualizada(i,1)=prioridad_actualizada(i,1)+ponderacionesIncapacidadLaboral(1,1);
   
   end 
   
end
   
%-----------------------------------------------------------------------
%peor y mejor caso posible de prioridad y diferencia
prioridadmaxima=-3.1;
prioridadminima=4;
Difmaxdeprio=7.1;

%prioridades clinicas en porcentajes entre 0 y 1, para no operar con
%numeros negativos, cuando no estemos ni en peor ni el mejor caso haremos
%la suma de la prioridad -la prioridad maxima (trabajare como si la prioridad
%fuese de 0 a 6.7, de ahi el -0.2 de la prioridad maxima) para asegurarnos que el
%valor con el que se opera siempre es mayor a 0 y menor a 3.6, una vez realizado lo
%dividiremos por la diferencia maxima que puede haber entre 2 prioridades,
%este porcentaje es el inverso ya que cuanto mas alejado de la prioridad
%maxima mas % tenemos por lo tanto hacemos 1- este valor y conseguimos el 
% correspondiente a cada paciente
for i = 1:k

    
    n=prioridad_actualizada(i,1);
    
switch n
       
    case -3.1
       prioridad_actualizada(i,1)= 1;
    case 4
        prioridad_actualizada(i,1)= 0;
    otherwise
        prioridad_actualizada(i,1)=1-((prioridad_actualizada(i,1)-prioridadmaxima)/Difmaxdeprio);
end
end
prioridad_actualizada;
%--------------------------------------------------------------------------------------------------

%fecha de peticion
TPET=raw(:,2);
TPET(1,:)=[];
%tamaño de la matriz de fechas de peticion 
Tam=size(TPET,1);

%Quitar nulos exportados del excel en las fechas
for  i=Tam:-1:k+1
   
   TPET(i,:)=[];

end

%comprobacion matriz fechas peticion
TPET;

%fecha CEX
TCEX=raw(:,3);
TCEX(1,:)=[];

%tamaño de la matriz de fechas CEX
Tam2=size(TCEX,1);

%Quitar nulos expo;rtados del excel en las fechas

for  i=Tam2:-1:k+1
   
   TCEX(i,:)=[];

end

%comprobacion matriz fechas CEX
TCEX;

PrimeraPeticion="0";
UltimaPeticion="0";
%orden de las fechas de peticion

for i = 1:k  

   res = datetime(TPET(i,:),'InputFormat','dd/MM/yyyy HH:mm:SS','Format','dd/MM/yyyy HH:mm:SS');

   if PrimeraPeticion=="0" && UltimaPeticion=="0"
       PrimeraPeticion=TPET(i,:);
       UltimaPeticion=TPET(i,:);
   else
       dias=datenum(PrimeraPeticion,'dd/mm/yyyy HH:MM:SS')-datenum(TPET(i,:),'dd/mm/yyyy HH:MM:SS');
       if dias>0
           PrimeraPeticion=TPET(i,:);
       else
       dias=datenum(UltimaPeticion,'dd/mm/yyyy HH:MM:SS')-datenum(TPET(i,:),'dd/mm/yyyy HH:MM:SS');
            if dias<0
                
                 UltimaPeticion=TPET(i,:);
                
            end
       end
   end  
end

%Comprobamos si las peticiones se han ordenado de forma correcta
PrimeraPeticion;
UltimaPeticion;

%VARIABLE PARA HACER LOS PORCENTAJES RELATIVOS A LA FECHA DE PETICION
DifPET=datenum(UltimaPeticion,'dd/mm/yyyy HH:MM:SS')-datenum(PrimeraPeticion,'dd/mm/yyyy HH:MM:SS');

PrimeraFechaCEX="0";
UltimaFechaCEX="0";

%orden de las fechas CEX
for i = 1:k

   res = datetime(TCEX(i,:),'InputFormat','dd/MM/yyyy','Format','dd/MM/yyyy');

   if PrimeraFechaCEX=="0" && UltimaFechaCEX=="0"
       PrimeraFechaCEX=TCEX(i,:);
       UltimaFechaCEX=TCEX(i,:);
   else
       dias=datenum(PrimeraFechaCEX,'dd/mm/yyyy')-datenum(TCEX(i,:),'dd/mm/yyyy');
       if dias>0
           PrimeraFechaCEX=TCEX(i,:);
       else
       dias=datenum(UltimaFechaCEX,'dd/mm/yyyy')-datenum(TCEX(i,:),'dd/mm/yyyy');
            if dias<0
                
                 UltimaFechaCEX=TCEX(i,:);
                
            end
       end
   end  
end

%Comprobamos si las fechas CEX se han ordenado de forma correcta
PrimeraFechaCEX;
UltimaFechaCEX;

%VARIABLE PARA HACER LOS PORCENTAJES RELATIVOS A LA FECHA DE PETICION
DifCEX=datenum(UltimaFechaCEX,'dd/mm/yyyy')-datenum(PrimeraFechaCEX,'dd/mm/yyyy');

%CALCULO DE LA PRIORIDAD DE CADA PACIENTE
% 0.7x Criterios medicos relativos al estado del paciente asi como la
% incapacidad laboral, 0.2x Fecha CEX siendo 0.2 la fecha mas cercana y 0
% la mas lejana y por ultimo 0.1x Fecha de petición siendo como en las
% fechas CEX 0.1 la mas cercana y 0 la mas lejana


%Calculamos la cantidad de dias entre la primera fecha y el resto para
%luego sacar el porce ntaje del 0.1 correspondiente a peticiones que le
%pertenece a cada paciente 


%matrizes para guardar las prioridades de los pacientes que corresponden a
%peticiones y fechas CEX
prioridadPET = zeros(k,1);
prioridadCEX = zeros(k,1);

for i = 1:k

   res = datetime(TPET(i,:),'InputFormat','dd/MM/yyyy HH:mm:SS','Format','dd/MM/yyyy HH:mm:SS ');

   diaspet=datenum(TPET(i,:),'dd/mm/yyyy HH:MM:SS')-datenum(PrimeraPeticion,'dd/mm/yyyy HH:MM:SS');
  
   prioridadPET(i,:) = (1-(diaspet/DifPET))*0.1;
    
end

%comprobacion prioridad por petición
prioridadPET;

%Calculamos la cantidad de dias entre la primera fecha y el resto para
%luego sacar el porcentaje del 0.2 correspondiente a fechas CEX que le
%pertenece a cada paciente 

for i = 1:k
    
    res = datetime(TCEX(i,:),'InputFormat','dd/MM/yyyy','Format','dd/MM/yyyy');
    
    diasCEX=datenum(TCEX(i,:),'dd/mm/yyyy')-datenum(PrimeraFechaCEX,'dd/mm/yyyy');
    
    prioridadCEX(i,:) =  (1-(diasCEX/DifCEX))*0.2;
    
end

%comprobacion prioridad por petición
prioridadCEX;


%PRIORIDADES FINALES 
prioridadFINAL = zeros(k,1);

for i = 1:k
    
    %restamos las prioridades por peticion y por fecha CEX  a la prioridad
    %por criterios medicos
    prioridadFINAL(i,:)=-prioridad_actualizada(i,:)*0.7-prioridadCEX(i,:)-prioridadPET(i,:);
    
end

%prioridad final-->Menor es mas prioridad
prioridadFINAL;
%ordenamos las prioridades 
prioridadFINALorden= sort (prioridadFINAL);

%MATRIX DE PACIENTES
z=txt(:,:);

prioridadFINALorden;




%buscamos a que paciente pertenece cada prioridad y hacemos la tabla para
%guardarlos
t = table('Size',[k 12],'VariableTypes',{'double','string','string','string','string','string','string','string','string','string','string','string'});
t.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Urgente','Ingresado','AlergiasIR','PlanificacionQuirurgica','Directa'};

    for i = 1:k
        %pacientes urgentes/ingresados a P0(maxima prioridad)
        if (strcmpi(string(z{i,18}),'Si')==1)||(strcmpi(string(z{i,19}),'Si')==1)
            t(i,:) = table(-1,z(i,1),z(i,13),z(i,14),z(i,15),z(i,16),z(i,17),z(i,18),z(i,19),z(i,20),z(i,21),z(i,22));
        else
            t(i,:) = table(prioridadFINAL(i,:),z(i,1),z(i,13),z(i,14),z(i,15),z(i,16),z(i,17),z(i,18),z(i,19),z(i,20),z(i,21),z(i,22));
        end           
    end
      
%comrpobamos que laa tabla este bien
t;
t2=t;

%--------------------------------------------------------------------------
%Separaremos en 4 plantillas dependiendo de a que maquinas tienen
%disponibilidad

%Tablas Pacientes que pueden ir a la maquina 1(MAÑANA/TARDE/FINDES)

RM1= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM1.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM1T= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM1T.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM1W= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM1W.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};

%Tablas Pacientes que pueden ir a la maquina 2

RM2= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM2.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM2T= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM2T.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM2W= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM2W.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};

%Tablas Pacientes que pueden ir a la maquina 3
RM3= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM3.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM3T= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM3T.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM3W= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM3W.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};

%Tablas Pacientes que pueden ir a la maquina 4

RM4= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM4.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM4T= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM4T.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};
RM4W= table('Size',[k 7],'VariableTypes',{'double','string','string','string','string','string','string'});
RM4W.Properties.VariableNames = {'Prioridad','Paciente','Region','Marcapasos','Claustrofobia','Protesis','Indirecta'};

%bucle para separar en plantillas dependiendo de en que maquinas pueden ser
%atendidos
for i = 1:k
    
    %variables sacadas de la tabla de prioridades t2
        prioridadt2=string(t2{i,1});
        pacientet2=string(t2{i,2});
        regiont2= string(t2{i,3});
        marcapasost2=string(t2{i,4});
        claustrofobiat2=string(t2{i,5});
        protesist2=string(t2{i,6});
        indirectat2=string(t2{i,7});
        
    switch true
       
        %casos de tener marcapasos
            case (strcmpi(string(t2{i,4}),'Si')==1)
                         switch true
                             %marcapasos+claustrofobia
                             case (strcmpi(string(t2{i,5}),'Si')==1)
                                 %marcapasos+claustrofobia+protesis
                                 if(strcmpi(string(t2{i,6}),'Si')==1)
                                     
                                      RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                 %marcapasos+claustrofobia(no protesis)
                                 else
                                     
                                      RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                 end 
                                 
                             %marcapasos+protesis  
                             case (strcmpi(string(t2{i,6}),'Si')==1)
                                 %marcapasos+protesis(no claustrofobia)
                                 if(strcmpi(string(t2{i,5}),'No')==1)
                                      RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                 end
                                 %solo marcapasos 
                             case (strcmpi(string(t2{i,5}),'No')==1) 
                                 if(strcmpi(string(t2{i,6}),'No')==1)
                                     %casos marcapasos+region
                                     switch true
                                         case (strcmpi(string(t2{i,3}),'Hombro')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         case (strcmpi(string(t2{i,3}),'Pelvis')==1) 
                                           RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                           RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Columna')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Pubis')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Sacroiliacas')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Cadera')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Muslo')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Rodilla')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Pierna')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Tobillo')==1)
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Mediopie')==1) 
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                                         case (strcmpi(string(t2{i,3}),'Antepie')==1)     
                                          RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         case (strcmpi(string(t2{i,3}),'Brazo')==1)  
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                         case (strcmpi(string(t2{i,3}),'Codo')==1)     
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                         case (strcmpi(string(t2{i,3}),'Antebrazo')==1)  
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                         case (strcmpi(string(t2{i,3}),'Muñeca')==1)  
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                         case (strcmpi(string(t2{i,3}),'Mano')==1)     
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         case (strcmpi(string(t2{i,3}),'Dedo')==1)     
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         case (strcmpi(string(t2{i,3}),'Cuerpo entero')==1)
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         case (strcmpi(string(t2{i,3}),'ABDTX')==1)         
                                          RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                             
                                     end
                                  end
                             
                         end            
             %casos claustrofobia
            case (strcmpi(string(t2{i,5}),'Si')==1) 
                switch true
                    %claustro+protesis
                     case(strcmpi(string(t2{i,6}),'Si')==1)
                     RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                    %claustro+indirecta
                     case(strcmpi(string(t2{i,7}),'Si')==1)
                     RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                     %solo claustro  
                     case(strcmpi(string(t2{i,7}),'No')==1)
                     RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                     RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                    
                end
            %solo protesis
            case (strcmpi(string(t2{i,6}),'Si')==1)
                RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                
                    %si no es/hay ingresado/urgente/alergias/planificacion
                    %quirurgica/Artro Directa
                 if (strcmpi(string(t2{i,8}),'No')==1)&&(strcmpi(string(t2{i,9}),'No')==1)&&(strcmpi(string(t2{i,10}),'No')==1)&&(strcmpi(string(t2{i,11}),'No')==1)&&(strcmpi(string(t2{i,12}),'No')==1)
                         switch true
                             case (strcmpi(string(z{i,5}),'Tumor')==1)
                                 %si es tumor pero no se ha complicado ni
                                 %es primer diagnostico lo guardamos
                                 if (strcmpi(string(z{i,6}),'Diagnostico')==0)&& (strcmpi(string(z{i,9}),'Complicacion')==0)
                                 RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                 end
                                 %si no es tumor ni infeccioso lo guardamos
                             case (strcmpi(string(z{i,5}),'INFECCIOSO')==0) 
                                 RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                         end
                 end
                
                
                
            %Caso solo indirecta           
            case (strcmpi(string(t2{i,7}),'Si')==1)
                 switch true
                       case (strcmpi(string(t2{i,3}),'Hombro')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       case (strcmpi(string(t2{i,3}),'Pelvis')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Columna')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Pubis')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Sacroiliacas')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Cadera')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Muslo')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Rodilla')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Pierna')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Tobillo')==1)
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Mediopie')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        
                       case (strcmpi(string(t2{i,3}),'Antepie')==1)     
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       case (strcmpi(string(t2{i,3}),'Brazo')==1)  
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Codo')==1)     
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Antebrazo')==1)  
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Muñeca')==1)  
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Mano')==1)     
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       case (strcmpi(string(t2{i,3}),'Dedo')==1)     
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       case (strcmpi(string(t2{i,3}),'Cuerpo entero')==1)
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       case (strcmpi(string(t2{i,3}),'ABDTX')==1)         
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                            
                 end
                 if (strcmpi(string(t2{i,8}),'No')==1)&&(strcmpi(string(t2{i,9}),'No')==1)&&(strcmpi(string(t2{i,10}),'No')==1)&&(strcmpi(string(t2{i,11}),'No')==1)&&(strcmpi(string(t2{i,12}),'No')==1)
                         switch true
                             case (strcmpi(string(z{i,5}),'Tumor')==1)
                                 %si es tumor pero no se ha complicado ni
                                 %es primer diagnostico lo guardamos
                                 if (strcmpi(string(z{i,6}),'Diagnostico')==0)&& (strcmpi(string(z{i,9}),'Complicacion')==0)
                                  switch true
                                   case (strcmpi(string(t2{i,3}),'Hombro')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Pelvis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Columna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Pubis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Sacroiliacas')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Cadera')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Muslo')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Rodilla')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Pierna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Tobillo')==1)
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Mediopie')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Antepie')==1)     
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Brazo')==1)  
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Codo')==1)     
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Antebrazo')==1)  
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Muñeca')==1)  
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Mano')==1)     
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Dedo')==1)     
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Cuerpo entero')==1)
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'ABDTX')==1)         
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   

                                  end
                                 end
                                 %si no es tumor ni infeccioso lo guardamos
                             case (strcmpi(string(z{i,5}),'INFECCIOSO')==0) 
                                 switch true
                                   case (strcmpi(string(t2{i,3}),'Hombro')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Pelvis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Columna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Pubis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Sacroiliacas')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Cadera')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Muslo')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Rodilla')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Pierna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Tobillo')==1)
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Mediopie')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Antepie')==1)     
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Brazo')==1)  
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Codo')==1)     
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Antebrazo')==1)  
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Muñeca')==1)  
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Mano')==1)     
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Dedo')==1)     
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Cuerpo entero')==1)
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'ABDTX')==1)         
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   

                                  end
                         end
                 end
                 
             %Caso ninguna de las anteriores solo region 
             
            case (strcmpi(string(t2{i,7}),'No')==1)  
                switch true
                       case (strcmpi(string(t2{i,3}),'Hombro')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       case (strcmpi(string(t2{i,3}),'Pelvis')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);                  
                       case (strcmpi(string(t2{i,3}),'Columna')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);  
                       case (strcmpi(string(t2{i,3}),'Pubis')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);                                      
                       case (strcmpi(string(t2{i,3}),'Sacroiliacas')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);                                           
                       case (strcmpi(string(t2{i,3}),'Cadera')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);               
                       case (strcmpi(string(t2{i,3}),'Muslo')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);            
                       case (strcmpi(string(t2{i,3}),'Rodilla')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);  
                       case (strcmpi(string(t2{i,3}),'Pierna')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);  
                       case (strcmpi(string(t2{i,3}),'Tobillo')==1)
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);          
                       case (strcmpi(string(t2{i,3}),'Mediopie')==1) 
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);             
                       case (strcmpi(string(t2{i,3}),'Antepie')==1)     
                       RM1(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM3(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                       case (strcmpi(string(t2{i,3}),'Brazo')==1)  
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Codo')==1)     
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Antebrazo')==1)  
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Muñeca')==1)  
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Mano')==1)     
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Dedo')==1)     
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'Cuerpo entero')==1)
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       case (strcmpi(string(t2{i,3}),'ABDTX')==1)         
                       RM2(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                       RM4(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                             
                end
                 if (strcmpi(string(t2{i,8}),'No')==1)&&(strcmpi(string(t2{i,9}),'No')==1)&&(strcmpi(string(t2{i,10}),'No')==1)&&(strcmpi(string(t2{i,11}),'No')==1)&&(strcmpi(string(t2{i,12}),'No')==1)
                         switch true
                             case (strcmpi(string(z{i,5}),'Tumor')==1)
                                 %si es tumor pero no se ha complicado ni
                                 %es primer diagnostico lo guardamos
                                 if (strcmpi(string(z{i,6}),'Diagnostico')==0)&& (strcmpi(string(z{i,9}),'Complicacion')==0)
                                  switch true
                                   case (strcmpi(string(t2{i,3}),'Hombro')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Pelvis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2); 
                                   case (strcmpi(string(t2{i,3}),'Columna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2); 
                                   case (strcmpi(string(t2{i,3}),'Pubis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Sacroiliacas')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Cadera')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Muslo')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Rodilla')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Pierna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Tobillo')==1)
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Mediopie')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Antepie')==1)     
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Brazo')==1)  
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Codo')==1)     
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);  
                                   case (strcmpi(string(t2{i,3}),'Antebrazo')==1)  
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Muñeca')==1)  
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Mano')==1)     
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Dedo')==1)     
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Cuerpo entero')==1)
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'ABDTX')==1)         
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2); 

                                  end
                                 end
                                 %si no es tumor ni infeccioso lo guardamos
                             case (strcmpi(string(z{i,5}),'INFECCIOSO')==0) 
                                 switch true
                                   case (strcmpi(string(t2{i,3}),'Hombro')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                    if (strcmpi(string(t2{i,5}),'ARTICULAR')==1) 
                                        RM1W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        RM2W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        RM3W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        RM4W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                    end
                                   case (strcmpi(string(t2{i,3}),'Pelvis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2); 
                                   case (strcmpi(string(t2{i,3}),'Columna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2); 
                                   case (strcmpi(string(t2{i,3}),'Pubis')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Sacroiliacas')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Cadera')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Muslo')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Rodilla')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        if (strcmpi(string(t2{i,5}),'ARTICULAR')==1) 
                                         RM1W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         RM2W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         RM3W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                         RM4W(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                        end
                                   case (strcmpi(string(t2{i,3}),'Pierna')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Tobillo')==1)
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Mediopie')==1) 
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);

                                   case (strcmpi(string(t2{i,3}),'Antepie')==1)     
                                   RM1T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM3T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Brazo')==1)  
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Codo')==1)     
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);  
                                   case (strcmpi(string(t2{i,3}),'Antebrazo')==1)  
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Muñeca')==1)  
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);   
                                   case (strcmpi(string(t2{i,3}),'Mano')==1)     
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Dedo')==1)     
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'Cuerpo entero')==1)
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   case (strcmpi(string(t2{i,3}),'ABDTX')==1)         
                                   RM4T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2);
                                   RM2T(i,:) = table(prioridadt2,pacientet2,regiont2,marcapasost2,claustrofobiat2,protesist2,indirectat2); 

                                  end
                         end
                 end
                 
    end
     
           
      
                   
end

%eliminando missings horarios de la mañana
RM1;
RM111 = rmmissing(RM1);
RM11=sortrows(RM111);
RM2;
RM222 = rmmissing(RM2);
RM22=sortrows(RM222);
RM3;
RM333 = rmmissing(RM3);
RM33=sortrows(RM333);
RM4;
RM444 = rmmissing(RM4);
RM44=sortrows(RM444);
%eliminando missings horarios de la Tarde
RM1T;
RM11T1 = rmmissing(RM1T);
RM11T=sortrows(RM11T1);
RM2T;
RM22T1 = rmmissing(RM2T);
RM22T=sortrows(RM22T1);
RM3T;
RM33T1 = rmmissing(RM3T);
RM33T=sortrows(RM33T1);
RM4T;
RM44T1 = rmmissing(RM4T);
RM44T=sortrows(RM44T1);
%eliminando missings horarios del fin de semana
RM1W;
RM2W;
RM3W;
RM4W;
RM11W1 = rmmissing(RM1W);
RM22W1 = rmmissing(RM2W);
RM33W1 = rmmissing(RM3W);
RM44W1 = rmmissing(RM4W);
RM11W=sortrows(RM11W1);
RM22W=sortrows(RM22W1);
RM33W=sortrows(RM33W1);
RM44W=sortrows(RM44W1);

%--------------------------------------------------------------------------
%Excel Horario semana
filenamehorario = 'Horario22S';
%Cojomos el horario y lo guardamos en una matriz
[num,txt,raw] = xlsread(filenamehorario);

%buscamos la palabra clave en el horario 
[row,col] =find(txt=="ME");

% asignamos los huecos medios a los turnos de tarde y de mañana
huecosM=21;
huecosT=21;

%TABLAS PARA TRABAJAR SOBRE LA PLANTILLA DE HORARIOS
TP = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TP.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TP2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TP2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TP3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TP3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TP4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TP4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPLUNT = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPLUNT.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPLUNT2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPLUNT2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPLUNT3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPLUNT3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPLUNT4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPLUNT4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMAR = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMAR.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMAR2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMAR2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMAR3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMAR3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMAR4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMAR4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMART = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMART.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMART2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMART2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMART3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMART3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMART4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMART4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPMIE = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIE.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMIE2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIE2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMIE3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIE3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMIE4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIE4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPMIET = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIET.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMIET2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIET2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMIET3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIET3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPMIET4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPMIET4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPJUE = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUE.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPJUE2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUE2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPJUE3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUE3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPJUE4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUE4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPJUET = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUET.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPJUET2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUET2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPJUET3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUET3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPJUET4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPJUET4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPVIE = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIE.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPVIE2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIE2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPVIE3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIE3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPVIE4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIE4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPVIET = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIET.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPVIET2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIET2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPVIET3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIET3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPVIET4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPVIET4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPSAB = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSAB.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPSAB2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSAB2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPSAB3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSAB3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPSAB4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSAB4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPSABT = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSABT.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPSABT2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSABT2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPSABT3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSABT3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPSABT4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPSABT4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

TPDOM = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOM.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPDOM2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOM2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPDOM3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOM3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPDOM4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOM4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};


TPDOMT = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOMT.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPDOMT2 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOMT2.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPDOMT3 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOMT3.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};
TPDOMT4 = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
TPDOMT4.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Turnos'};

%cojemos el tamaño de una de las matrizes de coordenadas
s=size(row,1);

%declaramos la variable huecos y un contador(no todos los pacientes ocupan
%los mismos huecos)
%el contador lo usaremos para ir rellenando la tabla
huecos= 0;
contador=1;

%el contador2 sera para asegurarse de que no se exeda el tamaño de la
%matriz de pacientes ya que es posible que tengamos menos pacientes que
%horas disponibles

contador2=1;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%POSIBLE QUE SE TENGA QUE METER EN EL BUCLE Y REINICIARSE A 1 PARA CADA
%ITERACCION

%Excel de pacientes
filename = '120922SOL.xlsx';
%Cojomos el horario y lo guardamos en una matriz
[numpac,txtpac,rawpac] = xlsread(filename);

%CONTADOR PARA ACTUALIZAR HORARIOS( PARA LAS POSICIONES EN LOS
%DIFERENTES DIAS
contadorACT=1;

 for i = 1:s
        contador3=1;
        %HORARIO ENCONTRADO
        dia = raw(2,col(i,1));
        diames= raw(1,col(i,1));
        mes=raw(1,1);
        maquina=raw(row(i,1),1);
        turno=raw(row(i,1),2);
        %DECISION HUECOS
        if raw(row(i,1),2)== "M"
            huecos=huecosM;
            switch true
                case (strcmpi(maquina,'RM1')==1) 
                    p=size(RM11,1);
                case (strcmpi(maquina,'RM2')==1)
                    p=size(RM22,1);
                case (strcmpi(maquina,'RM3')==1)
                    p=size(RM33,1);
                case (strcmpi(maquina,'RM4')==1)
                    p=size(RM44,1);
                
            end
                
        else
             huecos=huecosT;
            switch true
                case (strcmpi(maquina,'RM1')==1) 
                     p=size(RM11T,1);
                case (strcmpi(maquina,'RM2')==1)
                    p=size(RM22T,1);
                case (strcmpi(maquina,'RM3')==1)
                     p=size(RM33T,1);
                case (strcmpi(maquina,'RM4')==1)
                    p=size(RM44T,1);
                
            end
        
        end
        
        while huecos>0 && contador2<k+1 && contador3<p+1
            
            
            switch true
                %horarios del lunes
                case (strcmpi(dia,'Lun')==1)
                    %turno de mañana
                    if(strcmpi(turno,'M')==1)
                        switch true
                            %LUNES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM11{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TP(contadorACT,:) = table(string(RM11{contador,2}),dia,diames,mes,maquina,turno,string(RM11{contador,3}),string(RM11{contador,4}),string(RM11{contador,5}),string(RM11{contador,6}),string(RM11{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TP(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TP(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TP(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TP(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TP(contadorACT,12)=table("2");
                                        otherwise
                                         TP(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %LUNES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM22{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TP2(contadorACT,:) = table(string(RM22{contador,2}),dia,diames,mes,maquina,turno,string(RM22{contador,3}),string(RM22{contador,4}),string(RM22{contador,5}),string(RM22{contador,6}),string(RM22{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                   switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TP2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TP2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TP2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TP2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TP2(contadorACT,12)=table("2");
                                        otherwise
                                         TP2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                   end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %LUNES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM33{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TP3(contadorACT,:) = table(string(RM33{contador,2}),dia,diames,mes,maquina,turno,string(RM33{contador,3}),string(RM33{contador,4}),string(RM33{contador,5}),string(RM33{contador,6}),string(RM33{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TP3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TP3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TP3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TP3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TP3(contadorACT,12)=table("2");
                                        otherwise
                                         TP3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %LUNES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM44{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TP4(contadorACT,:) = table(string(RM44{contador,2}),dia,diames,mes,maquina,turno,string(RM44{contador,3}),string(RM44{contador,4}),string(RM44{contador,5}),string(RM44{contador,6}),string(RM44{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TP4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TP4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TP4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TP4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TP4(contadorACT,12)=table("2");
                                        otherwise
                                         TP4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    
                        end 
%-------------------------------------------------------------------------                        
                    else
                        %LUNES TARDE
                        switch true
                            %LUNES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM11T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPLUNT(contadorACT,:) = table(string(RM11T{contador,2}),dia,diames,mes,maquina,turno,string(RM11T{contador,3}),string(RM11T{contador,4}),string(RM11T{contador,5}),string(RM11T{contador,6}),string(RM11T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPLUNT(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPLUNT(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPLUNT(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPLUNT(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPLUNT(contadorACT,12)=table("2");
                                        otherwise
                                         TPLUNT(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %LUNES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM22T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPLUNT2(contadorACT,:) = table(string(RM22T{contador,2}),dia,diames,mes,maquina,turno,string(RM22T{contador,3}),string(RM22T{contador,4}),string(RM22T{contador,5}),string(RM22T{contador,6}),string(RM22T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPLUNT2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPLUNT2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                          TPLUNT2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPLUNT2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                          TPLUNT2(contadorACT,12)=table("2");
                                        otherwise
                                         TPLUNT2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %LUNES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM33T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPLUNT3(contadorACT,:) = table(string(RM33T{contador,2}),dia,diames,mes,maquina,turno,string(RM33T{contador,3}),string(RM33T{contador,4}),string(RM33T{contador,5}),string(RM33T{contador,6}),string(RM33T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPLUNT3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPLUNT3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPLUNT3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPLUNT3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPLUNT3(contadorACT,12)=table("2");
                                        otherwise
                                         TPLUNT3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %LUNES MAQUINA 4
                           
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPLUNT4(contadorACT,:) = table(string(RM44T{contador,2}),dia,diames,mes,maquina,turno,string(RM44T{contador,3}),string(RM44T{contador,4}),string(RM44T{contador,5}),string(RM44T{contador,6}),string(RM44T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPLUNT4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPLUNT4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                          TPLUNT4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                         TPLUNT4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                          TPLUNT4(contadorACT,12)=table("2");
                                        otherwise
                                         TPLUNT4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    
                        end
                    end
%-------------------------------------------------------------------------                      
                case (strcmpi(dia,'Mar')==1)
                    if(strcmpi(turno,'M')==1)
                        %MARTES MAÑANA
                        switch true
                            %MARTES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMAR(contadorACT,:) = table(string(RM11{contador,2}),dia,diames,mes,maquina,turno,string(RM11{contador,3}),string(RM11{contador,4}),string(RM11{contador,5}),string(RM11{contador,6}),string(RM11{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMAR(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMAR(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMAR(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMAR(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMAR(contadorACT,12)=table("2");
                                        otherwise
                                         TPMAR(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %MARTES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMAR2(contadorACT,:) = table(string(RM22{contador,2}),dia,diames,mes,maquina,turno,string(RM22{contador,3}),string(RM22{contador,4}),string(RM22{contador,5}),string(RM22{contador,6}),string(RM22{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMAR2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMAR2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMAR2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMAR2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMAR2(contadorACT,12)=table("2");
                                        otherwise
                                         TPMAR2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %MARTES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMAR3(contadorACT,:) = table(string(RM33{contador,2}),dia,diames,mes,maquina,turno,string(RM33{contador,3}),string(RM33{contador,4}),string(RM33{contador,5}),string(RM33{contador,6}),string(RM33{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMAR3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMAR3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMAR3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMAR3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMAR3(contadorACT,12)=table("2");
                                        otherwise
                                         TPMAR3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %MARTES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMAR4(contadorACT,:) = table(string(RM44{contador,2}),dia,diames,mes,maquina,turno,string(RM44{contador,3}),string(RM44{contador,4}),string(RM44{contador,5}),string(RM44{contador,6}),string(RM44{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMAR4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMAR4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMAR4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMAR4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMAR4(contadorACT,12)=table("2");
                                        otherwise
                                         TPMAR4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    
                        end
                        
                    else
                        %MARTES TARDE
                       switch true
                            %MARTES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMART(contadorACT,:) = table(string(RM11T{contador,2}),dia,diames,mes,maquina,turno,string(RM11T{contador,3}),string(RM11T{contador,4}),string(RM11T{contador,5}),string(RM11T{contador,6}),string(RM11T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMART(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMART(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMART(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMART(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMART(contadorACT,12)=table("2");
                                        otherwise
                                         TPMART(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %MARTES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMART2(contadorACT,:) = table(string(RM22T{contador,2}),dia,diames,mes,maquina,turno,string(RM22T{contador,3}),string(RM22T{contador,4}),string(RM22T{contador,5}),string(RM22T{contador,6}),string(RM22T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMART2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMART2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                          TPMART2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMART2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMART2(contadorACT,12)=table("2");
                                        otherwise
                                         TPMART2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %MARTES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMART3(contadorACT,:) = table(string(RM33T{contador,2}),dia,diames,mes,maquina,turno,string(RM33T{contador,3}),string(RM33T{contador,4}),string(RM33T{contador,5}),string(RM33T{contador,6}),string(RM33T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMART3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMART3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMART3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                           huecos=huecos-2;
                                           TPMART3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMART3(contadorACT,12)=table("2");
                                        otherwise
                                         TPMART3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %MARTES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM44T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMART4(contadorACT,:) = table(string(RM44T{contador,2}),dia,diames,mes,maquina,turno,string(RM44T{contador,3}),string(RM44T{contador,4}),string(RM44T{contador,5}),string(RM44T{contador,6}),string(RM44T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMART4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMART4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMART4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMART4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMART4(contadorACT,12)=table("2");
                                        otherwise
                                         TPMART4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    
                        end
                    end
%---------------------------------------------------------------------------------------------
                case (strcmpi(dia,'Mier')==1)
                        %horarios del MIERCOLES
                    if(strcmpi(turno,'M')==1)
                        %MIERCOLES MAÑANA
                        switch true
                            %MIERCOLES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIE(contadorACT,:) = table(string(RM11{contador,2}),dia,diames,mes,maquina,turno,string(RM11{contador,3}),string(RM11{contador,4}),string(RM11{contador,5}),string(RM11{contador,6}),string(RM11{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIE(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIE(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMIE(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMIE(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                          TPMIE(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIE(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %MIERCOLES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIE2(contadorACT,:) = table(string(RM22{contador,2}),dia,diames,mes,maquina,turno,string(RM22{contador,3}),string(RM22{contador,4}),string(RM22{contador,5}),string(RM22{contador,6}),string(RM22{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIE2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIE2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                          TPMIE2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMIE2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMIE2(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIE2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %MIERCOLES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIE3(contadorACT,:) = table(string(RM33{contador,2}),dia,diames,mes,maquina,turno,string(RM33{contador,3}),string(RM33{contador,4}),string(RM33{contador,5}),string(RM33{contador,6}),string(RM33{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIE3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIE3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMIE3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMIE3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMIE3(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIE3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %MIERCOLES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIE4(contadorACT,:) = table(string(RM44{contador,2}),dia,diames,mes,maquina,turno,string(RM44{contador,3}),string(RM44{contador,4}),string(RM44{contador,5}),string(RM44{contador,6}),string(RM44{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIE4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIE4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                          TPMIE4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                         TPMIE4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMIE4(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIE4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    
                        end
                    else
                        %MIERCOLES TARDE
                         switch true
                            %MIERCOLES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIET(contadorACT,:) = table(string(RM11T{contador,2}),dia,diames,mes,maquina,turno,string(RM11T{contador,3}),string(RM11T{contador,4}),string(RM11T{contador,5}),string(RM11T{contador,6}),string(RM11T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIET(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIET(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMIET(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMIET(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMIET(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIET(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %MIERCOLES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIET2(contadorACT,:) = table(string(RM22T{contador,2}),dia,diames,mes,maquina,turno,string(RM22T{contador,3}),string(RM22T{contador,4}),string(RM22T{contador,5}),string(RM22T{contador,6}),string(RM22T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIET2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIET2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                          TPMIET2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMIET2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                          TPMIET2(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIET2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %MIERCOLES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIET3(contadorACT,:) = table(string(RM33T{contador,2}),dia,diames,mes,maquina,turno,string(RM33T{contador,3}),string(RM33T{contador,4}),string(RM33T{contador,5}),string(RM33T{contador,6}),string(RM33T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIET3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIET3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMIET3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMIET3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMIET3(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIET3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %MIERCOLES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPMIET4(contadorACT,:) = table(string(RM44T{contador,2}),dia,diames,mes,maquina,turno,string(RM44T{contador,3}),string(RM44T{contador,4}),string(RM44T{contador,5}),string(RM44T{contador,6}),string(RM44T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPMIET4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPMIET4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPMIET4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPMIET4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPMIET4(contadorACT,12)=table("2");
                                        otherwise
                                         TPMIET4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    
                        end
                    end
%--------------------------------------------------------------------------
                case (strcmpi(dia,'Jue')==1)
                    %horarios del JUEVES
                    if(strcmpi(turno,'M')==1)
                        %JUEVES MAÑANA
                        switch true
                            %JUEVES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUE(contadorACT,:) = table(string(RM11{contador,2}),dia,diames,mes,maquina,turno,string(RM11{contador,3}),string(RM11{contador,4}),string(RM11{contador,5}),string(RM11{contador,6}),string(RM11{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUE(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUE(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUE(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUE(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUE(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUE(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %JUEVES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUE2(contadorACT,:) = table(string(RM22{contador,2}),dia,diames,mes,maquina,turno,string(RM22{contador,3}),string(RM22{contador,4}),string(RM22{contador,5}),string(RM22{contador,6}),string(RM22{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUE2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUE2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUE2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUE2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUE2(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUE2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %JUEVES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUE3(contadorACT,:) = table(string(RM33{contador,2}),dia,diames,mes,maquina,turno,string(RM33{contador,3}),string(RM33{contador,4}),string(RM33{contador,5}),string(RM33{contador,6}),string(RM33{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUE3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUE3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUE3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUE3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUE3(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUE3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %JUEVES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUE4(contadorACT,:) = table(string(RM44{contador,2}),dia,diames,mes,maquina,turno,string(RM44{contador,3}),string(RM44{contador,4}),string(RM44{contador,5}),string(RM44{contador,6}),string(RM44{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUE4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUE4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUE4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUE4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUE4(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUE4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    
                        end
                    else
                        %JUEVES TARDE
                         switch true
                            %JUEVES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUET(contadorACT,:) = table(string(RM11T{contador,2}),dia,diames,mes,maquina,turno,string(RM11T{contador,3}),string(RM11T{contador,4}),string(RM11T{contador,5}),string(RM11T{contador,6}),string(RM11T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUET(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUET(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUET(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUET(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUET(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUET(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %JUEVES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUET2(contadorACT,:) = table(string(RM22T{contador,2}),dia,diames,mes,maquina,turno,string(RM22T{contador,3}),string(RM22T{contador,4}),string(RM22T{contador,5}),string(RM22T{contador,6}),string(RM22T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUET2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUET2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUET2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUET2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUET2(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUET2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %JUEVES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUET3(contadorACT,:) = table(string(RM33T{contador,2}),dia,diames,mes,maquina,turno,string(RM33T{contador,3}),string(RM33T{contador,4}),string(RM33T{contador,5}),string(RM33T{contador,6}),string(RM33T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUET3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUET3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUET3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUET3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUET3(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUET3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %JUEVES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPJUET4(contadorACT,:) = table(string(RM44T{contador,2}),dia,diames,mes,maquina,turno,string(RM44T{contador,3}),string(RM44T{contador,4}),string(RM44T{contador,5}),string(RM44T{contador,6}),string(RM44T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPJUET4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPJUET4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPJUET4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPJUET4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPJUET4(contadorACT,12)=table("2");
                                        otherwise
                                         TPJUET4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    
                        end
                    end
%--------------------------------------------------------------------------                    
                case (strcmpi(dia,'Vie')==1)
                    %horarios del VIERNES
                    if(strcmpi(turno,'M')==1)
                        %VIERNES MAÑANA
                        switch true
                            %VIERNES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIE(contadorACT,:) = table(string(RM11{contador,2}),dia,diames,mes,maquina,turno,string(RM11{contador,3}),string(RM11{contador,4}),string(RM11{contador,5}),string(RM11{contador,6}),string(RM11{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIE(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIE(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIE(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIE(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIE(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIE(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %VIERNES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIE2(contadorACT,:) = table(string(RM22{contador,2}),dia,diames,mes,maquina,turno,string(RM22{contador,3}),string(RM22{contador,4}),string(RM22{contador,5}),string(RM22{contador,6}),string(RM22{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIE2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIE2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIE2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIE2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIE2(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIE2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %VIERNES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIE3(contadorACT,:) = table(string(RM33{contador,2}),dia,diames,mes,maquina,turno,string(RM33{contador,3}),string(RM33{contador,4}),string(RM33{contador,5}),string(RM33{contador,6}),string(RM33{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIE3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIE3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIE3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIE3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIE3(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIE3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %VIERNES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIE4(contadorACT,:) = table(string(RM44{contador,2}),dia,diames,mes,maquina,turno,string(RM44{contador,3}),string(RM44{contador,4}),string(RM44{contador,5}),string(RM44{contador,6}),string(RM44{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIE4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIE4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIE4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIE4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIE4(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIE4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    
                        end
                    else
                        %VIERNES TARDE
                         switch true
                            %VIERNES MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIET(contadorACT,:) = table(string(RM11T{contador,2}),dia,diames,mes,maquina,turno,string(RM11T{contador,3}),string(RM11T{contador,4}),string(RM11T{contador,5}),string(RM11T{contador,6}),string(RM11T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIET(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIET(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIET(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIET(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIET(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIET(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %VIERNES MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIET2(contadorACT,:) = table(string(RM22T{contador,2}),dia,diames,mes,maquina,turno,string(RM22T{contador,3}),string(RM22T{contador,4}),string(RM22T{contador,5}),string(RM22T{contador,6}),string(RM22T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIET2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIET2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIET2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIET2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIET2(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIET2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %VIERNES MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIET3(contadorACT,:) = table(string(RM33T{contador,2}),dia,diames,mes,maquina,turno,string(RM33T{contador,3}),string(RM33T{contador,4}),string(RM33T{contador,5}),string(RM33T{contador,6}),string(RM33T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIET3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIET3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIET3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIET3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIET3(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIET3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end

                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %VIERNES MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44T{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44T{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPVIET4(contadorACT,:) = table(string(RM44T{contador,2}),dia,diames,mes,maquina,turno,string(RM44T{contador,3}),string(RM44T{contador,4}),string(RM44T{contador,5}),string(RM44T{contador,6}),string(RM44T{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
   
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPVIET4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPVIET4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPVIET4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPVIET4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPVIET4(contadorACT,12)=table("2");
                                        otherwise
                                         TPVIET4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44T{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    
                        end
                    end
 %--------------------------------------------------------------------------
                case (strcmpi(dia,'Sab')==1)
                    %horarios del SABADO
                    if(strcmpi(turno,'M')==1)
                        %SABADO MAÑANA
                        switch true
                            %SABADO MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSAB(contadorACT,:) = table(string(RM11W{contador,2}),dia,diames,mes,maquina,turno,string(RM11W{contador,3}),string(RM11W{contador,4}),string(RM11W{contador,5}),string(RM11W{contador,6}),string(RM11W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %eliminar paciente ya asignado de las
                                  %listas en las que este.
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSAB(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSAB(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSAB(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSAB(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSAB(contadorACT,12)=table("2");
                                        otherwise
                                         TPSAB(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %SABADO MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSAB2(contadorACT,:) = table(string(RM22W{contador,2}),dia,diames,mes,maquina,turno,string(RM22W{contador,3}),string(RM22W{contador,4}),string(RM22W{contador,5}),string(RM22W{contador,6}),string(RM22W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSAB2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSAB2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSAB2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSAB2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSAB2(contadorACT,12)=table("2");
                                        otherwise
                                         TPSAB2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %SABADO MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSAB3(contadorACT,:) = table(string(RM33W{contador,2}),dia,diames,mes,maquina,turno,string(RM33W{contador,3}),string(RM33W{contador,4}),string(RM33W{contador,5}),string(RM33W{contador,6}),string(RM33W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSAB3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSAB3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSAB3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSAB3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSAB3(contadorACT,12)=table("2");
                                        otherwise
                                         TPSAB3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %SABADO MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSAB4(contadorACT,:) = table(string(RM44W{contador,2}),dia,diames,mes,maquina,turno,string(RM44W{contador,3}),string(RM44W{contador,4}),string(RM44W{contador,5}),string(RM44W{contador,6}),string(RM44W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSAB4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSAB4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSAB4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSAB4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSAB4(contadorACT,12)=table("2");
                                        otherwise
                                         TPSAB4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    
                        end 
                    else
                        %SABADO TARDE
                         switch true
                            %SABADO MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSABT(contadorACT,:) = table(string(RM11W{contador,2}),dia,diames,mes,maquina,turno,string(RM11W{contador,3}),string(RM11W{contador,4}),string(RM11W{contador,5}),string(RM11W{contador,6}),string(RM11W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %eliminar paciente ya asignado de las
                                  %listas en las que este.
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSABT(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSABT(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSABT(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSABT(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSABT(contadorACT,12)=table("2");
                                        otherwise
                                         TPSABT(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %SABADO MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSABT2(contadorACT,:) = table(string(RM22W{contador,2}),dia,diames,mes,maquina,turno,string(RM22W{contador,3}),string(RM22W{contador,4}),string(RM22W{contador,5}),string(RM22W{contador,6}),string(RM22W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSABT2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSABT2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSABT2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSABT2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSABT2(contadorACT,12)=table("2");
                                        otherwise
                                         TPSABT2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %SABADO MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSABT3(contadorACT,:) = table(string(RM33W{contador,2}),dia,diames,mes,maquina,turno,string(RM33W{contador,3}),string(RM33W{contador,4}),string(RM33W{contador,5}),string(RM33W{contador,6}),string(RM33W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSABT3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSABT3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSABT3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSABT3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSABT3(contadorACT,12)=table("2");
                                        otherwise
                                         TPSABT3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %SABADO MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPSABT4(contadorACT,:) = table(string(RM44W{contador,2}),dia,diames,mes,maquina,turno,string(RM44W{contador,3}),string(RM44W{contador,4}),string(RM44W{contador,5}),string(RM44W{contador,6}),string(RM44W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPSABT4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPSABT4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPSABT4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPSABT4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPSABT4(contadorACT,12)=table("2");
                                        otherwise
                                         TPSABT4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    
                        end
                    end
%-------------------------------------------------------------------------------
                case (strcmpi(dia,'Dom')==1)
                    %horarios del Domingo
                    if(strcmpi(turno,'M')==1)
                        %DOMINGO MAÑANA
                         switch true
                            %DOMINGO MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOM(contadorACT,:) = table(string(RM11W{contador,2}),dia,diames,mes,maquina,turno,string(RM11W{contador,3}),string(RM11W{contador,4}),string(RM11W{contador,5}),string(RM11W{contador,6}),string(RM11W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %eliminar paciente ya asignado de las
                                  %listas en las que este.
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOM(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOM(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOM(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOM(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOM(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOM(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %DOMINGO MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOM2(contadorACT,:) = table(string(RM22W{contador,2}),dia,diames,mes,maquina,turno,string(RM22W{contador,3}),string(RM22W{contador,4}),string(RM22W{contador,5}),string(RM22W{contador,6}),string(RM22W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOM2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOM2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOM2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOM2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOM2(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOM2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %DOMINGO MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOM3(contadorACT,:) = table(string(RM33W{contador,2}),dia,diames,mes,maquina,turno,string(RM33W{contador,3}),string(RM33W{contador,4}),string(RM33W{contador,5}),string(RM33W{contador,6}),string(RM33W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOM3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOM3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOM3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOM3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOM3(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOM3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %DOMINGO MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM44W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOM4(contadorACT,:) = table(string(RM44W{contador,2}),dia,diames,mes,maquina,turno,string(RM44W{contador,3}),string(RM44W{contador,4}),string(RM44W{contador,5}),string(RM44W{contador,6}),string(RM44W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOM4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOM4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOM4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOM4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOM4(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOM4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    
                        end
                    else
                        %DOMINGO TARDE
                         switch true
                            %DOMINGO MAQUINA 1
                            case (strcmpi(maquina,'RM1')==1)
                                   %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM11W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM11W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOMT(contadorACT,:) = table(string(RM11W{contador,2}),dia,diames,mes,maquina,turno,string(RM11W{contador,3}),string(RM11W{contador,4}),string(RM11W{contador,5}),string(RM11W{contador,6}),string(RM11W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %eliminar paciente ya asignado de las
                                  %listas en las que este.
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOMT(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOMT(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOMT(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOMT(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOMT(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOMT(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM11W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
  %--------------------------------------------------------------------
                            %DOMINGO MAQUINA 2
                            case (strcmpi(maquina,'RM2')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                   %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM22W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM22W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOMT2(contadorACT,:) = table(string(RM22W{contador,2}),dia,diames,mes,maquina,turno,string(RM22W{contador,3}),string(RM22W{contador,4}),string(RM22W{contador,5}),string(RM22W{contador,6}),string(RM22W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1; 
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOMT2(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOMT2(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOMT2(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOMT2(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOMT2(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOMT2(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM22W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
%-----------------------------------------------------------------------
                            %DOMINGO MAQUINA 3
                            case (strcmpi(maquina,'RM3')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM33W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19); 
                                  Reg= string(RM33W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOMT3(contadorACT,:) = table(string(RM33W{contador,2}),dia,diames,mes,maquina,turno,string(RM33W{contador,3}),string(RM33W{contador,4}),string(RM33W{contador,5}),string(RM33W{contador,6}),string(RM33W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOMT3(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOMT3(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOMT3(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOMT3(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOMT3(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOMT3(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM33W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
 %-----------------------------------------------------------------------                                 
                           %DOMINGO MAQUINA 4
                            case (strcmpi(maquina,'RM4')==1)
                                  %GUARDAMOS PACIENTE Y LO BUSCAMOS EN LA
                                  %LISTA GLOBAL JUNTO CON TODOS SUS DATOS
                                  busquedaP=string(RM44W{contador,2});
                                  [row1,col1] =find(txtpac==busquedaP);
                                  %guardamos region/tipo de estuddio y si
                                  %es necesario contraste( hay que añadir
                                  %esta casilla al excel para probar
                                  %urgente e ingresado son protocolo
                                  %complejo 2 huecos asi que lo guardamos
                                  urg=txtpac(row1,18);
                                  ing=txtpac(row1,19);
                                  Reg= string(RM44W{contador,3});
                                  Estudio=txtpac(row1,5);
                                  Contraste=txtpac(row1,23);
                                  TPDOMT4(contadorACT,:) = table(string(RM44W{contador,2}),dia,diames,mes,maquina,turno,string(RM44W{contador,3}),string(RM44W{contador,4}),string(RM44W{contador,5}),string(RM44W{contador,6}),string(RM44W{contador,7}),"0");
                                  contador3=contador3+1;
                                  contador2=contador2+1;
                                  %quitar huecos
                                    switch true
                                      case (strcmpi(Reg,'Cuerpo entero')==1)
                                          huecos=huecos-3;
                                          TPDOMT4(contadorACT,12)=table("3");
                                      case (strcmpi(Estudio,'Tumor')==1)
                                          huecos=huecos-2;
                                          TPDOMT4(contadorACT,12)=table("2");
                                      case (strcmpi(Contraste,'Si')==1)
                                           huecos=huecos-2;
                                           TPDOMT4(contadorACT,12)=table("2");
                                      case (strcmpi(urg,'Si')==1)
                                          huecos=huecos-2;
                                          TPDOMT4(contadorACT,12)=table("2");
                                      case (strcmpi(ing,'Si')==1)
                                           huecos=huecos-2; 
                                           TPDOMT4(contadorACT,12)=table("2");
                                        otherwise
                                         TPDOMT4(contadorACT,12)=table("1");
                                          huecos=huecos-1;
                                    end
                                    contadorACT=contadorACT+1;
                                    %eliminar paciente ya asignado de las
                                    %listas en las que este.
                                    %eliminar en tabla 2 FINDE
                                    RM22EW=table2array(RM22W);
                                    [rowRME,~] =find(RM22EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 FINDE
                                    RM33EW=table2array(RM33W);
                                    [rowRME,~] =find(RM33EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 FINDE
                                    RM11EW=table2array(RM11W);
                                    [rowRME,~] =find(RM11EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11W(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2 Tarde
                                    RM22ET=table2array(RM22T);
                                    [rowRME,~] =find(RM22ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3 Tarde
                                    RM33ET=table2array(RM33T);
                                    [rowRME,~] =find(RM33ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 Tarde
                                    RM44ET=table2array(RM44T);
                                    [rowRME,~] =find(RM44ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 1 Tarde
                                    RM11ET=table2array(RM11T);
                                    [rowRME,~] =find(RM11ET==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11T(rowRME,:) = [];
                                    end
                                    %eliminar en tabla1
                                    RM11E=table2array(RM11);
                                    [rowRME,~] =find(RM11E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM11(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 2
                                    RM22E=table2array(RM22);
                                    [rowRME,~] =find(RM22E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM22(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 3
                                    RM33E=table2array(RM33);
                                    [rowRME,~] =find(RM33E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM33(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4
                                    RM44E=table2array(RM44);
                                    [rowRME,~] =find(RM44E==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44(rowRME,:) = [];
                                    end
                                    %eliminar en tabla 4 FINDE
                                    RM44EW=table2array(RM44W);
                                    [rowRME,~] =find(RM44EW==string(RM44W{contador,2}));
                                    EliminacionRM = isempty(rowRME);
                                    if EliminacionRM==0 
                                    RM44W(rowRME,:) = [];
                                    end
                                    
                        end
                    end
             end
            

                    
         end
 
 end
 
 
 %JUNTAMOS MISMAS REGIONES DENTRO DE MISMOS DIAS Y ELIMINAMOS SOBRANTES
TP;
TPOR=sortrows(TP,7);
TPOR1=rmmissing(TPOR);
TP2;
TP2OR=sortrows(TP2,7);
TP2OR1=rmmissing(TP2OR);

TP3;
TP3OR=sortrows(TP3,7);
TP3OR1=rmmissing(TP3OR);
TP4;
TP4OR=sortrows(TP4,7);
TP4OR1=rmmissing(TP4OR);

TPMAR;
TPORMAR=sortrows(TPMAR,7);
TPORMAR1=rmmissing(TPORMAR);
TPMAR2;
TPORMAR2=sortrows(TPMAR2,7);
TPORMAR21=rmmissing(TPORMAR2);
TPMAR3;
TPORMAR3=sortrows(TPMAR3,7);
TPORMAR31=rmmissing(TPORMAR3);
TPMAR4;
TPORMAR4=sortrows(TPMAR4,7);
TPORMAR41=rmmissing(TPORMAR4);

TPMIE;
TPORMIE=sortrows(TPMIE,7);
TPORMIE1=rmmissing(TPORMIE);
TPMIE2;
TPORMIE2=sortrows(TPMIE2,7);
TPORMIE21=rmmissing(TPORMIE2);
TPMIE3;
TPORMIE3=sortrows(TPMIE3,7);
TPORMIE31=rmmissing(TPORMIE3);
TPMIE4;
TPORMIE4=sortrows(TPMIE4,7);
TPORMIE41=rmmissing(TPORMIE4);

TPJUE;
TPORJUE=sortrows(TPJUE,7);
TPORJUE1=rmmissing(TPORJUE);
TPJUE2;
TPORJUE2=sortrows(TPJUE2,7);
TPORJUE21=rmmissing(TPORJUE2);
TPJUE3;
TPORJUE3=sortrows(TPJUE3,7);
TPORJUE31=rmmissing(TPORJUE3);
TPJUE4;
TPORJUE4=sortrows(TPJUE4,7);
TPORJUE41=rmmissing(TPORJUE4);


TPVIE;
TPORVIE=sortrows(TPVIE,7);
TPORVIE1=rmmissing(TPORVIE);
TPVIE2;
TPORVIE2=sortrows(TPVIE2,7);
TPORVIE21=rmmissing(TPORVIE2);
TPVIE3;
TPORVIE3=sortrows(TPVIE3,7);
TPORVIE31=rmmissing(TPORVIE3);
TPVIE4;
TPORVIE4=sortrows(TPVIE4,7);
TPORVIE41=rmmissing(TPORVIE4);


TPSAB;
TPORSAB=sortrows(TPSAB,7);
TPORSAB1=rmmissing(TPORSAB);
TPSAB2;
TPORSAB2=sortrows(TPSAB2,7);
TPORSAB21=rmmissing(TPORSAB2);
TPSAB3;
TPORSAB3=sortrows(TPSAB3,7);
TPORSAB31=rmmissing(TPORSAB3);
TPSAB4;
TPORSAB4=sortrows(TPSAB4,7);
TPORSAB41=rmmissing(TPORSAB4);

TPDOM;
TPORDOM=sortrows(TPDOM,7);
TPORDOM1=rmmissing(TPORDOM);
TPDOM2;
TPORDOM2=sortrows(TPDOM2,7);
TPORDOM21=rmmissing(TPORDOM2);
TPDOM3;
TPORDOM3=sortrows(TPDOM3,7);
TPORDOM31=rmmissing(TPORDOM3);
TPDOM4;
TPORDOM4=sortrows(TPDOM4,7);
TPORDOM41=rmmissing(TPORDOM4);

TPLUNT;
TPORLUNT=sortrows(TPLUNT,7);
TPORLUNT1=rmmissing(TPORLUNT);
TPLUNT2;
TPORLUNT2=sortrows(TPLUNT2,7);
TPORLUNT21=rmmissing(TPORLUNT2);
TPLUNT3;
TPORLUNT3=sortrows(TPLUNT3,7);
TPORLUNT31=rmmissing(TPORLUNT3);
TPLUNT4;
TPORLUNT4=sortrows(TPLUNT4,7);
TPORLUNT41=rmmissing(TPORLUNT4);


TPMART;
TPORMART=sortrows(TPMART,7);
TPORMART1=rmmissing(TPORMART);
TPMART2;
TPORMART2=sortrows(TPMART2,7);
TPORMART21=rmmissing(TPORMART2);
TPMART3;
TPORMART3=sortrows(TPMART3,7);
TPORMART31=rmmissing(TPORMART3);
TPMART4;
TPORMART4=sortrows(TPMART4,7);
TPORMART41=rmmissing(TPORMART4);

TPMIET;
TPORMIET=sortrows(TPMIET,7);
TPORMIET1=rmmissing(TPORMIET);
TPMIET2;
TPORMIET2=sortrows(TPMIET2,7);
TPORMIET21=rmmissing(TPORMIET2);
TPMIET3;
TPORMIET3=sortrows(TPMIET3,7);
TPORMIET31=rmmissing(TPORMIET3);
TPMIET4;
TPORMIET4=sortrows(TPMIET4,7);
TPORMIET41=rmmissing(TPORMIET4);

TPJUET;
TPORJUET=sortrows(TPJUET,7);
TPORJUET1=rmmissing(TPORJUET);
TPJUET2;
TPORJUET2=sortrows(TPJUET2,7);
TPORJUET21=rmmissing(TPORJUET2);
TPJUET3;
TPORJUET3=sortrows(TPJUET3,7);
TPORJUET31=rmmissing(TPORJUET3);
TPJUET4;
TPORJUET4=sortrows(TPJUET4,7);
TPORJUET41=rmmissing(TPORJUET4);

TPVIET;
TPORVIET=sortrows(TPVIET,7);
TPORVIET1=rmmissing(TPORVIET);
TPVIET2;
TPORVIET2=sortrows(TPVIET2,7);
TPORVIET21=rmmissing(TPORVIET2);
TPVIET3;
TPORVIET3=sortrows(TPVIET3,7);
TPORVIET31=rmmissing(TPORVIET3);
TPVIET4;
TPORVIET4=sortrows(TPVIET4,7);
TPORVIET41=rmmissing(TPORVIET4);

TPSABT;
TPORSABT=sortrows(TPSABT,7);
TPORSABT1=rmmissing(TPORSABT);
TPSABT2;
TPORSABT2=sortrows(TPSABT2,7);
TPORSABT21=rmmissing(TPORSABT2);
TPSABT3;
TPORSABT3=sortrows(TPSABT3,7);
TPORSABT31=rmmissing(TPORSABT3);
TPSABT4;
TPORSABT4=sortrows(TPSABT4,7);
TPORSABT41=rmmissing(TPORSABT4);

TPDOMT;
TPORDOMT=sortrows(TPDOMT,7);
TPORDOMT1=rmmissing(TPORDOMT);
TPDOMT2;
TPORDOMT2=sortrows(TPDOMT2,7);
TPORDOMT21=rmmissing(TPORDOMT2);
TPDOMT3;
TPORDOMT3=sortrows(TPDOMT3,7);
TPORDOMT31=rmmissing(TPORDOMT3);
TPDOMT4;
TPORDOMT4=sortrows(TPDOMT4,7);
TPORDOMT41=rmmissing(TPORDOMT4);
%--------------------------------------------------------------------------

%Lista final de pacientes(los que se van a atender)
Final = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
Final.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Hora'};
%comprobaremos que tablas no estan vacias y rellenaremos 
%Comp = isempty(TPOR1);
%contador de pacientes(para no sobre escribir cuando cambiemos de lista)
ContadorPAC=1;
%tamaño de las listas
%size1=size(TPOR1,1);

%creamos las horas de mañana y tarde para repartir los huecos
HM = ["8:00","8:20","8:40","9:00","9:20","9:40","10:00","10:20","10:40","11:00","11:20","11:40","12:00","12:20","12:40","13:00","13:20","13:40","14:00","14:20","14:40","15:00"];
HT = ["15:00","15:20","15:40","16:00","16:20","16:40","17:00","17:20","17:40","18:00","18:20","18:40","19:00","19:20","19:40","20:00","20:20","20:40","21:00","21:20","21:40","22:00"];

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPOR1);
%tamaño de las listas
size1=size(TPOR1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPOR1{i,1}),string(TPOR1{i,2}),string(TPOR1{i,3}),string(TPOR1{i,4}),string(TPOR1{i,5}),string(TPOR1{i,6}),string(TPOR1{i,7}),string(TPOR1{i,8}),string(TPOR1{i,9}),string(TPOR1{i,10}),string(TPOR1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPOR1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPOR1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
           
         
     end
     contadorhoras
end


%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TP2OR1);
%tamaño de las listas
size1=size(TP2OR1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TP2OR1{i,1}),string(TP2OR1{i,2}),string(TP2OR1{i,3}),string(TP2OR1{i,4}),string(TP2OR1{i,5}),string(TP2OR1{i,6}),string(TP2OR1{i,7}),string(TP2OR1{i,8}),string(TP2OR1{i,9}),string(TP2OR1{i,10}),string(TP2OR1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TP2OR1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TP2OR1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
          
         
     end
     contadorhoras
end

     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TP3OR1);
%tamaño de las listas
size1=size(TP3OR1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TP3OR1{i,1}),string(TP3OR1{i,2}),string(TP3OR1{i,3}),string(TP3OR1{i,4}),string(TP3OR1{i,5}),string(TP3OR1{i,6}),string(TP3OR1{i,7}),string(TP3OR1{i,8}),string(TP3OR1{i,9}),string(TP3OR1{i,10}),string(TP3OR1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TP3OR1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TP3OR1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TP4OR1);
%tamaño de las listas
size1=size(TP4OR1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TP4OR1{i,1}),string(TP4OR1{i,2}),string(TP4OR1{i,3}),string(TP4OR1{i,4}),string(TP4OR1{i,5}),string(TP4OR1{i,6}),string(TP4OR1{i,7}),string(TP4OR1{i,8}),string(TP4OR1{i,9}),string(TP4OR1{i,10}),string(TP4OR1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TP4OR1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TP4OR1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
     
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORLUNT1);
%tamaño de las listas
size1=size(TPORLUNT1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORLUNT1{i,1}),string(TPORLUNT1{i,2}),string(TPORLUNT1{i,3}),string(TPORLUNT1{i,4}),string(TPORLUNT1{i,5}),string(TPORLUNT1{i,6}),string(TPORLUNT1{i,7}),string(TPORLUNT1{i,8}),string(TPORLUNT1{i,9}),string(TPORLUNT1{i,10}),string(TPORLUNT1{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORLUNT1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORLUNT1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORLUNT21);
%tamaño de las listas
size1=size(TPORLUNT21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORLUNT21{i,1}),string(TPORLUNT21{i,2}),string(TPORLUNT21{i,3}),string(TPORLUNT21{i,4}),string(TPORLUNT21{i,5}),string(TPORLUNT21{i,6}),string(TPORLUNT21{i,7}),string(TPORLUNT21{i,8}),string(TPORLUNT21{i,9}),string(TPORLUNT21{i,10}),string(TPORLUNT21{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORLUNT21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORLUNT21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORLUNT31);
%tamaño de las listas
size1=size(TPORLUNT31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORLUNT31{i,1}),string(TPORLUNT31{i,2}),string(TPORLUNT31{i,3}),string(TPORLUNT31{i,4}),string(TPORLUNT31{i,5}),string(TPORLUNT31{i,6}),string(TPORLUNT31{i,7}),string(TPORLUNT31{i,8}),string(TPORLUNT31{i,9}),string(TPORLUNT31{i,10}),string(TPORLUNT31{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORLUNT31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORLUNT31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
     
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORLUNT41);
%tamaño de las listas
size1=size(TPORLUNT41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORLUNT41{i,1}),string(TPORLUNT41{i,2}),string(TPORLUNT41{i,3}),string(TPORLUNT41{i,4}),string(TPORLUNT41{i,5}),string(TPORLUNT41{i,6}),string(TPORLUNT41{i,7}),string(TPORLUNT41{i,8}),string(TPORLUNT41{i,9}),string(TPORLUNT41{i,10}),string(TPORLUNT41{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORLUNT41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORLUNT41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMAR1);
%tamaño de las listas
size1=size(TPORMAR1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMAR1{i,1}),string(TPORMAR1{i,2}),string(TPORMAR1{i,3}),string(TPORMAR1{i,4}),string(TPORMAR1{i,5}),string(TPORMAR1{i,6}),string(TPORMAR1{i,7}),string(TPORMAR1{i,8}),string(TPORMAR1{i,9}),string(TPORMAR1{i,10}),string(TPORMAR1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMAR1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMAR1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMAR21);
%tamaño de las listas
size1=size(TPORMAR21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMAR21{i,1}),string(TPORMAR21{i,2}),string(TPORMAR21{i,3}),string(TPORMAR21{i,4}),string(TPORMAR21{i,5}),string(TPORMAR21{i,6}),string(TPORMAR21{i,7}),string(TPORMAR21{i,8}),string(TPORMAR21{i,9}),string(TPORMAR21{i,10}),string(TPORMAR21{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMAR21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMAR21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
     
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMAR31);
%tamaño de las listas
size1=size(TPORMAR31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMAR31{i,1}),string(TPORMAR31{i,2}),string(TPORMAR31{i,3}),string(TPORMAR31{i,4}),string(TPORMAR31{i,5}),string(TPORMAR31{i,6}),string(TPORMAR31{i,7}),string(TPORMAR31{i,8}),string(TPORMAR31{i,9}),string(TPORMAR31{i,10}),string(TPORMAR31{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMAR31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMAR31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end 
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMAR41);
%tamaño de las listas
size1=size(TPORMAR41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMAR41{i,1}),string(TPORMAR41{i,2}),string(TPORMAR41{i,3}),string(TPORMAR41{i,4}),string(TPORMAR41{i,5}),string(TPORMAR41{i,6}),string(TPORMAR41{i,7}),string(TPORMAR41{i,8}),string(TPORMAR41{i,9}),string(TPORMAR41{i,10}),string(TPORMAR41{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMAR41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMAR41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMART1);
%tamaño de las listas
size1=size(TPORMART1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMART1{i,1}),string(TPORMART1{i,2}),string(TPORMART1{i,3}),string(TPORMART1{i,4}),string(TPORMART1{i,5}),string(TPORMART1{i,6}),string(TPORMART1{i,7}),string(TPORMART1{i,8}),string(TPORMART1{i,9}),string(TPORMART1{i,10}),string(TPORMART1{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMART1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMART1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
           
         
     end
     contadorhoras
     
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMART21);
%tamaño de las listas
size1=size(TPORMART21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMART21{i,1}),string(TPORMART21{i,2}),string(TPORMART21{i,3}),string(TPORMART21{i,4}),string(TPORMART21{i,5}),string(TPORMART21{i,6}),string(TPORMART21{i,7}),string(TPORMART21{i,8}),string(TPORMART21{i,9}),string(TPORMART21{i,10}),string(TPORMART21{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMART21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMART21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMART31);
%tamaño de las listas
size1=size(TPORMART31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMART31{i,1}),string(TPORMART31{i,2}),string(TPORMART31{i,3}),string(TPORMART31{i,4}),string(TPORMART31{i,5}),string(TPORMART31{i,6}),string(TPORMART31{i,7}),string(TPORMART31{i,8}),string(TPORMART31{i,9}),string(TPORMART31{i,10}),string(TPORMART31{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMART31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMART31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMART41);
%tamaño de las listas
size1=size(TPORMART41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMART41{i,1}),string(TPORMART41{i,2}),string(TPORMART41{i,3}),string(TPORMART41{i,4}),string(TPORMART41{i,5}),string(TPORMART41{i,6}),string(TPORMART41{i,7}),string(TPORMART41{i,8}),string(TPORMART41{i,9}),string(TPORMART41{i,10}),string(TPORMART41{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMART41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMART41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
     
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIE1);
%tamaño de las listas
size1=size(TPORMIE1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIE1{i,1}),string(TPORMIE1{i,2}),string(TPORMIE1{i,3}),string(TPORMIE1{i,4}),string(TPORMIE1{i,5}),string(TPORMIE1{i,6}),string(TPORMIE1{i,7}),string(TPORMIE1{i,8}),string(TPORMIE1{i,9}),string(TPORMIE1{i,10}),string(TPORMIE1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIE1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIE1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIE21);
%tamaño de las listas
size1=size(TPORMIE21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIE21{i,1}),string(TPORMIE21{i,2}),string(TPORMIE21{i,3}),string(TPORMIE21{i,4}),string(TPORMIE21{i,5}),string(TPORMIE21{i,6}),string(TPORMIE21{i,7}),string(TPORMIE21{i,8}),string(TPORMIE21{i,9}),string(TPORMIE21{i,10}),string(TPORMIE21{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIE21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIE21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIE31);
%tamaño de las listas
size1=size(TPORMIE31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIE31{i,1}),string(TPORMIE31{i,2}),string(TPORMIE31{i,3}),string(TPORMIE31{i,4}),string(TPORMIE31{i,5}),string(TPORMIE31{i,6}),string(TPORMIE31{i,7}),string(TPORMIE31{i,8}),string(TPORMIE31{i,9}),string(TPORMIE31{i,10}),string(TPORMIE31{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIE31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIE31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
     end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIE41);
%tamaño de las listas
size1=size(TPORMIE41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIE41{i,1}),string(TPORMIE41{i,2}),string(TPORMIE41{i,3}),string(TPORMIE41{i,4}),string(TPORMIE41{i,5}),string(TPORMIE41{i,6}),string(TPORMIE41{i,7}),string(TPORMIE41{i,8}),string(TPORMIE41{i,9}),string(TPORMIE41{i,10}),string(TPORMIE41{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIE41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIE41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIET1);
%tamaño de las listas
size1=size(TPORMIET1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIET1{i,1}),string(TPORMIET1{i,2}),string(TPORMIET1{i,3}),string(TPORMIET1{i,4}),string(TPORMIET1{i,5}),string(TPORMIET1{i,6}),string(TPORMIET1{i,7}),string(TPORMIET1{i,8}),string(TPORMIET1{i,9}),string(TPORMIET1{i,10}),string(TPORMIET1{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIET1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIET1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end    
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIET21);
%tamaño de las listas
size1=size(TPORMIET21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIET21{i,1}),string(TPORMIET21{i,2}),string(TPORMIET21{i,3}),string(TPORMIET21{i,4}),string(TPORMIET21{i,5}),string(TPORMIET21{i,6}),string(TPORMIET21{i,7}),string(TPORMIET21{i,8}),string(TPORMIET21{i,9}),string(TPORMIET21{i,10}),string(TPORMIET21{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIET21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIET21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIET31);
%tamaño de las listas
size1=size(TPORMIET31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIET31{i,1}),string(TPORMIET31{i,2}),string(TPORMIET31{i,3}),string(TPORMIET31{i,4}),string(TPORMIET31{i,5}),string(TPORMIET31{i,6}),string(TPORMIET31{i,7}),string(TPORMIET31{i,8}),string(TPORMIET31{i,9}),string(TPORMIET31{i,10}),string(TPORMIET31{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIET31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIET31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end   
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORMIET41);
%tamaño de las listas
size1=size(TPORMIET41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORMIET41{i,1}),string(TPORMIET41{i,2}),string(TPORMIET41{i,3}),string(TPORMIET41{i,4}),string(TPORMIET41{i,5}),string(TPORMIET41{i,6}),string(TPORMIET41{i,7}),string(TPORMIET41{i,8}),string(TPORMIET41{i,9}),string(TPORMIET41{i,10}),string(TPORMIET41{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORMIET41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORMIET41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end    
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUE1);
%tamaño de las listas
size1=size(TPORJUE1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUE1{i,1}),string(TPORJUE1{i,2}),string(TPORJUE1{i,3}),string(TPORJUE1{i,4}),string(TPORJUE1{i,5}),string(TPORJUE1{i,6}),string(TPORJUE1{i,7}),string(TPORJUE1{i,8}),string(TPORJUE1{i,9}),string(TPORJUE1{i,10}),string(TPORJUE1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUE1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUE1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUE21);
%tamaño de las listas
size1=size(TPORJUE21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUE21{i,1}),string(TPORJUE21{i,2}),string(TPORJUE21{i,3}),string(TPORJUE21{i,4}),string(TPORJUE21{i,5}),string(TPORJUE21{i,6}),string(TPORJUE21{i,7}),string(TPORJUE21{i,8}),string(TPORJUE21{i,9}),string(TPORJUE21{i,10}),string(TPORJUE21{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUE21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUE21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end    
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUE31);
%tamaño de las listas
size1=size(TPORJUE31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUE31{i,1}),string(TPORJUE31{i,2}),string(TPORJUE31{i,3}),string(TPORJUE31{i,4}),string(TPORJUE31{i,5}),string(TPORJUE31{i,6}),string(TPORJUE31{i,7}),string(TPORJUE31{i,8}),string(TPORJUE31{i,9}),string(TPORJUE31{i,10}),string(TPORJUE31{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUE31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUE31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end   
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUE41);
%tamaño de las listas
size1=size(TPORJUE41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUE41{i,1}),string(TPORJUE41{i,2}),string(TPORJUE41{i,3}),string(TPORJUE41{i,4}),string(TPORJUE41{i,5}),string(TPORJUE41{i,6}),string(TPORJUE41{i,7}),string(TPORJUE41{i,8}),string(TPORJUE41{i,9}),string(TPORJUE41{i,10}),string(TPORJUE41{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUE41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUE41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUET1);
%tamaño de las listas
size1=size(TPORJUET1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUET1{i,1}),string(TPORJUET1{i,2}),string(TPORJUET1{i,3}),string(TPORJUET1{i,4}),string(TPORJUET1{i,5}),string(TPORJUET1{i,6}),string(TPORJUET1{i,7}),string(TPORJUET1{i,8}),string(TPORJUET1{i,9}),string(TPORJUET1{i,10}),string(TPORJUET1{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUET1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUET1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end    
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUET21);
%tamaño de las listas
size1=size(TPORJUET21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUET21{i,1}),string(TPORJUET21{i,2}),string(TPORJUET21{i,3}),string(TPORJUET21{i,4}),string(TPORJUET21{i,5}),string(TPORJUET21{i,6}),string(TPORJUET21{i,7}),string(TPORJUET21{i,8}),string(TPORJUET21{i,9}),string(TPORJUET21{i,10}),string(TPORJUET21{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUET21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUET21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
 end    
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUET31);
%tamaño de las listas
size1=size(TPORJUET31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUET31{i,1}),string(TPORJUET31{i,2}),string(TPORJUET31{i,3}),string(TPORJUET31{i,4}),string(TPORJUET31{i,5}),string(TPORJUET31{i,6}),string(TPORJUET31{i,7}),string(TPORJUET31{i,8}),string(TPORJUET31{i,9}),string(TPORJUET31{i,10}),string(TPORJUET31{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUET31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUET31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end

%---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORJUET41);
%tamaño de las listas
size1=size(TPORJUET41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORJUET41{i,1}),string(TPORJUET41{i,2}),string(TPORJUET41{i,3}),string(TPORJUET41{i,4}),string(TPORJUET41{i,5}),string(TPORJUET41{i,6}),string(TPORJUET41{i,7}),string(TPORJUET41{i,8}),string(TPORJUET41{i,9}),string(TPORJUET41{i,10}),string(TPORJUET41{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORJUET41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORJUET41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end     
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIE1);
%tamaño de las listas
size1=size(TPORVIE1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIE1{i,1}),string(TPORVIE1{i,2}),string(TPORVIE1{i,3}),string(TPORVIE1{i,4}),string(TPORVIE1{i,5}),string(TPORVIE1{i,6}),string(TPORVIE1{i,7}),string(TPORVIE1{i,8}),string(TPORVIE1{i,9}),string(TPORVIE1{i,10}),string(TPORVIE1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIE1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIE1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end

     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIE21);
%tamaño de las listas
size1=size(TPORVIE21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIE21{i,1}),string(TPORVIE21{i,2}),string(TPORVIE21{i,3}),string(TPORVIE21{i,4}),string(TPORVIE21{i,5}),string(TPORVIE21{i,6}),string(TPORVIE21{i,7}),string(TPORVIE21{i,8}),string(TPORVIE21{i,9}),string(TPORVIE21{i,10}),string(TPORVIE21{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIE21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIE21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIE31);
%tamaño de las listas
size1=size(TPORVIE31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIE31{i,1}),string(TPORVIE31{i,2}),string(TPORVIE31{i,3}),string(TPORVIE31{i,4}),string(TPORVIE31{i,5}),string(TPORVIE31{i,6}),string(TPORVIE31{i,7}),string(TPORVIE31{i,8}),string(TPORVIE31{i,9}),string(TPORVIE31{i,10}),string(TPORVIE31{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIE31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIE31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIE41);
%tamaño de las listas
size1=size(TPORVIE41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIE41{i,1}),string(TPORVIE41{i,2}),string(TPORVIE41{i,3}),string(TPORVIE41{i,4}),string(TPORVIE41{i,5}),string(TPORVIE41{i,6}),string(TPORVIE41{i,7}),string(TPORVIE41{i,8}),string(TPORVIE41{i,9}),string(TPORVIE41{i,10}),string(TPORVIE41{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIE41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIE41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIET1);
%tamaño de las listas
size1=size(TPORVIET1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIET1{i,1}),string(TPORVIET1{i,2}),string(TPORVIET1{i,3}),string(TPORVIET1{i,4}),string(TPORVIET1{i,5}),string(TPORVIET1{i,6}),string(TPORVIET1{i,7}),string(TPORVIET1{i,8}),string(TPORVIET1{i,9}),string(TPORVIET1{i,10}),string(TPORVIET1{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIET1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIET1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIET21);
%tamaño de las listas
size1=size(TPORVIET21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIET21{i,1}),string(TPORVIET21{i,2}),string(TPORVIET21{i,3}),string(TPORVIET21{i,4}),string(TPORVIET21{i,5}),string(TPORVIET21{i,6}),string(TPORVIET21{i,7}),string(TPORVIET21{i,8}),string(TPORVIET21{i,9}),string(TPORVIET21{i,10}),string(TPORVIET21{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIET21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIET21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIET31);
%tamaño de las listas
size1=size(TPORVIET31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIET31{i,1}),string(TPORVIET31{i,2}),string(TPORVIET31{i,3}),string(TPORVIET31{i,4}),string(TPORVIET31{i,5}),string(TPORVIET31{i,6}),string(TPORVIET31{i,7}),string(TPORVIET31{i,8}),string(TPORVIET31{i,9}),string(TPORVIET31{i,10}),string(TPORVIET31{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIET31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIET31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORVIET41);
%tamaño de las listas
size1=size(TPORVIET41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORVIET41{i,1}),string(TPORVIET41{i,2}),string(TPORVIET41{i,3}),string(TPORVIET41{i,4}),string(TPORVIET41{i,5}),string(TPORVIET41{i,6}),string(TPORVIET41{i,7}),string(TPORVIET41{i,8}),string(TPORVIET41{i,9}),string(TPORVIET41{i,10}),string(TPORVIET41{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORVIET41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORVIET41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSAB1);
%tamaño de las listas
size1=size(TPORSAB1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSAB1{i,1}),string(TPORSAB1{i,2}),string(TPORSAB1{i,3}),string(TPORSAB1{i,4}),string(TPORSAB1{i,5}),string(TPORSAB1{i,6}),string(TPORSAB1{i,7}),string(TPORSAB1{i,8}),string(TPORSAB1{i,9}),string(TPORSAB1{i,10}),string(TPORSAB1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSAB1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSAB1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSAB21);
%tamaño de las listas
size1=size(TPORSAB21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSAB21{i,1}),string(TPORSAB21{i,2}),string(TPORSAB21{i,3}),string(TPORSAB21{i,4}),string(TPORSAB21{i,5}),string(TPORSAB21{i,6}),string(TPORSAB21{i,7}),string(TPORSAB21{i,8}),string(TPORSAB21{i,9}),string(TPORSAB21{i,10}),string(TPORSAB21{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSAB21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSAB21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSAB31);
%tamaño de las listas
size1=size(TPORSAB31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSAB31{i,1}),string(TPORSAB31{i,2}),string(TPORSAB31{i,3}),string(TPORSAB31{i,4}),string(TPORSAB31{i,5}),string(TPORSAB31{i,6}),string(TPORSAB31{i,7}),string(TPORSAB31{i,8}),string(TPORSAB31{i,9}),string(TPORSAB31{i,10}),string(TPORSAB31{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSAB31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSAB31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSAB41);
%tamaño de las listas
size1=size(TPORSAB41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSAB41{i,1}),string(TPORSAB41{i,2}),string(TPORSAB41{i,3}),string(TPORSAB41{i,4}),string(TPORSAB41{i,5}),string(TPORSAB41{i,6}),string(TPORSAB41{i,7}),string(TPORSAB41{i,8}),string(TPORSAB41{i,9}),string(TPORSAB41{i,10}),string(TPORSAB41{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSAB41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSAB41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSABT1);
%tamaño de las listas
size1=size(TPORSABT1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSABT1{i,1}),string(TPORSABT1{i,2}),string(TPORSABT1{i,3}),string(TPORSABT1{i,4}),string(TPORSABT1{i,5}),string(TPORSABT1{i,6}),string(TPORSABT1{i,7}),string(TPORSABT1{i,8}),string(TPORSABT1{i,9}),string(TPORSABT1{i,10}),string(TPORSABT1{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSABT1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSABT1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSABT21);
%tamaño de las listas
size1=size(TPORSABT21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSABT21{i,1}),string(TPORSABT21{i,2}),string(TPORSABT21{i,3}),string(TPORSABT21{i,4}),string(TPORSABT21{i,5}),string(TPORSABT21{i,6}),string(TPORSABT21{i,7}),string(TPORSABT21{i,8}),string(TPORSABT21{i,9}),string(TPORSABT21{i,10}),string(TPORSABT21{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSABT21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSABT21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSABT31);
%tamaño de las listas
size1=size(TPORSABT31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSABT31{i,1}),string(TPORSABT31{i,2}),string(TPORSABT31{i,3}),string(TPORSABT31{i,4}),string(TPORSABT31{i,5}),string(TPORSABT31{i,6}),string(TPORSABT31{i,7}),string(TPORSABT31{i,8}),string(TPORSABT31{i,9}),string(TPORSABT31{i,10}),string(TPORSABT31{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSABT31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSABT31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORSABT41);
%tamaño de las listas
size1=size(TPORSABT41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORSABT41{i,1}),string(TPORSABT41{i,2}),string(TPORSABT41{i,3}),string(TPORSABT41{i,4}),string(TPORSABT41{i,5}),string(TPORSABT41{i,6}),string(TPORSABT41{i,7}),string(TPORSABT41{i,8}),string(TPORSABT41{i,9}),string(TPORSABT41{i,10}),string(TPORSABT41{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORSABT41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORSABT41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOM1);
%tamaño de las listas
size1=size(TPORDOM1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOM1{i,1}),string(TPORDOM1{i,2}),string(TPORDOM1{i,3}),string(TPORDOM1{i,4}),string(TPORDOM1{i,5}),string(TPORDOM1{i,6}),string(TPORDOM1{i,7}),string(TPORDOM1{i,8}),string(TPORDOM1{i,9}),string(TPORDOM1{i,10}),string(TPORDOM1{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOM1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOM1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOM21);
%tamaño de las listas
size1=size(TPORDOM21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOM21{i,1}),string(TPORDOM21{i,2}),string(TPORDOM21{i,3}),string(TPORDOM21{i,4}),string(TPORDOM21{i,5}),string(TPORDOM21{i,6}),string(TPORDOM21{i,7}),string(TPORDOM21{i,8}),string(TPORDOM21{i,9}),string(TPORDOM21{i,10}),string(TPORDOM21{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOM21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOM21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOM31);
%tamaño de las listas
size1=size(TPORDOM31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOM31{i,1}),string(TPORDOM31{i,2}),string(TPORDOM31{i,3}),string(TPORDOM31{i,4}),string(TPORDOM31{i,5}),string(TPORDOM31{i,6}),string(TPORDOM31{i,7}),string(TPORDOM31{i,8}),string(TPORDOM31{i,9}),string(TPORDOM31{i,10}),string(TPORDOM31{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOM31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOM31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOM41);
%tamaño de las listas
size1=size(TPORDOM41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOM41{i,1}),string(TPORDOM41{i,2}),string(TPORDOM41{i,3}),string(TPORDOM41{i,4}),string(TPORDOM41{i,5}),string(TPORDOM41{i,6}),string(TPORDOM41{i,7}),string(TPORDOM41{i,8}),string(TPORDOM41{i,9}),string(TPORDOM41{i,10}),string(TPORDOM41{i,11}),HM(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOM41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOM41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOMT1);
%tamaño de las listas
size1=size(TPORDOMT1,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOMT1{i,1}),string(TPORDOMT1{i,2}),string(TPORDOMT1{i,3}),string(TPORDOMT1{i,4}),string(TPORDOMT1{i,5}),string(TPORDOMT1{i,6}),string(TPORDOMT1{i,7}),string(TPORDOMT1{i,8}),string(TPORDOMT1{i,9}),string(TPORDOMT1{i,10}),string(TPORDOMT1{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOMT1{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOMT1{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOMT21);
%tamaño de las listas
size1=size(TPORDOMT21,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOMT21{i,1}),string(TPORDOMT21{i,2}),string(TPORDOMT21{i,3}),string(TPORDOMT21{i,4}),string(TPORDOMT21{i,5}),string(TPORDOMT21{i,6}),string(TPORDOMT21{i,7}),string(TPORDOMT21{i,8}),string(TPORDOMT21{i,9}),string(TPORDOMT21{i,10}),string(TPORDOMT21{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOMT21{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOMT21{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOMT31);
%tamaño de las listas
size1=size(TPORDOMT31,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOMT31{i,1}),string(TPORDOMT31{i,2}),string(TPORDOMT31{i,3}),string(TPORDOMT31{i,4}),string(TPORDOMT31{i,5}),string(TPORDOMT31{i,6}),string(TPORDOMT31{i,7}),string(TPORDOMT31{i,8}),string(TPORDOMT31{i,9}),string(TPORDOMT31{i,10}),string(TPORDOMT31{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOMT31{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOMT31{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;
            
         
     end
     contadorhoras
end
     %---------------------------------------------------------------------------
%comprobaremos que tablas no estan vacias y rellenaremos 
Comp = isempty(TPORDOMT41);
%tamaño de las listas
size1=size(TPORDOMT41,1);

%empezamos a rellenar la lista y poner horas
if Comp==0 
     contadorhoras=1;
     for i = 1:size1
         
         %AÑADIMOS LOS DATOS DEL PACIENTE
         Final(ContadorPAC,:) = table(string(TPORDOMT41{i,1}),string(TPORDOMT41{i,2}),string(TPORDOMT41{i,3}),string(TPORDOMT41{i,4}),string(TPORDOMT41{i,5}),string(TPORDOMT41{i,6}),string(TPORDOMT41{i,7}),string(TPORDOMT41{i,8}),string(TPORDOMT41{i,9}),string(TPORDOMT41{i,10}),string(TPORDOMT41{i,11}),HT(1,contadorhoras));
       %MIRAMOS CUANTOS TURNOS VA A USAR Y LOS AÑADIMOS AL CONTADOR DE
       %HORAS
       
      switch true
          case (strcmpi(string(TPORDOMT41{i,12}),'3')==1)
             contadorhoras=contadorhoras+3;
          case (strcmpi(string(TPORDOMT41{i,12}),'2')==1)
             contadorhoras=contadorhoras+2;
          otherwise
             contadorhoras=contadorhoras+1;
      end 
         ContadorPAC=ContadorPAC+1;

     end
     contadorhoras
end

%los contadores de horas de cada bucle empiezan en 1 porque se usan
%como indice para repartir las horas, por lo tanto los huecos siempre
%son contadorhoras-1  es decir si da 22 es 21 huecos utilizados.

Final;
FinalPac=rmmissing(Final);


%buscamos si el dia 1 esta en la tabla con el fin de actualizar el mes de
%la cita correctamente si fuese necesario
 TPARRAY=table2array(FinalPac);
 [row2,col2] =find(TPARRAY=="1");
 row2;
 col2;
 
 %miramos si el array para buscar el dia uno esta vacio 
 TF1 = isempty(row2);
 %guardamos el tamaño de de la tabla de horarios
tpsize=size(FinalPac);

 %0 significa que no esta vacio, miramos a ver si el indice 1,1 de la filas
 %es mayor que uno ya que eso significa que el 1 que hemos encontrado es
 %cambio de mes
 if TF1==0 && row2(1,1)>1
     
     for i = row2(1,1):tpsize
         
         FinalPac(i,4) = raw(1,2);
         
     end

 end
 t2
 FinalPac

% en esta tabla guardaremos aquellos pacientes que se encuentren en
% desconocido para los casos claustrofobia/protesis/marcapasos
%estos necesitan ser "entrevistados" para aclarar estos datos
confirmarCPM = table('Size',[k 12],'VariableTypes',{'string','string','string','string','string','string','string','string','string','string','string','string'});
confirmarCPM.Properties.VariableNames = {'Paciente','dia','dia mes','mes','maquina','turno','Region','Marcapasos','Claustrofobia','Protesis','Indirecta','Hora'};


for i= 1:tpsize
       
        Pacienteatendido=string(FinalPac{i,1});
    
        [row,col] =find(txtpac==Pacienteatendido);

        switch true
             case (strcmpi(string(txtpac{row,31}),'se desconoce')==1)
                confirmarCPM(i,:) = table(string(FinalPac{i,1}),string(FinalPac{i,2}),string(FinalPac{i,3}),string(FinalPac{i,4}),string(FinalPac{i,5}),string(FinalPac{i,6}),string(FinalPac{i,7}),string(FinalPac{i,8}),string(FinalPac{i,9}),string(FinalPac{i,10}),string(FinalPac{i,11}),string(FinalPac{i,12}));
             case (strcmpi(string(txtpac{row,32}),'se desconoce')==1)
                confirmarCPM(i,:) = table(string(FinalPac{i,1}),string(FinalPac{i,2}),string(FinalPac{i,3}),string(FinalPac{i,4}),string(FinalPac{i,5}),string(FinalPac{i,6}),string(FinalPac{i,7}),string(FinalPac{i,8}),string(FinalPac{i,9}),string(FinalPac{i,10}),string(FinalPac{i,11}),string(FinalPac{i,12}));
             case (strcmpi(string(txtpac{row,33}),'se desconoce')==1)
                confirmarCPM(i,:) = table(string(FinalPac{i,1}),string(FinalPac{i,2}),string(FinalPac{i,3}),string(FinalPac{i,4}),string(FinalPac{i,5}),string(FinalPac{i,6}),string(FinalPac{i,7}),string(FinalPac{i,8}),string(FinalPac{i,9}),string(FinalPac{i,10}),string(FinalPac{i,11}),string(FinalPac{i,12}));
        end
        

end
 
 confirmarCPM;
 confirmacionCPM=rmmissing(confirmarCPM)
 
 
 %comprobacion total de huecos en la lista(totales)
 contabilizarhuecos=0;
 totalsize=size(txtpac,1);
 for i= 1:totalsize-1
       
        Pacienteatendido=string(t2{i,2});
    
        [row,col] =find(txtpac==Pacienteatendido);

     switch true
       case (strcmpi(txtpac{row,13},'Cuerpo entero')==1)
            contabilizarhuecos=contabilizarhuecos+3;
       case (strcmpi(txtpac{row,5},'Tumor')==1)
              contabilizarhuecos=contabilizarhuecos+2;
       case (strcmpi(txtpac{row,23},'Si')==1)
              contabilizarhuecos=contabilizarhuecos+2;
       case (strcmpi(txtpac{row,18},'Si')==1)
              contabilizarhuecos=contabilizarhuecos+2;
       case (strcmpi(txtpac{row,19},'Si')==1)
              contabilizarhuecos=contabilizarhuecos+2;
        otherwise
              contabilizarhuecos=contabilizarhuecos+1; 
     end
        

end
contabilizarhuecos
    
 
%quitar los pacientes ya en la lista

%cojemos el tamaño de la lista de pacientes que han entrado en los horarios
%de esta semana y vamos mirando en cada fila que paciente es y comparando
%con la matriz donde estaban todos los paciente y al encontrar vamos
%eliminando toda la fila del paciente.

for i= 1:tpsize
       
        Pacienteatendido=string(FinalPac{i,1});
    
        [row,col] =find(txtpac==Pacienteatendido);

        rawpac(row,:)=[];
        txtpac(row,:)=[];
        

end


tt=sortrows (t2);


%guardamos los pacientes que restan en una nueva hoja
filename = 'acumuladoprueba.xlsx';
writecell(rawpac,filename,'Sheet','testdata','Range','B2');
%guardamos los pacierntes ya citados en un excel
filename = 'citadosprueba.xlsx';
writetable(FinalPac,filename,'Sheet','testdata','Range','B2');
%guardamos cual era el orden de prioridad en este dia
filename = 'ORDENprueba.xlsx';
writetable(tt,filename,'Sheet','testdata','Range','B2');

