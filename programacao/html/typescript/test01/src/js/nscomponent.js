"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.test_NsComponent = exports.TNSComponent = void 0;
const itms_Global_1 = require("./itms_Global");
/**
 * Class TNsComponent
 * @packageDocumentation
 * @author Paulo Pacheco
 * @version 0.0.1
 *
 * @alpha
 *
 */
/**
  TNSComponent é classe base para os componentes que precisam de uma estados de componente.
  @category componentes
*/
class TNSComponent {
    /** @constructor */
    constructor(aState) {
        this.state = aState;
    }
    ;
    /**
     ### Método usado para ligar ou desligar bits do atributo state.
 
     @remarks
        - Os Bits de variável são setados com operador OR ou + e testados com operador AND. <br>
        - Exemplo:
          > Variável State de uma tabela em disco.
          >> Bit00 = 0 --> Arquivo fechado; <br>
          >> Bit00 = 1 --> Arquivo aberto;<br>
          >> Bit01 = 0 --> Arquivo Compartilhado;  <br>
          >> Bit01 = 1 --> Arquivo Nao compartilhado.  <br>
            
        - TESTANDO SE UM BITS ESTA HABILITADO
          > - Teste se a tabela esta compartilhada: (State And Bit01) <> 0
          > - Arquivo aberto e nao compartilhado:   (
                                                      (State And Bit00) <> 0 and
                                                      (State And Bit01) <> 0
                                                   )
 
     @param aState
       1. bits que deseja habilita.
       2. Exemplo de mapa de bits: 0001, 0010.
      
     @param enable:
         1. Se true a posição indicada por aState é setada para 1;
         2. Se false a posição indicada por aState é setada para 0.
      
     @returns
        1. Retorna o valor anterior do atributo state.
      
     @example Exemplo de chamada ao método
       ```typescript
 
         test_SetState():void{
 
           //Imprime 1 porque o bit 0 está ligado
           console.log(this.state);
           
               
           //Imprime false porque o bit 1 está desligado
           let aState : boolean = this.setState(MapBits.Mb_Bit01,true);
           console.log(aState);
           
           //Imprime 1 porque o bit 1 está ligado
           console.log(this.state);
             
         }
 
         try {
           // Cria o objeto nsComponent
           let nsComponent = new TNSComponent(MapBits.Mb_Bit00);
 
           //Executa test_SetState()
           nsComponent.test_SetState();
 
         } catch (error) {
           //Se houver error imprime o erro.
           console.log(error);
         }
         
       ```
     */
    setState(aState, enable) {
        //Retorna o estado anterior do Mapa de bits passado por aState
        //TESTANDO SE UM BITS ESTA HABILITADO
        if ((this.state & aState) != 0)
            return true;
        else
            return false;
        if (enable == true) {
            this.state = this.state | aState;
        }
        else {
            this.state = this.state & ~aState;
        }
    }
    ;
    /**
     * @privateRemarks
     */
    test_SetState() {
        /**Imprime 1 porque o bit 0 está ligado*/
        console.log(this.state);
        /**Imprime false porque o bit 1 está desligado*/
        let aState = this.setState(itms_Global_1.MapBits.Mb_Bit01, true);
        console.log(aState);
        /**Imprime 1 porque o bit 1 está ligado*/
        console.log(this.state);
    }
}
exports.TNSComponent = TNSComponent;
// Teste do método setState
function test_NsComponent() {
    try {
        // Cria o objeto nsComponent
        let nsComponent = new TNSComponent(itms_Global_1.MapBits.Mb_Bit00);
        //Executa test_SetState()
        nsComponent.test_SetState();
    }
    catch (error) {
        //Se houver error imprime o erro.
        console.log(error);
    }
}
exports.test_NsComponent = test_NsComponent;
//# sourceMappingURL=nscomponent.js.map