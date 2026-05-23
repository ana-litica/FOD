{
  4. Se cuenta con un archivo maestro de productos de una cadena de venta de alimentos congelados. De
cada producto se almacena la siguiente información: código de producto, nombre, descripción, stock
disponible, stock mínimo y precio.
Diariamente se recibe un archivo detalle por cada una de las 30 sucursales de la cadena. Cada archivo
detalle contiene: código de producto y cantidad vendida.
Se solicita desarrollar un procedimiento que reciba los 30 archivos detalle y actualice el stock del archivo
maestro.
Además, deberá generarse un archivo de texto que informe, para aquellos productos cuyo stock
disponible se encuentre por debajo del stock mínimo, los siguientes datos: nombre del producto,
descripción, stock disponible y precio.
Analizar alternativas para la generación de dicho informe: realizarlo en el mismo procedimiento de
actualización o en un procedimiento separado, indicando las ventajas y desventajas de cada opción.
Nota: Todos los archivos se encuentran ordenados por código de producto. En cada archivo detalle
puede haber cero, uno o más registros para un mismo producto.
   
   
}


program P2E4;
const valorCorte=9999;
	  df={30}4;
type
	rango=1..df;
	producto=record
		cod: integer;
		nombre:string[30];
		descripcion: string[60];
		stockDisponible:integer;
		stockMinimo:integer;
		precio:real;
	end;
	
	registro=record
		cod:integer;
		vendidos:integer;
	end;

	archivoMaestro=file of producto;
	archivoDetalle=file of registro;
	
	vector=array [rango] of archivoDetalle;
	vectorDatos=array[rango]of registro;

procedure crearMaestro(var maestro:archivoMaestro);

	procedure leerProducto(var prod: producto);
	begin
		writeln('Ingrese el codigo de producto');
		readln(prod.cod);
		if(prod.cod<>valorCorte)then
		begin
			writeln('Ingrese el nombre del producto');
			readln(prod.nombre);
			writeln('Ingrese la descripcion del producto');
			readln(prod.descripcion);
			writeln('Ingrese el stock disponibles del producto');
			readln(prod.stockDisponible);
			writeln('Ingrese el stock minimo del producto');
			readln(prod.stockMinimo);
			writeln('Ingrese el precio del producto');
			readln(prod.precio);
		end;
	end;
	
var
	prod:producto;
begin
	rewrite(maestro);
	leerProducto(prod);
	while(prod.cod<>valorCorte)do
	begin
		write(maestro,prod);
		leerProducto(prod);
	end;
	close(maestro);
end;

procedure crearDetalles(var detalles:vector);

	procedure leerRegistro(var reg:registro);
	begin
		writeln('Ingrese el codigo de producto');
		readln(reg.cod);
		if(reg.cod<>valorCorte)then
		begin
			writeln('Ingrese la cantidad vendida');
			readln(reg.vendidos);
		end;
	end;

	procedure crearDetalle(var detalle:archivoDetalle);
	var
		reg:registro;
	begin
		rewrite(detalle);
		leerRegistro(reg);
		while(reg.cod<>valorcorte)do
		begin
			write(detalle, reg);
			leerRegistro(reg);
		end;
		close(detalle);
	end;

var
	i:rango;
begin
	for i:=1 to df do
	begin
		writeln('Detalle ',i);
		crearDetalle(detalles[i]);
	end;
end;
	
procedure imprimirMaestro(var maestro:archivoMaestro);	

	procedure imprimirProducto(p:producto);
	begin
		writeln('Producto: ',p.cod,'. Nombre: ',p.nombre,'. Descripcion: ',p.descripcion,'. Stock disponible: ',p.stockDisponible,
			'. Stock minimo: ',p.stockMinimo,'. Precio: ',p.precio:2:4);
	end;

var
	prod:producto;
begin
	reset(maestro);
	while(not eof(maestro))do
	begin
		read(maestro,prod);
		imprimirProducto(prod);
	end;
	close(maestro);
end;
	
procedure imprimirDetalles(var detalles:vector);

	procedure imprimirDetalle(var detalle:archivoDetalle);
	
		procedure imprimirRegistro(reg:registro);
		begin
			writeln('Codigo de producto: ',reg.cod,'. Cantidad vendida: ',reg.vendidos);
		end;
	
	var
		reg:registro;
	begin
		reset(detalle);
		while(not eof(detalle))do
		begin
			read(detalle, reg);
			imprimirRegistro(reg);
		end;
		close(detalle);
	end;

var
	i:rango;
begin
	for i:=1 to df do begin
		writeln('Detalle numero ',i);
		imprimirDetalle(detalles[i]);
	end;
end;
	
procedure actualizarMaestro(var maestro:archivoMaestro;var detalles:vector);

	procedure leer(var detalle:archivoDetalle;var dato: registro);
	begin
		if(not eof(detalle))then
			read(detalle,dato)
		else
			dato.cod:=valorCorte;
	end;

	procedure minimo(var detalles:vector;var datosDetalles:vectorDatos;var min:registro);
	var
		i,minPos:rango;
	begin
		min.cod:=valorCorte;
		for i:=1 to df do
			if(datosDetalles[i].cod<min.cod)then
			begin
				min:=datosDetalles[i];
				minPos:=i;
			end;
		if(min.cod<>valorCorte)then
			leer(detalles[minPos],datosDetalles[minPos]);
	end;

var
	regMaestro:producto;
	min,contador:registro;
	datosDetalles:vectorDatos;
	i:rango;
begin
	reset(maestro);
	for i:=1 to df do 
	begin
		reset(detalles[i]);
		leer(detalles[i],datosDetalles[i]);
	end;
	
	minimo(detalles,datosDetalles,min);
	if(not eof(maestro))then
			read(maestro,regMaestro);
			
	while(min.cod<>valorCorte)do
	begin
		contador.cod:=min.cod;
		contador.vendidos:=0;
		while(contador.cod=min.cod)do
		begin
			contador.vendidos+=min.vendidos;
			minimo(detalles,datosDetalles,min);
		end;
		
		while((not eof(maestro))and(contador.cod<>regMaestro.cod))do
			read(maestro,regMaestro);
		
		regMaestro.stockDisponible-=contador.vendidos;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regMaestro);
	end;	
		
	for i:=1 to df do 
		close(detalles[i]);
	close(maestro);
end;	
	
procedure exportarStockMinimo(var maestro:archivoMaestro);	
var
	informe:text;
	datos:producto;
begin
	assign(informe,'informeEj4');
	reset(maestro);
	rewrite(informe);
	while(not eof(maestro))do
	begin
		read(maestro,datos);
		if(datos.stockDisponible<datos.stockMinimo)then
			writeln(informe,'Producto: ',datos.nombre,'. Descripcion: ',datos.descripcion,
			'. Stock disponible: ',datos.stockDisponible,'. Precio: ',datos.precio:2:2);
	end;
	close(informe);
	close(maestro);
end;
	
var
	maestro:archivoMaestro;
	detalles:vector;
	opcion,i:integer;
	numero:string;
begin
	assign(maestro,'Ej4Maestro');
	for i:=1 to df do
	begin
		str(i,numero);
		assign(detalles[i],'Ej4Detalle'+numero);
	end;
	
	writeln('1. Crear archivo maestro.');
	writeln('2. Crear archivos detalle.');
	writeln('3. Imprimir maestro.');
	writeln('4. Imprimir detalles');
	writeln('5. Actualizar maestro');
	writeln('6. Exportar productos con stock menor al minimo a archivo de texto');
	
	writeln('Ingrese una opcion:');
	readln(opcion);
	
	case opcion of 
		1: crearMaestro(maestro);
		2: crearDetalles(detalles);
		3: imprimirMaestro(maestro);
		4: imprimirDetalles(detalles);
		5: actualizarMaestro(maestro, detalles);
		6: exportarStockMinimo(maestro);
	end;
	
end.
