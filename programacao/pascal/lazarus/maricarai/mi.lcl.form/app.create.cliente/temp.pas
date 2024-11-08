add('"- **Descrição do formulário.**"');
add('""')
add('"- Número sequencial:"\LLLLLL'+ChFN+'id'+CharAccSkip+CharAccReadOnly+CharPfInKeyPrimary+CharPfInKeyPrimaryAutoIncrement+ChH+'Numero sequêncial');  
add('""');    
add('""');
add('"- **Dados de acesso ao serviço**:');
add('"  - Protocolo do serviço no servidor:"\');
add('""');    
add('"    - Protocol`: Nome do campo.
    - Valores Possíveis
                    1. http.
                    2. https.
    - Eventos.
    - `OnCalcFields`.
        - Calcula a URL do serviço.

- Endereço IP ou Nome do Host:
    - `Host` : Nome do campo.
    - Eventos.
    - `OnCalcFields`.
        - Calcula a URL do serviço.

- Número da porta do serviço no servidor.
    - `Port` : Nome do campo.
    - Eventos.
    - `OnCalcFields`.
        - Calcula a URL do serviço.

- Nome do recurso (`WebModule`) do servidor:
    - `WebModule` : Nome do campo.
    - Eventos.
    - `OnCalcFields`.
        - Calcula a URL do serviço.
    - Notas:
    - O nome do `webModule` deve ser passado como parâmetro ao executar o formulário `TCreateclientesForm`.

- Nome da pasta root onde se criarão as aplicações clientes:
- `PathRoot`: Nome do Campo.
- `CmLocatePathRoot` : Botão de ação para selecionar pasta.
- Tags:
    - `ChEA` : A sequência a seguir é o nome da ação. A mesma deve ser implementada no formulário LCL.
    - Exemplo de uso:
        - `ChEA`+`CmLocatePathRoot`+🔍.
- Eventos.
    - `OnEnterField`.
    - Seleciona a pasta root onde a aplicação será criada.
- Obs.: O padrão da pasta root é a pasta do executável da aplicação servidora.

- Tipo de aplicação.  
- `typApp` : Nome do campo.
    - Valores possíveis.
    1. App LCL : sim.
    2. App Javascript: não.
    3. App Dynamic_html:sim.  
    4. App VueJS: não.
    5. App AngularJS: não.
    6. App ReactJS: não.

    - Eventos:
    - `OnCalcFields`
        - Calcular o nome da pasta destino da aplicação.

- Nome da subpasta da aplicação cliente usada para gerar a aplicação.  
- `PathClient`: Nome do Campo
- Tags :
    - `CharAccReadOnly`:
    - Indica que o campo é somente para leitura.
