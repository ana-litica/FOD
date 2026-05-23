{
3. A partir de información sobre la alfabetización en la Argentina, se desea actualizar un archivo maestro
que contiene los siguientes datos: nombre de la provincia, cantidad de personas alfabetizadas y total de
encuestados.
Para ello, se dispone de dos archivos detalle, provenientes de distintas agencias de censo. Cada uno de
estos archivos contiene: nombre de la provincia, código de localidad, cantidad de personas alfabetizadas
y cantidad de encuestados.
Se solicita desarrollar los módulos necesarios para actualizar el archivo maestro a partir de la
información contenida en ambos archivos detalle.
Nota: Todos los archivos están ordenados por nombre de provincia. En los archivos detalle pueden
existir cero, uno o más registros por cada provincia.  
}

program P2E3;
const valorCorte='ZZZ';
type
	registroMaestro=record
		provincia:string[50];
		alfabetizados:integer;
		encuestados:integer;
	end;
	
	registroDetalle=record
		provincia:string[50];
		localidad:integer;
		alfabetizados:integer;
		encuestados:integer;
	end;
	
	archivoMaestro=file of registroMaestro;
	archivoDetalle=file of registroDetalle;

procedure crearMaestro(var maestro: archivoMaestro);

	procedure leerDatoMaestro(var dato:registroMaestro);
	begin
		writeln('Provincia:');
		readln(dato.provincia);
		if(dato.provincia<>valorCorte)then
		begin
			writeln('Cantidad de alfabetizados:');
			readln(dato.alfabetizados);
			writeln('Cantidad de encuestados:');
			readln(dato.encuestados);
		end;
	end;

var
	dato:registroMaestro;
begin
	rewrite(maestro);
	
	leerDatoMaestro(dato);
	while(dato.provincia<>valorCorte)do
	begin
		write(maestro,dato);
		leerDatoMaestro(dato);
	end;
	
	close(maestro);
end;

procedure crearDetalle(var detalle:archivoDetalle);

	procedure leerDatoDetalle(var dato:registroDetalle);
	begin
		writeln('Provincia:');
		readln(dato.provincia);
		if(dato.provincia<>valorCorte)then
		begin
			writeln('Codigo de localidad:');
			readln(dato.localidad);
			writeln('Cantidad de alfabetizados:');
			readln(dato.alfabetizados);
			writeln('Cantidad de encuestados:');
			readln(dato.encuestados);
		end;
	end;

var
	dato:registroDetalle;
begin
	rewrite(detalle);
	
	leerDatoDetalle(dato);
	while(dato.provincia<>valorcorte)do
	begin
		write(detalle,dato);
		leerDatoDetalle(dato);
	end;
	
	close(detalle);
end;

procedure imprimirMaestro(var maestro:archivoMaestro);
var
	dato:registroMaestro;
begin
	reset(maestro);
	
	while(not eof(maestro))do
	begin
		read(maestro,dato);
		writeln('Provincia: ',dato.provincia,'. Personas alfabetizadas: ',dato.alfabetizados,
			'. Personas encuestadas: ',dato.encuestados);
	end;
	close(maestro);
end;
	
procedure imprimirDetalle(var detalle:archivoDetalle);
var
	dato:registroDetalle;
begin
	reset(detalle);
	
	while(not eof(detalle))do
	begin
		read(detalle,dato);
		writeln('Provincia: ',dato.provincia,'. Codigo de localidad: ',dato.localidad,'. Personas alfabetizadas: ',dato.alfabetizados,
			'. Personas encuestadas: ',dato.encuestados);
	end;
	close(detalle);
end;

procedure actualizarMaestro(var maestro:archivoMaestro;var detalle1:archivoDetalle;var detalle2:archivoDetalle);

	procedure leer(var archivo:archivoDetalle;var dato:registroDetalle);
	begin
		if(not eof(archivo))then
			read(archivo,dato)
		else
			dato.provincia:=valorcorte;
	end;
	
	procedure minimo(var detalle1,detalle2:archivoDetalle;var dato1,dato2,min:registroDetalle);
	begin
		if(dato1.provincia<dato2.provincia)then
		begin
			min:=dato1;
			leer(detalle1,dato1);
		end
		else begin
			min:=dato2;
			leer(detalle2,dato2);
		end;
	end;

var
	min,regDet1,regDet2:registroDetalle;
	regMaestro:registroMaestro;
	alf,enc:integer;
	actual:string[50];
begin
	reset(maestro);
	reset(detalle1);	
	reset(detalle2);

	
	leer(detalle1,regDet1);
	leer(detalle2,regDet2);
	minimo(detalle1,detalle2,regDet1,regDet2,min);

	while(min.provincia<>valorCorte)do
	begin
		actual:=min.provincia;
		alf:=0;
		enc:=0;
		
		read(maestro,regMaestro);
		while((not eof(maestro)) and(regMaestro.provincia<>actual))do
			read(maestro,regMaestro);
		
		while(actual=min.provincia)do
		begin
			alf+=min.alfabetizados;
			enc+=min.encuestados;
			minimo(detalle1,detalle2,regDet1,regDet2,min);
		end;
		
		{while((not eof(maestro)) and(regMaestro.provincia<>actual))do
			read(maestro,regMaestro);}
			
		regMaestro.alfabetizados+=alf;
		regMaestro.encuestados+=enc;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regMaestro);
		
		{if(not eof(maestro))then
			read(maestro,regMaestro);}
	end;
	
	
	close(detalle1);
	close(detalle2);
	close(maestro);
end;

var
	maestro:archivoMaestro;
	detalle1,detalle2:archivoDetalle;
	opcion: integer;
begin
	assign(maestro,'Ej3Maestro');
	assign(detalle1,'Ej3Detalle1');
	assign(detalle2,'Ej3Detalle2');
	
	writeln('1. Crear archivo maestro.');
	writeln('2. Crear primer archivo detalle');
	writeln('3. Crear segundo archivo detalle');
	writeln('4. Actualizar maestro');
	writeln('5. Imprimir maestro');
	writeln('6. Imprimir detalle 1');
	writeln('7. Imprimir detalle 2');
	
	writeln('Ingrese una opcion:');
	readln(opcion);
	
	case opcion of
		1: crearMaestro(maestro);
		2: crearDetalle(detalle1);
		3: crearDetalle(detalle2);
		4: actualizarMaestro(maestro,detalle1,detalle2);
		5: imprimirMaestro(maestro);
		6: imprimirDetalle(detalle1);
		7: imprimirDetalle(detalle2);
	end;
end.
