{
  1. Una empresa posee un archivo que contiene información sobre los ingresos percibidos por diferentes
empleados en concepto de comisión. De cada empleado se conoce: código de empleado, nombre y
monto de la comisión.
La información del archivo se encuentra ordenada por código de empleado, y cada empleado puede
aparecer más de una vez en el archivo de comisiones.
Se solicita realizar un procedimiento que reciba el archivo anteriormente descrito y lo compacte. Como
resultado, deberá generar un nuevo archivo en el cual cada empleado aparezca una única vez, con el
valor total acumulado de sus comisiones.
Nota: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única
vez.
}

program P2E1;
const valorAlto='9999';
type	
	empleado=record
		cod: string[10];
		nombre:string[30];
		monto:real;
	end;
	
	archivo=file of empleado;
	
procedure crearDetalle(var detalle:archivo);

	procedure leerEmpleado(var emp:empleado);
	begin
		writeln('Ingrese el codigo de empleado');
		readln(emp.cod);
		if(emp.cod<>valorAlto)then
		begin
			writeln('Ingrese el nombre del empleado:');
			readln(emp.nombre);
			writeln('Ingrese el monto de la comision');
			readln(emp.monto);
		end;
	end;

var
	emp:empleado;
begin
	rewrite(detalle);
	leerEmpleado(emp);
	while(emp.cod<>valorAlto)do
	begin
		write(detalle,emp);
		leerEmpleado(emp);
	end;
	writeln('a');
	close(detalle);
end;

procedure cargarMaestro(var maestro,detalle:archivo);

	procedure leer(var det:archivo; var reg:empleado);
	begin
		if(not eof(det))then
			read(det,reg)
		else
			reg.cod:=valorAlto;
	end;

var
	regDetalle,regMaestro:empleado;
	codActual:string[10];
	total:real;
begin

	rewrite(maestro);
	reset(detalle);
	
	leer(detalle,regDetalle);
	while(regDetalle.cod<>valorAlto)do
	begin
		codActual:=regDetalle.cod;
		total:=0;
		while(codActual=regDetalle.cod)do
		begin
			total+=regDetalle.monto;
			leer(detalle,regDetalle);
		end;
		regMaestro:=regDetalle;
		regMaestro.monto:=total;
		write(maestro,regMaestro);
	end;
	
	close(maestro);
	close(detalle);
end;

procedure imprimirArchivo(var archivo:archivo);
var
	reg:empleado;
begin
	reset(archivo);
	while(not eof(archivo))do
	begin
		read(archivo,reg);
		writeln('Codigo: ',reg.cod,'. Nombre: ',reg.nombre,' . comision: ',reg.monto:2:1);
	end;
	close(archivo);
end;

var
	maestro,detalle: archivo;
begin
	assign(maestro,'Ej1maestro');
	assign(detalle,'Ej1detalle');
	
	//crearDetalle(detalle); //Para crear el detalle
	
	cargarMaestro(maestro,detalle); //lo que pide el ejercicio
	
	imprimirArchivo(maestro);
	writeln;
	writeln;
	imprimirArchivo(detalle);
end.
