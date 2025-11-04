unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  uAnalisadorLexico;

type
  TFormPrincipal = class(TForm)
    edtNovoToken: TEdit;
    btnAdicionarToken: TButton;
    sgMatrizTransicao: TStringGrid;
    lblNovoToken: TLabel;
    gbTokensReconhecidos: TGroupBox;
    lbTokensReconhecidos: TListBox;
    lblAnalisar: TLabel;
    edtAnalisarToken: TEdit;
    gbHistorico: TGroupBox;
    lbHistorico: TListBox;
    pnlLegenda: TPanel;
    shpVerde: TShape;
    lblLegendaValido: TLabel;
    lblLegendaInvalido: TLabel;
    lbl_LegendaParaAnalisar: TLabel;
    btn_Limpar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarTokenClick(Sender: TObject);
    procedure edtAnalisarTokenChange(Sender: TObject);
    procedure edtAnalisarTokenKeyPress(Sender: TObject; var Key: Char);
    procedure edtNovoTokenKeyPress(Sender: TObject; var Key: Char);
    procedure sgMatrizTransicaoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure btn_LimparClick(Sender: TObject);
  private
    FAnalisador: TAnalisadorLexico;
    procedure AtualizarMatrizVisual;
    procedure ValidarEntrada(var Key: Char);
  public
    destructor Destroy; override;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FAnalisador := TAnalisadorLexico.Create;
end;

destructor TFormPrincipal.Destroy;
begin
  FAnalisador.Free;
  inherited;
end;

procedure TFormPrincipal.btnAdicionarTokenClick(Sender: TObject);
var
  NovoToken: string;
begin
  NovoToken := Trim(LowerCase(edtNovoToken.Text));
  if (NovoToken <> '') and (lbTokensReconhecidos.Items.IndexOf(NovoToken) = -1) then
  begin
    lbTokensReconhecidos.Items.Add(NovoToken);
    FAnalisador.AlimentaMatriz(lbTokensReconhecidos.Items);
    AtualizarMatrizVisual;
    edtNovoToken.Clear;
    edtNovoToken.SetFocus;
  end
  else
    ShowMessage('Token inválido ou já existente.');
end;

procedure TFormPrincipal.btn_LimparClick(Sender: TObject);
begin
  lbTokensReconhecidos.Clear;
  lbHistorico.Clear;
  edtNovoToken.Clear;
  edtAnalisarToken.Clear;
  FAnalisador.AlimentaMatriz(lbTokensReconhecidos.Items);
  AtualizarMatrizVisual;
  edtNovoToken.SetFocus;
end;

procedure TFormPrincipal.AtualizarMatrizVisual;
var
  Matriz: TArray<TArray<Integer>>;
  Alfabeto: string;
  i, j: Integer;
  Estado: string;
begin
  if not Assigned(FAnalisador) then Exit;

  Matriz := FAnalisador.GetMatriz;
  Alfabeto := FAnalisador.GetAlfabeto;

  sgMatrizTransicao.ColCount := Length(Alfabeto) + 1;
  sgMatrizTransicao.RowCount := Length(Matriz) + 1;

  sgMatrizTransicao.Cells[0, 0] := 'Estado';
  for j := 0 to Length(Alfabeto) - 1 do
    sgMatrizTransicao.Cells[j + 1, 0] := Alfabeto[j + 1];

  for i := 0 to Length(Matriz) - 1 do
  begin
    Estado := 'q' + IntToStr(i);
    if FAnalisador.EhEstadoFinal(i) then
      Estado := Estado + '*';
    sgMatrizTransicao.Cells[0, i + 1] := Estado;

    for j := 0 to Length(Alfabeto) - 1 do
    begin
      if Matriz[i, j] <> -1 then
        sgMatrizTransicao.Cells[j + 1, i + 1] := 'q' + IntToStr(Matriz[i, j])
      else
        sgMatrizTransicao.Cells[j + 1, i + 1] := '-';
    end;
  end;
  sgMatrizTransicao.Invalidate;
end;

procedure TFormPrincipal.edtAnalisarTokenChange(Sender: TObject);
begin
  sgMatrizTransicao.Invalidate;
end;

procedure TFormPrincipal.edtAnalisarTokenKeyPress(Sender: TObject; var Key: Char);
var
  TokenAnalisado: string;
  EstadoAtual, Coluna, i: Integer;
  Reconhecido: Boolean;
begin
  ValidarEntrada(Key);
  if Key = #0 then
  begin
    Key := #0;
    TokenAnalisado := Trim(LowerCase(edtAnalisarToken.Text));
    if TokenAnalisado = '' then Exit;
    if not Assigned(FAnalisador) then Exit;

    EstadoAtual := 0;
    Reconhecido := True;
    for i := 1 to Length(TokenAnalisado) do
    begin
      Coluna := Pos(TokenAnalisado[i], FAnalisador.GetAlfabeto) - 1;
      if (EstadoAtual < Length(FAnalisador.GetMatriz)) and (Coluna > -1) and
         (FAnalisador.GetMatriz[EstadoAtual, Coluna] <> -1) then
        EstadoAtual := FAnalisador.GetMatriz[EstadoAtual, Coluna]
      else
      begin
        Reconhecido := False;
        Break;
      end;
    end;

    if Reconhecido and FAnalisador.EhEstadoFinal(EstadoAtual) then
    begin
      lbHistorico.Items.Add(TokenAnalisado + ' -> Reconhecido');
      ShowMessage('Token "' + TokenAnalisado + '" foi RECONHECIDO!');
    end
    else
    begin
      lbHistorico.Items.Add(TokenAnalisado + ' -> Rejeitado');
      ShowMessage('Token "' + TokenAnalisado + '" foi REJEITADO!');
    end;
    edtAnalisarToken.Clear;
    edtAnalisarToken.SetFocus;
  end;
end;

procedure TFormPrincipal.edtNovoTokenKeyPress(Sender: TObject; var Key: Char);
begin
  ValidarEntrada(Key);
  if Key = #13 then
     btnAdicionarToken.Click;
end;

procedure TFormPrincipal.sgMatrizTransicaoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Texto: string;
  EstadoAtual, Coluna, i: Integer;
  Matriz: TArray<TArray<Integer>>;
  Pintar: Boolean;
  CorFundo: TColor;
  Grid: TStringGrid;
begin
  Grid := (Sender as TStringGrid);

  if (ACol < Grid.FixedCols) or (ARow < Grid.FixedRows) then
    CorFundo := clBtnFace
  else
    CorFundo := clWindow;

  if (ARow > 0) and (ACol > 0) and Assigned(FAnalisador) then
  begin
    Texto := LowerCase(edtAnalisarToken.Text);
    if Texto <> '' then
    begin
      Matriz := FAnalisador.GetMatriz;
      EstadoAtual := 0;

      for i := 1 to Length(Texto) do
      begin
        Coluna := Pos(Texto[i], FAnalisador.GetAlfabeto());
        if (EstadoAtual = ARow - 1) and (Coluna = ACol) then
        begin
          if (EstadoAtual < Length(Matriz)) and (Coluna > 0) and (Matriz[EstadoAtual, Coluna - 1] <> -1) then
            CorFundo := clGreen
          else
            CorFundo := clRed;
          Break;
        end;

        if (EstadoAtual < Length(Matriz)) and (Coluna > 0) and (Matriz[EstadoAtual, Coluna - 1] <> -1) then
          EstadoAtual := Matriz[EstadoAtual, Coluna - 1]
        else
          Break;
      end;
    end;
  end;

  Grid.Canvas.Brush.Color := CorFundo;
  Grid.Canvas.FillRect(Rect);
  Grid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Grid.Cells[ACol, ARow]);
end;

procedure TFormPrincipal.ValidarEntrada(var Key: Char);
begin
  if not (Key in ['a'..'z', 'A'..'Z', #8]) then
    Key := #0;
end;

end.
