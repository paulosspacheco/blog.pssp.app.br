# Exemplo 02

- Certamente! O segundo exemplo de uso em Turbo Vision foca em **estender o objeto da aplicação** para tornar o programa mais flexível e preparado para futuras ersonalizações.
- Este programa é apresentado no **Listing 1.2: TUTOR01.PAS, an extensible application**.
- Aqui está o código:

  ```pascal

        program Tutor01;
           uses App; // APP.TPU holds application objects

          type TTutorApp = object(TApplication)  // define your application type
                           end; 

         // leaving room for future extensions
          var 
           TutorApp: TTutorApp; // declare an instance of your new type
        begin
            TutorApp.Init; // set up the application object
            TutorApp.Run;  // interact with the user
            TutorApp.Done; // dispose of the application object
        end.

  ```

**Explicação e funcionamento:**

* **`uses App;`**: Assim como no programa `Minimal`, esta linha importa a unidade `App`, que contém a definição do objeto básico da aplicação, `TApplication`.

*   **`type TTutorApp = object(TApplication) end;`**: Esta é a principal diferença em relação ao programa `Minimal`. Em vez de usar `TApplication` diretamente, uma **nova classe, `TTutorApp`, é derivada de `TApplication`**. No momento, `TTutorApp` não adiciona nenhum campo ou método novo, o que significa que se comporta exatamente como seu ancestral, `TApplication`. No entanto, esta abordagem deixa espaço para futuras extensões e personalizações.

*   **`var TutorApp: TTutorApp;`**: Uma instância da nova classe `TTutorApp` é declarada.

*   **`TutorApp.Init;`, `TutorApp.Run;`, `TutorApp.Done;`**: Estes métodos são chamados na mesma sequência que no programa `Minimal`. O construtor `Init` configura a aplicação, o método `Run` executa o loop de eventos principal, e o destruidor `Done` libera os recursos.

**Propósito e Benefícios:**

Embora o programa `Tutor01` produza a mesma interface visual que o `Minimal` (uma barra de menu em branco, uma linha de status com Alt+X para sair e uma área de trabalho sombreada), ele demonstra um conceito fundamental do Turbo Vision: **extensibilidade via programação orientada a objetos**.

Em vez de modificar diretamente o código-fonte do `TApplication` na unidade `APP.PAS`, o que poderia introduzir bugs e comprometer a fundação padrão e confiável do *framework*, o Turbo Vision incentiva a **derivação de novos tipos de objeto**. Ao derivar `TTutorApp` de `TApplication`, você pode:
*   **Adicionar novos campos e métodos**.
*   **Sobrescrever métodos existentes** do `TApplication` para alterar seu comportamento.

Esta abordagem garante que a base do *framework* permaneça intacta e confiável para todas as suas aplicações, enquanto suas personalizações são mantidas em um local conveniente e isolado, tornando seu código mais robusto e fácil de manter.