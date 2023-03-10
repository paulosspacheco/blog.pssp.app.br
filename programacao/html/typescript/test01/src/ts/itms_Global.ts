/** 
 * Pacote de constantes e classes de uso global
 * 
 * @remarks Para que a tag seja visualizada na documentação 
 * é preciso que ela seja precedida do caractere \`(crase)
 * Exemplo: `@public
 * 
 * - Link para módulo: {@link nscomponent | módulo nscomponent}
 * - Link para classe: {@link nscomponent.TNSComponent | Class TNSComponent}
 * 
 * 
 * @packageDocumentation
 * 
 * @author Paulo Pacheco
 * @version 0.0.1
 * @alpha
 * 
*/

/** Mapas de bits usados para trabalhar com bit através dos operadores &(and) ~(note) |(or) */
export // Dica de como exportar https://www.typescriptlang.org/docs/handbook/modules.html#export
enum MapBits {

    /**Número hexadecimal 0x0001 com bit 0 em 1, Binário: 1 */
    Mb_Bit00 = 0x0001, 

    /**Número hexadecimal 0x0002 com bit 1 em 1, Binário: 10 */
    Mb_Bit01 = 0x0002,

    /**Número hexadecimal 0x0004 com bit 2 em 1, Binário: 100 */
    Mb_Bit02 = 0x0004,

    /**Número hexadecimal 0x0008 com bit 3 em 1, Binário: 1000 */
    Mb_Bit03 = 0x0008,  

    /**Número hexadecimal 0x0010 com bit 4 em 1, Binário: 10000 */
    Mb_Bit04 = 0x0010,  

    /**Número hexadecimal 0x0020 com bit 5 em 1, Binário: 100000 */
    Mb_Bit05 = 0x0020,

    /**Número hexadecimal 0x0040 com bit 6 em 1, Binário: 1000000 */
    Mb_Bit06 = 0x0040,      

    /**Número hexadecimal 0x0080 com bit 7 em 1, Binário: 10000000 */
    Mb_Bit07 = 0x0080,      

    /**Número hexadecimal 0x0100 com bit 8 em 1, Binário: 100000000 */
    Mb_Bit08 = 0x0100,      

    /**Número hexadecimal 0x0200 com bit 9 em 1, Binário: 1000000000 */
    Mb_Bit09 = 0x0200,      

    /**Número hexadecimal 0x0400 com bit 10 em 1, Binário: 10000000000 */
    Mb_Bit10 = 0x0400,      
    /**Número hexadecimal 0x0800 com bit 11 em 1, Binário: 100000000000 */
    Mb_Bit11 = 0x0800,      
    /**Número hexadecimal 0x1000 com bit 12 em 1, Binário: 1000000000000 */
    Mb_Bit12 = 0x1000,      
    /**Número hexadecimal 0x2000 com bit 13 em 1, Binário: 10000000000000 */
    Mb_Bit13 = 0x2000      

  }
  

export // Dica de como exportar https://www.typescriptlang.org/docs/handbook/modules.html#export
class Itms_Global{
    
}
  