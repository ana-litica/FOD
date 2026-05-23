{
   3. Realizar un programa que presente un menu con opciones para:
a. Crear un archivo binario de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: numero de empleado,
apellido, nombre, edad y DNI. Algunos empleados pueden ingresan el DNI con valor 0, lo
que significa que al momento de la carga puede no tenerlo. La carga finaliza cuando se
ingresa el String 'fin' como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por linea.
iii. Listar en pantalla los empleados mayores de 70 años, proximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}


program P1E3yE4;
type	registro=record
			nro: integer;
			apellido:string[20];
			nombre:string[20];
			edad:integer;
			dni:integer;
		end;
		
		archivo=file of registro;

procedure cargarEmpleados(var empleados:archivo);
var
	emp:registro;
begin
	writeln('Ingrese el apellido del empleado:');
	readln(emp.apellido);
	while(emp.apellido<>'fin')do
	begin
		writeln('Ingrese el nombre del empleado:');
		readln(emp.nombre);
		writeln('Ingrese el numero del empleado:');
		readln(emp.nro);
		writeln('Ingrese la edad del empleado:');
		readln(emp.edad);
		writeln('Ingrese el dni del empleado:');
		readln(emp.dni);
		
		write(empleados, emp);
		
		writeln('Ingrese el apellido del empleado:');
		readln(emp.apellido);
	end;
end;

procedure mostrarDatos(emp:registro);
begin
	writeln('Apellido: ',emp.apellido,'. Nombre: ',emp.nombre,
			'. Numero de empleado: ',emp.nro,'. DNI: ',emp.dni,'. Edad: ',emp.edad);
end;

procedure listarNombre(var empleados: archivo);
var
	nombreBuscar:string[20];
	emple:registro;
begin
	reset(empleados);
	writeln('Ingrese el nombre o apellido que desea buscar');
	readln(nombreBuscar);
	writeln('Empleados con nombre o apellido ', nombreBuscar);
	while(not eof(empleados)) do
	begin
		read(empleados, emple);
		if((emple.nombre=nombreBuscar) or (emple.apellido=nombreBuscar))then
			MostrarDatos(emple);
	end;
	close(empleados);
end;

procedure listarEmpleados(var empleados: archivo);
var
	emp:registro;
begin
	reset(empleados);
	writeln('Empleados:');
	while(not eof(empleados))do
	begin
		read(empleados,emp);
		mostrarDatos(emp);
	end;
	close(empleados);
end;

procedure listarMayores(var empleados:archivo);
var
	emp:registro;
begin
	reset(empleados);
	writeln('Empleados mayores a 70 anios: ');
	while(not eof(empleados))do 
	begin	
		read(empleados,emp);
		if(emp.edad>70)then
			mostrarDatos(emp);
	end;
	close(empleados);
end;

var
	empleados: archivo;
	nombreFisico:string[25];
	opcion: byte;
begin
	writeln('Ingrese el nombre del archivo: ');
	readln(nombreFisico);
	
	assign(empleados,nombreFisico);
	writeln('1: Crear archivo de empleados.');
	writeln('2: Abrir y analizar archivo');
	
	writeln('Ingrese la opcion');
	readln(opcion);
	
	case opcion of 
		1: begin
			rewrite(empleados);
			cargarEmpleados(empleados);
			close(empleados);
		end;
	
		2: begin
			listarNombre(empleados);
			listarEmpleados(empleados);
			listarMayores(empleados);
		end;
	
	end;
end.
