        //  5. Exemplo javascript para contar o tamanho de cada string de um array:
        //     1. Código javascript:

        //        ```javascript

                  const materials = ['Hydrogen','Helium','Lithium','Beryllium'];

                  /**
                   *  Array.prototype.map()
                   *  Cria uma nova matriz com os resultados da chamada de uma
                   *  função fornecida em cada elemento desta matriz.
                   *  EXEMPLO DE USO:
                   */
                  result = materials.map(material => material.length);
                  console.log(result);
                  // expected output: Array [8, 6, 7, 9]

            //    ```
