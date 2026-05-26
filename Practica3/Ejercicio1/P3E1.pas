{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados) agregando una
opción que permita realizar bajas físicas en el archivo. La baja debe realizarse a partir del número
de empleado ingresado por teclado, identificando el registro correspondiente en el archivo. Una
vez encontrado, se debe reemplazar el registro a eliminar por el último registro del archivo, y luego
truncando el archivo en la posición del último registro de forma tal de evitar duplicados.   
   
}

program P3E1;
const valorAlto=9999;
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

{Ejercicio 4}
//4a
procedure leerEmpleado(var emp:registro);
begin
	writeln('Ingrese el apellido del empleado:');
	readln(emp.apellido);
	if(emp.apellido<>'fin')then
	begin
		writeln('Ingrese el nombre del empleado:');
		readln(emp.nombre);
		writeln('Ingrese el numero del empleado:');
		readln(emp.nro);
		writeln('Ingrese la edad del empleado:');
		readln(emp.edad);
		writeln('Ingrese el dni del empleado:');
		readln(emp.dni);
	end;
end;

procedure buscarEmpleado(var empleados:archivo; nroEmp:integer;var encontrado:boolean);
var
	aux:registro;
begin
	encontrado:=false;
	read(empleados, aux);
	while((not eof(empleados)) and (not encontrado))do
	begin
		read(empleados, aux);
		if(aux.nro<>nroEmp)then
			encontrado:=true;
	end;
end;


procedure agregarEmpleado(var empleados:archivo);
var
	emp:registro;
	unicidad:boolean;
begin
	reset(empleados);
	leerEmpleado(emp);
	while(emp.apellido<>'fin')do
	begin
		buscarEmpleado(empleados,emp.nro,unicidad);
		if(unicidad)then
		begin
			seek(empleados,filepos(empleados)-1);
			write(empleados, emp);
		end;
		leerEmpleado(emp);
	end;
	close(empleados);
end;

//4b

procedure modificar(var empleados: archivo);
var
	nro,edad: integer;
	emp:registro;
begin
	reset(empleados);
	writeln('Ingrese la el numero de empleado de quien hay que modificar su edad');
	readln(nro);
	writeln('Ingrese la edad a modificar');
	readln(edad);
	read(empleados,emp);
	while((not eof(empleados)) and (nro<>emp.nro))do
		read(empleados,emp);
	if(nro=emp.nro)then
	begin
		emp.edad:=edad;
		seek(empleados,filepos(empleados)-1);
		write(empleados, emp);
	end;
	close(empleados);
end;

procedure exportarTodos(var empleados:archivo; var todosEmpleados:text);
var
	emp:registro;
begin
	assign(todosEmpleados,'todos_empleados.txt');
	reset(empleados);
	rewrite (todosEmpleados);
	while(not eof(empleados)) do
	begin
		read(empleados,emp);
		writeln(todosEmpleados, emp.nro,' ',emp.edad,' ',emp.dni,' ',emp.apellido,' ',emp.nombre);
		//write(todos,emp);
	end;
	close(empleados);
    close (todosEmpleados);
end;

procedure exportarSinDNI(var empleados:archivo;var sinDNI:text);
var
   emp:registro;
begin
	assign(sindni,'faltaDNIEmpleado.txt');
    reset (empleados);
    rewrite(sindni);
     while(not eof(empleados))do
     begin
          read(empleados,emp);
          if(emp.dni=0)then
             writeln(sinDNI,emp.nro,' ',emp.edad,' ',emp.dni,' ',emp.apellido,' ',emp.nombre);
     end;
     close(empleados);
     close(sindni);
end;

procedure bajaFisica(var empleados: archivo);

	procedure leer(var empleados:archivo;var emp:registro);
	begin
		if(not eof(empleados))then
			read(empleados,emp)
		else
			emp.nro:=valorAlto;
	end;

var
	nro: integer;
	emp,ultimo:registro;
begin
	writeln('Ingrese el numero de empleado a eliminar');
	readln(nro);
	
	reset(empleados);
	seek(empleados,filesize(empleados)-1);
	read(empleados,ultimo);
	seek(empleados,0);
	
	leer(empleados,emp);
	while((emp.nro<>valorAlto) and (emp.nro<>nro))do
		leer(empleados,emp);
	
	if(emp.nro=nro)then
	begin
		seek(empleados,filepos(empleados)-1);
		write(empleados,ultimo);
		seek(empleados,filesize(empleados)-1);
		truncate(empleados);
	end;
	
	close(empleados);
end;

var
	empleados: archivo;
	nombreFisico:string[25];
	opcion: byte;
	todosEmpleados,sindni:Text;
begin
	writeln('Ingrese el nombre del archivo: ');
	readln(nombreFisico);
	
	assign(empleados,nombreFisico);
	writeln('1: Crear archivo de empleados.');
	writeln('2: Abrir y analizar archivo');
	writeln('3: Aniadir empleado/s');
	writeln('4: Modificar la edad de un empleado');
	writeln('5: Exportar todos los empleados a un archivo');
	writeln('6: Exportar empleados sin DNI');
	writeln('7: Dar de baja un empleado');
	
	writeln('Ingrese la opcion');
	readln(opcion);
	
	case opcion of 
      //Ejercicio 3
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

		//Ejercicio 4
		3: agregarEmpleado(empleados);
		4: modificar(empleados);
		5: exportarTodos(empleados,todosEmpleados);
        6: exportarSinDNI(empleados,sindni);
        
        //Practica 3, ejericicio 1
        7: bajaFisica(empleados);
	end;
end.


