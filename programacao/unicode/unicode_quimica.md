# linguagem química no Unicode é construída "combinando diferentes blocos já existentes"

A química, ao contrário da matemática, não possui um bloco Unicode chamado exclusivamente de *"Chemical Symbols"*. Em vez disso, a linguagem química no Unicode é construída **combinando diferentes blocos já existentes** — como caracteres alfanuméricos, subscritos/sobrescritos, setas de reação e elementos de teoria das estruturas.

Abaixo estão as principais categorias de Unicodes utilizados para compor equações, fórmulas e estruturas químicas:

---

## 1. Subscritos e Sobrescritos (Fórmulas e Íons)

Essenciais para indicar a quantidade de átomos ($H_2O$) e a carga elétrica dos íons ($SO_4^{2-}$).

* **Bloco Principal:** *Superscripts and Subscripts* (`U+2070` a `U+209F`)
* **Subscritos Numéricos (`U+2080` a `U+2089`):**

| Símbolo | Nome Unicode | Code Point (Hex) | Exemplo de Uso |
| --- | --- | --- | --- |
| **₀** | `SUBSCRIPT ZERO` | `U+2080` | — |
| **₁** | `SUBSCRIPT ONE` | `U+2081` | — |
| **₂** | `SUBSCRIPT TWO` | `U+2082` | H₂O (Água) |
| **₃** | `SUBSCRIPT THREE` | `U+2083` | NH₃ (Amônia) |
| **₄** | `SUBSCRIPT FOUR` | `U+2084` | CH₄ (Metano) |

* **Sobrescritos para Cargas e Isótopos:**

| Símbolo | Nome Unicode | Code Point (Hex) | Exemplo de Uso |
| --- | --- | --- | --- |
| **⁺** | `SUPERSCRIPT PLUS SIGN` | `U+207A` | Na⁺ (Cátion Sódio) |
| **⁻** | `SUPERSCRIPT MINUS SIGN` | `U+207B` | Cl⁻ (Ânion Cloreto) |
| **²** | `SUPERSCRIPT TWO` | `U+00B2` | Ca²⁺ (Cátion Cálcio) |
| **³** | `SUPERSCRIPT THREE` | `U+00B3` | Fe³⁺ (Cátion Ferro III) |

---

## 2. Setas de Reação Química e Equilíbrio

Representam os sentidos das reações, estados de transição e equilíbrio químico.

* **Blocos:** *Arrows* (`U+2190`–`U+21FF`) e *Supplemental Arrows-A/B*

| Símbolo | Nome Unicode | Code Point (Hex) | Função / Significado |
| --- | --- | --- | --- |
| **→** | `RIGHTWARDS ARROW` | `U+2192` | Reação irreversível (Sentido direto) |
| **⇄** | `RIGHTWARDS ARROW OVER LEFTWARDS ARROW` | `U+21C4` | Reação reversível / Equilíbrio |
| **⇌** | `RIGHT HARPOON WITH BARB UP OVER LEFT HARPOON WITH BARB DOWN` | `U+21CC` | Equilíbrio químico (harpinhas clássicas) |
| **↔** | `LEFT RIGHT ARROW` | `U+2194` | Ressonância de estruturas |
| **↑** | `UPWARDS ARROW` | `U+2191` | Liberação de gás |
| **↓** | `DOWNWARDS ARROW` | `U+2193` | Formação de precipitado (sólido) |

---

## 3. Símbolos de Estado, Fases e Condições Reacionais

Usados para indicar calor, luz, catalisadores ou características físicas das substâncias.

| Símbolo | Nome Unicode | Code Point (Hex) | Significado Química |
| --- | --- | --- | --- |
| **Δ** | `GREEK CAPITAL LETTER DELTA` | `U+0391` | Aquecimento / Variação de energia |
| **hν** | `LATIN SMALL LETTER H` + `GREEK SMALL LETTER CHI/NU` | `U+0068` + `U+03BD` | Luz / Radiação ultravioleta |
| **°** | `DEGREE SIGN` | `U+00B0` | Condição padrão (ex: E°, ΔH°) |
| **⦵** | `CIRCLED WHITE BULLET` | `U+29B5` | Notação IUPAC alternativa para estado padrão |
| **⚡** | `HIGH VOLTAGE SIGN` | `U+26A1` | Eletrólise |

---

## 4. Ligações Químicas e Estruturas Desenhadas em Texto

Símbolos usados para representar ligações covalentes simples, duplas, triplas e elétrons livres.

| Símbolo | Nome Unicode | Code Point (Hex) | Notação Química |
| --- | --- | --- | --- |
| **-** | `HYPHEN-MINUS` / `MINUS SIGN` | `U+002D` / `U+2212` | Ligação simples (ex: C-C) |
| **=** | `EQUALS SIGN` | `U+003D` | Ligação dupla (ex: C=C) |
| **≡** | `IDENTICAL TO` | `U+2261` | Ligação tripla (ex: N≡N) |
| **∷** | `PROPORTION` | `U+2237` | Par de elétrons livres (Estrutura de Lewis) |
| **⋅** | `DOT OPERATOR` | `U+22C5` | Ligação de radical livre / Hidratos (ex: CuSO₄·5H₂O) |

---

## 5. Elementos e Símbolos Especiais de Gabinete / Emojis

Para representação visual e interfaces modernas de software de laboratório.

| Símbolo | Nome Unicode | Code Point (Hex) | Categoria |
| --- | --- | --- | --- |
| **⚗** | `ALEMBIC` | `U+2697` | Símbolo clássico de destilação / química |
| **🧪** | `TEST TUBE` | `U+1F9EA` | Tubo de ensaio (Emoji) |
| **🧫** | `PETRI DISH` | `U+1F9EB` | Placa de Petri (Emoji) |
| **🧬** | `DNA` | `U+1F9EC` | Molécula de DNA / Bioquímica |
| **⚛** | `ATOM SYMBOL` | `U+269B` | Átomo / Química nuclear |
| **☢** | `RADIOACTIVE SIGN` | `U+2622` | Radiação / Radioquímica |

---

### 💡 Exemplo de Equação Química usando apenas Unicode Puro:

> **Reação de combustão do Metano:**
> `CH₄ + 2 O₂ → CO₂ + 2 H₂O + Δ`
> **Equilíbrio da Amônia:**
> `N₂ + 3 H₂ ⇌ 2 NH₃`