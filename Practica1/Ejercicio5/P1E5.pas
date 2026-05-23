{5. Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados
desde un archivo de texto denominado “celulares.txt”. Los registros correspondientes a
los celulares deben contener: código de celular, nombre, descripción, marca, precio,
stock mínimo y stock disponible. El formato del archivo de texto de carga se especifica en
la NOTA 2 ubicada al final del ejercicio.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock
mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de
caracteres proporcionada por el usuario.
d. Exportar el archivo binario creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado podría ser
utilizado en un futuro como archivo de carga (ver inciso a), por lo que debería respetar el
formato dado para este tipo de archivos en la NOTA 2.
}

program P1E5;
type
    registro=record
      cod:integer;
      nombre:string [30];
      descripcion:string[30];
      marca:string[30];
      precio:real;
      stockMinimo:integer;
      stockDisponible:integer;
    end;

    archivo=file of registro;

//A
procedure crearArchivo(var celulares:archivo; var carga:Text);
var
   r:registro;
begin
     reset(carga);
     rewrite(celulares);

     while(not eof(carga))do
     begin
          readln(carga,r.cod,r.precio,r.marca);
          readln(carga,r.stockDisponible,r.stockMinimo,r.descripcion);
          readln(carga,r.nombre);
          write(celulares,r);
     end;
     writeln('Archivo cargado');
     close(carga);
     close(celulares);
end;

procedure imprimirCelular(d:registro);
begin
     writeln('Codigo: ',d.cod,'. Descripcion: ',d.descripcion,'. Marca: ',d.marca,
                      '. Precio: ',d.precio:0:2,'. Stock Minimo: ',d.stockMinimo,'. Stock Disponible: ',d.stockDisponible);
end;

procedure listarMenores(var celulares:archivo);
var
   dato:registro;
begin
     reset(celulares);
     writeln('Celulares con stock menor al minimo:');
     while(not eof(celulares))do
     begin
          read(celulares,dato);
          if(dato.stockDisponible < dato.stockMinimo)then
                  imprimirCelular(dato);
     end;
     close(celulares);
end;

procedure listarDescripcion(var celulares:archivo);
var
   r:registro;
   desc:string[30];
begin
     reset(celulares);
     writeln('Ingrese la descripcion a buscar');
     readln(desc);
     while(not eof(celulares))do
     begin
          read(celulares,r);
          if(r.descripcion= desc)then
             imprimirCelular(r);
     end;
     close(celulares);
end;

procedure exportarTexto(var celulares:archivo;var carga:Text);
var
   r:registro;
begin
     reset(celulares);
     rewrite(carga);

     while(not eof(celulares))do
     begin
          read(celulares,r);
          write(carga,r.cod,' ',r.precio,' ',r.marca);
          write(carga,r.stockDisponible,' ',r.stockMinimo,' ',r.descripcion);
          write(carga,r.nombre);
     end;
     close(celulares);
     close(carga);
end;

var
   celulares:archivo;
   carga: Text;
   nombreBinario: string[30];
   opcion:integer;
begin
     writeln('Ingrese el nombre del archivo de celulares:');
     readln(nombreBinario);

     assign(celulares,nombreBinario);
     assign(carga,'celulares.txt');

     writeln('1. Crear archivo binario.');
     writeln('2. Listar los datos de los celulares con stock menor al minimo.');
     writeln('3. Listar celulares con descripcion igual a una cadena de caracteres.');
     writeln('4. Exportar texto a otro archivo');

     writeln('Ingrese la opcion seleccionada');
     readln(opcion);

     case opcion of
          1: crearArchivo(celulares,carga);
          2: listarMenores(celulares);
          3: listarDescripcion(celulares);
          4: exportarTexto(celulares, carga);
     end;
end.

