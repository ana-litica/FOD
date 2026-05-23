{Realizar un algoritmo que cree un archivo binario de nÃºmeros enteros no ordenados y permita
incorporar datos al archivo. Los nÃºmeros son ingresados desde el teclado. La carga finaliza
cuando se ingresa el nÃºmero 30000, que no debe incorporarse al archivo. El nombre del archivo
debe ser proporcionado por el usuario desde el teclado.
}

program ejercicio1;
const   limite=30000;

var
   numeros: file of integer;
   nro: integer;
   nombreArchivo: string[25];
begin
     write('Ingrese el nombre del archivo: ');
     read(nombreArchivo);

     assign (numeros,nombreArchivo);
     rewrite(numeros);

     writeln('Ingrese un numero: ');
     readln(nro);

     while(nro<>limite)do begin
       write(numeros,nro);
       writeln('Ingrese un numero: ');
       readln(nro);
     end;
     
{
     seek(numeros,0);
     read(numeros,nro);
     while(not eof(numeros))do
     begin
		writeln(nro);
		read(numeros,nro);
     end;
}

     close(numeros);
end.

