import { Itms_Global, MapBits } from './itms_Global';

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
export // Dica de como exportar https://www.typescriptlang.org/docs/handbook/modules.html#export
class TNSComponent {  
  /**
   * * @defaultValue `Mb_Bit00`
   */   
   public state : number;  

   /** @constructor */
   constructor(aState:number){
     this.state = aState;  
   };
 
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
   public setState(aState : number , enable: boolean):boolean {
      //Retorna o estado anterior do Mapa de bits passado por aState

      //TESTANDO SE UM BITS ESTA HABILITADO
      if ((this.state & aState) != 0)
        return true
      else 
        return false;

      if (enable == true)
        { this.state = this.state | aState}
      else 
        { this.state = this.state & ~ aState}             
   };
   
   /**
    * @privateRemarks
    */
   public test_SetState():void{

    /**Imprime 1 porque o bit 0 está ligado*/
    console.log(this.state);                  
    
            
    /**Imprime false porque o bit 1 está desligado*/
    let aState : boolean = this.setState(MapBits.Mb_Bit01,true);
    console.log(aState);
    
    /**Imprime 1 porque o bit 1 está ligado*/
    console.log(this.state);  
       
   }
}


// Teste do método setState
export // Dica de como exportar https://www.typescriptlang.org/docs/handbook/modules.html#export
function test_NsComponent():void{
  try {
    // Cria o objeto nsComponent
    let nsComponent = new TNSComponent(MapBits.Mb_Bit00);  

    //Executa test_SetState()
    nsComponent.test_SetState();

  } catch (error) {
    //Se houver error imprime o erro.
    console.log(error);
  }
}                