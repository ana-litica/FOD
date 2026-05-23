{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”,
con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

program P1E6;
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
                      '. Precio: ',d.precio,'. Stock Minimo: ',d.stockMinimo,'. Stock Disponible: ',d.stockDisponible);
end;
//B
procedure listarMenores(var celulares:archivo);
var
   dato:registro;
begin
     reset(celulares);
     while(not eof(celulares))do
     begin
          read(celulares,dato);
          if(dato.stockDisponible < dato.stockMinimo)then
                  imprimirCelular(dato);
     end;
     close(celulares);
end;
//C
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
          writeln(r.descripcion);
          if(r.descripcion= desc)then
             imprimirCelular(r);
             
     end;
     close(celulares);
end;
//D
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

//6A
procedure leerCelular(var r:registro);
begin
     writeln('Ingrese el codigo del celular');
     readln(r.cod);
     writeln('Ingrese el nombre del celular');
     readln(r.nombre);
     writeln('Ingrese la descripcion del celular');
     readln(r.descripcion);
     writeln('Ingrese la marca del celular');
     readln(r.marca);
     writeln('Ingrese el precio del celular');
     readln(r.precio);
     writeln('Ingrese el stock minimo');
     readln(r.stockMinimo);
     writeln('Ingrese el stock disponible');
     readln(r.stockDisponible);
end;

procedure agregarCelulares(var celulares:archivo);
var
   celu:registro;
begin
     reset(celulares);
     writeln('Ingrese el celular a agregar');
     leerCelular(celu);
     seek(celulares,filepos(celulares));
     while(celu.nombre<>'')do
     begin
          write(celulares,celu);
          read(celulares,celu);
     end;
     close(celulares);
end;

//6B
procedure modificarStock(var celulares:archivo);
var
   celu,dato:registro;
begin
     reset(celulares);
     writeln('Ingrese el celular');
     leerCelular(celu);
     read(celulares,dato);
     while((not eof(celulares)) and (celu.nombre<>dato.nombre))do
     begin
          writeln('Ingrese el celular');
          read(celulares,dato);
     end;
     if(celu.nombre=dato.nombre)then
     begin
          seek(celulares,filepos(celulares)-1);
          write(celulares,celu);
     end;
     close(celulares);
end;

procedure exportarSinStock(var celulares:archivo;var sinStock:Text);
var
   r:registro;
begin
     assign(sinStock,'SinStock.txt');

     rewrite(sinStock);
     reset(celulares);
     while(not eof(celulares))do
     begin
          read(celulares,r);
          if(r.stockDisponible=0)then
          begin
               write(sinStock, r.cod,' ',r.precio,' ',r.marca);
               write(sinStock,r.stockDisponible,' ',r.stockMinimo,' ',r.descripcion);
               write(sinStock,r.nombre);
          end;
     end;
     close(sinStock);
     close(celulares);
end;

var
   celulares:archivo;
   carga,sinStock: Text;
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
     writeln('5. Aniadir mas celulares');
     writeln('6. Modificar stock de un celular');
     writeln('7. Exportar exportar informacion de los celulares sin stock');

     writeln('Ingrese la opcion seleccionada');
     readln(opcion);

     case opcion of
          1: crearArchivo(celulares,carga);   //5A
          2: listarMenores(celulares);        //5B
          3: listarDescripcion(celulares);    //5C
          4: exportarTexto(celulares, carga); //5D
          5: agregarCelulares(celulares);     //6A
          6: modificarStock(celulares);       //6B
          7: exportarSinStock(celulares,sinStock);     //6C
     end;
end.
