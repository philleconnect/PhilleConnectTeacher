unit UControlMachineThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process, httpsend;

type
  TControlMachineThread = class(TThread)
    private
      ip, room, name: string;
    protected
      procedure execute; override;
    public
      constructor create(cip, croom, cname: string);
  end;

implementation

constructor TControlMachineThread.create(cip, croom, cname: string);
begin
  ip:=cip;
  room:=croom;
  name:=cname;
  FreeOnTerminate:=true;
  inherited create(true);
end;

procedure TControlMachineThread.execute;
var
  process: TProcess;
  response: TMemoryStream;
  vncpassword: string;
begin
  response:=TMemoryStream.Create;
  try
    if HttpPostURL('http://'+ip+':34567/'+room+'/'+name+'/requestcontrol', '', response) then
      if response <> nil then begin
        response.Position := 0;
        SetString(vncpassword, PChar(response.Memory), response.Size);
      end;
  finally
    response.Free;
  end;
  process:=TProcess.create(nil);
  {$IFDEF WINDOWS}
    process.executable:='C:\Program Files\PhilleConnect\vnc\vncviewer.exe';
    process.parameters.add(ip+' -notoolbar -dotcursor -password "'+vncpassword+'" -quality 2 -quickoption 2 -nostatus -shared -disableclipboard');
  {$ENDIF}
  {$IFDEF LINUX}
    process.executable:='sh';
    process.parameters.add('-c');
    process.parameters.add('x11vnc -o /tmp/x11vnc.log -storepasswd '+Trim(vncpassword)+' /tmp/philleconnectpasswd');
    process.execute;
    process.waitOnExit;
    process.free;
    sleep(2000);
    process:=TProcess.create(nil);
    process.executable:='sh';
    process.parameters.add('-c');
    process.parameters.add('xtightvncviewer -x11cursor -quality 4 -passwd /tmp/philleconnectpasswd '+ip);
  {$ENDIF}
  process.execute;
  process.waitOnExit;
  process.free;
  response:=TMemoryStream.Create;
  try
    if HttpPostURL('http://'+ip+':34567/'+room+'/'+name+'/cancelcontrol', '', response) then
      if response <> nil then begin
        response.Position := 0;
        SetString(vncpassword, PChar(response.Memory), response.Size);
      end;
  finally
    response.Free;
  end;
end;

end.
