CREATE TABLE parametros (
        id int,
        empresa VARCHAR(60),
        dataAtual DATE );
   
INSERT INTO parametros (id, empresa, dataAtual)
VALUES (
    '1',
    'Itms Sitemas e Consultoria Ltda',
    STR_TO_DATE('08,1,2021','%d,%m,%Y')
  );
  INSERT INTO parametros (id, empresa, dataAtual)
