/**
 * Porta JS de conceitos centrais de `mi_rtl_ui_Dmxscroller`
 * ----------------------------------------------------------------------
 * O QUE O CÓDIGO ORIGINAL FAZIA (resumo):
 *  - Motor de "Form Scroller" (à la Turbo Vision) regido por templates:
 *      * Constrói campos (TDmxFieldRec) a partir de uma gramática de máscara.
 *      * Orquestra estados (Active/Browse/Edit/Insert), navegação BOF/EOF.
 *      * Integra com ActionList (CRUD/Navegação) e com DataSource/BufDataset.
 *      * Expõe utilitários (FieldByName/Number, Locate, etc).
 *
 * PRINCIPAIS ADAPTAÇÕES PARA JS:
 *  - `TDmxFieldRec` virou classe leve `DmxFieldRec` (objeto JS).
 *  - `TUiDmxScroller` virou classe `DmxScroller`, com:
 *      * `templates` (equivalente a _Strings/Assign/Add).
 *      * `fields` / `dataFields` (listas JS + mapa por nome).
 *      * `actions` via `ActionList`/`Action` (enable/disable, get/set).
 *      * `state` com bitmask própria (ACTIVE/EDIT/INSERT/BROWSE/...).
 *      * `dataSource` (adapter sobre Array<Object>) com API similar a TDataSet.
 *  - Partes dependentes de LCL/VCL/BufDataset/mi.rtl.* foram simuladas:
 *      * `ActionList`/`Action`: implementadas aqui.
 *      * `DataSource`: implementada aqui (básica, mas funcional).
 *      * Parser de templates: implementado um parser mínimo + `addField`.
 *
 * NOTAS DE PORTABILIDADE:
 *  - Strings em Pascal são 1-based; no JS tudo é 0-based.
 *  - `AnsiChar`/`Char` → `String` (1-char) no JS.
 *  - Ponteiros (pDmxFieldRec / Prev/Next/RSelf) viram referências JS.
 *  - Tipagem forte → checks de runtime/documentação por JSDoc.
 *  - Exceptions: `throw new Error(...)`.
 *
 * ESTE ARQUIVO É FRAMEWORK-AGNOSTIC:
 *  - Opcional: use `renderActions` e `renderForm` para DOM nativo.
 *  - Em React/Vue, use `scroller.fields` e `scroller.actions` para render.
 */

// ==============================
// Helpers de bitmask/estado
// ==============================

/** Constantes de estado (equivalentes aos Mb_St_* do Pascal) */
export const STATE = Object.freeze({
  ACTIVE:        1 << 0,   // estava em SetActive(...)
  BROWSE:        1 << 1,
  EDIT:          1 << 2,
  INSERT:        1 << 3,
  CREATING_TMPL: 1 << 4,
  // ... adicione outros bits conforme precisar
});

/** Access flags (accNormal/accReadOnly/...) — convertidos do Pascal */
export const ACCESS = Object.freeze({
  NORMAL:    0,
  READ_ONLY: 1,
  HIDDEN:    2,
  SKIP:      4,
  DELIMITER: 8,
  EXTERNAL:  16,
  SPEC_A:    32,
  SPEC_B:    64,
  SPEC_C:    128,
});

/** Type codes de template (subconjunto mais comum) */
export const TYPECODE = Object.freeze({
  STR:           'S',   // fldStr
  STR_ALPHA:     's',   // fldStrAlfa
  STR_NUM:       '#',   // fldStrNumber
  ANSI_CHAR:     'C',   // fldAnsiChar
  ANSI_CHAR_ALF: 'c',   // fldAnsiCharAlfa
  ANSI_CHAR_NUM: 'N',   // fldAnsiCharNum
  BYTE:          'B',
  SHORTINT:      'J',
  SMALLWORD:     'W',
  SMALLINT:      'I',
  LONGINT:       'L',
  DOUBLE:        'R',
  DOUBLE_POS:    'r',
  BOOLEAN:       'X',
  HEX:           'H',
  EXTENDED:      'E',
  REAL4:         'O',
  REAL4_POS:     'o',
  ENUM:          '^E',  // notação de “escape” no Pascal (template)
  ENUM_DB:       '^D',
  BLOB:          '^O',
});

/** Utilitários */
const hasFlag = (mask, flag) => (mask & flag) !== 0;
const setFlag = (mask, flag, enable) => enable ? (mask | flag) : (mask & ~flag);

// ==============================
// ActionList / Action (adapter de TActionList/TAction)
// ==============================

export class Action {
  /** @param {string} name */
  constructor(name, handler = null) {
    this.name = String(name);
    this.enabled = true;
    this.handler = typeof handler === 'function' ? handler : null;
  }
  run(...args) {
    if (!this.enabled) return false;
    if (this.handler) return this.handler(...args);
    return true;
  }
}

export class ActionList {
  constructor() {
    /** @type {Map<string, Action>} */
    this.map = new Map();
    /** lista de comandos “válidos” (equivalente a _CommandsValid) */
    this.valid = new Set();
  }
  add(name, handler = null, { enabled = true, valid = true } = {}) {
    const act = new Action(name, handler);
    act.enabled = !!enabled;
    this.map.set(name, act);
    if (valid) this.valid.add(name);
    return act;
  }
  get(name) { return this.map.get(name) || null; }
  setEnabled(name, enable) {
    const a = this.get(name); if (a) a.enabled = !!enable;
  }
  isEnabled(name) {
    const a = this.get(name); return a ? !!a.enabled : true;
  }
  /** Ativa/Desativa lote, respeitando “válidos” */
  setStateBatch(names, enable) {
    if (!Array.isArray(names) || names.length === 0) {
      // Sem argumento: aplica a todos válidos
      for (const [n, a] of this.map) {
        if (this.valid.has(n)) a.enabled = !!enable;
      }
      return;
    }
    for (const n of names) {
      if (this.valid.has(n)) this.setEnabled(n, enable);
    }
  }
  /** Conveniência para “todos”, similar a high(aCommands) = -1 */
  disableAll() { this.setStateBatch([], false); }
  enableAll()  { this.setStateBatch([], true); }
  get names() { return Array.from(this.map.keys()); }
}

// ==============================
// DataSource (adapter simples de TDataSource/TDataSet)
// ==============================

export class DataSource {
  /**
   * @param {Array<object>} rows
   * @param {string|null} primaryKey
   */
  constructor(rows = [], primaryKey = null) {
    this.rows = Array.isArray(rows) ? rows : [];
    this.primaryKey = primaryKey;
    this.index = this.rows.length > 0 ? 0 : -1;
    /** @type {'browse'|'edit'|'insert'|null} */
    this.state = this.rows.length > 0 ? 'browse' : null;
  }
  get active() { return this.index >= 0 && this.index < this.rows.length; }
  get eof()    { return this.rows.length === 0 || this.index >= this.rows.length - 1; }
  get bof()    { return this.rows.length === 0 || this.index <= 0; }
  current()    { return this.active ? this.rows[this.index] : null; }

  next() { if (!this.eof) this.index += 1; this.state = 'browse'; return this.current(); }
  prev() { if (!this.bof) this.index -= 1; this.state = 'browse'; return this.current(); }
  first() { if (this.rows.length) { this.index = 0; this.state = 'browse'; } return this.current(); }
  last()  { if (this.rows.length) { this.index = this.rows.length - 1; this.state = 'browse'; } return this.current(); }

  edit()   { if (this.active) this.state = 'edit'; }
  insert() { this.state = 'insert'; this.rows.push({}); this.index = this.rows.length - 1; }
  post()   { if (this.state === 'insert' || this.state === 'edit') this.state = 'browse'; }
  cancel() { if (this.state === 'insert') { this.rows.pop(); this.index = this.rows.length - 1; } this.state = 'browse'; }

  /**
   * @param {(row: object, i:number)=>boolean} predicate
   * @returns {boolean}
   */
  locate(predicate) {
    const idx = this.rows.findIndex((r, i) => predicate(r, i));
    if (idx >= 0) { this.index = idx; this.state = 'browse'; return true; }
    return false;
  }
  maxPrimaryKey() {
    if (!this.primaryKey) return null;
    let m = null;
    for (const r of this.rows) {
      const v = r?.[this.primaryKey];
      if (typeof v === 'number') m = (m === null) ? v : Math.max(m, v);
    }
    return m;
  }
}

// ==============================
// DmxFieldRec (record -> classe JS leve)
// ==============================

export class DmxFieldRec {
  /**
   * @param {Partial<DmxFieldRec>} init
   */
  constructor(init = {}) {
    // Campos principais do Pascal (adaptados para camelCase)
    this.linkEdit = null;                 // TComponent -> objeto JS ou null
    this.templateOrg = '';                // Template original
    this.next = null;                     // encadeamento (opcional)
    this.rSelf = this;                    // referência a si mesmo
    this.prev = null;
    this.access = ACCESS.NORMAL;          // byte
    this.fieldnum = 0;                    // Integer (0 = não-dados)
    this.screenTab = 0;                   // integer
    this.columnWid = 0;                   // byte
    this.shownWid = 0;                    // byte
    this.typeCode = TYPECODE.STR;         // AnsiChar ou escape “^E” etc.
    this.fillValue = ' ';                 // AnsiChar
    this.upperLimit = 0;                  // byte
    this.showZeroes = false;              // boolean
    this.trueLen = 0;                     // byte
    this.parenthesis = false;             // boolean
    this.decimals = 0;                    // byte
    this.fieldSize = 0;                   // integer
    this.dataTab = 0;                     // integer
    this.template = '';                   // ptString -> string
    this.dataSource = null;               // DataSource ou outro adapter
    this.keyField = '';                   // String
    this.listField = '';                  // String
    this.listOptionsDefault = 0;          // Longint
    this.defaultConst = '';               // String
    this.defaultExpression = '';          // String
    this.linkExecAction = null;           // referência para ação (ou rec), opcional
    this.charShowPassword = '\u2022';     // •
    this.quitFieldAltomatic = false;      // Boolean
    this.selStart = 0;                    // Integer
    this.selEnd = 0;                      // Integer
    this._fieldAltered = false;           // Boolean
    this.helpCtxHint = '';                // String
    this.helpCtxPorque = '';
    this.helpCtxOnde = '';
    this.helpCtxComo = '';
    this.helpCtxQuais = '';
    this.helpCtxHistorico = '';
    this._okSpcAnt = false;               // Boolean
    this.providerFlags = 0;               // placeholder
    this.foreignKey = null;               // placeholder
    this.keyForeign = '';                 // String
    this.fieldName = '';                  // (não estava listado acima, mas é essencial)
    this.alias = '';                      // rótulo amigável

    Object.assign(this, init);
  }
}

// ==============================
// DmxScroller (núcleo do motor)
// ==============================

export class DmxScroller {
  constructor() {
    /** @type {string[]} templates (equivalente a _Strings) */
    this.templates = [];
    /** @type {DmxFieldRec[]} */
    this.fields = [];
    /** @type {Map<string, DmxFieldRec>} campos com fieldnum != 0 */
    this.dataFields = new Map();
    /** @type {ActionList} */
    this.actionList = new ActionList();
    /** nomes permitidos para enable/disable em lote (equiv. _CommandsValid) */
    this.actionList.valid = new Set([
      'cmNewRecord','cmUpdateRecord','cmLocate','cmDeleteRecord','cmCancel',
      'cmGoBof','cmNextRecord','cmPrevRecord','cmGoEof','cmRefresh'
    ]);
    /** bitmask Estado */
    this.state = 0;
    /** @type {DataSource|null} */
    this.dataSource = null;
    /** configuráveis */
    this.charEscape = '\\'; // no Pascal, barras + tokens
  }

  // --------- Estado ---------

  /** @param {number} mask @param {boolean} enable */
  setState(mask, enable) {
    const prev = hasFlag(this.state, mask);
    this.state = setFlag(this.state, mask, enable);
    // No Pascal, UpdateCommands é chamado em alguns estados
    if (hasFlag(mask, (STATE.EDIT | STATE.INSERT | STATE.BROWSE)) && this.active && this.isDataSourceActive()) {
      this.updateCommands();
    }
    return prev;
  }
  getState(mask) { return hasFlag(this.state, mask); }
  get active() { return this.getState(STATE.ACTIVE); }
  /** @param {boolean} on */
  setActive(on) { this.setState(STATE.ACTIVE, !!on); }

  // --------- Templates ---------

  /** Adiciona uma linha de template (equivalente a procedure add(...)) */
  addTemplate(tpl) {
    const sanitized = (tpl ?? '') === '' ? '~~' : String(tpl).replaceAll('"', '~');
    this.templates.push(sanitized);
  }
  /** Substitui o conjunto de templates (Assign) */
  setTemplates(list) {
    this.templates = Array.isArray(list) ? list.slice() : [];
  }

  // --------- Campos ---------

  /**
   * Parser mínimo de template para ilustrar a ideia:
   *  - identifica tokens do tipo \A...\A (AnsiString) e gera DmxFieldRec básico.
   *  - Para port “fiel” ao Pascal, seria necessário portar todo `CreateStruct`.
   *  *Você pode pular o parser e usar addField(...)*.
   */
  createStructMinimal() {
    this.fields = [];
    this.dataFields.clear();

    let fieldnum = 0;
    for (const line of this.templates) {
      // Exemplo muito simplificado: procura padrão \A{...nome...}
      // Isso é apenas ilustrativo.
      const regex = /\\([ASCH#N]|X|R|L|I|B)([A-Za-z0-9_]*)/g; // tipo + nome opcional
      let m;
      while ((m = regex.exec(line)) !== null) {
        const [, typeCode, maybeName] = m;
        const name = maybeName || `field_${this.fields.length + 1}`;
        const rec = new DmxFieldRec({
          typeCode,
          fieldName: name,
          fieldnum: ++fieldnum,
          template: line,
        });
        this.fields.push(rec);
        // dataFields: guarda só fieldnum != 0
        this.dataFields.set(name.toLowerCase(), rec);
      }
    }
  }

  /** API explícita: adiciona um campo sem passar por template */
  addField(rec) {
    const fld = new DmxFieldRec(rec);
    if (!fld.fieldName) throw new Error('addField: fieldName é obrigatório');
    if (!fld.fieldnum) fld.fieldnum = this.fields.length + 1;
    this.fields.push(fld);
    if (fld.fieldnum !== 0) this.dataFields.set(fld.fieldName.toLowerCase(), fld);
    return fld;
  }

  fieldByName(name) {
    if (!name) return null;
    return this.dataFields.get(String(name).toLowerCase()) || null;
  }
  fieldByNumber(n) {
    if (typeof n !== 'number') return null;
    return this.fields.find(f => f.fieldnum === n) || null;
  }

  // --------- DataSource ---------

  setDataSource(ds /* DataSource|null */) {
    this.dataSource = ds || null;
  }
  getDataSet() {
    return this.dataSource;
  }
  isDataSourceActive() {
    return !!(this.dataSource && this.dataSource.active);
  }

  // --------- Actions ---------

  /** Inicializa/retorna uma Action por nome (equiv. GetAction) */
  getAction(name) {
    if (!name) return null;
    let act = this.actionList.get(name);
    if (!act) act = this.actionList.add(name);
    return act;
  }

  /** Habilita/desabilita uma action (equiv. SetStateAction) */
  setStateAction(name, enable) {
    this.actionList.setEnabled(name, !!enable);
  }

  /** Lê o estado enabled de uma action (equiv. getStateAction) */
  getStateAction(name) {
    return this.actionList.isEnabled(name);
  }

  /**
   * Habilita ações passadas (EnableCommands),
   * se nenhum nome for passado, habilita **todas** as válidas.
   */
  enableCommands(...names) {
    this.actionList.setStateBatch(names, true);
  }
  /** Desabilita ações (DisableCommands) — sem nomes => todas as válidas */
  disableCommands(...names) {
    this.actionList.setStateBatch(names, false);
  }
  /**
   * Retorna true se **todas** as ações passadas estão habilitadas.
   * No Pascal, quando `Mi_ActionList` não existe, retorna true.
   */
  commandsEnabled(...names) {
    if (!names || names.length === 0) return true;
    for (const n of names) {
      if (!this.getStateAction(n)) return false;
    }
    return true;
  }

  /** Atualiza conjunto de actions conforme estado/dataset (analogia a UpdateCommands) */
  updateCommands() {
    const ds = this.getDataSet();
    const canBrowse = !!ds && ds.active;
    const canNav = !!ds && ds.rows.length > 0;

    // Exemplo de política básica; ajuste conforme sua UI:
    this.setStateAction('cmNewRecord', true);
    this.setStateAction('cmUpdateRecord', canBrowse);
    this.setStateAction('cmDeleteRecord', canBrowse);
    this.setStateAction('cmLocate', true);
    this.setStateAction('cmCancel', true);

    this.setStateAction('cmGoBof', canNav && !ds.bof);
    this.setStateAction('cmPrevRecord', canNav && !ds.bof);
    this.setStateAction('cmNextRecord', canNav && !ds.eof);
    this.setStateAction('cmGoEof', canNav && !ds.eof);
    this.setStateAction('cmRefresh', true);
  }

  // --------- Botões/Template CRUD & Navigator (equivalentes em string) ---------

  /** Retorna uma *string* de “template visual” (compatível conceitualmente) */
  static getTemplateCRUDButtons(
    aCmNewRecord = 'cmNewRecord',
    aCmUpdateRecord = 'cmUpdateRecord',
    aCmLocate = 'cmLocate',
    aCmDeleteRecord = 'cmDeleteRecord',
    aCmCancel = 'cmCancel',
  ) {
    // No original, concatena strings com tokens/ícones e escapes ChEA.
    // Aqui simulamos com uma string descritiva.
    return [
      `[➕ Novo]{${aCmNewRecord}}`,
      `[✏️ Alterar]{${aCmUpdateRecord}}`,
      `[🔎 Localizar]{${aCmLocate}}`,
      `[🗑️ Excluir]{${aCmDeleteRecord}}`,
      `[⤴️ Cancelar]{${aCmCancel}}`,
    ].join(' ');
  }

  static getTemplateDbNavigatorButtons(
    aCmGoBof = 'cmGoBof',
    aCmNextRecord = 'cmNextRecord',
    aCmPrevRecord = 'cmPrevRecord',
    aCmGoEof = 'cmGoEof',
    aCmRefresh = 'cmRefresh',
  ) {
    return [
      `[⏮ Primeiro]{${aCmGoBof}}`,
      `[▶ Próximo]{${aCmNextRecord}}`,
      `[◀ Anterior]{${aCmPrevRecord}}`,
      `[⏭ Último]{${aCmGoEof}}`,
      `[🔄 Atualizar]{${aCmRefresh}}`,
    ].join(' ');
  }

  // --------- Renderização DOM opcional (sem frameworks) ---------

  /**
   * Renderiza botões de actions em um container (DOM nativo).
   * @param {HTMLElement} container
   * @param {string[]} names  nomes de actions na ordem
   */
  renderActions(container, names) {
    if (!container) return;
    container.innerHTML = '';
    for (const name of names) {
      const act = this.getAction(name);
      const btn = document.createElement('button');
      btn.textContent = name;
      btn.disabled = !act.enabled;
      btn.addEventListener('click', () => act.run(this));
      // Observa mudanças simples: re-render é sua responsabilidade em apps reais
      Object.defineProperty(act, 'enabled', {
        set: (v) => (btn.disabled = !v),
        get: () => !btn.disabled,
        configurable: true,
      });
      container.appendChild(btn);
    }
  }

  /**
   * Renderização simples de campos como <label><input>.
   * @param {HTMLElement} container
   */
  renderForm(container) {
    if (!container) return;
    container.innerHTML = '';
    const ds = this.getDataSet();

    for (const f of this.fields) {
      if ((f.access & ACCESS.HIDDEN) !== 0) continue;
      const wrap = document.createElement('div');
      const label = document.createElement('label');
      label.textContent = f.alias || f.fieldName;
      label.style.display = 'block';

      const input = document.createElement('input');
      input.type = f.typeCode === TYPECODE.BOOLEAN ? 'checkbox' : 'text';

      if (ds && ds.current()) {
        const curr = ds.current();
        if (f.typeCode === TYPECODE.BOOLEAN) {
          input.checked = !!curr[f.fieldName];
        } else {
          input.value = curr[f.fieldName] ?? '';
        }
      }

      if ((f.access & ACCESS.READ_ONLY) !== 0) input.readOnly = true;

      input.addEventListener('input', () => {
        if (!ds || !ds.current()) return;
        if (f.typeCode === TYPECODE.BOOLEAN) {
          ds.current()[f.fieldName] = !!input.checked;
        } else {
          ds.current()[f.fieldName] = input.value;
        }
        f._fieldAltered = true;
      });

      wrap.appendChild(label);
      wrap.appendChild(input);
      container.appendChild(wrap);
    }
  }
}

// ==============================
// Exemplo de uso (comentado):
// ==============================

/*
import { DmxScroller, DataSource, STATE, TYPECODE, ACCESS } from './dmxscroller.js';

const scroller = new DmxScroller();

// Definindo campos explicitamente (evita parser de template completo)
scroller.addField({ fieldName: 'id',   alias: 'Código', typeCode: TYPECODE.LONGINT, access: ACCESS.READ_ONLY });
scroller.addField({ fieldName: 'nome', alias: 'Nome',   typeCode: TYPECODE.STR, fieldSize: 40 });
scroller.addField({ fieldName: 'ativo',alias: 'Ativo',  typeCode: TYPECODE.BOOLEAN });

// Dataset simples
const ds = new DataSource([
  { id: 1, nome: 'Alice', ativo: true },
  { id: 2, nome: 'Bruno', ativo: false },
], 'id');

scroller.setDataSource(ds);
scroller.setActive(true);
scroller.setState(STATE.BROWSE, true);

// Actions (handlers)
scroller.actionList.add('cmNewRecord', () => { ds.insert(); scroller.updateCommands(); return true; });
scroller.actionList.add('cmUpdateRecord', () => { ds.edit(); return true; });
scroller.actionList.add('cmDeleteRecord', () => { /* remova do array conforme sua política *\/ return true; });
scroller.actionList.add('cmCancel', () => { ds.cancel(); scroller.updateCommands(); return true; });
scroller.actionList.add('cmNextRecord', () => { ds.next(); return true; });
scroller.actionList.add('cmPrevRecord', () => { ds.prev(); return true; });
scroller.actionList.add('cmGoBof', () => { ds.first(); return true; });
scroller.actionList.add('cmGoEof', () => { ds.last(); return true; });
scroller.actionList.add('cmRefresh', () => { /* recarregar dados *\/ return true; });

// Em browser:
// scroller.renderActions(document.getElementById('nav'), ['cmGoBof','cmPrevRecord','cmNextRecord','cmGoEof','cmRefresh']);
// scroller.renderActions(document.getElementById('crud'), ['cmNewRecord','cmUpdateRecord','cmDeleteRecord','cmCancel']);
// scroller.renderForm(document.getElementById('form'));
*/

// ============================================================================
// FIM
// ============================================================================
