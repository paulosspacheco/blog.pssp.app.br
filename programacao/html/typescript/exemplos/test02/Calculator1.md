<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como instalar typescript no vscode<a href="instalar.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a><a href="instalar.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

<!-- <details>
   <summary><b>1. INDEX </b></summary> -->

   1. **Operadores aritméticos**
      1. Subtração:
         1. **(  \-  )**
      2. Soma:
         1. **(  +  )**
      3. Divisão:
         1. **(  \\  )**
      4. Multiplicação:
         1. **(  \*  )**
      5. Módulo — resto da divisão:
         1. (  %  )
      6. Exponenciação:
         1. (  **  )
      7. Incremento:
         1. (  ++  )
      8. Decremento:
         1. ( -- )
   2. 
   3. ,
   4. ;
   5. :
   6. !==
   7. ()
   8. [].indexOf()
   9.  {}
       
   10. &&
   11. `
   12. <=
   13. >=
   14. ${}
   15. case
   16. class
   17. console.log
   18. else
   19. Error
   20. export
   21. function
   22. if
   23. is
   24. new
   25. number
   26. private
   27. protected
   28. public
   29. return
   30. string
   31. switch
   32. this
   33. throw
   34. undefined

<!-- </details> -->

## Exemplos

 1. Calculadora:
    1. Código typescript

       ```typescript

        export class Calculator {
        private current = 0;
        private memory = 0;
        private operator: string;
        protected processDigit(digit: string, currentValue: number) {
            if (digit >= "0" && digit <= "9") {
            return currentValue * 10 + (digit.charCodeAt(0) - "0".charCodeAt(0));
            }
        }
        protected processOperator(operator: string) {
            if (["+", "-", "*", "/"].indexOf(operator) >= 0) {
            return operator;
            }
        }
        protected evaluateOperator(
            operator: string,
            left: number,
            right: number
        ): number {
            switch (this.operator) {
            case "+":
                return left + right;
            case "-":
                return left - right;
            case "*":
                return left * right;
            case "/":
                return left / right;
            }
        }
        private evaluate() {
            if (this.operator) {
            this.memory = this.evaluateOperator(
                this.operator,
                this.memory,
                this.current
            );
            } else {
            this.memory = this.current;
            }
            this.current = 0;
        }
        public handleChar(char: string) {
            if (char === "=") {
            this.evaluate();
            return;
            } else {
            let value = this.processDigit(char, this.current);
            if (value !== undefined) {
                this.current = value;
                return;
            } else {
                let value = this.processOperator(char);
                if (value !== undefined) {
                this.evaluate();
                this.operator = value;
                return;
                }
            }
            }
            throw new Error(`Unsupported input: '${char}'`);
        }
        public getResult() {
            return this.memory;
        }
        }
        export function test(c: Calculator, input: string) {
        for (let i = 0; i < input.length; i++) {
            c.handleChar(input[i]);
        }
        console.log(`result of '${input}' is '${c.getResult()}'`);
        }


       ```

    2. .
    3. .

</main>

[🔝🔝](#topo "Retorna ao topo")