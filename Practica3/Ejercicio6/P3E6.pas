{
Se cuenta con un archivo que almacena información sobre especies de aves en peligro de
extinción. De cada especie se registran los siguientes datos: código, nombre de la especie, familia,
descripción y zona geográfica. El archivo no se encuentra ordenado por ningún criterio.
Se desea desarrollar un programa que permita eliminar especies de aves extintas. Para ello, el
programa deberá contar con dos procedimientos:
Un procedimiento que, dado el código de una especie, la marque como borrada (baja lógica). En
caso de querer eliminar múltiples especies, este procedimiento podrá invocarse repetidamente.
Un procedimiento que realice la compactación del archivo (baja física), eliminando
definitivamente aquellas especies marcadas como borradas. Para ello, cada vez que se elimine un
registro, se deberá reemplazar su posición con el último registro del archivo y luego eliminar dicho
último registro, evitando así dejar espacios vacíos y registros duplicados.
Implemente además una variante de este procedimiento de compactación en la cual el archivo
sea truncado una única vez al finalizar el proceso.
    
}


program P3E6;
const valorAlto=9999;
type
	especie=record
		cod:integer;
		nombre:String[45];
		familia:String[45];
		descripcion:String[45];
		zona:String[45];
	end;
	
	tipoArchivo=file of especie;

procedure crearArchivo(var archivo:tipoArchivo);

	procedure leerEspecie(var ave:especie);
	begin
		writeln('Codigo');
		readln(ave.cod);
		if(ave.cod<>valorAlto)then
		begin
			writeln('Nombre de la especie');
			readln(ave.nombre);
			writeln('Familia');
			readln(ave.familia);
			writeln('Descripcion');
			readln(ave.descripcion);
			writeln('Zona geografica');
			readln(ave.zona);
		end;
	end;

var
	ave:especie;
begin
	rewrite(archivo);
	leerEspecie(ave);
	while(ave.cod<>valorAlto)do
	begin
		write(archivo,ave);
		leerEspecie(ave);
	end;
	close(archivo);
end;

procedure leer(var archivo:tipoArchivo;var dato:especie);
begin
	if(not eof(archivo))then
		read(archivo,dato)
	else
		dato.cod:=valorAlto;
end;

procedure imprimirArchivo(var archivo:tipoArchivo);
var
	ave:especie;
begin
	reset(archivo);
	while(not eof(archivo))do
	begin
		read(archivo,ave);
		writeln('Codigo: ',ave.cod,'. Nombre de la especie: ',ave.nombre,'. Familia: ',ave.familia,
			'. Descripcion: ',ave.descripcion,'. Zona geografica: ',ave.zona);
	end;
	close(archivo);
end;

procedure bajaLogica(var archivo:tipoArchivo; cod:integer);
var
	ave:especie;
begin
	reset(archivo);
	leer(archivo,ave);
	
	while(ave.cod<>cod)do
		leer(archivo,ave);
	
	seek(archivo,filepos(archivo)-1);
	ave.cod:=ave.cod*-1;
	write(archivo,ave);		
	
	close(archivo);
end;

procedure bajaFisica(var archivo:tipoArchivo);
var	
	ave,aux:especie;
	posActual:integer;
begin
	reset(archivo);
	leer(archivo,ave);
	
	while(ave.cod <> valorAlto)do
	begin
		if(ave.cod<0)then
		begin
			posActual:=filepos(archivo)-1;
			seek(archivo,filesize(archivo)-1);
			read(archivo,aux);
			seek(archivo,filepos(archivo)-1);
			write(archivo,ave);
			seek(archivo,posActual);
			write(archivo,aux);
			seek(archivo,filepos(archivo)-1);
			truncate(archivo);
		end;
		leer(archivo,ave);
	end;
	
	close(archivo);
end;
	
var
	archivo:tipoArchivo;
	cod:integer;
	seguir:string[5];
begin
	assign(archivo,'Aves');
	
{
	crearArchivo(archivo);
	imprimirArchivo(archivo);
}
	
	write('Ingrese el codigo de la especie a borrar');
	readln(cod);
	seguir:='si';
	while(seguir='si')do
	begin
		bajaLogica(archivo,cod);
		writeln('Desea eliminar mas especies?');
		readln(seguir);
		if(seguir='si')then
		begin
			write('Ingrese el codigo de la especie a borrar');
			readln(cod);
		end;
	end;
	bajaFisica(archivo);
	imprimirArchivo(archivo);
end.
		
