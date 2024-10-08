class ObjectsMethods {

    1. _E_ Número real com sizeof = 10 bytes. Aceita positivos e negativos
    2. _O_ Número Real sizeof = 4 Byte. Aceita positivos e negativos
    3. _o_ Número Real sizeof = 4 Byte. Aceita só positivos
    4. _P_ Número Real sizeof = 4 Byte. Ao entrar no campo o mesmo é por 100 e ao sair o mesmo é dividido por 100 aceita positivos e negativos
    5. _p_ Número Real sizeof = 4 Ao entrar no campo o mesmo é por 100 e ao sair o mesmo é dividido por 100 aceita positivos e negativos
    6. _R_ Número real sizeof = 8 positivos e negativos
    7. _r_ Número real sizeof = 8 positivo
    8. _B_ Número byte sizeof = 1 aceita so positivo
    9. _J_ Número shortint sizeof = 1 aceita positivo e negativo
    10. _W_ Número SmallWORD sizeof = 2 aceita só positivos
    11. _I_ Número SmallInt sizeof = 2 aceita só positivos e negativos
    12. _L_ Número longint aceita positivos e negativos
    13. _#_ Numero String que só aceita digitos 0 a 9
    14. _0_ AnsiChar que só aceita digitos 0 a 9    

    static  fldAnsiChar = ;
    static  fldAnsiChar_Lowstatic = ;
    static  fldAnsiCharVAL = ;
    static  fldSTRNUM = ;
    static  fldSTR = 'S';
    static  fldstr_Lowcase ='s';   
    static  fldRealNum = ;
    static  fldReal4 = ;
    static  fldReal4Positivo = ;
    static  fldReal4P = ;
    static  fldReal4PPositivo = ;
    static  fldRealNum_Positivo = ;
    static  fldExtended = ;
    static  fldENum = ;
    static  fldENum_db = ;
    static  fldBOOLEAN = ;
    static  fldBYTE = ;
    static  fldSHORTINT = ;
    static  fldSmallWORD = ;
    static  fldSmallInt = ;
    static  fldLONGINT = ;
    static  FldRadioButton = ;

  static formatValue(aValue, aMask) {
    let result = ;

    if (aMask[0] === FldDateTime) {
      // Tratamento especial para FldDateTime
      result = aValue; // Placeholder para tratamento de datas
    } else {
      let lenS = aValue.length;
      let posS = 0;
      let len_aMask = aMask.length;
      let s = String(aValue);
      let r = 0;

      // Checa se a máscara é número relativo
      if (aMask.includes(fldReal4P) || aMask.includes(fldReal4PPositivo)) {
        r = parseFloat(aValue);
        r = r * 100;
        s = this.strNum(aMask, r, fldExtended); // Você precisaria implementar strNum
        if (s.includes(this.showDecimalSeparator)) {
          s = s.replace(this.showDecimalSeparator, this.decimalSeparator);
        }
      }

      // Gera a máscara
      for (let i = len_aMask - 1; i >= 0; i--) {
        switch (aMask[i]) {
          case fldAnsiChar:
          case fldAnsiChar_Lowcase:
          case fldAnsiCharVAL:
          case fldSTRNUM:
          case fldSTR:
          case fldRealNum:
          case fldReal4:
          case fldReal4Positivo:
          case fldReal4P:
          case fldReal4PPositivo:
          case fldRealNum_Positivo:
          case fldExtended:
          case fldENum:
          case fldENum_db:
          case fldBOOLEAN:
          case fldBYTE:
          case fldSHORTINT:
          case fldSmallWORD:
          case fldSmallInt:
          case fldLONGINT:
          case FldRadioButton:
            if (lenS >= 1) {
              if ([fldRealNum, fldReal4, fldReal4P, fldReal4PPositivo, fldRealNum_Positivo, fldExtended].includes(aMask[i])) {
                if (s[lenS - 1] === this.decimalSeparator) {
                  lenS--;
                }
                result = s[lenS - 1] + result;
              } else {
                result = s[lenS - 1] + result;
              }
              lenS--;
            }
            break;

          case fldstr_Lowcase:
            if (lenS >= 1) {
              result = s[lenS - 1].toLowerCase() + result;
              lenS--;
            }
            break;

          default:
            if (lenS >= 1) {
              result = aMask[i] + result;
            }
            break;
        }
      }
    }

    return result;
  }

  static strNum(mask, value, type) {
    // Implementar a função de formatação de número
    // Esta função deve lidar com o valor, a máscara e o tipo
    // como no Pascal
    return value.toString(); // Placeholder
  }

  static get decimalSeparator() {
    return ,; // Define o separador decimal como vírgula
  }

  static get showDecimalSeparator() {
    return .; // Define o caractere separador a ser exibido
  }
}
