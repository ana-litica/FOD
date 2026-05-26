{
5. Una cadena de tiendas de indumentaria dispone de un archivo maestro no ordenado que
contiene la información de las prendas que se encuentran a la venta. De cada prenda se registran
los siguientes datos: cod_prenda, descripción, colores, tipo_prenda, stock y precio_unitario.
Debido a un cambio de temporada, es necesario actualizar las prendas disponibles. Para ello, se
recibe un archivo detalle que contiene los códigos (cod_prenda) de aquellas prendas que
quedarán obsoletas. Se deberá implementar un procedimiento que reciba ambos archivos y
realice la baja lógica de las prendas indicadas; para ello, se deberá modificar el campo stock de la
prenda correspondiente asignándole un valor negativo como marca de eliminación.
Adicionalmente, se deberá implementar otro procedimiento que permita efectivizar las bajas
lógicas realizadas sobre el archivo maestro. Para ello, se deberá crear un archivo auxiliar en el cual
se copien únicamente aquellas prendas que no estén marcadas como eliminadas (es decir,
aquellas cuyo stock sea mayor o igual a cero).
Finalmente, una vez completado el proceso de compactación, el archivo auxiliar deberá
reemplazar al archivo maestro original, adoptando su mismo nombre.
   
}


program P3E5;
const valorAlto=9999;
type
	prenda=record
		cod_prenda:integer;
		descripcion:string[50];
		colores:string[45];
		tipo_prenda:string[50];
		stock:integer;
		precio_unitario:real;
	end;
	
	tipoMaestro=file of prenda;
	tipoDetalle=file of integer;

procedure crearMaestro(var maestro:tipoMaestro);

	procedure leerPrenda(var p:prenda);
	begin
		writeln('Codigo de prenda: ');
		readln(p.cod_prenda);
		if(p.cod_prenda<>valoralto)then
		begin
			writeln('Descripcion de prenda: ');
			readln(p.descripcion);
			writeln('Colores de prenda: ');
			readln(p.colores);
			writeln('Tipo de prenda: ');
			readln(p.tipo_prenda);
			writeln('Stock de prenda: ');
			readln(p.stock);
			writeln('Precio unitario de prenda: ');
			readln(p.precio_unitario);
		end;
	end;

var
	p:prenda;
begin
	rewrite(maestro);
	leerPrenda(p);
	while(p.cod_prenda<>valorAlto)do
	begin
		write(maestro,p);
		leerPrenda(p);
	end;
	close(maestro);
end;

procedure crearDetalle(var detalle:tipoDetalle);
var
	cod:integer;
begin
	rewrite(detalle);
	writeln('Codigo de prenda: ');
	readln(cod);
	while(cod<>valoralto)do
	begin
		writeln('Codigo de prenda: ');
		readln(cod);
		write(detalle,cod);
	end;
	close(detalle);
end;

procedure leerDetalle(var detalle:tipoDetalle; var cod:integer);
begin
	if(not eof(detalle))then
		read(detalle,cod)
	else
		cod:=valorAlto;
end;

procedure leerMaestro(var maestro:tipoMaestro; var p:prenda);
begin
	if(not eof(maestro))then
		read(maestro,p)
	else
		p.cod_prenda:=valorAlto;
end;

procedure bajaLogica(var maestro:tipoMaestro;var detalle: tipoDetalle);
var
	cod:integer;
	p:prenda;
begin
	reset(maestro);
	reset(detalle);
	
	leerDetalle(detalle,cod);
	
	while(cod<>valorAlto)do
	begin
		leerMaestro(maestro,p);
		while((cod<>p.cod_prenda))do
			leerMaestro(maestro,p);
			
		seek(maestro,filepos(maestro)-1);
		p.stock:=p.stock*-1;
		write(maestro,p);
		seek(maestro,0);	
		leerDetalle(detalle,cod);
	end;
	
	close(detalle);
	close(maestro);
end;

procedure bajaFisica(var maestro:tipoMaestro;var nuevoMaestro:tipoMaestro);
var
	p:prenda;
begin
	reset(maestro);
	rewrite(nuevoMaestro);
	leerMaestro(maestro,p);
	
	while(p.cod_prenda<>valorAlto)do
	begin
		if(p.stock>0)then
			write(nuevoMaestro,p);
		leerMaestro(maestro,p);
	end;
	
	close(nuevoMaestro);
	close(maestro);
	
	
	rename(Maestro,'Maestro_viejo.dat');
	rename(nuevoMaestro,'Maestro.dat');

	
end;

procedure imprimirMaestro(var maestro:tipoMaestro);

	procedure imprimirPrenda(p:prenda);
	begin
		writeln('Codigo: ',p.cod_prenda,'. Descripcion: ',p.descripcion,'. Colores: ',p.colores,
			'. Tipo: ',p.tipo_prenda,'. Stock: ',p.stock,'. Precio unitario: ',p.precio_unitario:0:2);
	end;

var
	p:prenda;
begin
	reset(maestro);
	while(not eof(maestro))do
	begin
		read(maestro,p);		
		imprimirPrenda(p);
	end;
	close(maestro);
end;

procedure imprimirDetalle(var detalle:tipoDetalle);
var
	cod:integer;
begin
	reset(detalle);
	while(not eof(detalle))do
	begin
		read(detalle,cod);
		writeln('Codigo: ',cod);
	end;
	close(detalle);
end;

var
	maestro,nuevoMaestro:tipoMaestro;
	detalle:tipoDetalle;
begin
	assign(maestro,'Maestro');
	assign(detalle,'Detalle');
	assign(nuevoMaestro,'MaestroNuevo');
	

{
	writeln('Maestro');
	crearMaestro(maestro);
	writeln('Detalle');
	crearDetalle(detalle);
	
	writeln('Maestro');
	imprimirMaestro(maestro);
	writeln('Detalle');
	imprimirDetalle(detalle);
}

	
	bajaLogica(maestro,detalle);

	bajaFisica(maestro,nuevoMaestro);
	
	imprimirMaestro(Maestro);
	imprimirMaestro(nuevoMaestro);
	
end.

