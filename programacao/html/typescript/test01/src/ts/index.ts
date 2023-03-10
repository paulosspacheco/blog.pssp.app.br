// file1.ts
/**
 * **Documento do arquivo index.ts**
 *
 * _Este é o programa principal do aplicativo e está 
 * definido o menu principal_.
 * 
 * @module - Menu Principal do aplicativo
 * 
 * 
 */

import { test_NsComponent, TNSComponent } from './nscomponent';
// Dicas de importação: https://www.typescriptlang.org/docs/handbook/modules.html#import
/**
 * Este projeto é usado para estudar a linguagem typescript
 * 
 * 
 * @author Paulo Pacheco
 * @version 0.0.1 
 * @alpha
 *  - {@link Itms_Global | Itms_Globa}
 *  - {@link nscomponent | TNSComponent}
*/

/** 
 * Teste da classe TNSComponent 
 * 
*/
test_NsComponent();


// Copyright (c) Example Company. All rights reserved. Licensed under the MIT license.
/**
 * Interface implemented by all widgets.
 * @remarks
 *  -
 *  - The `widget-lib` defines the {@link IWidget} interface and {@link Widget} class,
 *  - {@link Itms_Global | Itms_Globa}
 *  - {@link nscomponent | TNSComponent} 
 * @public
 * 
 */
export interface IWidget {
  /**
   * Draws the widget on the screen.
   */
  render(): void;
}