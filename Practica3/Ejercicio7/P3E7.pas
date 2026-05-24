{
   Se cuenta con un archivo con información de las diferentes distribuciones de linux existentes. De
cada distribución se conoce: nombre, año de lanzamiento, número de versión del kernel, cantidad
de desarrolladores y descripción. El nombre de las distribuciones no puede repetirse. Este archivo
debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización de espacio libre
llamada lista invertida. Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. BuscarDistribucion: módulo que recibe por parámetro el archivo, un nombre de
distribución y devuelve la posición dentro del archivo donde se encuentra el registro
correspondiente a la distribución dada (si existe) o devuelve -1 en caso de que no
exista..
b. AltaDistribucion: módulo que recibe como parámetro el archivo y el registro que
contiene los datos de una nueva distribución, y se encarga de agregar la distribución al
archivo reutilizando espacio disponible en caso de que exista. El control de unicidad lo
debe realizar utilizando el módulo anterior. En caso de que la distribución que se quiere
agregar ya exista se debe informar “ya existe la distribución”.
c. BajaDistribucion: módulo que recibe como parámetro el archivo y el nombre de una
distribución, y se encarga de dar de baja lógicamente la distribución dada. Para marcar
una distribución como borrada se debe utilizar el campo cantidad de desarrolladores
para mantener actualizada la lista invertida. Para verificar que la distribución a borrar
exista debe utilizar el módulo BuscarDistribucion. En caso de no existir se debe informar
“Distribución no existente”.
   
}


program P3E7;
const	valorAlto='ZZZ';
type 
	distribucion=record
		nombre:string[45];
		lanzamiento:integer;
		kernel:string[20];
		desarrolladores:integer;
		descripcion:string[50];
	end;
	
	tipoArchivo=file of distribucion;
	
procedure leerDistro(var distro:distribucion);
begin
	writeln('Nombre');
	readln(distro.nombre);
	if(distro.nombre<>valorAlto)then
	begin
		writeln('Anio de lanzamiento');
		readln(distro.lanzamiento);
		writeln('Version de kernel');
		readln(distro.kernel);
		writeln('Cantidad de desarrolladores');
		readln(distro.desarrolladores);
		writeln('Descripcion');
		readln(distro.descripcion);
	end;
end;

procedure imprimirArchivo(var archivo:tipoArchivo);
var
	distro:distribucion;
begin
	reset(archivo);
	while(not eof(archivo))do
	begin
		read(archivo,distro);
		writeln('Nombre: ',distro.nombre,'. Anio de lanzamiento: ',distro.lanzamiento,'. Version de kernel: ',distro.kernel,
			'. Cantidad de desarrolladores: ',distro.desarrolladores,'. Descripcion: ',distro.descripcion);
	end;
	close(archivo);
end;
	
procedure crearArchivo(var archivo:tipoArchivo);
var
	distro:distribucion;
begin
	rewrite(archivo);
	distro.desarrolladores:=0;
	write(archivo,distro);
	leerDistro(distro);
	while(distro.nombre<>valorAlto)do
	begin
		write(archivo,distro);
		leerDistro(distro);		
	end;
	close(archivo);
end;	

procedure leer(var archivo:tipoArchivo; var dato:distribucion);
begin
	if(not eof(archivo))then
		read(archivo,dato)
	else
		dato.nombre:=valorAlto;
end;

function buscarDistribucion(var archivo:tipoArchivo; nombre:string):integer;
var
	distro:distribucion;
begin
	reset(archivo);
	leer(archivo,distro);
	leer(archivo,distro);
	while((distro.nombre<>valorAlto) and (distro.nombre<>nombre))do
	begin
		leer(archivo,distro);
	end;
	if(distro.nombre=nombre)then
		buscarDistribucion:=filepos(archivo)-1
	else
		buscarDistribucion:=-1;
	close(archivo);
end;

procedure alta(var archivo:tipoArchivo; nuevaDistro:distribucion);
var
	cabecera:distribucion;
begin
	if(buscarDistribucion(archivo,nuevaDistro.nombre)<>-1)then
		writeln('Ya existe la distribucion')
	else
	begin
		reset(archivo);
		leer(archivo,cabecera);
		if(cabecera.desarrolladores=0)then
		begin
			seek(archivo,filesize(archivo));
			write(archivo,nuevaDistro);
		end
		else
		begin
			seek(archivo,cabecera.desarrolladores*-1);
			read(archivo,cabecera);
			seek(archivo,filepos(archivo)-1);
			write(archivo,nuevaDistro);
			seek(archivo,0);
			write(archivo,cabecera);
		end;
		close(archivo);
	end;
end;

procedure baja(var archivo:tipoArchivo; nombre:string);
var
	pos:integer;
	cabecera:distribucion;
begin
	pos:=buscarDistribucion(archivo,nombre);
	if(pos = -1)then
		writeln('Distribucion no existente')
	else
	begin
		reset(archivo);
		leer(archivo,cabecera);				//leer cual es la ultima posicion borrada
		seek(archivo,pos);					//voy a la posicion que quiero borrar
		write(archivo,cabecera);			//guardo la posicion del proximo, el valor actual de la cabecera
		seek(archivo,0);					//vuelvo a la cabecera
		cabecera.desarrolladores:=pos*-1;	
		write(archivo,cabecera);			//actualizo la ultima posicion 
		close(archivo);			
	end;
end;
	
var
	archivo:tipoArchivo;
	opcion:integer;
	distro:distribucion;
begin
	assign(archivo,'DistribucionesLinux');
{
	crearArchivo(archivo);
	imprimirArchivo(archivo);
}
	writeln('1: buscar distribucion');
	writeln('2: alta');
	writeln('3: baja');
	
	writeln('Opcion:');
	readln(opcion);
	
	case opcion of 
		1: begin
			writeln('Ingrese el nombre de la distribucion a buscar');
			readln(distro.nombre);
			writeln(buscarDistribucion(archivo,distro.nombre));
		end;
		2: begin
			writeln('Ingrese los datos de la distro a agregar');
			leerDistro(distro);
			alta(archivo,distro);
			imprimirArchivo(archivo);
		end;
		3: begin
			writeln('Ingrese el nombre de la distro a dar de baja');
			readln(distro.nombre);
			baja(archivo,distro.nombre);
			imprimirArchivo(archivo);
		   end;
	end;
		
end.
