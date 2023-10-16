{: Está unit contém o algorítimo de arvore b+ balanceada criada pelo projeto chatgpt.
}

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1_CreateDataFile: TButton;
    Button2_Index_DataFile: TButton;
    Button3_Lista_DataFile: TButton;
    ListBox1: TListBox;
    procedure Button1_CreateDataFileClick(Sender: TObject);
    procedure Button2_Index_DataFileClick(Sender: TObject);
    procedure Button3_Lista_DataFileClick(Sender: TObject);

  private
    const
      //MaxRecords = 100;
      M          = 32;
      Error      : Integer = 0;
      MaxNr      = 5;

    type
      TKey = Record
        NumberRecord : Longint;
        chave : ShortString;
      end;

    const
      SpecialKey : TKey = (NumberRecord:-1;chave : '-1') ;

    Type
      TRecord = record
        NumberRecord : Longint;
        // Defina aqui a estrutura do seu registro
        Nome     : TKey;
        Endereco : String[80];
      end;

      //TIndexNode = record
      //  // Defina aqui a estrutura do nó de índice da árvore B+
      //end;

      TIndexNode = record
        Keys: array [1..M] of TKey;  // Array de chaves no nó
        NumberRecords: array [0..M] of LongInt;  // Array de ponteiros para os filhos ou registros
        NumKeys: Integer;  // Número de chaves atualmente no nó
        IsLeaf: Boolean;  // Indica se o nó é uma folha
      end;

      TIndexFile = file of TIndexNode;
      TDataFile  = file of TRecord;

    var
      DataFile  : file of TRecord;
      IndexFile : TIndexFile;
    var
      currentNode: TIndexNode;
    var
      Nr  : Longint;
      Rec : TRecord;

  public
   procedure SplitNode(splitPosition: Integer; var parentNode, newNode: TIndexNode);
   //procedure InsertInNode(nodePosition: LongInt; recordToInsert: TRecord ; var acurrentNode: TIndexNode {; var IndexFile: TIndexFile});
     procedure InsertInNode(nodePosition: LongInt; recordToInsert: TRecord ; var acurrentNode: TIndexNode {var IndexFile: TIndexFile});

   procedure InsertRecord({var DataFile: TDataFile; var IndexFile: TIndexFile;} var recordToInsert: TRecord);
   Procedure CreateDataFile;
   Function OpenDataFile:Boolean;
   Procedure CloseDataFile;
   procedure BuildIndex;
   function SearchKey(key: TKey{; var currentNode: TIndexNode}{; var IndexFile: TIndexFile}): LongInt;
   function ReadFirstKey({var IndexFile: TIndexFile}): TKey;
   function GoToLastKey({var IndexFile: TIndexFile}): TKey;
   procedure DeleteKey(key: TKey{; var currentNode: TIndexNode; var IndexFile: TIndexFile});
   function GoToNextKey(key: TKey {; var currentNode: TIndexNode; var IndexFile: TIndexFile}): TKey;
   Function EofIndexFile(var CurrentKey : TKey):Boolean;
   procedure Lista_DataFile;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


procedure TForm1.SplitNode(splitPosition: Integer; var parentNode, newNode: TIndexNode);
var
  i: Integer;
begin
  // Cria um novo nó que receberá a metade das chaves do nó original
  newNode.NumKeys := (M + 1) div 2;
  newNode.IsLeaf := parentNode.IsLeaf;

  // Copia as chaves e ponteiros para o novo nó
  for i := 1 to newNode.NumKeys do
  begin
    newNode.Keys[i] := parentNode.Keys[i + splitPosition];
    newNode.NumberRecords[i - 1] := parentNode.NumberRecords[i + splitPosition - 1];
  end;

  // Atualiza o número de chaves no nó original
  parentNode.NumKeys := (M + 1) div 2 - 1;

  // Move as chaves restantes no nó original para abrir espaço para a nova chave
  for i := splitPosition to parentNode.NumKeys do
    parentNode.Keys[i] := parentNode.Keys[i + 1];

  // Move os ponteiros restantes no nó original
  for i := splitPosition - 1 to parentNode.NumKeys do
    parentNode.NumberRecords[i] := parentNode.NumberRecords[i + 1];

  // Ajusta o ponteiro do último ponteiro do nó original para apontar para o novo nó
  parentNode.NumberRecords[parentNode.NumKeys] := FileSize(IndexFile);
end;

procedure TForm1.InsertInNode(nodePosition: LongInt; recordToInsert: TRecord ; var acurrentNode: TIndexNode {var IndexFile: TIndexFile});
var
  insertPosition, i: Integer;
begin
  // Encontra a posição correta para inserção do registro na ordem ascendente
  insertPosition := acurrentNode.NumKeys;
  while (insertPosition > 0) and (recordToInsert.Nome.chave < acurrentNode.Keys[insertPosition].Chave) do
    Dec(insertPosition);

  // Move as chaves e ponteiros maiores para abrir espaço para a nova chave
  for i := acurrentNode.NumKeys downto insertPosition + 1 do
  begin
    acurrentNode.Keys[i + 1] := acurrentNode.Keys[i];
    acurrentNode.NumberRecords[i] := acurrentNode.NumberRecords[i - 1];
  end;

  // Insere a nova chave e atualiza o número de chaves no nó
  acurrentNode.Keys[insertPosition + 1] := recordToInsert.Nome;
  acurrentNode.NumberRecords[insertPosition] := recordToInsert.NumberRecord;
  Inc(acurrentNode.NumKeys);

  // Atualiza o nó no arquivo de índice
  Seek(IndexFile, nodePosition);
  Write(IndexFile, acurrentNode);
end;


//procedure InsertRecord(var DataFile: file of TRecord; var IndexFile: TIndexFile; var recordToInsert: TRecord);
//begin
//  // Implemente aqui o código para inserir um registro na árvore B+ e no arquivo de dados
//end;
procedure TForm1.InsertRecord({var DataFile: TDataFile; var IndexFile: TIndexFile;} var recordToInsert: TRecord);
var
  rootNode: TIndexNode;
  newNode: TIndexNode;
  currentPosition: LongInt;
  i, j: Integer;
begin
  // Inicializa o ponteiro atual para a raiz
  currentPosition := FileSize(IndexFile);

  // Lê o nó raiz do arquivo de índice
  if currentPosition = 0 then
  begin
    rootNode.NumKeys := 0;
    rootNode.IsLeaf := True;
  end
  else
  begin
    Seek(IndexFile, 0);
    Read(IndexFile, rootNode);
  end;

  // Verifica se a raiz está cheia
  if rootNode.NumKeys = M then
  begin
    // Cria um novo nó para ser a nova raiz
    newNode.NumKeys := 0;
    newNode.IsLeaf := False;
    newNode.NumberRecords[0] := currentPosition;

    // Atualiza a raiz no arquivo de índice
    Seek(IndexFile, FileSize(IndexFile));
    Write(IndexFile, newNode);

    // Realiza a divisão da antiga raiz
    SplitNode(0, rootNode, newNode);

    // Atualiza o ponteiro atual para a nova raiz
    currentPosition := FileSize(IndexFile) - 1;
  end;

  // Insere o registro na árvore B+
  InsertInNode(currentPosition, recordToInsert, rootNode{, IndexFile});

  // Atualiza o nó raiz no arquivo de índice
  Seek(IndexFile, 0);
  Write(IndexFile, rootNode);
end;

Procedure TForm1.CreateDataFile;
Begin
  AssignFile(IndexFile, 'index.dat');
  System.Rewrite(IndexFile);
  System.Close(IndexFile);

  AssignFile(DataFile, 'data.dat');
  System.Rewrite(DataFile);
  with Rec do
  begin
    rec.NumberRecord:=0;
    rec.Nome.NumberRecord:=rec.NumberRecord;
    rec.Nome.chave:= 'Paulo Sérgio';
    Write(DataFile,Rec);

    rec.NumberRecord:=1;
    rec.Nome.NumberRecord:=rec.NumberRecord;
    rec.Nome.chave:= 'Antônio Leite Pacheco';
    Write(DataFile,Rec);

    rec.NumberRecord:=2;
    rec.Nome.NumberRecord:=rec.NumberRecord;
    rec.Nome.chave:= 'José Carlos';
    Write(DataFile,Rec);

    rec.NumberRecord:=3;
    rec.Nome.NumberRecord:=rec.NumberRecord;
    rec.Nome.chave:= 'Luiza Célia';
    Write(DataFile,Rec);

    rec.NumberRecord:=4;
    rec.Nome.NumberRecord:=rec.NumberRecord;
    rec.Nome.chave:= 'Paulo Henrique';
    Write(DataFile,Rec);




  end;

  System.close(DataFile);

end;

Function TForm1.OpenDataFile:Boolean;
begin

  AssignFile(DataFile, 'data.dat');
  {$I-}
  Reset(DataFile,sizeof(TRecord));
  Result := IOResult=0;
  {$I+}

  If Result then
  begin
    AssignFile(IndexFile, 'index.dat');
    {$I-}
    Reset(IndexFile,sizeof(TIndexNode));
    Result := IOResult=0;
    {$I+}
  end;

end;

Procedure TForm1.CloseDataFile;
begin
  System.Close(DataFile);
  System.Close(IndexFile);
end;

procedure TForm1.BuildIndex;
var
  recordToInsert: TRecord;
begin
  AssignFile(IndexFile, 'index.dat');
  System.Rewrite(IndexFile);
  System.Close(IndexFile);

  AssignFile(DataFile, 'data.dat');
  System.Reset(DataFile,sizeof(TRecord));

  AssignFile(IndexFile, 'index.dat');
  System.Reset(IndexFile,sizeof(TIndexNode));
  {$I-}
  seek(DataFile,0);
  {$I+}
  if IOResult = 0
  then while not EOF(DataFile) do
       begin
         Read(DataFile, recordToInsert);
         InsertRecord({DataFile, IndexFile,} recordToInsert);
       end;

  System.Close(DataFile);
  System.Close(IndexFile);
end;

function TForm1.SearchKey(key: TKey{; var currentNode: TIndexNode; var IndexFile: TIndexFile}): LongInt;
var
  i: Integer;
begin
  i := 1;

  // Percorre as chaves do nó até encontrar uma chave maior ou igual à chave buscada
  while (i <= currentNode.NumKeys) and (key.chave > currentNode.Keys[i].chave) do
    Inc(i);

  // Verifica se a chave foi encontrada no nó atual
  if (i <= currentNode.NumKeys) and (key.chave = currentNode.Keys[i].chave) then
  begin
    // Chave encontrada, retorna o ponteiro correspondente
    Result := currentNode.NumberRecords[i - 1];
  end
  else if currentNode.IsLeaf then
  begin
    // Se o nó atual é uma folha e a chave não foi encontrada, retorna -1 para indicar que a chave não existe
    Result := -1;
  end
  else
  begin
    // Se o nó atual não é uma folha, faz a leitura do próximo nó para continuar a busca recursivamente
    Seek(IndexFile, currentNode.NumberRecords[i - 1]);
    Read(IndexFile, currentNode);
    Result := SearchKey(key {, currentNode, IndexFile});
  end;

end;

function TForm1.ReadFirstKey({var IndexFile: TIndexFile}): TKey;
var
  rootNode: TIndexNode;
begin
  Seek(IndexFile, 0);
  Read(IndexFile, rootNode);

  while not rootNode.IsLeaf do
  begin
    Seek(IndexFile, rootNode.NumberRecords[0]);
    Read(IndexFile, rootNode);
  end;

  Result := rootNode.Keys[1];
end;

function TForm1.GoToLastKey({var IndexFile: TIndexFile}): TKey;
begin
  Seek(IndexFile, 0);
  Read(IndexFile, currentNode);

  while not currentNode.IsLeaf do
  begin
    Seek(IndexFile, currentNode.NumberRecords[currentNode.NumKeys]);
    Read(IndexFile, currentNode);
  end;

  Result := currentNode.Keys[currentNode.NumKeys];
end;

procedure TForm1.DeleteKey(key: TKey{; var currentNode: TIndexNode; var IndexFile: TIndexFile});
var
  i, j: Integer;
begin
  // Encontra a posição da chave a ser deletada no nó atual
  i := 1;
  while (i <= currentNode.NumKeys) and (key.chave > currentNode.Keys[i].chave) do
    Inc(i);

  // Se a chave foi encontrada no nó atual
  if (i <= currentNode.NumKeys) and (key.chave = currentNode.Keys[i].chave) then
  begin
    // Remove a chave e ajusta os ponteiros e chaves subsequentes
    for j := i to currentNode.NumKeys - 1 do
    begin
      currentNode.Keys[j] := currentNode.Keys[j + 1];
      currentNode.NumberRecords[j] := currentNode.NumberRecords[j + 1];
    end;
    Dec(currentNode.NumKeys);

    // Atualiza o nó no arquivo de índice
    Seek(IndexFile, FilePos(IndexFile) - 1);
    Write(IndexFile, currentNode);
  end
  else if not currentNode.IsLeaf then
  begin
    // Se a chave não foi encontrada e o nó não é uma folha, continua a busca recursivamente no próximo nó
    Seek(IndexFile, currentNode.NumberRecords[i - 1]);
    Read(IndexFile, currentNode);
    DeleteKey(key{, currentNode, IndexFile});
  end;
end;

function TForm1.GoToNextKey(key: TKey {; var currentNode: TIndexNode; var IndexFile: TIndexFile}): TKey;
var
  i: Integer;
begin
  i := 1;

  // Percorre as chaves do nó até encontrar uma chave maior que a chave atual
  while (i <= currentNode.NumKeys) and (key.chave >= currentNode.Keys[i].chave) do
    Inc(i);

  if i <= currentNode.NumKeys then
  begin
    // Se há uma chave maior no nó atual, retorna essa chave
    Result := currentNode.Keys[i];
  end
  else if not currentNode.IsLeaf then
  begin
    // Se o nó atual não é uma folha, continua a busca recursivamente no próximo nó
    Seek(IndexFile, currentNode.NumberRecords[i - 1]);
    Read(IndexFile, currentNode);
    Result := GoToNextKey(key{, currentNode, IndexFile});
  end
  else
  begin
    // Se o nó atual é uma folha e não há chaves maiores, retorna um valor
    // especial para indicar que não há próxima chave
    Result := SpecialKey; // Defina o valor especial desejado
  end;
end;

Function TForm1.EofIndexFile(var CurrentKey : TKey):Boolean;
begin
  result := CurrentKey.chave = SpecialKey.chave;
end;

procedure TForm1.Lista_DataFile;
  var
    CurrentKey : TKey;
    LastKey : TKey;
    S : String;

begin
  if OpenDataFile then
  begin
    ListBox1.Clear;
    LastKey    := GoToLastKey{(IndexFile)};
    CurrentKey := ReadFirstKey{(IndexFile)};


   //Lista todos os registro em ordem crescente da chave
   while not eofIndexFile(CurrentKey) do
   begin
     {$I-}
     Seek(DataFile, CurrentKey.NumberRecord);
     Error := IOResult;
     {$I+}
     If Error=0
     then begin
            {$I-}
            Read(DataFile, Rec);
            Error := IOResult;
            {$I+}
            If Error=0
            then begin
//                   WriteLn('Chave: ',Rec.Nome.chave:6,' NumberRecord',Rec.NumberRecord:6,' Endereco: ',REc.Endereco);
                   s:='Chave: '+Rec.Nome.chave+' NumberRecord: '+IntToStr(Rec.NumberRecord)+' Endereco: '+REc.Endereco;
                   ListBox1.AddItem(s,nil);
                   CurrentKey := GoToNextKey(CurrentKey);//,currentNode,IndexFile});

                 end;
     end;
   end;

   CloseDataFile;
  end;
end;


{ TForm1 }

procedure TForm1.Button1_CreateDataFileClick(Sender: TObject);
begin

  CreateDataFile;
end;

procedure TForm1.Button2_Index_DataFileClick(Sender: TObject);
begin
  BuildIndex;
end;

procedure TForm1.Button3_Lista_DataFileClick(Sender: TObject);
begin
  Lista_DataFile;
end;


end.


