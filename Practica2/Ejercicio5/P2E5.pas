{
   5. Suponga que trabaja en una oficina donde se encuentra instalada una red local (LAN). La misma está
conformada por 5 máquinas conectadas entre sí y a un servidor central.
Semanalmente, cada máquina genera un archivo detalle de logs que registra las sesiones abiertas por los
usuarios en cada terminal, junto con su duración. Cada archivo contiene los siguientes campos: código de
usuario, fecha y tiempo de sesión.
Se solicita desarrollar un procedimiento que reciba los archivos detalle y genere un archivo maestro con la
siguiente información: código de usuario, fecha y tiempo total de sesiones abiertas.
Notas:
● Cada archivo detalle está ordenado por código de usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día, ya sea en la misma máquina o en
diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
   
   
}

program P2E5;
const valorCorte=9999;
type	
	rango=1..5;
	sesion=record
		usuario: integer;
		fecha:string[8];
		tiempo:real;
	end;
	
	archivo=file of sesion;
	
	vectorDetalles=array[rango] of archivo;
	vectorDatos=array[rango] of sesion;

procedure crearDetalles(var detalles:vectorDetalles);

	procedure crearDetalle(var detalle: archivo);
	
		procedure leerSesion(var s:sesion);
		begin
			writeln('Ingrese el codigo de usuario');
			readln(s.usuario);
			if(s.usuario<>valorcorte)then
			begin
				writeln('Ingrese la fecha de la sesion');
				readln(s.fecha);
				writeln('Ingrese el tiempo de sesion');
				readln(s.tiempo);
			end;
		end;
	
	var
		s:sesion;
	begin	
		rewrite(detalle);
		leerSesion(s);
		while(s.usuario<>valorCorte)do
		begin
			write(detalle,s);
			leerSesion(s);
		end;
		close(detalle);
	end;

var
	i:rango;
begin
	for i:=1 to 5 do
	begin
		writeln('Detalle ',i);
		crearDetalle(detalles[i]);
	end;
end;

procedure imprimir(s:sesion);
begin
	writeln('Usuario: ',s.usuario,'. Fecha: ',s.fecha,'. Tiempo de sesion: ',s.tiempo:0:2);
end;

procedure imprimirDetalles(var detalles:vectorDetalles);
var
	i:rango;
	s:sesion;
begin
	for i:=1 to 5 do
	begin
		writeln('Detalle numero ',i);
		reset(detalles[i]);
		while(not eof(detalles[i]))do
		begin
			read(detalles[i],s);
			imprimir(s);
		end;
		close(detalles[i]);
	end;
end;

procedure crearMaestro(var maestro:archivo;var detalles:vectorDetalles);

	procedure leer(var detalle:archivo;var dato:sesion);
	begin
		if(not eof(detalle))then
			read(detalle,dato)
		else
			dato.usuario:=valorCorte;
	end;
	
	procedure minimo(var detalles:vectorDetalles; var dato:vectorDatos; var min:sesion);
	var
		i,pos:rango;
	begin
		min.usuario:=valorCorte;
		min.fecha:='zzz';
		for i:=1 to 5 do
		begin
			if((dato[i].usuario<min.usuario) or ((dato[i].usuario=min.usuario) and (dato[i].fecha<min.fecha)))then begin
				min:=dato[i];
				pos:=i;
			end;
		end;
		writeln(pos);
		if(min.usuario<>valorCorte)then
			leer(detalles[pos],dato[pos]);
	end;

var
	datos:vectorDatos;
	aux,min:sesion;
	i:rango;
begin
	rewrite(maestro);
	for i:=1 to 5 do
	begin
		reset(detalles[i]);
		leer(detalles[i],datos[i]);
	end;
	minimo(detalles,datos,min);
	
	while(min.usuario<>valorCorte)do 
	begin
		aux.usuario:=min.usuario;
		while(aux.usuario=min.usuario)do
		begin
			aux.fecha:=min.fecha;
			aux.tiempo:=0;
			while((aux.usuario = min.usuario)and(aux.fecha =min.fecha))do
			begin
				aux.tiempo+=min.tiempo;
				minimo(detalles,datos,min);
				writeln(min.usuario);
				writeln(min.fecha);
			end;
			write(maestro,aux);
		end;
	end;
	
	for i:=1 to 5 do
		close(detalles[i]);
	close(maestro);
end;
		
procedure imprimirMaestro(var maestro:archivo);
var	s:sesion;
begin
	reset(maestro);
	while(not eof(maestro))do
	begin
		read(maestro,s);
		imprimir(s);
	end;
	close(maestro);
end;		
		
var
	maestro:archivo;
	detalles:vectorDetalles;
	i:rango;
	pos:string[1];
	opcion:integer;
begin
	//assign(maestro,C:\Users\alfar\OneDrive\Escritorio\Facultad\2. Segundo Año\Fundamentos de organización de datos\Prácticas\Practica2\var\log\Ej5Maestro);
	assign(maestro,'Ej5Maestro');
	for i:=1 to 5 do
	begin
		str(i,pos);
		assign(detalles[i],'Ej5Detalle'+pos);
	end;
	
	writeln('1. Crear detalles');
	writeln('2. Crear maestro');
	writeln('3. Imprimir detalles');
	writeln('4. Imprimir maestro');
	
	writeln('Ingrese una opcion');
	readln(opcion);
	case opcion of
		1: crearDetalles(detalles);
		2: crearMaestro(maestro,detalles);
		3: imprimirDetalles(detalles);
		4: imprimirMaestro(maestro);
	end;
	
end.
