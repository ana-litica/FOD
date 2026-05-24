{
2. Definir un programa que genere un archivo con registros de longitud fija con información de
productos de un comercio. Los datos se ingresan por teclado y de cada producto se almacena:
código de producto, nombre, descripción, precio y stock disponible. Implementar un
procedimiento que, a partir del archivo de datos generado, realice la baja lógica de todos
aquellos productos cuyo stock disponible sea igual a 0.
La baja lógica debe indicarse marcando el registro con un carácter especial que se sitúa como
prefijo en algún campo de tipo string a su elección. Por ejemplo, se puede anteponer el carácter @
al nombre del producto: ‘@Arroz Gallo 1K’.  
}


program P3E2;
const valorAlto=9999;
type
	producto=record
		cod:integer;
		nombre:string[30];
		descripcion:string[30];
		precio:Real;
		stock:integer;
	end;
	
	tipoArchivo=file of producto;
	
procedure crearArchivo(var archivo:tipoArchivo);	

	procedure leerProducto(var prod:producto);
	begin
		writeln('Ingrese el codigo de producto');
		readln(prod.cod);
		if(prod.cod <> valorAlto)then
		begin
			writeln('Ingrese el nombre del producto');
			readln(prod.nombre);
			writeln('Ingrese la descripcion del producto');
			readln(prod.descripcion);
			writeln('Ingrese precio del producto');
			readln(prod.precio);
			writeln('Ingrese stock del producto');
			readln(prod.stock);
		end;
	end;

var
	prod:producto;
begin	
	rewrite(archivo);
	leerProducto(prod);
	while(prod.cod <> valorAlto)do
	begin
		write(archivo,prod);
		leerProducto(prod);
	end;
	
	close(archivo);
end;

procedure imprimirArchivo(var archivo:tipoArchivo);
var
	prod:producto;
begin
	reset(archivo);
	while(not eof(archivo))do
	begin
		read(archivo,prod);
		writeln('Codigo: ', prod.cod,'. Nombre: ',prod.nombre,'. Descripcion: ',prod.descripcion,'. Precio: ',prod.precio:0:2,
		'. Stock disponible: ', prod.stock);
	end;
	close(archivo);
end;

procedure bajaLogica(var archivo:tipoArchivo);

	procedure leer(var archivo:tipoArchivo;var prod:producto);
	begin
		if(not eof(archivo))then
			read(archivo,prod)
		else
			prod.cod:=valorAlto;
	end;

var
	prod:producto;
begin
	reset(archivo);
	
	leer(archivo,prod);
	while(prod.cod<>valorAlto)do
	begin
		if(prod.stock=0)then
		begin
			prod.nombre:='@'+prod.nombre;
			seek(archivo,filepos(archivo)-1);
			write(archivo,prod);
		end;
		leer(archivo,prod);
	end;
	
	close(archivo);
end;

var
	archivo:tipoArchivo;
	opcion:integer;
begin
	assign(archivo,'Productos');
	
	writeln('1. Crear archivo');
	writeln('2. Imprimir archivo');
	writeln('3. Baja logica');
	
	writeln('Opcion:');
	readln(opcion);
	
	case opcion of 
		1: crearArchivo(archivo);
		2: imprimirArchivo(archivo);
		3: bajaLogica(archivo);
	end;
end.
	
