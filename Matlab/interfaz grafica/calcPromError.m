function [errinf,errsup,promedio,err] = calcPromError(datos1)
promedio=mean(datos1,2,'omitnan');%obtiene el promedio de todos los animales
 [row,col]=size(datos1);%numero de datos
err=std(datos1,0,2,'omitnan')./sqrt(length(col));
errinf=promedio-err;
errsup=promedio+err;
u=length(datos1);