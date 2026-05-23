{
   Realizar un algoritmo, que utilizando el archivo de numeros enteros no ordenados creado en el
ejercicio 1, informe por pantalla cantidad de numeros menores a 15000 y el promedio de los
numeros ingresados. El nombre del archivo a procesar debe ser proporcionado por el usuario
una unica vez. Ademas, el algoritmo debera listar el contenido del archivo en pantalla. Resolver
el ejercicio realizando un unico recorrido del archivo.
   
}

program P1E2;
type	archivo=file of integer;

procedure recorrerArchivo(var numeros:archivo;var promedio: real; var cantidad:integer);
var
	total:integer;
	nro:integer;
begin
	total:=0;
	while(not eof(numeros))do
	begin
		read(numeros, nro);
		total+=1;
		promedio+=nro;
		if(nro<15000)then
			cantidad+=1;
		writeln(nro);
	end;
	promedio:=promedio/total;
end;

var
	numeros: archivo;
	nombreFisico: string[25];
	promedio: real;
	cantidad: integer;
begin
	cantidad:=0;
	promedio:=0;
	writeln('Ingrese el nombre del archivo: ');
	readln(nombreFisico);
	
	assign(numeros, nombreFisico);
	reset(numeros);
	
	recorrerArchivo(numeros, promedio, cantidad);
	close(numeros);
	writeln('El promedio de los numeros; ',promedio:1:2);
	writeln('La cantidad de numeros menores a 15000 son: ',cantidad);
end.
