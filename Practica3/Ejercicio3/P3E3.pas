{
3. Realizar un programa que gestione un archivo de libros de una librería. De cada libro se registra:
código, género, título, autor, cantidad de páginas y precio. El programa debe presentar un menú
con las siguientes opciones:
a. Crear el archivo y cargarlo con datos ingresados por teclado, utilizando la técnica de
lista invertida para recuperar espacio libre en el archivo.
b. Abrir el archivo existente y permitir su mantenimiento mediante las siguientes
operaciones:
i. Dar de alta un libro leyendo la información desde el teclado. Para esta
operación, en caso de ser posible, deberá recuperarse el espacio libre usando la
lista invertida.
ii. Modificar los datos de un libro leyendo la información desde el teclado. El
código del libro no puede ser modificado.
iii. Eliminar un libro cuyo código es ingresado por teclado.
c. Exportar el contenido del archivo de libros a un archivo de texto llamados “libros.txt”,
excluyendo los registros marcados como borrados.

NOTAS:
● Debe utilizar una lista invertida para la recuperación del espacio libre.
○ El primer registro del archivo se utiliza como cabecera de la lista.
■ El campo código de la cabecera tiene el valor cero (0) si no hay espacio libre.
■ Si el campo código de la cabecera tiene un valor negativo, indica la posición del
primer registro a reutilizar.

○ Los registros libres (aquellos marcados como borrados) utilizan el campo código como
enlace, almacenando la posición en forma negativa del siguiente registro en la lista
invertida
○ En la operación de alta:
■ Si la cabecera indica que hay espacio libre, se debe reutilizar el primer registro
disponible. Además, se debe actualizar la cabecera con la siguiente posición en
la lista invertida de espacios libres.
■ Si la cabecera indica que no hay espacio libre, se debe agregar el nuevo registro
al final del archivo.
○ En la operación de baja:
■ El registro borrado se debe incorporar a la lista invertida de espacios libres. Al ser
una lista invertida (o pila), el último registro borrado es el próximo a ser reutilizado.
Para ello, en el registro borrado se almacena el valor actual de la cabecera,
mientras que la cabecera se actualiza con la posición (en valor negativo) del
registro borrado.

● Tanto en la creación como en la apertura el nombre del archivo debe ser proporcionado por el
usuario.
   
}


program P3E2;
const	valorAlto=9999;
type
	libro= record
		cod:integer;
		genero:string[30];
		titulo:string[30];
		autor:string[30];
		paginas:integer;
		precio:real;
	end;
	
	tipoArchivo=file of libro;
	
procedure leerLibro(var l:libro);
begin
	writeln('Codigo de libro (no se puede modificar): ');
	readln(l.cod);
	if(l.cod<>valorAlto)then
	begin
		writeln('Genero');
		readln(l.genero);
		writeln('Titulo');
		readln(l.titulo);
		writeln('Autor');
		readln(l.autor);
		writeln('Cantidad de paginas');
		readln(l.paginas);
		writeln('Precio');
		readln(l.precio);
	end;
end;	
	
procedure crearArchivo(var archivo:tipoArchivo);
var
	reg:libro;
begin
	rewrite(archivo);
	reg.cod:=0;
	write(archivo,reg);
	leerLibro(reg);
	
	while(reg.cod <> valorAlto)do
	begin
		write(archivo,reg);
		leerLibro(reg);
	end;
	
	close(archivo);
end;

procedure darAlta(var archivo: tipoArchivo);
var
	reg,nuevoLibro:libro;
begin
	reset(archivo);
	read(archivo,reg);
	leerLibro(nuevoLibro);
	
	if(reg.cod=0)then
	begin
		seek(archivo,filesize(archivo));
		write(archivo,nuevoLibro);
	end
	else
	begin
		seek(archivo,reg.cod*-1);
		read(archivo,reg);
		seek(archivo,filepos(archivo)-1);
		write(archivo,nuevoLibro);
		seek(archivo,0);
		write(archivo,reg);
	end;
	
	close(archivo);
end;

procedure leer(var archivo:tipoArchivo;var reg:libro);
begin
	if(not eof(archivo))then
		read(archivo,reg)
	else
		reg.cod:=valorAlto;
end;


procedure modificarDatos(var archivo:tipoArchivo);
var
	lib,modLibro:libro;
begin
	reset(archivo);
	writeln('Ingrese los datos del libro a modificar:');
	leerLibro(modLibro);
	leer(archivo,lib);
	
	while((lib.cod<>valorAlto)and(lib.cod<>modLibro.cod))do
		leer(archivo,lib);
		
	if(lib.cod=modLibro.cod)then
	begin
		seek(archivo,filepos(archivo)-1);
		write(archivo,modLibro);
	end;
	
	close(archivo);
end;

procedure eliminar(var archivo:tipoArchivo);
var
	header,reg: libro;
	codigo:integer;
begin
	reset(archivo);
	leer(archivo,header); //dato cabecera
	leer(archivo,reg);	  //sig cabecera
	writeln('Ingrese el codigo del libro a eliminar');
	readln(codigo);
	
	while((reg.cod<>valoralto)and(reg.cod<>codigo))do
		leer(archivo,reg);
		
	if(reg.cod=codigo)then
	begin
		seek(archivo,filepos(archivo)-1);
		write(archivo,header);
		seek(archivo,0);
		reg.cod:=reg.cod*-1;
		write(archivo,reg);
	end;
	
	
	close(archivo);
end;

procedure exportarATxt(var archivo:tipoArchivo; var librostxt:text);
var	
	lib:libro;
begin
	reset(archivo);
	rewrite(librostxt);

	leer(archivo,lib);
	
	while(lib.cod<>valoralto)do
	begin
		if(lib.cod>0)then
		begin
			write(librostxt,lib.cod,' ',lib.genero,' ',lib.titulo,' ',lib.autor,' ',lib.paginas,' ',lib.precio);
		end;
		leer(archivo,lib);
	end;

	close(librostxt);
	close(archivo);
end;

procedure imprimirArchivo(var archivo: tipoArchivo);

	procedure imprimirLibro(l:libro);
	begin
		writeln('Codigo: ',l.cod,'. Genero: ',l.genero,'. Titulo: ',l.titulo,'. Autor: ',l.autor,
		'. Paginas: ',l.paginas,'. Precio: ',l.precio:0:2);
	end;

var 
	lib:libro;
begin
	reset(archivo);
	
	while(not eof(archivo))do
	begin
		read(archivo,lib);
		imprimirLibro(lib);
	end;

	close(archivo);
end;
	
var
	archivo: tipoArchivo;
	opcion:integer;
	nombre:string[30];
	librostxt:text;
begin
	writeln('Ingrese el nombre del archivo');
	readln(nombre);
	assign(archivo,nombre);
	assign(librostxt,'libros.txt');
	
	writeln('1. Crear archivo');
	writeln('2. Dar de alta un libro');
	writeln('3. Modificar los datos de un libro');
	writeln('4. Eliminar un libro');
	writeln('5. Exportar a archivo de texto');
	writeln('6. Imprimir archivo');
	
	imprimirArchivo(archivo);
	writeln('Opcion: ');
	readln(opcion);
	
	case opcion of 
		1: crearArchivo(archivo);
		2: darAlta(archivo);
		3: modificarDatos(archivo);
		4: eliminar(archivo);
		5: exportarATxt(archivo,librostxt);
		6: imprimirArchivo(archivo);
	end;
end.
