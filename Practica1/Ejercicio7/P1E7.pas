{7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de texto. El
nombre del archivo de texto es: “novelas.txt”. La información en el archivo de texto
consiste en: código de novela, nombre, género y precio de diferentes novelas argentinas.
Los datos de cada novela se almacenan en dos líneas en el archivo de texto. La primera
línea contendrá la siguiente información: código novela, precio y género, y la segunda
línea almacenará el nombre de la novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una
novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program P1E7;
type
    registro=record
      cod:integer;
      nombre:string[30];
      precio:real;
      genero:string[30];
    end;

    archivo=file of registro;

procedure cargarArchivo(var novelas:archivo);
var
   carga:Text;
   r:registro;
begin
     assign(carga,'novelas.txt');
     reset(carga);
     rewrite(novelas);

     while(not eof(carga))do
     begin
          readln(carga,r.cod,r.precio,r.genero);
          readln(carga,r.nombre);
          write(novelas,r);
     end;
     writeln('Se cargó el archivo');
     close(carga);
     close(novelas);
end;

procedure leerNovela(var libro:registro);
begin
	writeln('Codigo de novela');
	readln(libro.cod);
	writeln('Nombre de la novela');
	readln(libro.nombre);
	writeln('Precio de la novela ');
	readln(libro.precio);
	writeln('Genero de la novela');
	readln(libro.genero);
end;

procedure agregarNovela(var novelas:archivo);
var
	libro:registro;
begin
	reset(novelas);
	leerNovela(libro);
	seek(novelas,filesize(novelas));
	write(novelas,libro);
	close(novelas);
end;

procedure modificarNovela(var novelas:archivo);
var
	libro,reg: registro;
begin
	reset(novelas);
	leerNovela(libro);
	read(novelas,reg);
	while((not eof(novelas))and(reg.cod=libro.cod))do
	begin
		read(novelas,reg);
	end;
	
	if(reg.cod=libro.cod)then
	begin
		seek(novelas,filepos(novelas)-1);
		write(novelas,libro);
	end;
	
	close(novelas);
end;

procedure imprimirNovelas(var novelas:archivo);
var
	libro:registro;
begin
	reset(novelas);
	read(novelas,libro);
	while(not eof(novelas))do
	begin
		writeln('Codigo: ',libro.cod,'. Nombre: ',libro.nombre,'. Precio: ',libro.precio:0:2,'. Genero:',libro.genero);
		read(novelas,libro);
		
	end;
	close(novelas);
end;

var
   novelas:archivo;
   nombreFisico:String[30];
   opcion:integer;
begin
     writeln('Ingrese el nombre del archivo:');
     readln(nombreFisico);
     assign(novelas,nombreFisico);
     
     writeln('1. Crear archivo binario');
     writeln('2. Agregar novelas');
     writeln('3. Modificar novela');
     writeln('4. Imprimir novela');

	writeln('Ingrese una opción');
	readln(opcion);
	case opcion of 
		1:cargarArchivo(novelas);
		2:agregarNovela(novelas);
		3:modificarNovela(novelas);
		4:imprimirNovelas(novelas);
	end;
end.

