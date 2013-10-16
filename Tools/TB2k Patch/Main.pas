unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm_Main = class(TForm)
    Memo_Output: TMemo;
    Panel_Top: TPanel;
    Button_Select: TButton;
    procedure Button_SelectClick(Sender: TObject);
  end;

var
  Form_Main: TForm_Main;

implementation

uses FileCtrl;

{$R *.dfm}

procedure TForm_Main.Button_SelectClick(Sender: TObject);
var
  DataDir, TB2kDir: string;

  procedure CopyFile(const FileName: string);
  var
    S: string;
  begin
    if Windows.CopyFile(PChar(DataDir + FileName), PChar(TB2kDir + '\Packages\' + FileName), True) then
      S := 'OK'
    else
      S := 'Error';
    Memo_Output.Lines.Add('copying ' + FileName + '... ' + S);
  end;

const
  BufferSize = 2400;
var
  ValidDir: Boolean;
  I: Integer;
  SecurityAttributes: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Buffer: PAnsiChar;
  BytesRead: DWORD;
begin
  if not SelectDirectory('Select Toolbar2000 location', '', TB2kDir) then Exit;

  DataDir := ExtractFilePath(Application.ExeName) + 'Data\';
  Memo_Output.Clear;

  // Try to find necessary directory
  ValidDir := False;
  for I := 1 to 3 do
  begin
    TB2kDir := ExcludeTrailingPathDelimiter(TB2kDir);
    if DirectoryExists(TB2kDir + '\Source') and DirectoryExists(TB2kDir + '\Packages') then
    begin
      ValidDir := True;
      Break;
    end;
    TB2kDir := ExtractFilePath(TB2kDir);
  end;

  if not ValidDir then
  begin
    Memo_Output.Lines.Add('Cannot find Toolbar2000 in selected directory. Please try again.');
    Exit;
  end;

  Memo_Output.Lines.Add('Toolbar2000 found. Trying to patch files...');
  Memo_Output.Lines.Add('');

  // Patch files
  with SecurityAttributes do
  begin
    nLength := SizeOf(TSecurityAttributes);
    lpSecurityDescriptor := nil;
    bInheritHandle := True;
  end;
  if not CreatePipe(ReadPipe, WritePipe, @SecurityAttributes, 0) then
  begin
    Memo_Output.Lines.Add('Cannot capture console output.');
    Exit;
  end;

  try
    FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
    with StartupInfo do
    begin
      cb := SizeOf(TStartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := ReadPipe;
      hStdOutput := WritePipe;
    end;
    if not CreateProcess(
      nil,
      PChar(Format('"%s" --directory="%s" --input="%s"',
        [DataDir + 'patch.exe', TB2kDir + '\Source', DataDir + 'diff.txt'])),
      @SecurityAttributes,
      @SecurityAttributes,
      True,
      NORMAL_PRIORITY_CLASS,
      nil,
      nil,
      StartupInfo,
      ProcessInfo) then
    begin
      Memo_Output.Lines.Add('Cannot run patch.');
      Exit;
    end;

    try
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    finally
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
    end;

    Buffer := AllocMem(BufferSize + 1);
    try
      repeat
        BytesRead := FileRead(ReadPipe, Buffer^, BufferSize);
        Buffer[BytesRead] := #0;
        OemToAnsi(Buffer, Buffer);
        Memo_Output.Text := Memo_Output.Text + string(Buffer);
      until
        BytesRead < BufferSize;
    finally
      FreeMem(Buffer);
    end;
  finally
    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);
  end;

  // Copy new files
  Memo_Output.Lines.Add('');

  CopyFile('tb2k_d14.dpk');
  CopyFile('tb2kdsgn_d14.dpk');
  CopyFile('tb2k_d14.res');
  CopyFile('tb2kdsgn_d14.res');

  CopyFile('tb2k_d15_xe.dpk');
  CopyFile('tb2kdsgn_d15_xe.dpk');
  CopyFile('tb2k_d15_xe.res');
  CopyFile('tb2kdsgn_d15_xe.res');

  CopyFile('tb2k_d16_xe2.dpk');
  CopyFile('tb2kdsgn_d16_xe2.dpk');
  CopyFile('tb2k_d16_xe2.res');
  CopyFile('tb2kdsgn_d16_xe2.res');

  CopyFile('tb2k_d17_xe3.dpk');
  CopyFile('tb2kdsgn_d17_xe3.dpk');
  CopyFile('tb2k_d17_xe3.res');
  CopyFile('tb2kdsgn_d17_xe3.res');

  CopyFile('tb2k_d18_xe4.dpk');
  CopyFile('tb2kdsgn_d18_xe4.dpk');
  CopyFile('tb2k_d18_xe4.res');
  CopyFile('tb2kdsgn_d18_xe4.res');

  CopyFile('tb2k_d19_xe5.dpk');
  CopyFile('tb2kdsgn_d19_xe5.dpk');
  CopyFile('tb2k_d19_xe5.res');
  CopyFile('tb2kdsgn_d19_xe5.res');

  Memo_Output.Lines.Add('');
  Memo_Output.Lines.Add('Finished.');
end;

end.
