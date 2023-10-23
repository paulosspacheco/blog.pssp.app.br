program tipuesearch;

{$mode objfpc}{$H+}

uses
  SysUtils,
  fpwebfile,
  fphttpapp, u_TipueSearch;

  var err:integer;
begin

  Application.Title:='tipuesearch';
  Application.Port:=8080;
  Application.Initialize;

  writeLn('Criando arquivo: "./tipuesearch_content.js"...');
  Err:=CrateIndexTipuesearch;
  if Err <>0
  Then WriteLn('Error: ',Inttostr(Err))
  else begin
         writeLn('Criado arquivo: "./tipuesearch_content.js".');
       end;

  //Application.Run;
end.

