#Include "Protheus.ch"

/*****************************************************************************\
**---------------------------------------------------------------------------**
** FUNÇÃO   : MdiOk	       | AUTOR : Cristiano Machado  | DATA : 03/12/2015   **
**---------------------------------------------------------------------------**
** DESCRIÇÃO: Validar o Acesso ao Interface MDI                              **
**---------------------------------------------------------------------------**
** USO      : Especifico para o cliente IMDEPA                               **
**---------------------------------------------------------------------------**
**---------------------------------------------------------------------------**
**            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.              **
**---------------------------------------------------------------------------**
**   PROGRAMADOR   |   DATA   |            MOTIVO DA ALTERACAO               **
**---------------------------------------------------------------------------**
**                 |          |                                              **
**                 |          |                                              **
\*---------------------------------------------------------------------------*/
*******************************************************************************
User Function MdiOk()
*******************************************************************************
Private lMDI_Habilitada := .F. // .T. -> Define se MDI esta HABILIDATA sem qualquer verificação. .F. -> Funcao ControleMDI() irá verificar se o seguir o conteudo do parametro IM_PERMDI.

//| Define Teclas de Atalho
SetKey( K_CTRL_T, 		{ || U_ExecMyFunc() } ) // CONTROL + T |

//| Função para Tratamento de Entrada no SIGAMDI ....
ControleMDI( !lMDI_Habilitada )


Return(lMDI_Habilitada)
*******************************************************************************
Static Function ControleMDI(lAtivo) //| Função para Tratamento de Entrada no SIGAMDI
*******************************************************************************

	If !lAtivo
		Return(lAtivo)
	EndIf

	lMDI_Habilitada := U_GetSx6("IM_PERMDI",Nil,.T.)// Parametro Configura se Permite ou Não a Utilizacao da Interface MDI.

  //| Permite o Acesso ao SIGAMDI apenas para o Administrador do Sistema
	If !lMDI_Habilitada .And. ( __cUserId <> "000000" ) //| Administrador
		Iw_MsgBox("O Acesso à Interface MDI esta DESABILITADA ! Entre em contato com o Admistrador do sistema. Parametro: IM_PERMDI ","Atenção","ALERT")
	EndIF

Return( lMDI_Habilitada )
