O primeiro exemplo de uso de uma aplicação Turbo Vision é a construção do programa mais simples possível, que consiste em uma instância do objeto base da aplicação, **TApplication**.

Este programa mínimo é apresentado no **Listing 1.1: The simplest Turbo Vision program**.

Aqui está o código:

```
program Minimal;
uses App;
var MyApp: TApplication;
begin
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.
```

**Explicação e funcionamento:**
*   **`uses App;`**: A definição do objeto básico da aplicação (`TApplication`) está contida na unidade `App`. Embora este programa utilize diretamente apenas esta unidade, `App` por si só faz uso de várias outras unidades do Turbo Vision.
*   **`var MyApp: TApplication;`**: Declara uma variável `MyApp` do tipo `TApplication`. No mundo orientado a objetos do Turbo Vision, até a sua aplicação é um objeto.
*   **`MyApp.Init;`**: O construtor da aplicação (`Init`) configura as vistas da aplicação e inicializa os subsistemas da aplicação, incluindo os *drivers* de mouse e vídeo, o gerenciador de memória e o manipulador de erros.
*   **`MyApp.Run;`**: O método `Run` executa a aplicação chamando o método `Execute` (que `TProgram` herdou de `TGroup`).
*   **`MyApp.Done;`**: O destruidor `Done` descarta o objeto da aplicação, primeiro chamando o destruidor `Done` herdado de `TProgram` e depois desligando todos os subsistemas do Turbo Vision.

Ao executar este programa, você verá uma tela com uma **barra de menu em branco na parte superior**, uma **linha de status na parte inferior** que indica a disponibilidade da tecla de atalho Alt+X para sair do programa, e uma **área de trabalho sombreada** entre eles. O que você vê é apenas o **esqueleto de uma aplicação real**, que já possui funções para lidar com a maioria dos elementos que você adicionar.