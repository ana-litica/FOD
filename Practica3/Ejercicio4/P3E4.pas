{
4. Dada la siguiente estructura:
type

reg_flor = record
nombre: String[45];
codigo: integer;
end;
tArchFlores = file of reg_flor;

Se desea implementar un sistema de gestión de flores utilizando un archivo con reutilización de
espacio.
● Las bajas lógicas se realizan apilando los registros eliminados.
● Las altas deben reutilizar los espacios libres disponibles antes de agregar nuevos registros al final
del archivo.
● El registro en la posición 0 se utiliza como cabecera de la pila de registros borrados.
Política de reutilización:
● Si el campo código del registro cabecera es 0, significa que no hay registros borrados
disponibles.
● Si el campo código es -N, indica que el próximo registro libre se encuentra en la posición N del
archivo.
● Cada registro borrado debe almacenar en su campo codigo el valor negativo que apunte al
siguiente registro libre, formando así una pila enlazada.
a. Implementación requerida
Implementar el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro,
respetando la política de reutilización de espacio descripta 
procedure agregarFlor (var a: tArchFlores; nombre: string; codigo: integer);
b. Listado del archivo
Realizar un procedimiento que liste el contenido del archivo omitiendo las flores eliminadas (es
decir, aquellos registros que forman parte de la pila de libres.
Se permite modificar o agregar estructuras auxiliares si se considera necesario para obtener
correctamente el listado.
c. Implemente el siguiente módulo:
Abre el archivo y elimina la flor recibida como parámetro manteniendo la
política descripta anteriormente
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor); }
   



program P3E4;
const	valorAlto=9999;
type
	reg_flor=record
		nombre: String[45];
		codigo: integer;
	end;
	
	tArchFlores = file of reg_flor;
	
procedure leerFlor(var f:reg_flor);
begin
	writeln('Ingrese el codigo de la flor');
	readln(f.codigo);
	if(f.codigo<>valorAlto)then
	begin
		writeln('Ingrese el nombre de la flor');
		readln(f.nombre);
	end;
end;

procedure cargarFlores(var flores:tArchFlores);	
var
	dato:reg_flor;
begin
	rewrite(flores);
	dato.codigo:=0;
	write(flores,dato);
	leerFlor(dato);
	while(dato.codigo<>valorAlto)do
	begin
		write(flores,dato);
		leerFlor(dato);
	end;
	close(flores);
end;

procedure imprimir(var flores:tArchFlores);
var
	flor:reg_flor;
begin
	reset(flores);
	while(not eof(flores))do
	begin
		read(flores,flor);
		writeln('Nombre: ',flor.nombre,'. Codigo: ',flor.codigo);
	end;
	close(flores);
end;

procedure leer(var flores:tArchFlores;var dato:reg_flor);
begin
	if(not eof(flores))then
		read(flores,dato)
	else
		dato.codigo:=valorAlto;
end;

procedure agregarFlor(var a:tArchFlores;nombre:string;codigo:integer);
var
	sig,dato:reg_flor;
begin
	reset(a);
	leer(a,sig);
	dato.nombre:=nombre;
	dato.codigo:=codigo;
	
	if(sig.codigo<0)then
	begin
		seek(a,sig.codigo*-1);
		read(a,sig);
		seek(a,filepos(a)-1);
		write(a,dato);
		seek(a,0);
		write(a,sig);
	end
	else
	begin
		seek(a,filesize(a));
		write(a,dato);
	end;
	
	close(a);
end;

procedure listarFlores(var flores:tArchFlores);
var
	dato:reg_flor;
begin
	reset(flores);
	leer(flores,dato);
	while(dato.codigo<>9999)do
	begin
		if(dato.codigo>0)then
			writeln('Codigo: ',dato.codigo,'. Nombre: ',dato.nombre);
		leer(flores,dato);
	end;
	
	close(flores);
end;

procedure eliminarFlor(var a:tArchFlores;flor:reg_flor);
var
	cabecera,dato:reg_flor;
begin
	reset(a);
	leer(a,cabecera);
	leer(a,dato);
	while((dato.codigo <> valorAlto)and(dato.codigo<>flor.codigo))do 
		leer(a,dato);
	
	if(dato.codigo=flor.codigo)then
	begin
		seek(a,filepos(a)-1);
		write(a,cabecera);
		seek(a,0);
		dato.codigo:=dato.codigo*-1;
		write(a,dato);
	end;
	
	close(a);
end;
	
var
	flores:tArchFlores;
	opcion:integer;
	f:reg_flor;
begin
	assign(flores,'floresEj4');
	
	writeln('1. Cargar archivo de flores');
	writeln('2. Agregar flor');
	writeln('3. Listar flores');
	writeln('4. Eliminar flor');
imprimir(flores);
	writeln('Opcion:');
	readln(opcion);
	
	case opcion of
		1:  begin
			cargarFlores(flores);
			imprimir(flores);
			end;
		2: begin
			leerFlor(f);
			agregarFlor(flores,f.nombre,f.codigo);
		end;
		3: listarFlores(flores);
		4: begin
			writeln('Ingrese el codigo de la flor');
			readln(f.codigo);
			writeln('Ingrese el nombre de la flor');
			readln(f.nombre);
			eliminarFlor(flores,f);
		end;
	end;
end.


