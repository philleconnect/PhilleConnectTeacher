unit UCreateImageThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, httpsend;

type
  TShowStatusEvent = procedure(data: string) of Object;
  TCreateImageThread = class(TThread)
    private
      name, ip, room, fStatusText: string;
      FOnShowStatus: TShowStatusEvent;
      procedure showStatus;
    protected
      procedure execute; override;
    public
      constructor create(cname, cip, croom: string);
      property OnShowStatus: TShowStatusEvent read FOnShowStatus write FOnShowStatus;
  end;

implementation

constructor TCreateImageThread.create(cname, cip, croom: string);
begin
  name:=cname;
  ip:=cip;
  room:=croom;
  FreeOnTerminate:=true;
  inherited create(true);
end;

procedure TCreateImageThread.showStatus;
begin
  if Assigned(FOnShowStatus) then begin
    FOnShowStatus(fStatusText);
  end;
end;

procedure TCreateImageThread.execute;
var
  response: TMemoryStream;
begin
  response:=TMemoryStream.Create;
  try
    if HttpPostURL('http://'+ip+':34567/'+room+'/'+name+'/screenshot', '', response) then
      if response <> nil then begin
        response.Position := 0;
        SetString(fStatusText, PChar(response.Memory), response.Size);
      end;
  finally
    response.Free;
  end;
  Synchronize(@showStatus);
end;

end.

