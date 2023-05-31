// Módulo baseWidget.ts
/**
 * Documento do módulo baseWidget.ts
 *  
 * @remark
 * Conjunto de classes abstratas usada para visualização de telas.
 * 
 * @module - Classes abstratas para ferramentas visuais.
 * 
 * @alpha
 */


/**
 * A classe base para todos os widgets.
 *
 * @remarks
 * Para detalhes, veja {@link https://example.com/my-protocol | as especificações do protocolo}.
 *
 * @internal
 */
export abstract class BaseWidget {
    /**
*     _title é a variável da propriedade pública
      título e só pode ser acessado pelos métodos get e set.
     */
    private _title  : string;

    /**
     * 
     * @param a_title - String com o título do widget
     */
    constructor (a_title:string){
        this._title = a_title;
    }    

  /**
   * Desenha o widget.
   * 
   * @remarks
   *
   * O membro `draw` implementa a renderização principal para um widget.
   *
   * @param force 
   *   - true - se deve forçar o redesenho;
   *   - false - se não deve forçar o redesenho.
   * 
   * @returns 
   *   - true, se a renderização ocorreu; 
   *   - falso, se a visualização já estava atualizada
   *
   * @beta @virtual
   */
  public draw(force: boolean): boolean {
    return force;
  }

  /**
   * Se o widget está visível no momento.
   *
   * @example
   * Aqui está um exemplo de código para ocultar um widget:
   *
   * ```typescripts
   * let myWidget = new MyWidget();
   * myWidget.visible = false;
   * ```
   *
   * @defaultValue `true`
   */
  public visible: boolean = true;

  
  /**
   * 
   * Os métodos **Get** ou **set** ler ou grava o atributo **_title** da propriedade **title**.
   * Veja mais sobre propriedade {@link https://javascript.info/property-accessors#:~:text=Accessor%20descriptors&text=get%20%E2%80%93%20a%20function%20without%20arguments,same%20as%20for%20data%20properties. | aqui}.
   */
  public get title(): string {
    return this._title;
  }

  // NOTA: API Extractor e typedoc considera suas funções getter e setter 
  // de propriedade como um único item de API. 
  // Não escreva nenhuma documentação para o setter.
  public set title(value: string) {
    this._title = value;
  }
}
