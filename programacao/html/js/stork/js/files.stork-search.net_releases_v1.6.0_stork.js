var stork;
(() => {
  "use strict";
  var e = {
      214: (e, t, n) => {
        let r;
        n.r(t),
          n.d(t, {
            default: () => _,
            wasm_register_index: () => v,
            wasm_search: () => y,
            wasm_stork_version: () => w,
          });
        const o = new Array(32).fill(void 0);
        function s(e) {
          return o[e];
        }
        o.push(void 0, null, !0, !1);
        let i = o.length;
        let a = 0,
          l = null;
        function u() {
          return (
            (null !== l && l.buffer === r.memory.buffer) ||
              (l = new Uint8Array(r.memory.buffer)),
            l
          );
        }
        let c = new TextEncoder("utf-8");
        const d =
          "function" == typeof c.encodeInto
            ? function (e, t) {
                return c.encodeInto(e, t);
              }
            : function (e, t) {
                const n = c.encode(e);
                return t.set(n), { read: e.length, written: n.length };
              };
        function h(e, t, n) {
          if (void 0 === n) {
            const n = c.encode(e),
              r = t(n.length);
            return (
              u()
                .subarray(r, r + n.length)
                .set(n),
              (a = n.length),
              r
            );
          }
          let r = e.length,
            o = t(r);
          const s = u();
          let i = 0;
          for (; i < r; i++) {
            const t = e.charCodeAt(i);
            if (t > 127) break;
            s[o + i] = t;
          }
          if (i !== r) {
            0 !== i && (e = e.slice(i)), (o = n(o, r, (r = i + 3 * e.length)));
            const t = u().subarray(o + i, o + r);
            i += d(e, t).written;
          }
          return (a = i), o;
        }
        let f = null;
        function g() {
          return (
            (null !== f && f.buffer === r.memory.buffer) ||
              (f = new Int32Array(r.memory.buffer)),
            f
          );
        }
        let p = new TextDecoder("utf-8", { ignoreBOM: !0, fatal: !0 });
        function m(e, t) {
          return p.decode(u().subarray(e, e + t));
        }
        function v(e, t) {
          try {
            const d = r.__wbindgen_add_to_stack_pointer(-16);
            var n = h(e, r.__wbindgen_malloc, r.__wbindgen_realloc),
              o = a,
              s = (function (e, t) {
                const n = t(1 * e.length);
                return u().set(e, n / 1), (a = e.length), n;
              })(t, r.__wbindgen_malloc),
              i = a;
            r.wasm_register_index(d, n, o, s, i);
            var l = g()[d / 4 + 0],
              c = g()[d / 4 + 1];
            return m(l, c);
          } finally {
            r.__wbindgen_add_to_stack_pointer(16), r.__wbindgen_free(l, c);
          }
        }
        function y(e, t) {
          try {
            const c = r.__wbindgen_add_to_stack_pointer(-16);
            var n = h(e, r.__wbindgen_malloc, r.__wbindgen_realloc),
              o = a,
              s = h(t, r.__wbindgen_malloc, r.__wbindgen_realloc),
              i = a;
            r.wasm_search(c, n, o, s, i);
            var l = g()[c / 4 + 0],
              u = g()[c / 4 + 1];
            return m(l, u);
          } finally {
            r.__wbindgen_add_to_stack_pointer(16), r.__wbindgen_free(l, u);
          }
        }
        function w() {
          try {
            const n = r.__wbindgen_add_to_stack_pointer(-16);
            r.wasm_stork_version(n);
            var e = g()[n / 4 + 0],
              t = g()[n / 4 + 1];
            return m(e, t);
          } finally {
            r.__wbindgen_add_to_stack_pointer(16), r.__wbindgen_free(e, t);
          }
        }
        p.decode();
        const _ = async function e(t) {
          void 0 === t &&
            (t = new URL(
              "stork_bg.wasm",
              (function (e) {
                const t = n.p;
                let r = "";
                return (
                  (!t || t.indexOf("://") < 0) &&
                    (r +=
                      window.location.protocol + "//" + window.location.host),
                  (r += t || "/"),
                  r + e
                );
              })("node_modules/stork-search/stork.js")
            ));
          const l = { wbg: {} };
          (l.wbg.__wbg_new_693216e109162396 = function () {
            return (function (e) {
              i === o.length && o.push(o.length + 1);
              const t = i;
              return (i = o[t]), (o[t] = e), t;
            })(new Error());
          }),
            (l.wbg.__wbg_stack_0ddaca5d1abfb52f = function (e, t) {
              var n = h(s(t).stack, r.__wbindgen_malloc, r.__wbindgen_realloc),
                o = a;
              (g()[e / 4 + 1] = o), (g()[e / 4 + 0] = n);
            }),
            (l.wbg.__wbg_error_09919627ac0992f5 = function (e, t) {
              try {
                console.error(m(e, t));
              } finally {
                r.__wbindgen_free(e, t);
              }
            }),
            (l.wbg.__wbindgen_object_drop_ref = function (e) {
              !(function (e) {
                const t = s(e);
                (function (e) {
                  e < 36 || ((o[e] = i), (i = e));
                })(e);
              })(e);
            }),
            ("string" == typeof t ||
              ("function" == typeof Request && t instanceof Request) ||
              ("function" == typeof URL && t instanceof URL)) &&
              (t = fetch(t));
          const { instance: u, module: c } = await (async function (e, t) {
            if ("function" == typeof Response && e instanceof Response) {
              if ("function" == typeof WebAssembly.instantiateStreaming)
                try {
                  return await WebAssembly.instantiateStreaming(e, t);
                } catch (t) {
                  if ("application/wasm" == e.headers.get("Content-Type"))
                    throw t;
                  console.warn(
                    "`WebAssembly.instantiateStreaming` failed because your server does not serve wasm with `application/wasm` MIME type. Falling back to `WebAssembly.instantiate` which is slower. Original error:\n",
                    t
                  );
                }
              const n = await e.arrayBuffer();
              return await WebAssembly.instantiate(n, t);
            }
            {
              const n = await WebAssembly.instantiate(e, t);
              return n instanceof WebAssembly.Instance
                ? { instance: n, module: e }
                : n;
            }
          })(await t, l);
          return (r = u.exports), (e.__wbindgen_wasm_module = c), r;
        };
      },
      914: (e, t, n) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.calculateOverriddenConfig = t.defaultConfig = void 0);
        var r = n(445),
          o = n(466);
        (t.defaultConfig = {
          showProgress: !0,
          printIndexInfo: !1,
          showScores: !1,
          showCloseButton: !0,
          minimumQueryLength: 3,
          forceOverwrite: !1,
          resultNoun: { singular: "file", plural: "files" },
          onQueryUpdate: void 0,
          onResultSelected: void 0,
          onResultsHidden: void 0,
          onInputCleared: void 0,
          transformResultUrl: function (e) {
            return e;
          },
        }),
          (t.calculateOverriddenConfig = function (e) {
            var n = (0, o.difference)(
              Object.keys(e),
              Object.keys(t.defaultConfig)
            );
            if (n.length > 0) {
              var s = (0, o.plural)(n.length, "key", "keys"),
                i = JSON.stringify(n);
              return new r.default(
                "Invalid ".concat(s, " in config object: ").concat(i)
              );
            }
            for (
              var a = Object.assign({}, t.defaultConfig),
                l = 0,
                u = Object.keys(t.defaultConfig);
              l < u.length;
              l++
            ) {
              var c = u[l],
                d = e[c];
              void 0 !== d && (a[c] = d);
            }
            return a;
          });
      },
      227: (e, t) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.existsBeyondContainerBounds =
            t.setText =
            t.clear =
            t.add =
            t.create =
              void 0),
          (t.create = function (e, t) {
            var n = document.createElement(e);
            return (
              t.classNames && n.setAttribute("class", t.classNames.join(" ")), n
            );
          }),
          (t.add = function (e, t, n) {
            n.insertAdjacentElement(t, e);
          }),
          (t.clear = function (e) {
            for (; e && e.firstChild; ) e.removeChild(e.firstChild);
          }),
          (t.setText = function (e, t) {
            var n = document.createTextNode(t);
            e && e.firstChild
              ? e.replaceChild(n, e.firstChild)
              : e && e.appendChild(n);
          }),
          (t.existsBeyondContainerBounds = function (e, t) {
            var n = e.getBoundingClientRect(),
              r = t.getBoundingClientRect();
            return n.bottom > r.bottom || n.top < r.top;
          });
      },
      934: (e, t, n) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.Entity = void 0);
        var r = n(139),
          o = n(771),
          s = n(214),
          i = n(445),
          a = (function () {
            function e(e, t, n) {
              var r = this;
              (this._state = "initialized"),
                (this.downloadProgress = 0),
                (this.results = []),
                (this.totalResultCount = 0),
                (this.eventListenerFunctions = {}),
                (this.highlightedResult = 0),
                (this.resultsVisible = !1),
                (this.hoverSelectEnabled = !0),
                (this.setDownloadProgress = function (e) {
                  (r.state = "loading"),
                    (r.downloadProgress = e),
                    r.config.showProgress && r.render();
                }),
                (this.name = e),
                (this.url = t),
                (this.config = n);
            }
            return (
              Object.defineProperty(e.prototype, "state", {
                get: function () {
                  return this._state;
                },
                set: function (e) {
                  (this._state = e), this.render();
                },
                enumerable: !1,
                configurable: !0,
              }),
              (e.prototype.getCurrentMessage = function () {
                if (!this.domManager) return null;
                var e = this.domManager.getQuery();
                return "error" === this.state
                  ? "Error! Check the browser console."
                  : "ready" != this.state
                  ? "Loading..."
                  : (null == e ? void 0 : e.length) <
                    this.config.minimumQueryLength
                  ? "Filtering..."
                  : this.results
                  ? 0 === this.totalResultCount
                    ? "No ".concat(this.config.resultNoun.plural, " found.")
                    : 1 === this.totalResultCount
                    ? "1 ".concat(this.config.resultNoun.singular, " found.")
                    : ""
                        .concat(this.totalResultCount, " ")
                        .concat(this.config.resultNoun.plural, " found.")
                  : null;
              }),
              (e.prototype.generateRenderConfig = function () {
                return {
                  results: this.results,
                  resultsVisible: !0,
                  showScores: this.config.showScores,
                  message: this.getCurrentMessage(),
                  showProgress: this.config.showProgress,
                  progress: this.downloadProgress,
                  state: this.state,
                };
              }),
              (e.prototype.render = function () {
                this.domManager &&
                  this.domManager.render(this.generateRenderConfig());
              }),
              (e.prototype.registerIndex = function (e) {
                var t = this;
                return new Promise(function (n, r) {
                  var o = JSON.parse((0, s.wasm_register_index)(t.name, e));
                  o.error
                    ? r(new i.default(o.error))
                    : (t.config.printIndexInfo && console.log(o),
                      (t.state = "ready"),
                      n(o));
                });
              }),
              (e.prototype.attachToDom = function () {
                (this.domManager = new o.EntityDom(this.name, this)),
                  this.render();
              }),
              (e.prototype.injestSearchData = function (e) {
                var t = this;
                (this.results = e.results),
                  (this.totalResultCount = e.total_hit_count),
                  (this.highlightedResult = 0);
                var n = e.url_prefix || "";
                this.results.map(function (e) {
                  var r = "",
                    o = e.excerpts
                      .map(function (e) {
                        return e.internal_annotations;
                      })
                      .filter(function (e) {
                        return !!e;
                      })[0];
                  if (o && o[0]) {
                    var s = o[0];
                    "string" == typeof s.a && (r += s.a);
                  }
                  e.excerpts &&
                    e.excerpts[0] &&
                    e.excerpts[0].internal_annotations &&
                    e.excerpts[0].internal_annotations[0] &&
                    e.excerpts[0].internal_annotations[0].a &&
                    "string" ==
                      typeof e.excerpts[0].internal_annotations[0].a &&
                    (r = e.excerpts[0].internal_annotations[0].a),
                    (e.entry.url = t.config.transformResultUrl(
                      "".concat(n).concat(e.entry.url).concat(r)
                    ));
                }),
                  this.render();
              }),
              (e.prototype.getSanitizedResults = function () {
                var e = this.results;
                return (
                  e.map(function (e) {
                    delete e.title_highlight_ranges,
                      e.excerpts.map(function (e) {
                        delete e.highlight_ranges,
                          delete e.internal_annotations;
                      });
                  }),
                  e
                );
              }),
              (e.prototype.setDownloadError = function () {
                this.state = "error";
              }),
              (e.prototype.performSearch = function (e) {
                if ("ready" === this.state) {
                  if (e.length < this.config.minimumQueryLength)
                    return (this.results = []), void this.render();
                  try {
                    var t = (0, r.resolveSearch)(this.name, e);
                    if (!t) return;
                    this.injestSearchData(t),
                      this.config.onQueryUpdate &&
                        this.config.onQueryUpdate(
                          e,
                          this.getSanitizedResults()
                        );
                  } catch (e) {
                    console.error(e);
                  }
                } else this.render();
              }),
              e
            );
          })();
        t.Entity = a;
      },
      771: (e, t, n) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.EntityDom = void 0);
        var r = n(227),
          o = n(9),
          s = {
            results: [],
            resultsVisible: !1,
            showScores: !1,
            message: null,
            showProgress: !1,
            progress: 1,
            state: "ready",
          },
          i = (function () {
            function e(e, t) {
              var n,
                o,
                i = this;
              (this.scrollAnchorPoint = "end"), (this.entity = t);
              var a = [
                  {
                    selector: 'input[data-stork="'.concat(e, '"]'),
                    elementName: "input",
                  },
                  {
                    selector: 'div[data-stork="'.concat(e, '-output"]'),
                    elementName: "output",
                  },
                ].map(function (t) {
                  var n = document.querySelector(t.selector);
                  if (!n)
                    throw new Error(
                      'Could not register search box "'
                        .concat(e, '": ')
                        .concat(
                          t.elementName,
                          " element not found. Make sure an element matches the query selector `"
                        )
                        .concat(t.selector, "`")
                    );
                  return n;
                }),
                l = a[0],
                u = a[1];
              (this.elements = {
                input: l,
                output: u,
                list: (0, r.create)("ul", { classNames: ["stork-results"] }),
                attribution: (0, r.create)("div", {
                  classNames: ["stork-attribution"],
                }),
                progress: (0, r.create)("div", {
                  classNames: ["stork-progress"],
                }),
                message: (0, r.create)("div", {
                  classNames: ["stork-message"],
                }),
                closeButton: (0, r.create)("button", {
                  classNames: ["stork-close-button"],
                }),
              }),
                this.elements.input.removeEventListener(
                  "input",
                  this.entity.eventListenerFunctions.inputInputEvent
                ),
                this.elements.input.removeEventListener(
                  "keydown",
                  this.entity.eventListenerFunctions.inputKeydownEvent
                ),
                (this.entity.eventListenerFunctions = {
                  inputInputEvent: function (e) {
                    i.handleInputEvent(e);
                  },
                  inputKeydownEvent: function (e) {
                    i.handleKeyDownEvent(e);
                  },
                }),
                this.elements.input.addEventListener(
                  "input",
                  this.entity.eventListenerFunctions.inputInputEvent
                ),
                this.elements.input.addEventListener(
                  "keydown",
                  this.entity.eventListenerFunctions.inputKeydownEvent
                ),
                null === (n = this.elements.list) ||
                  void 0 === n ||
                  n.addEventListener("mousemove", function () {
                    i.hoverSelectEnabled = !0;
                  }),
                (this.elements.attribution.innerHTML =
                  'Powered by <a href="https://stork-search.net">Stork</a>'),
                (this.elements.closeButton.innerHTML =
                  '\n<svg height="0.8em" viewBox="0 0 23 24" xmlns="http://www.w3.org/2000/svg">\n<g fill="none" fill-rule="evenodd" stroke-linecap="round">\n<g transform="translate(-700 -149)" stroke="currentcolor" stroke-width="4">\n<line id="a" x1="702.5" x2="720" y1="152.5" y2="170"/>\n<line transform="translate(711 161) rotate(-90) translate(-711 -161)" x1="702.5" x2="720" y1="152.5" y2="170"/>\n</g>\n</g>\n</svg>'),
                this.entity.config.showProgress &&
                  (0, r.add)(
                    this.elements.progress,
                    "afterend",
                    this.elements.input
                  ),
                null === (o = this.elements.closeButton) ||
                  void 0 === o ||
                  o.addEventListener("click", function () {
                    (i.elements.input.value = ""),
                      i.elements.input.focus(),
                      i.render(s);
                    var e = [
                        i.entity.config.onInputCleared,
                        i.entity.config.onResultsHidden,
                      ],
                      t = e[0],
                      n = e[1];
                    t && t(), n && n();
                  });
            }
            return (
              (e.prototype.clearDom = function () {
                var e;
                (0, r.clear)(this.elements.output),
                  (0, r.clear)(this.elements.list),
                  null === (e = this.elements.closeButton) ||
                    void 0 === e ||
                    e.remove(),
                  this.elements.output.classList.remove("stork-output-visible");
              }),
              (e.prototype.render = function (e) {
                var t,
                  n = this,
                  s = this.elements.input.value;
                if (
                  (this.clearDom(), (this.lastRenderState = e), e.showProgress)
                ) {
                  var i = (function () {
                    switch (e.state) {
                      case "ready":
                      case "error":
                        return 1;
                      case "initialized":
                      case "loading":
                        return 0.9 * e.progress + 0.05;
                    }
                  })();
                  i < 1
                    ? ((this.elements.progress.style.width = "".concat(
                        100 * i,
                        "%"
                      )),
                      (this.elements.progress.style.opacity = "1"))
                    : ((this.elements.progress.style.width = "100%"),
                      (this.elements.progress.style.opacity = "0"));
                }
                if (
                  ("error" === e.state &&
                    this.elements.input.classList.add("stork-error"),
                  this.getQuery().length > 0 &&
                    e.resultsVisible &&
                    (this.elements.output.classList.add("stork-output-visible"),
                    (0, r.add)(
                      this.elements.message,
                      "beforeend",
                      this.elements.output
                    )),
                  e.message && (0, r.setText)(this.elements.message, e.message),
                  (null === (t = e.results) || void 0 === t
                    ? void 0
                    : t.length) > 0 && e.resultsVisible)
                ) {
                  (0, r.add)(
                    this.elements.list,
                    "beforeend",
                    this.elements.output
                  );
                  for (
                    var a = function (t) {
                        var s = e.results[t],
                          i = {
                            selected: t === l.highlightedResult,
                            showScores: e.showScores,
                          },
                          a = (0, o.resultToListItem)(s, i);
                        (0, r.add)(a, "beforeend", l.elements.list),
                          a.addEventListener("mousemove", function () {
                            n.hoverSelectEnabled &&
                              t !== n.highlightedResult &&
                              n.changeHighlightedResult({
                                to: t,
                                shouldScrollTo: !1,
                              });
                          }),
                          a.addEventListener("mouseleave", function () {
                            n.hoverSelectEnabled &&
                              t === n.highlightedResult &&
                              n.changeHighlightedResult({
                                to: -1,
                                shouldScrollTo: !1,
                              });
                          }),
                          a.addEventListener("click", function (e) {
                            e.preventDefault(), n.selectResult();
                          });
                      },
                      l = this,
                      u = 0;
                    u < e.results.length;
                    u++
                  )
                    a(u);
                  (0, r.add)(
                    this.elements.attribution,
                    "beforeend",
                    this.elements.output
                  );
                }
                ((null == s ? void 0 : s.length) || 0) > 0 &&
                  this.entity.config.showCloseButton &&
                  (0, r.add)(
                    this.elements.closeButton,
                    "afterend",
                    this.elements.input
                  );
              }),
              (e.prototype.selectResult = function () {
                if (null != this.highlightedResult) {
                  var e = this.entity.results[this.highlightedResult];
                  this.entity.config.onResultSelected
                    ? Promise.resolve(
                        this.entity.config.onResultSelected(this.getQuery(), e)
                      ).finally(function () {
                        window.location.assign(e.entry.url);
                      })
                    : window.location.assign(e.entry.url);
                }
              }),
              (e.prototype.changeHighlightedResult = function (e) {
                var t,
                  n = this.highlightedResult,
                  o = Math.max(
                    -1,
                    Math.min(this.entity.results.length - 1, e.to)
                  );
                (this.highlightedResult = o),
                  (this.scrollAnchorPoint = (n || 0) < o ? "end" : "start");
                for (var s = null, i = 0; i < this.entity.results.length; i++) {
                  var a =
                    null === (t = this.elements.list) || void 0 === t
                      ? void 0
                      : t.children[i];
                  if (a) {
                    var l = "selected";
                    i == o
                      ? (a.classList.add(l), (s = a))
                      : a.classList.remove(l);
                  }
                }
                return (
                  e.shouldScrollTo &&
                    ((this.hoverSelectEnabled = !1),
                    s &&
                      (0, r.existsBeyondContainerBounds)(
                        s,
                        this.elements.list
                      ) &&
                      s.scrollIntoView({
                        behavior: "smooth",
                        block: this.scrollAnchorPoint,
                        inline: "nearest",
                      })),
                  o
                );
              }),
              (e.prototype.handleKeyDownEvent = function (e) {
                switch (e.keyCode) {
                  case 40:
                    if (null == this.highlightedResult)
                      this.changeHighlightedResult({
                        to: 0,
                        shouldScrollTo: !0,
                      });
                    else {
                      var t = Math.min(
                        this.highlightedResult + 1,
                        this.entity.results.length - 1
                      );
                      this.changeHighlightedResult({
                        to: t,
                        shouldScrollTo: !0,
                      });
                    }
                    break;
                  case 38:
                    null != this.highlightedResult &&
                      ((t = Math.max(0, this.highlightedResult - 1)),
                      this.changeHighlightedResult({
                        to: t,
                        shouldScrollTo: !0,
                      }));
                    break;
                  case 13:
                    this.selectResult();
                    break;
                  case 27:
                    if (this.lastRenderState.resultsVisible)
                      this.render(s),
                        (n = this.entity.config.onResultsHidden) && n();
                    else if (this.elements.input.value.length > 0) {
                      var n;
                      (this.elements.input.value = ""),
                        this.render(s),
                        (n = this.entity.config.onInputCleared) && n();
                    }
                    break;
                  default:
                    return;
                }
              }),
              (e.prototype.handleInputEvent = function (e) {
                this.entity.performSearch(e.target.value);
              }),
              (e.prototype.getQuery = function () {
                return this.elements.input.value;
              }),
              e
            );
          })();
        t.EntityDom = i;
      },
      129: function (e, t, n) {
        var r =
          (this && this.__assign) ||
          function () {
            return (
              (r =
                Object.assign ||
                function (e) {
                  for (var t, n = 1, r = arguments.length; n < r; n++)
                    for (var o in (t = arguments[n]))
                      Object.prototype.hasOwnProperty.call(t, o) &&
                        (e[o] = t[o]);
                  return e;
                }),
              r.apply(this, arguments)
            );
          };
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.debug = t.entityIsReady = t.attachToDom = t.register = void 0);
        var o = n(934),
          s = n(914),
          i = n(794),
          a = n(258),
          l = n(445),
          u = {};
        (t.register = function (e, t, n) {
          return new Promise(function (r, c) {
            var d = (0, s.calculateOverriddenConfig)(n);
            if (d instanceof l.default) c(d);
            else {
              u[e] &&
                !d.forceOverwrite &&
                c(
                  new l.default(
                    "You're registering an index named `".concat(
                      e,
                      "`, but that already exists. If this is expected, set forceOverwrite to true in your Javascript config to allow overwriting indexes."
                    )
                  )
                );
              var h = new o.Entity(e, t, d);
              (u[e] = h),
                (0, i.loadIndexFromUrl)(t, {
                  progress: function (e) {
                    h.setDownloadProgress(e);
                  },
                  load: function (e) {
                    (0, a.runAfterWasmLoaded)(
                      function () {
                        h.registerIndex(new Uint8Array(e)).then(r).catch(c);
                      },
                      function () {
                        h.state = "error";
                      }
                    );
                  },
                  error: function () {
                    h.setDownloadError(), c();
                  },
                });
            }
          });
        }),
          (t.attachToDom = function (e) {
            if (!u[e])
              throw new Error("Index ".concat(e, " has not been registered!"));
            u[e].attachToDom();
          }),
          (t.entityIsReady = function (e) {
            var t;
            return (
              "ready" ===
              (null === (t = u[e]) || void 0 === t ? void 0 : t.state)
            );
          }),
          (t.debug = function () {
            return { entities: r({}, u), entitiesCount: u.length };
          });
      },
      794: (e, t) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.loadIndexFromUrl = void 0),
          (t.loadIndexFromUrl = function (e, t) {
            var n = new XMLHttpRequest();
            n.addEventListener("load", function (e) {
              var n = e.target,
                r = n.status,
                o = n.response;
              0 !== r
                ? r < 200 || r > 299
                  ? t.error()
                  : t.load(o)
                : t.progress(e.loaded / e.total);
            }),
              n.addEventListener("error", function () {
                t.error();
              }),
              n.addEventListener("progress", function (e) {
                t.progress(e.loaded / e.total);
              }),
              (n.responseType = "arraybuffer"),
              n.open("GET", e),
              n.send();
          });
      },
      480: function (e, t, n) {
        var r =
          (this && this.__assign) ||
          function () {
            return (
              (r =
                Object.assign ||
                function (e) {
                  for (var t, n = 1, r = arguments.length; n < r; n++)
                    for (var o in (t = arguments[n]))
                      Object.prototype.hasOwnProperty.call(t, o) &&
                        (e[o] = t[o]);
                  return e;
                }),
              r.apply(this, arguments)
            );
          };
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.debug =
            t.register =
            t.search =
            t.attach =
            t.downloadIndex =
            t.initialize =
              void 0);
        var o = n(129),
          s = n(258),
          i = n(139),
          a = n(445),
          l = n(34),
          u = n(214);
        function c(e) {
          return (
            void 0 === e && (e = null), (0, s.loadWasm)(e).then(function () {})
          );
        }
        function d(e, t, n) {
          return (
            void 0 === n && (n = {}),
            new Promise(function (r, s) {
              var i = (0, l.validateIndexParams)(e, t);
              i ? s(i) : (0, o.register)(e, t, n).then(r).catch(s);
            })
          );
        }
        function h(e) {
          try {
            (0, o.attachToDom)(e);
          } catch (e) {
            throw new a.default(e.message);
          }
        }
        (t.initialize = c),
          (t.downloadIndex = d),
          (t.attach = h),
          (t.register = function (e, t, n) {
            void 0 === n && (n = {});
            var r = c(),
              o = d(e, t, n);
            return h(e), Promise.all([r, o]).then();
          }),
          (t.search = function (e, t) {
            if (!e || !t)
              throw new a.default(
                "Make sure to call stork.search() with two arguments: the index name and the search query."
              );
            if (!(0, o.entityIsReady)(e))
              throw new a.default(
                "Couldn't find index. Make sure the stork.downloadIndex() promise has resolved before calling stork.search()."
              );
            return (0, i.resolveSearch)(e, t);
          }),
          (t.debug = function () {
            return r(r(r({}, (0, s.debug)()), (0, o.debug)()), {
              jsStorkVersion: "1.6.0",
              wasmStorkVersion: u.wasm_stork_version,
            });
          });
      },
      112: (e, t) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.highlight = void 0),
          (t.highlight = function (e, t) {
            function n(e, t, n) {
              return e.substr(0, t) + n + e.substr(t);
            }
            for (var r = 0, o = 0, s = t; o < s.length; o++) {
              var i = s[o],
                a = '<mark class="stork-highlight">',
                l = "</mark>";
              (e = n(e, i.beginning + r, a)),
                (r += a.length),
                (e = n(e, i.end + r, l)),
                (r += l.length);
            }
            return e;
          });
      },
      9: (e, t, n) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.resultToListItem = void 0);
        var r = n(112);
        t.resultToListItem = function (e, t) {
          var n = document.createElement("template");
          return (
            (n.innerHTML = '\n<li class="stork-result'
              .concat(t.selected ? " selected" : "", '">\n  <a href="')
              .concat(
                e.entry.url,
                '">\n    <div class="stork-title">\n      <p>'
              )
              .concat(
                (0, r.highlight)(e.entry.title, e.title_highlight_ranges || []),
                "</p>\n      "
              )
              .concat(
                t.showScores ? "<code><b>".concat(e.score, "</b></code>") : "",
                "\n    </div>\n    "
              )
              .concat(
                e.excerpts.length > 0
                  ? '<div class="stork-excerpt-container" />'
                  : "",
                "\n    "
              )
              .concat(
                e.excerpts
                  .map(function (e) {
                    return '<div class="stork-excerpt"><p>\n        ...'
                      .concat(
                        (0, r.highlight)(e.text, e.highlight_ranges || []),
                        "...\n        </p>\n        "
                      )
                      .concat(
                        t.showScores ? "<code>".concat(e.score, "</code>") : "",
                        "\n        </div>"
                      );
                  })
                  .join(""),
                "\n        "
              )
              .concat(
                e.excerpts.length > 0 ? "</div>" : "",
                "\n  </a>\n</li>"
              )),
            n.content.firstElementChild
          );
        };
      },
      139: (e, t, n) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.resolveSearch = void 0);
        var r = n(214),
          o = n(445);
        t.resolveSearch = function (e, t) {
          var n = null,
            s = null;
          try {
            (n = (0, r.wasm_search)(e, t)), (s = JSON.parse(n));
          } catch (e) {
            throw new o.default(
              "Could not parse data from wasm_search. If you see this, please file a bug: https://jil.im/storkbug " +
                n
            );
          }
          if (!s) throw new o.default("Data was an empty object");
          if (s.error)
            throw new o.default(
              "Could not perform search: the WASM binary failed to return search results.\n    You might not be serving your search index properly.\n    If you think this is an error, please file a bug: https://jil.im/storkbug\n    \n    The WASM binary came back with:\n    ".concat(
                s.error
              )
            );
          return s;
        };
      },
      445: function (e, t) {
        var n,
          r =
            (this && this.__extends) ||
            ((n = function (e, t) {
              return (
                (n =
                  Object.setPrototypeOf ||
                  ({ __proto__: [] } instanceof Array &&
                    function (e, t) {
                      e.__proto__ = t;
                    }) ||
                  function (e, t) {
                    for (var n in t)
                      Object.prototype.hasOwnProperty.call(t, n) &&
                        (e[n] = t[n]);
                  }),
                n(e, t)
              );
            }),
            function (e, t) {
              if ("function" != typeof t && null !== t)
                throw new TypeError(
                  "Class extends value " +
                    String(t) +
                    " is not a constructor or null"
                );
              function r() {
                this.constructor = e;
              }
              n(e, t),
                (e.prototype =
                  null === t
                    ? Object.create(t)
                    : ((r.prototype = t.prototype), new r()));
            });
        Object.defineProperty(t, "__esModule", { value: !0 });
        var o = (function (e) {
          function t(t) {
            var n = e.call(this, t) || this;
            return (n.name = "StorkError"), n;
          }
          return r(t, e), t;
        })(Error);
        t.default = o;
      },
      466: (e, t) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.plural = t.difference = t.htmlToElement = void 0),
          (t.htmlToElement = function (e) {
            var t = document.createElement("template");
            return (e = e.trim()), (t.innerHTML = e), t.content.firstChild;
          }),
          (t.difference = function (e, t) {
            var n = new Set(e),
              r = new Set(t),
              o = new Set(
                Array.from(n).filter(function (e) {
                  return !r.has(e);
                })
              );
            return Array.from(o);
          }),
          (t.plural = function (e, t, n) {
            return 1 == e ? t : n;
          });
      },
      34: (e, t, n) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.validateIndexParams = void 0);
        var r = n(445);
        t.validateIndexParams = function (e, t) {
          return "string" != typeof e
            ? new r.default("Index registration name must be a string.")
            : "string" != typeof t
            ? new r.default("URL must be a string.")
            : null;
        };
      },
      258: (e, t, n) => {
        Object.defineProperty(t, "__esModule", { value: !0 }),
          (t.debug = t.loadWasm = t.runAfterWasmLoaded = void 0);
        var r = n(214),
          o = n(445),
          s = "1.6.0",
          i = s
            ? "https://files.stork-search.net/releases/v".concat(
                s,
                "/stork.wasm"
              )
            : "https://files.stork-search.net/stork.wasm",
          a = null,
          l = null,
          u = [],
          c = [];
        (t.loadWasm = function (e) {
          if ((void 0 === e && (e = null), l)) return l;
          var t = e || i;
          a = t;
          var n = (0, r.default)(t)
            .then(function () {
              return d(), t;
            })
            .catch(function () {
              throw (
                (h(), new o.default("Error while loading WASM at ".concat(t)))
              );
            });
          return (l = n), n;
        }),
          (t.runAfterWasmLoaded = function (e, t) {
            return l
              ? (l
                  .then(function () {
                    return e();
                  })
                  .catch(function () {
                    return t();
                  }),
                l)
              : (u.push(e), c.push(t), null);
          });
        var d = function () {
            u.forEach(function (e) {
              e();
            }),
              (u = []);
          },
          h = function () {
            c.forEach(function (e) {
              e();
            }),
              (c = []);
          };
        t.debug = function () {
          return {
            wasmSourceUrl: a,
            wasmLoadPromise: l,
            queueLength: u.length,
          };
        };
      },
    },
    t = {};
  function n(r) {
    var o = t[r];
    if (void 0 !== o) return o.exports;
    var s = (t[r] = { exports: {} });
    return e[r].call(s.exports, s, s.exports, n), s.exports;
  }
  (n.d = (e, t) => {
    for (var r in t)
      n.o(t, r) &&
        !n.o(e, r) &&
        Object.defineProperty(e, r, { enumerable: !0, get: t[r] });
  }),
    (n.g = (function () {
      if ("object" == typeof globalThis) return globalThis;
      try {
        return this || new Function("return this")();
      } catch (e) {
        if ("object" == typeof window) return window;
      }
    })()),
    (n.o = (e, t) => Object.prototype.hasOwnProperty.call(e, t)),
    (n.r = (e) => {
      "undefined" != typeof Symbol &&
        Symbol.toStringTag &&
        Object.defineProperty(e, Symbol.toStringTag, { value: "Module" }),
        Object.defineProperty(e, "__esModule", { value: !0 });
    }),
    (() => {
      var e;
      n.g.importScripts && (e = n.g.location + "");
      var t = n.g.document;
      if (!e && t && (t.currentScript && (e = t.currentScript.src), !e)) {
        var r = t.getElementsByTagName("script");
        r.length && (e = r[r.length - 1].src);
      }
      if (!e)
        throw new Error(
          "Automatic publicPath is not supported in this browser"
        );
      (e = e
        .replace(/#.*$/, "")
        .replace(/\?.*$/, "")
        .replace(/\/[^\/]+$/, "/")),
        (n.p = e);
    })();
  var r = n(480);
  stork = r;
})();
//# sourceMappingURL=stork.js.map
