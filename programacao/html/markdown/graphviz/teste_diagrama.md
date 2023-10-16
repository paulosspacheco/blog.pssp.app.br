# teste diagrama 

- Crie diagramas em markdown usando graphvizblocos de código:

    ```graphviz

    digraph finite_state_machine {
        rankdir=LR;
        size="8,5"

        node [shape = doublecircle]; S;
        node [shape = point ]; qi

        node [shape = circle];
        qi -> S;
        S  -> q1 [ label = "a" ];
        S  -> S  [ label = "a" ];
        q1 -> S  [ label = "a" ];
        q1 -> q2 [ label = "ddb" ];
        q2 -> q1 [ label = "b" ];
        q2 -> q2 [ label = "b" ];
    }

    ```

- Exemplo 02

    ```graphviz

        strict graph { 
        
        a -- b
        a -- b
        b -- a [color=blue]
        
        } 


    ```

- Exemplo 03

    ```graphviz

        digraph G {
                node [ style=filled, color=yellow ]
                { A,B,C} -> {D,E,F}
        }

    ```
