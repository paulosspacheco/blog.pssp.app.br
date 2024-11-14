# Notas de versões do projeto /\/\ar/\carai

## Versão v1.10-Alpha

1. Versão v1.10.1
   1. Criado método TUiDmxScroller.CalcExpression(aExpression) usado para calcular campos no template.
      1. O método é executado em:
         1. TUiDmxScroller.DoOnNewRecord();
            1. Nota
               1. O valor padrão contante tem prioridade sobre a expressão, ou seja: Caso o campo defaultConst seja <> nil então a propriedade defaultExpression não é executa.
         2. TDmxFieldRec.DoOnEnter();
            1. Nota:
               1. O campo é calculado porque pode ser que a expressão tenha uma variável que seja outros campos do dataset.
      2. Nota:
         1. O caculo usa o componente [TFPExpressionParser](https://wiki.freepascal.org/How_To_Use_TFPExpressionParser) do freepascal.
      3. 