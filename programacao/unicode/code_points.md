# Unicode dedica blocos inteiros e milhares de *code points* exclusivamente para a matemática.


O padrão Unicode dedica blocos inteiros e milhares de *code points* exclusivamente para a matemática. Para organizar essa imensidão, o Unicode divide os símbolos em categorias funcionais.

Abaixo estão os principais blocos, intervalos e exemplos dos Unicode que representam a matemática:

---

## 1. Operadores Matemáticos Básicos e Aritmética

Símbolos de operações, comparações e relações fundamentais.

| Símbolo | Nome Unicode | Code Point (Hex) | Função / Uso |
| --- | --- | --- | --- |
| **+** | `PLUS SIGN` | `U+002B` | Adição |
| **−** | `MINUS SIGN` | `U+2212` | Subtração (diferente do hífen `-`) |
| **×** | `MULTIPLICATION SIGN` | `U+00D7` | Multiplicação |
| **÷** | `DIVISION SIGN` | `U+00F7` | Divisão |
| **=** | `EQUALS SIGN` | `U+003D` | Igualdade |
| **≠** | `NOT EQUAL TO` | `U+2260` | Desigualdade |
| **±** | `PLUS-MINUS SIGN` | `U+00B1` | Mais ou menos |
| **√** | `SQUARE ROOT` | `U+221A` | Raiz quadrada |
| **∞** | `INFINITY` | `U+221E` | Infinito |

---

## 2. Operadores N-Ários e Cálculo

Usados em somatórios, integrais e operações sobre conjuntos.

| Símbolo | Nome Unicode | Code Point (Hex) | Função / Uso |
| --- | --- | --- | --- |
| **∑** | `N-ARY SUMMATION` | `U+2211` | Somatório |
| **∏** | `N-ARY PRODUCT` | `U+220F` | Produtório |
| **∫** | `INTEGRAL` | `U+222B` | Integral |
| **∬** | `DOUBLE INTEGRAL` | `U+222C` | Integral dupla |
| **∮** | `CONTOUR INTEGRAL` | `U+222E` | Integral de linha/contorno |
| **∂** | `PARTIAL DIFFERENTIAL` | `U+2202` | Derivada parcial |
| **∆** | `INCREMENT` / Delta | `U+2206` | Variação / Diferença |

---

## 3. Teoria dos Conjuntos e Lógica Matemática

Símbolos para pertencer, subconjuntos, conectivos lógicos e quantificadores.

| Símbolo | Nome Unicode | Code Point (Hex) | Função / Uso |
| --- | --- | --- | --- |
| **∈** | `ELEMENT OF` | `U+2208` | Pertence |
| **∉** | `NOT AN ELEMENT OF` | `U+2209` | Não pertence |
| **⊂** | `SUBSET OF` | `U+2282` | Subconjunto próprio |
| **⊆** | `SUBSET OF OR EQUAL TO` | `U+2286` | Subconjunto ou igual |
| **∪** | `UNION` | `U+222A` | União |
| **∩** | `INTERSECTION` | `U+2229` | Interseção |
| **∅** | `EMPTY SET` | `U+2205` | Conjunto vazio |
| **∀** | `FOR ALL` | `U+2200` | Para todo (quantificador universal) |
| **∃** | `THERE EXISTS` | `U+2203` | Existe (quantificador existencial) |
| **∧** | `LOGICAL AND` | `U+2227` | Conjunção lógica (E) |
| **∨** | `LOGICAL OR` | `U+2228` | Disjunção lógica (OU) |
| **¬** | `NOT SIGN` | `U+00AC` | Negação lógica |

---

## 4. Conjuntos Numéricos Clássicos (Símbolos de Quadro Negro / *Blackboard Bold*)

Representam os grandes conjuntos de números na matemática. Ficam localizados no bloco de **Símbolos Alfanuméricos Matemáticos**.

| Símbolo | Nome Unicode | Code Point (Hex) | Conjunto |
| --- | --- | --- | --- |
| **ℕ** | `DOUBLE-STRUCK CAPITAL N` | `U+2115` | Números Naturais |
| **ℤ** | `DOUBLE-STRUCK CAPITAL Z` | `U+2124` | Números Inteiros |
| **ℚ** | `DOUBLE-STRUCK CAPITAL Q` | `U+211A` | Números Racionais |
| **ℝ** | `DOUBLE-STRUCK CAPITAL R` | `U+211D` | Números Reais |
| **ℂ** | `DOUBLE-STRUCK CAPITAL C` | `U+2102` | Números Complexos |
| **ℙ** | `DOUBLE-STRUCK CAPITAL P` | `U+2119` | Números Primos / Probabilidade |

---

## 5. Principais Blocos Unicode da Matemática

O Unicode organiza todos esses caracteres em **intervalos (blocos)** específicos para facilitar o desenvolvimento de fontes e interpretadores de texto:

1. **Mathematical Operators (`U+2200` a `U+22FF`):**
* Contém a maioria dos símbolos de álgebra, cálculo, geometria e lógica (`∀`, `∃`, `∈`, `∑`, `√`, `∝`, `∞`, `∫`).


2. **Supplemental Mathematical Operators (`U+2A00` a `U+2AFF`):**
* Operadores avançados e variações de integrais, somatórios e relações teóricas.


3. **Miscellaneous Mathematical Symbols-A (`U+27C0` a `U+27EF`) e B (`U+2980` a `U+29FF`):**
* Delimitadores, parênteses angulares de matrizes/vetores, colchetes brancos e setas especiais.


4. **Mathematical Alphanumeric Symbols (`U+1D400` a `U+1D7FF`):**
* Um bloco gigantesco no *Plano 1* que contém letras latinas e gregas formatadas especificamente para variáveis e matrizes (negrito, itálico, *script*, *fraktur*, *monospace*). Exemplo: $\boldsymbol{A}$ (`U+1D400`) para matrizes em negrito.