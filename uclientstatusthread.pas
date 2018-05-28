unit UClientStatusThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, HTTPSend;

type
  TShowStatusEvent = procedure(Status: String) of Object;
  TClientStatusThread = class(TThread)
    private
      fStatusText: string;
      FOnShowStatus: TShowStatusEvent;
      online, locked: boolean;
      ip: string;
      procedure showStatus;
    protected
      procedure execute; override;
    public
      constructor create(ipC: string);
      property OnShowStatus: TShowStatusEvent read FOnShowStatus write FOnShowStatus;
  end;

implementation

constructor TClientStatusThread.create(ipC: string);
begin
  ip:=ipC;
  online:=false;
  locked:=true;
  FreeOnTerminate:=true;
  inherited create(true);
end;

procedure TClientStatusThread.showStatus;
begin
  if Assigned(FOnShowStatus) then
    begin
      FOnShowStatus(fStatusText);
    end;
end;

procedure TClientStatusThread.execute;
var
  R1, R2: TMemoryStream;
  S1, S2: string;
begin
  R1:=TMemoryStream.Create;
  try
    if HttpPostURL('http://'+ip+':34567/online', '', R1) then
      if R1 <> nil then begin
        R1.Position := 0;
        SetString(S1, PChar(R1.Memory), R1.Size);
        if not(pos('online', S1) = 0) then begin
          online:=true;
          R2:=TMemoryStream.Create;
          try
            if HttpPostURL('http://'+ip+':34567/lockstate', '', R2) then
              if R2 <> nil then begin
                R2.Position := 0;
                SetString(S2, PChar(R2.Memory), R2.Size);
                if (pos('unlocked', S2) = 0) then begin
                  locked:=true;
                end
                else begin
                  locked:=false;
                end;
              end;
          finally
            R2.Free;
          end;
        end
        else begin
          online:=false;
        end;
      end;
  finally
    R1.Free;
  end;
  if not(online) then begin
    fStatusText:='0';
  end
  else begin
    if (locked) then begin
      fStatusText:='1';
    end
    else begin
      fStatusText:='2';
    end;
  end;
  Synchronize(@ShowStatus);
end;

end.

