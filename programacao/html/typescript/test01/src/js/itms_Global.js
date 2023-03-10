"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.Itms_Global = exports.MapBits = void 0;
/** Mapas de bits usados para trabalhar com bit através dos operadores &(and) ~(note) |(or) */
var MapBits;
(function (MapBits) {
    /**Número hexadecimal 0x0001 com bit 0 em 1, Binário: 1 */
    MapBits[MapBits["Mb_Bit00"] = 1] = "Mb_Bit00";
    /**Número hexadecimal 0x0002 com bit 1 em 1, Binário: 10 */
    MapBits[MapBits["Mb_Bit01"] = 2] = "Mb_Bit01";
    /**Número hexadecimal 0x0004 com bit 2 em 1, Binário: 100 */
    MapBits[MapBits["Mb_Bit02"] = 4] = "Mb_Bit02";
    /**Número hexadecimal 0x0008 com bit 3 em 1, Binário: 1000 */
    MapBits[MapBits["Mb_Bit03"] = 8] = "Mb_Bit03";
    /**Número hexadecimal 0x0010 com bit 4 em 1, Binário: 10000 */
    MapBits[MapBits["Mb_Bit04"] = 16] = "Mb_Bit04";
    /**Número hexadecimal 0x0020 com bit 5 em 1, Binário: 100000 */
    MapBits[MapBits["Mb_Bit05"] = 32] = "Mb_Bit05";
    /**Número hexadecimal 0x0040 com bit 6 em 1, Binário: 1000000 */
    MapBits[MapBits["Mb_Bit06"] = 64] = "Mb_Bit06";
    /**Número hexadecimal 0x0080 com bit 7 em 1, Binário: 10000000 */
    MapBits[MapBits["Mb_Bit07"] = 128] = "Mb_Bit07";
    /**Número hexadecimal 0x0100 com bit 8 em 1, Binário: 100000000 */
    MapBits[MapBits["Mb_Bit08"] = 256] = "Mb_Bit08";
    /**Número hexadecimal 0x0200 com bit 9 em 1, Binário: 1000000000 */
    MapBits[MapBits["Mb_Bit09"] = 512] = "Mb_Bit09";
    /**Número hexadecimal 0x0400 com bit 10 em 1, Binário: 10000000000 */
    MapBits[MapBits["Mb_Bit10"] = 1024] = "Mb_Bit10";
    /**Número hexadecimal 0x0800 com bit 11 em 1, Binário: 100000000000 */
    MapBits[MapBits["Mb_Bit11"] = 2048] = "Mb_Bit11";
    /**Número hexadecimal 0x1000 com bit 12 em 1, Binário: 1000000000000 */
    MapBits[MapBits["Mb_Bit12"] = 4096] = "Mb_Bit12";
    /**Número hexadecimal 0x2000 com bit 13 em 1, Binário: 10000000000000 */
    MapBits[MapBits["Mb_Bit13"] = 8192] = "Mb_Bit13";
})(MapBits = exports.MapBits || (exports.MapBits = {}));
class Itms_Global {
}
exports.Itms_Global = Itms_Global;
//# sourceMappingURL=itms_Global.js.map