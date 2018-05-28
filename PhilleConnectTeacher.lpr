program PhilleConnectStart;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, PCS, USMBShare, UGetMacAdress, UClientMachine, UGetIPAdress, UVNCView,
  UCreateImageThread, UControlMachineThread, UChangePassword,
  UResetStudentPassword, USMBThread, UClientStatusThread, URequestThread;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Twindow, window);
  Application.CreateForm(TCPForm, CPForm);
  Application.CreateForm(TRSPForm, RSPForm);
  Application.Run;
end.

