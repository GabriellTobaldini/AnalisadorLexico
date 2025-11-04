program AnalisadorLexico;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {FormPrincipal},
  uAnalisadorLexico in 'uAnalisadorLexico.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
