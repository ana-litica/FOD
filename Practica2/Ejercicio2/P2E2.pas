{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos
que comercializa. Para ello, dispone de un archivo maestro en el que se registran todos los productos.
De cada producto se almacena la siguiente información: código de producto, nombre comercial, precio de venta,
stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas realizadas. De cada venta se
almacena: código de producto y cantidad de unidades vendidas.
Se solicita desarrollar un programa que permita:
a) Actualizar el archivo maestro a partir del archivo detalle, teniendo en cuenta que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del archivo maestro puede ser actualizado por cero, uno o más registros del archivo
detalle.
● El archivo detalle sólo contiene registros cuyos códigos existen en el archivo maestro.
b) Generar un archivo de texto llamado “stock_minimo.txt” que contenga aquellos productos cuyo stock actual se
encuentre por debajo del stock mínimo permitido.
}

program P2E2;
const valorAlto=9999;
type
	producto=record
		cod:integer;
		nombre:String[30];
		precio:real;
		stockActual:integer;
		stockMinimo:integer;
	end;
	
	registro=record
		cod:integer;
		unidades:integer;
	end;
	
	archivoMaestro=file of producto;
	archivoDetalle=file of registro;
	
procedure crearMaestro(var maestro:archivoMaestro);

	procedure leerProducto(var prod:producto);
	begin
		writeln('Codigo de producto');
		readln(prod.cod);
		if(prod.cod<>valorAlto)then
		begin
			writeln('Nombre del producto');
			readln(prod.nombre);
			writeln('Precio del producto');
			readln(prod.precio);
			writeln('Stock actual del producto');
			readln(prod.stockActual);
			writeln('Stock minimo del producto');
			readln(prod.stockMinimo);
		end;
	end;

var
	prod: producto;
begin
	rewrite(maestro);
	leerProducto(prod);
	while(prod.cod<>valorAlto)do
	begin
		write(maestro,prod);
		leerProducto(prod);
	end;
	close(maestro);
end;

procedure crearDetalle(var detalle:archivoDetalle);

	procedure leerRegistro(var reg:registro);
	begin
		writeln('Codigo de producto');
		readln(reg.cod);
		if(reg.cod<>valorAlto)then
		begin
			writeln('Unidades vendidas:');
			readln(reg.unidades);
		end;
	end;

var
	reg:registro;
begin
	rewrite(detalle);
	leerRegistro(reg);
	while(reg.cod<>valorAlto)do
	begin
		write(detalle,reg);
		leerRegistro(reg);
	end;
	close(detalle);
end;
	
procedure imprimirMaestro(var maestro:archivoMaestro);
var	
	prod:producto;
begin
	reset(maestro);
	while(not eof(maestro))do
	begin
		read(maestro, prod);
		writeln('Codigo de producto: ',prod.cod,'. Nombre de producto: ',prod.nombre,'. Precio: ',prod.precio:2:0,
			'. Stock actual: ',prod.stockActual,'. Stock minimo: ',prod.stockMinimo);
	end;
	close(maestro);
end;	
	
procedure imprimirDetalle(var detalle:archivoDetalle);
var	
	reg:registro;
begin
	reset(detalle);
	while(not eof(detalle))do
	begin
		read(detalle, reg);
		writeln('Codigo de producto: ',reg.cod,'. Unidades vendidas: ',reg.unidades);
	end;
	close(detalle);
end;	
	
procedure actualizarMaestro(var maestro:archivoMaestro; var detalle:archivoDetalle);

	procedure leer(var detalle:archivoDetalle;var reg:registro);
	begin
		if(not eof(detalle))then
			read(detalle,reg)
		else
			reg.cod:=valorAlto;
	end;

var
	prod:producto;
	reg:registro;
begin
	reset(maestro);
	reset(detalle);
	
	leer(detalle,reg);
	while(reg.cod<>valorAlto)do
	begin
		read(maestro,prod);
		while(prod.cod<>reg.cod)do
			read(maestro,prod);
		while(reg.cod=prod.cod)do
		begin
			prod.stockActual-=reg.unidades;
			leer(detalle,reg);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,prod);
	end;
	
	close(maestro);
	close(detalle);
end;	
	
procedure crearStockMinimo(var maestro:archivoMaestro);	
var
	stockMinimo:text;
	prod:producto;
begin
	assign(stockMinimo,'stock_minimo.txt');
	reset(maestro);
	rewrite(stockMinimo);
	writeln(stockMinimo,'Productos con stock menor al minimo:');
	while(not eof(maestro))do
	begin
		read(maestro,prod);
		if(prod.stockActual<prod.stockMinimo)then
		begin
			writeln(stockMinimo,'Codigo de producto: ',prod.cod,'. Nombre de producto: ',prod.nombre,'. Precio: ',prod.precio:2:0,
			'. Stock actual: ',prod.stockActual,'. Stock minimo: ',prod.stockMinimo);
		end;
	end;
	close(maestro);
	close(stockMinimo);
end;
	
var
	maestro:archivoMaestro;
	detalle:archivoDetalle;opcion:integer;
begin
	assign(maestro,'Ej2Maestro');
	assign(detalle,'Ej2Detalle');
	
	writeln('1. Crear archivo maestro');
	writeln('2. Crear archivo detalle');
	writeln('3. Actualizar archivo maestro');
	writeln('4. Crear archivo de stock minimo');
	writeln('5. Imprimir maestro');
	writeln('6. Imprimir detalle');
	
	writeln('Seleccione una opcion');
	readln(opcion);
	
	case opcion of
		1: crearMaestro(maestro);
		2: crearDetalle(detalle);
		3: actualizarMaestro(maestro,detalle);
		4: crearStockMinimo(maestro);
		5: imprimirMaestro(maestro);
		6: imprimirDetalle(detalle);
	end;
end.
