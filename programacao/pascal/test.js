	
{CONTROLE PRINCIPAR DO SISTEMA DO SISTEMA}

{$H-}
unit Int;
  {$I z:\TV32\MarIcaraiV1\source\rtl\Platform_inc.pas}

interface

Uses
  classes,
  {$I z:\TV32\MarIcaraiV1\source\rtl\turbo_inc.pas    },
  {$I z:\TV32\MarIcaraiV1\source\TV\TVision_inc.pas  },
  {$I z:\TV32\MarIcaraiV1\TvDmx\TvDmx_Inc.pas    },
  {$I z:\TV32\MarIcaraiV1\db\db_units_inc.pas },
  {$I z:\TV32\gcic\gcic_ec\GCIC_TV_EC\PROJECT\Units\fontes_inc.pas},


  IntDupR,
  intutil,
  ObjProdE,

  ObjProdR,
  ObjCCust,
  Cta0304,

  intcr,
  intcp,
  IntDup,
  ObjComis,
  zUsuario_Operador, zUsuario_Lider,
  xUsuario,

  xLanAut,
  xxLanAut,
  zVendedo,
  xxCCusto,
  zBancos,
  xxNatOpe,
  Intle,
  XLog,
  XUsuaLog,
  InfoSist,xxPlanoC,EditMenu

  ,xxMovCta,
  MyApp,
  ZParametros,comandos

  ,ViDialog,db_Param

 ;


  TYPE
    TApp_GCIC_EC_Tv32 =  Class(TAppPrn)
     Public Constructor Create(AOwner: TComponent);Overload;Override;

    Public
      function MenuItems_Arquivos(aNext: PMenuItem): PMenuItem;Override;
      procedure CreateStatusLine; Override;
      procedure Run_Application(aApplication:TApplication;Event : TEvent;OkDestroy:Boolean);Overload;Override;
      Procedure ExecModuloCorrente(Const AModuloCorrente : TipoSistemaIntegrado;var Event : TEvent);Overload;
      Procedure ExecModuloCorrente(Const AModuloCorrente : TipoSistemaIntegrado);Overload;

      procedure HandleEvent(var Event : TEvent);  Override;
      function Execute: Word; Override;
   end;



Implementation
uses
  ViEditor, VPSysLow, Reprocessamento, Reindex,_ImGCIC,
  XDup, xFilial, Unit_Versao_Contabilidade_Integrada,Vi_Password , xPlanoC, Xnf_it, X_Contatos
  ,RM01_Venda_dos_vendedores_por_Canal_de_atendimento_em_quantidade
  //Unit_Cadastra_InputBox,
// , uITMS_UI_Form_Console_Main
//  ,Unit_DDE_Client_GCIC_EC
  , CMCT
  ,Form_Console_Main_u;


constructor TApp_GCIC_EC_Tv32.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

end;

function TApp_GCIC_EC_Tv32.MenuItems_Arquivos(aNext: PMenuItem): PMenuItem;
Begin
  MenuItems_Arquivos :=
    NewSubMenu('~A~)rquivos'           , hcNoContext,
      NewMenu(
        NewItem   ('Cmd temporario...','' ,  kbNoKey  ,Cm_Temp, hcNoContext,

        NewItem   ('~D~ata do processamento...','' ,  kbNoKey  ,CmLerDataAtual, hcNoContext,
{        NewSubMenu('~C~adastros', hcNoContext, NewMenu(MenuItems_Cadastros(nil)),}
        NewSubMenu('C~o~)nfigura‡äes', hcNoContext, NewMenu(
//          MI_Connection_GCIC.ArqNUsuario.NewImprimeFiltroItem(hcNoContext,
          NewVideoItem(hcNoContext,  { this item appears only on hi-res systems }
          NewItem('~T~roca ano de processamento...','' ,  kbNoKey  ,Cm_Troca_ano_de_processamento, hcNoContext,
          NewItem   ('~I~mpressoras'                 ,'' ,  kbNoKey  ,CmCadastraImpressoraLocal, hcNoContext,
          NewItem('~P~arƒmetros...'     ,'' ,  kbNoKey  ,CmParametros, hcNoContext,
          NewSubMenu('Cores da interface', hcNoContext, NewMenu(
            NewItem('~S~eleciona...'       ,'' ,  kbNoKey  ,cmCores, hcNoContext,
            NewItem('~E~dita ...','', kbNoKey,cmEditaCores, hcNoContext,
            NewItem('~S~alva como...','', kbNoKey,cmSalvaCores, hcNoContext,
          nil)))),

        nil)))))){)},

{        NewItem('E~x~ecutar...','Alt+X' ,kbAltX,CmExecutar, hcNoContext,}
        NewSubMenu('E~x~ecutar comando', hcNoContext, NewMenu(
          NewItem('Executar...','Alt+X' ,kbAltX,CmExecutar, hcNoContext,
          NewItem('Op‡äes','' ,kbNoKey,CmListMenu, hcNoContext,
        nil))),

        NewItem('Setup Impressora...','',kbNoKey ,cmPRN_SetOptions, hcNoContext,
        NewItem('~I~)mprime...','',kbNoKey ,cmPrint, hcNoContext,

        NewSubMenu('~E~)ncerramento do exerc¡cio', hcNoContext, NewMenu(
          NewItem('A~p~ura o resultado do exerc¡cio...'   ,'', kbNoKey,CmApuraOResultado,hcNoContext,
          NewItem('An~u~la a apura‡Æo do resultado do exerc¡cio...'   ,'', kbNoKey,CmAnulaapuraOResultado,hcNoContext,
          NewItem ('~E~ncerramento anual...'  ,'',kbNoKey,CmEncerramentoAnual, hcNoContext,
        nil)))),

        NewSubMenu('~F~)erramentas do sistema', hcNoContext, NewMenu(
{          NewItem('~A~ssistente de Manuten‡Æo','' ,KbShiftF9,CmAssistente_de_Manutencao, hcNoContext,}
          NewSubMenu('~M~)anuten‡Æo', hcNoContext, NewMenu(
             NewItem(sgc('~C~)ria índices dos arquivos...')       ,'' ,kbNoKey,CmCriaIndiceTodosArquivos, hcNoContext,
             NewItem('~R~)eprocessamento...'                 ,'' ,kbNoKey,CmReprocessaIntegrado, hcNoContext,
          nil))),

          NewSubMenu('Integra com os Governos Estadual e Municipal', hcNoContext, NewMenu(
            NewItem(sgc('Exporta para a DIEF Ceará...') ,'' ,kbNoKey,Cm_Exporta_para_a_DIEF_Ceara, hcNoContext,
            NewItem(sgc('Exporta para a DDS Fortaleza...') ,'' ,kbNoKey,Cm_Exporta_para_a_DDS_Fortaleza , hcNoContext,
          nil))),

      MenuItems_Import(
      MenuItems_Export(

          NewItem(sgc('~I~nformações do sistema')  ,'Shift F9' ,KbShiftF9,CmInfoSystem, hcNoContext,
          NewItem(sgc('~I~)nicializa saldo do exercício corrente...')  ,'',kbNoKey,Cm_Atualiza_Saldo_do_inicio_do_Exercicio, hcNoContext,

        nil))))))),

        NewSubMenu('~A~)cess¢rios', hcNoContext, NewMenu(
           NewItem('~C~)alculadora' ,'F9' ,  kbF9   , cmMathCalc, hcNoContext,
           NewItem('Cria ~m)~acro em forma de atalho no desktop do windows...' ,'F12' , kbF12  , CmCreate_Shortcut, hcNoContext,
        nil))),
        NewLine(
        NewItem ('~S~)air',  'Alt-S'    ,kbAltS, cmQuit,   hcNoContext,
        NewLine(
        NewItemParametros(nil)))))))))))))){)},
   anext);
end;


procedure TApp_GCIC_EC_Tv32.CreateStatusLine;
begin
  StatusLine := nil;
  If ParamExecucao.Tipo_de_Execucao in [TParamExecucao_Tipo_de_Execucao_Normal,TParamExecucao_Tipo_de_Execucao_Normal_Sem_Pedir_Senha]
  Then Begin
          GetExtent(R);
          R.A.Y := R.B.Y - 1;
          StatusLine := TStatusLine.Create(R,
                     NewStatusDef(0, $FFFF,
                       NewStatusKey('~Alt+S~ Sair'  , kbAltS, cmQuit,
                       NewStatusKey('~Alt+X~ Executar', kbAltX , CmExecutar,
                     nil)),
                   nil));
       End;
end;


procedure TApp_GCIC_EC_Tv32.Run_Application(aApplication: TApplication; Event: TEvent; OkDestroy: Boolean);
  Var
    wApp_Owner: App.TApplication;
begin
  try
    if (Form_Console_Main <>nil)
    then Begin
           wApp_Owner := Form_Console_Main.SET_App_Owner(aApplication);
         End;

  inherited Run_Application(aApplication,Event,OkDestroy);

  finally
    if (Form_Console_Main <>nil)
    then Begin
           Form_Console_Main.SET_App_Owner(wApp_Owner);
         End;

    //Se o programa foi executado apartir de gcic_vcl então finalizar a cessão
    If application.ParamExecucao.Tipo_de_Execucao in [TParamExecucao_Tipo_de_Execucao_Normal_Sem_Pedir_Senha,
                                        TParamExecucao_Tipo_de_Execucao_VCL,
                                        TParamExecucao_Tipo_de_Execucao_CGI,
                                        TParamExecucao_Tipo_de_Execucao_ISAPI]
    then begin
           App.Application.Terminated :=Execute_Finish;
    end;

  end;
end;

Procedure TApp_GCIC_EC_Tv32.ExecModuloCorrente(Const AModuloCorrente : TipoSistemaIntegrado;var Event : TEvent);
VAR
  WModuloCorrente : TipoSistemaIntegrado;
Begin
    CloseAllDmx;
    TRY
      WModuloCorrente := SetModuloCorrente(AModuloCorrente);

      Case GetModuloCorrente of
        CContabilidade : Run_Application(TAppCt.Create(self),Event);

        CEstoque       : Run_Application(TAppEs.Create(self),Event);

        CPedidoCompra  : Run_Application(TAppPc.Create(self),Event);

        CLivroDeEntrada: Run_Application(TAppLe.Create(self),Event);

        CPedidoVenda   : Run_Application(TAppPv.Create(self),Event);

        CNFe_Saida    : Begin

                        End;

        CLivroDeSaida  : Run_Application(TAppLs.Create(self),Event);

        CReceber       : Run_Application(TAppCr.Create(self),Event);

        CPagar         : Run_Application(TAppCp.Create(self),Event);

        CCaixaBancos   : Run_Application(TAppCx.Create(self),Event);

    {   CUltSistemaIntegrado  : _ImGCIC.ExecEvent(FNomeDoSistema,ModuloCorrente,ParamExecucao.NomeDeArquivosGenericos);}
      End;


    Finally
      SetModuloCorrente(wModuloCorrente);
      SysSetConsoleTitle(FNomeDoSistema);//+' -> Empresa: '+ParamExecucao.Identificacao.RazaoSocial);


    END;
End;

Procedure TApp_GCIC_EC_Tv32.ExecModuloCorrente(Const AModuloCorrente : TipoSistemaIntegrado);
  Var
    Event : TEvent;
Begin
  self.ClearEvent(Event);
  ExecModuloCorrente(AModuloCorrente,Event);
End;

procedure TApp_GCIC_EC_Tv32.HandleEvent(var Event : TEvent);
  Var
    i : Byte;
begin

{  If (not VidisTAppPrn_HandleEvent) and ((Event.What = evBroadcast) or (Event.What = evCommand)) And CommandEnabled(Event.Command) Then
  Case Event.Command of

    Cm_CTRL_CLOSE_EVENT,
    Cm_CTRL_LOGOFF_EVENT,
    Cm_CTRL_SHUTDOWN_EVENT,
    CmQuit :
    begin
       VidisTAppPrn_HandleEvent := true;
       If MessageBox('Deseja encerrar o GCIC',nil,mfConfirmation OR mfYesNo + mfInsertInApp,CmYes)<>CmYes
       Then begin
              ClearEvent(Event);
              VidisTAppPrn_HandleEvent := false;
              exit;
            end;

       VidisTAppPrn_HandleEvent := false;
       Event.Command := CmQuit;
    End;
  End;}


  Inherited HandleEvent(Event);
  If (Event.What = evCommand) and CommandEnabled(Event.Command)
  Then begin
    //FEntrouEm('-',Event.Command);
    Case Event.Command of
      CmControleDoContasAPagar      : ExecModuloCorrente(CPagar);
      CmControleDoContasAReceber    : ExecModuloCorrente(CReceber);
      CmControleDeEstoques          : ExecModuloCorrente(CEstoque);
      CmContabilidade               : ExecModuloCorrente(CContabilidade);
      CmControleDoCaixaBancos       : ExecModuloCorrente(CCaixaBancos);

      CmPedidoDeCompra              : ExecModuloCorrente(CPedidoCompra);
      CmPedidoDeVenda               : ExecModuloCorrente(CPedidoVenda);
      CmControleDeCompras           : ExecModuloCorrente(CLivroDeEntrada);
      CmControleDoFaturamento       : ExecModuloCorrente(CLivroDeSaida);
      CmNFe_Saida                   : Begin end;

      CmCriaIndiceTodosArquivos     :  If MI_Connection_GCIC.ArqNUsuario.MsgBoxCommandEnabled(CSistemaIntegrado,Event.Command)
                                        Then CriaIndiceTodosArquivos(True);
                                       //_ImGCIC.ExecEvent(CUltSistemaIntegrado,Event);

         CmReprocessaIntegrado      : If MI_Connection_GCIC.ArqNUsuario.MsgBoxCommandEnabled(CSistemaIntegrado,Event.Command)
                                      Then ReprocessaIntegrado(True);

          CmEncerramentoAnual       : If MI_Connection_GCIC.ArqNUsuario.MsgBoxCommandEnabled(CSistemaIntegrado,Event.Command)
                                      Then If EncerramentoAnual
                                          Then PutEvent(CreateEvent(TopView,EvCommand,CmCriaIndiceTodosArquivos,Self)^);

{      Cm_Exporta_para_a_DIEF_Ceara : If MI_Connection_GCIC.ArqNUsuario.MsgBoxCommandEnabled(CSistemaIntegrado,Event.Command)
                                     Then Run_Import_All_do_GCIC_EC_para_DIEF_Ceara;
      Cm_Exporta_para_a_DDS_Fortaleza   : _ImGCIC.ExecEvent(CUltSistemaIntegrado,Event);
}

      Cm_Atualiza_Saldo_do_inicio_do_Exercicio : Begin
                                 Atualiza_Saldo_do_inicio_do_Exercicio;
                               end;

      CmApuraOResultado             : apuraOResultado;
      CmAnulaapuraOResultado        : AnulaapuraOResultado;

      Cm_Temp,
      Cm_Troca_ano_de_processamento,

      CmUsuarioI,
      CmUsuarioA,
      CmUsuarioE ,

      CmTrocaSenha                ,
      cmCores                     ,
      cmEditaCores,
      cmSalvaCores,

      CmCadastraImpressoraLocal   ,

      Cm_Arq_Plano_de_PagamentoI,
      Cm_Arq_Plano_de_PagamentoA,
      Cm_Arq_Plano_de_PagamentoE,

      Cm_X_CNAEI,
      Cm_X_CNAEA,
      Cm_X_CNAEE,


      CmCadastroDeFiliaisI        ,
      CmCadastroDeFiliaisA        ,
      CmCadastroDeFiliaisE        ,

      Cm_Cadastra_grupos_de_produtos,
      CmManutencaoArqProdutoI     ,
      CmManutencaoArqProdutoA     ,
      CmManutencaoArqProdutoE     ,

      CmManutencaoArqClienteI     ,
      CmManutencaoArqClienteA     ,
      CmManutencaoArqClienteE     ,

      CmManutencaoArqFornecedorI  ,
      CmManutencaoArqFornecedorA  ,
      CmManutencaoArqFornecedorE  ,

      CmRotasI,
      CmRotasA,
      CmRotasE,

      CmCadastroDosVendedoresI    ,
      CmCadastroDosVendedoresA    ,
      CmCadastroDosVendedoresE    ,

      CmCadastroDasRegioesI       ,
      CmCadastroDasRegioesA       ,
      CmCadastroDasRegioesE       ,

      CmCadastroDosBancosI        ,
      CmCadastroDosBancosA        ,
      CmCadastroDosBancosE        ,


      CmManutencaoArqCCustoI      ,
      CmManutencaoArqCCustoA      ,
      CmManutencaoArqCCustoE      ,

      CmClassesI          ,
      CmClassesA          ,
      CmClassesE          ,

      CmManutencaoArqPlanoDeContasI   ,
      CmManutencaoArqPlanoDeContasA   ,
      CmManutencaoArqPlanoDeContasE   ,


      Cm_ReceitasI,
      Cm_ReceitasA,
      Cm_ReceitasE,

      Cm_DespesasI,
      Cm_DespesasA,
      Cm_DespesasE,

{      Cm_Cliente_Cartao_de_CreditoI ,
      Cm_Cliente_Cartao_de_CreditoA ,
      Cm_Cliente_Cartao_de_CreditoE,}

      Cm_LE_LancamentoAutomaticoI,
      Cm_LE_LancamentoAutomaticoA,
      Cm_LE_LancamentoAutomaticoE,


      {Lancamentos automaticos do livro de saida}
      Cm_LS_LancamentoAutomaticoI ,
      Cm_LS_LancamentoAutomaticoA ,
      Cm_LS_LancamentoAutomaticoE ,

      {Lancamentos automaticos do contas a pagar}
      Cm_CP_LancamentoAutomaticoI ,
      Cm_CP_LancamentoAutomaticoA ,
      Cm_CP_LancamentoAutomaticoE ,

      Cm_Cp_LancamentoAutomaticoAoBaixarI ,
      Cm_Cp_LancamentoAutomaticoAoBaixarA ,
      Cm_Cp_LancamentoAutomaticoAoBaixarE ,

      {Lancamentos automaticos do contas a receber}
      Cm_CR_LancamentoAutomaticoI ,
      Cm_CR_LancamentoAutomaticoA ,
      Cm_CR_LancamentoAutomaticoE ,

      Cm_Cr_LancamentoAutomaticoAoBaixarI ,
      Cm_Cr_LancamentoAutomaticoAoBaixarA ,
      Cm_Cr_LancamentoAutomaticoAoBaixarE ,


      {Lancamentos automaticos do Caixa/Bancos - Recebimentos}
      CmLancamentoAutomaticoCxBRecebimentosI ,
      CmLancamentoAutomaticoCxBRecebimentosA ,
      CmLancamentoAutomaticoCxBRecebimentosE ,


      {Lancamentos automaticos do Caixa/Bancos - Pagamentos}
      CmLancamentoAutomaticoCxBPagamentosI ,
      CmLancamentoAutomaticoCxBPagamentosA ,
      CmLancamentoAutomaticoCxBPagamentosE ,


      {Lancamentos automaticos do Caixa/Bancos - Transferencias}
      CmLancamentoAutomaticoCxBTransferenciasI ,
      CmLancamentoAutomaticoCxBTransferenciasA ,
      CmLancamentoAutomaticoCxBTransferenciasE ,

      Cm_LE_CadastroDasNatOperacoesI  ,
      Cm_LE_CadastroDasNatOperacoesA  ,
      Cm_LE_CadastroDasNatOperacoesE  ,

      Cm_LS_CadastroDasNatOperacoesI  ,
      Cm_LS_CadastroDasNatOperacoesA  ,
      Cm_LS_CadastroDasNatOperacoesE  ,

      Cm_ES_CadastroDasNatOperacoesI  ,
      Cm_ES_CadastroDasNatOperacoesA  ,
      Cm_ES_CadastroDasNatOperacoesE,

      CmContatosI,
      CmContatosA,
      CmContatosE,

      Cm_Canal_de_VendaE,
      Cm_Canal_de_VendaI,
      Cm_Canal_de_VendaA,

      Cm_Unidade_FederativaI,
      Cm_Unidade_FederativaA,
      Cm_Unidade_FederativaE,

      Cm_MunicipiosI,
      Cm_MunicipiosA,
      Cm_MunicipiosE,

      Cm_ContadoresI,
      Cm_ContadoresA,
      Cm_ContadoresE,

      Cm_Empresas_I,
      Cm_Empresas_A,
      Cm_Empresas_E,

      Cm_AIDF_I,
      Cm_AIDF_A,
      Cm_AIDF_E,

      Cm_AIDF_Forms_Usados_I,
      Cm_AIDF_Forms_Usados_A,
      Cm_AIDF_Forms_Usados_E,


      Cm_Informacoes_Complementar_Documento_Fiscal_I,
      Cm_Informacoes_Complementar_Documento_Fiscal_A,
      Cm_Informacoes_Complementar_Documento_Fiscal_E,

      Cm_Observacoes_do_Lancamento_Fiscal_I,
      Cm_Observacoes_do_Lancamento_Fiscal_A,
      Cm_Observacoes_do_Lancamento_Fiscal_E,



    {Listagens}
        CmListaCadastroDeFiliais         ,
        CmListCadastroDasRegioes         ,
        CmListCadastroDasNatOperacoes_Livre  ,
        Cm_LE_CadastroDasNatOperacoes_List,
        Cm_LS_CadastroDasNatOperacoes_List,
        Cm_ES_CadastroDasNatOperacoes_List,

        CmListCadastroDosBancos          ,

        CmPlanoDeContasProduto           ,
        CmPlanoDeContasProdutoAlfabetica ,
        CmListagemDosParamentrosDosProdutos ,

        CmListaArqCCusto                 ,
        CmListeArqFornecedor             ,
        CmListeArqClientes               ,
        CmPlanoDeContasContabilidade     ,
        CmListCadastroDosVendedores      ,
        CmFluxoDeCaixaDetalhe            ,
        CmListagem_Receitas,
        CmListagem_Despesas,
        CmImportar_DB_From_Excel_xls,
        CmImportar_DB_From_Sped_ECD

        : If Not Comun_HandleEvent(Event) Then Exit;

      Else
       exit;
    end;
    //FSaiuDe('-',Event.Command);
    ClearEvent(Event);
  end {If Event.What = evCommand then begin}
  Else
  If Event.What = evKeyDown Then
  begin
    Case Event.KeyCode of
      kbF1     : If CommandEnabled(CmF1) Then
                 Begin
                   PutEvent(CreateEvent(TopView,EvCommand,CmF1,Self)^);
                   ClearEvent(Event);
                 End
                 else
                 Exit;

      kbAltF1
               : If CommandEnabled(CmAltF1) Then
                 Begin
                   PutEvent(CreateEvent(TopView,EvCommand,CmAltF1,Self)^);
                   ClearEvent(Event);
                 End
                 else
                 Exit;

      kbShiftF1
               : If CommandEnabled(CmShiftF1) Then
                 Begin
                   PutEvent(CreateEvent(TopView,EvCommand,CmShiftF1,Self)^);
                   ClearEvent(Event);
                 End
                 else
                 Exit;

     else
     Exit;
    end;
    ClearEvent(Event);
  end;

end;

function TApp_GCIC_EC_Tv32.Execute: Word;
  var
    Event : TEvent;
    wModuloCorrente  :TipoSistemaIntegrado;
Begin
  If (ParamExecucao.Tipo_de_Execucao in [TParamExecucao_Tipo_de_Execucao_Normal_Exec_Command])
     and (ParamCount = 3)
     and (paramStr(3) <> '0')
  Then Begin
         App.Application.PutEvent(nil,paramStr(3));
       end
  Else If ParamCount = 1
       Then Begin
              PutEvent_List(Application,ParamStr(1));
            end;

  If (ParamExecucao.Tipo_de_Execucao in [TParamExecucao_Tipo_de_Execucao_Normal,
                                         TParamExecucao_Tipo_de_Execucao_Normal_Sem_Pedir_Senha])
      or
     (ParamCount=0)
     or ((ParamCount >= 3) and (ParamExecucao.Command=0))

  Then Result := Inherited Execute
  Else Begin
         If ParamCount = 1
         Then Begin
                SetModuloCorrente(CSistemaIntegrado);
                Repeat
                  GetEvent(Event);
                  if Event.What <> evNothing
                  then Begin
                         HandleEvent(Event);
                         if Event.What <> evNothing
                         then EventError(Event);
                       End
                  Else Break;
                Until false;

              end
         else Begin
                Event := CreateEvent(Self,EvCommand,ParamExecucao.Command,nil)^;
                IF ParamExecucao.Modulo = ord(CSistemaIntegrado)
                Then Begin
                       wModuloCorrente := SetModuloCorrente(TipoSistemaIntegrado(ParamExecucao.Modulo));
                       HandleEvent(Event);
                       SetModuloCorrente(wModuloCorrente);
                     End
                Else //ExecEvent(TipoSistemaIntegrado(ParamExecucao.Modulo),Event);
                     ExecModuloCorrente(TipoSistemaIntegrado(ParamExecucao.Modulo),Event);// executa mais nao sair do modulo.

              End;
       End;
end;

procedure inicializa_LancAutomatico_Indup(aModulo:TLaModulo);

  // 03/04/2004
  //  inicializa o código dos lancamentos automaticos porque implantei nova forma de contabilizar usando as tabelas de reeitas e  despesas.


  Var
    ArqDup : TArqDup;
Begin
  try

     ArqDup := TArqDup.Create('Arquivo de duplicatas',aModulo,IxDupTodas);

     with ArqDup,_RegDup do
     begin
//       Sele(0);
       GoBof;
       Repeat
         DuLancamentoAutomaticoAoIncluir := 0;
         DuLancamentoAutomaticoAoBaixar  := 0;
         ok := upDateRec;
         If ok
         then ok := nextRec
         else Raise TException.Create('GCIC',
                                 'Int.Pas',
                                 '',
                                  TaStatus);



       until not ok;
     end;

  finally
    ArqDup.Free;
  end;
end;



end.

